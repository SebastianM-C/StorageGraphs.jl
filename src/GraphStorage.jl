module GraphStorage

export add_nodes!, maxid, get_node_index, add_path!, indexby, plot_graph,
    paths_through, on_path, walkpath, add_quantity!

using LightGraphs, MetaGraphs
using GraphPlot
using Base.Threads

maxid(g) = haskey(g.gprops, :id) ? g.gprops[:id] : 1

"""
    add_nodes!(g, dep::Pair; id=maxid(g))

Recursively add nodes via the dependency chain specified by `dep`.
If any intermediarry node doesn't exist, it is created.
A new path is created starting from the first node to the last one.
"""
function add_nodes!(g, dep::Pair; id=maxid(g))
    if dep[2] isa Pair
        dest = add_nodes!(g, dep[2], id=id)
    else
        dest = dep[2]
        set_prop!(g, :id, id+1)
    end
    add_path!(g, dep[1], dest, id=id)

    return dep[1]
end

"""
    get_node_index(g, val; createnew=true)

Get the index of a node identified by a `NamedTuple`. If it doesn't exist,
it can be created.
"""
function get_node_index(g, val; createnew=true)
    i = -1
    ki = key_index(g, val)
    if ki isa Nothing
        for (k,v) in g.vprops
            if v == Dict(pairs(val))
                i = k
                break
            end
        end
        if i == -1
            createnew && add_node!(g, val)
            @debug "Node not found"
            return nv(g)
        end
    else
        k = keys(val)[ki]
        if !haskey(g[k], val[k])
            createnew && add_node!(g, val)
            @debug "Node not found"
            return nv(g)
        else
            i = g[k][val[k]]
        end
    end
    return i
end

"""
    add_path!(g, source, dest; id=maxid(g))

Create a path between the source node and the destination one.
If the nodes do not exist, they are created.
"""
function add_path!(g, source, dest; id=maxid(g))
    sv = get_node_index(g, source)
    dv = get_node_index(g, dest)
    if has_edge(g, sv, dv)
        push!(g.eprops[Edge(sv,dv)][:id], id)
    else
        add_edge!(g, sv, dv, Dict(:id=>[id]))
    end
end

"""
    add_node!(g, val::NamedTuple)

Add a new node to the storage graph.
"""
function add_node!(g, val::NamedTuple)
    add_vertex!(g)
    for (k,v) in pairs(val)
        set_prop!(g, nv(g), k, v)
    end
end

"""
    indexby(g, key)

Set `key` as an indexing property.
"""
function indexby(g, key)
    if key ∉ g.indices
        g.metaindex[key] = Dict{Any,Integer}()
        push!(g.indices, key)
    end
end

key_index(g, val) = findfirst(i -> i ∈ g.indices, keys(val))

function plot_graph(g)
    formatprop(p::Dict) = replace(string(p), "Dict{Symbol,Any}"=>"")
    vlabels = [formatprop(g.vprops[i]) for i in vertices(g)]
    elabels = [g.eprops[i][:id] for i in edges(g)]
    gplot(g, nodelabel=vlabels, edgelabel=elabels)
end

"""
    paths_through(g, v::Integer; dir=:out)

Return a vector of the paths going through the given vertex. If `dir` is specified,
use the corresponding edge direction (`:in` and `:out` are acceptable values).
"""
function paths_through(g, v::Integer; dir=:out)
    v == 0 && return Integer[]
    if dir == :out
        out = outneighbors(g, v)
        if isempty(out)
            return Integer[]
        else
            es = [Edge(v, i) for i in out]
        end
    else
        in = inneighbors(g, v)
        if isempty(in)
            return Integer[]
        else
            es = [Edge(i, v) for i in in]
        end
    end
    union(Integer[], get_prop.(Ref(g), es, :id)...)
end

function paths_through(g, dep::Pair; dir=:out)
    intersect(paths_through(g, dep[2], dir=dir), paths_through(g, dep[1], dir=dir))
end

function paths_through(g, val::NamedTuple; dir=:out)
    paths_through(g, get_node_index(g, val, createnew=false), dir=dir)
end

function paths_through(g, prop, val; dir=:out)
    paths_through(g, g[prop][val], dir=dir)
end

"""
    on_path(g, v, path)

Check if the vertex is on the given path.
"""
function on_path(g, v, path)
    !isempty(paths_through(g, v, dir=:in) ∩ path)
end

"""
    walkpath(g, paths, start; dir=:out, stopcond=(g,v)->false)

Walk on the given `paths` starting from `start` and return the last nodes.
If `dir` is specified, use the corresponding edge direction
(`:in` and `:out` are acceptable values).
"""
function walkpath(g, paths::Vector, start::Integer; dir=:out, stopcond=(g,v)->false)
    (dir == :out) ? walkpath(g, paths, start, outneighbors, stopcond=stopcond) :
        walkpath(g, paths, start, inneighbors, stopcond=stopcond)
end

function walkpath(g, paths::Vector, start::Integer, neighborfn; stopcond=(g,v)->false)
    result = Vector{eltype(g)}(undef, length(paths))
    @threads for i ∈ eachindex(paths)
        result[i] = walkpath(g, paths[i], start, neighborfn, stopcond=stopcond)
    end
    return result
end

function walkpath(g, path::Integer, start::Integer, neighborfn; stopcond=(g,v)->false)
    walkpath!(g, path, start, neighborfn, (g,v,n)->nothing, stopcond=stopcond)
end

"""
    walkpath!(g, path, start, neighborfn, action!; stopcond=(g,v)->false)

Walk on the given `path` and take an action at each node. The action is specified
by a function `action!(g, v, neighbors)` and it can modify the graph.
"""
function walkpath!(g, path, start, neighborfn, action!; stopcond=(g,v)->false)
    while !stopcond(g, start)
        neighbors = neighborfn(g, start)
        action!(g, start, neighbors)
        nexti = findfirst(n->on_path(g, n, path), neighbors)
        if nexti isa Nothing
            return start
        end
        start = neighbors[nexti]
    end
    return start
end

function endof(dep)
    if dep[2] isa Pair
        return endof(dep[2])
    else
        return dep[2]
    end
end

"""
    add_quantity!(g, dep, vals)

Add the multiple values (`vals`) of the things identified by the keys of `vals`,
with the dependency chain given by `dep`. The values of `vals` are assumed to
be vectors. Each added node will correspond to an element of the vectors.
Note: The dependency chain must contain all relevant information for identifying the values.
"""
function add_quantity!(g, dep, vals)
    dep_end = endof(dep)
    for i in axes(vals[1], 1)
        add_nodes!(g, dep)
        # decrease the id to stay on the same path
        g.gprops[:id] -= 1
        val = (v[i] for v in vals)
        add_nodes!(g, dep_end=>NamedTuple{keys(vals)}(val))
    end
end

end # module
