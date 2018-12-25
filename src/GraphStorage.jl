module GraphStorage

export add_node!, maxid, get_node_index, add_path!, indexby, plot_graph,
    paths_through, on_path, walkpath

using LightGraphs, MetaGraphs
using GraphPlot

maxid(g) = haskey(g.gprops, :id) ? g.gprops[:id] : 1

"""
    add_node!(g, dep::Pair; id=maxid(g)+1)

Recursively add a node via the dependency chain specified by `dep`.
If any intermediarry node doesn't exist, it is created.
A new path is created starting from the first node to the last one.
"""
function add_node!(g, dep::Pair; id=maxid(g))
    if dep[2] isa Pair
        dest = add_node!(g, dep[2], id=id)
    else
        dest = dep[2]
        set_prop!(g, :id, id+1)
    end
    add_path!(g, dep[1], dest, id=id)

    return dep[1]
end

"""
    get_node_index(g, val)

Get the index of a node identified by a `NamedTuple`. If it doesn't exist, it is created.
"""
function get_node_index(g, val)
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
            add_node!(g, val)
            @debug "Node not found"
            return nv(g)
        end
    else
        k = keys(val)[ki]
        if !haskey(g[k], val[k])
            add_node!(g, val)
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
function add_path!(sg, source, dest; id=maxid(g))
    sv = get_node_index(g, source)
    dv = get_node_index(g, dest)
    if has_edge(g, sv, dv)
        push!(g.eprops[Edge(sv,dv)][:id], id)
    else
        add_edge!(g, sv, dv, Dict(:id=>Set(id)))
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
    formatprop(p::Set) = replace(string(p), "Set"=>"")
    vlabels = [formatprop(g.vprops[i]) for i in vertices(g)]
    elabels = [formatprop(g.eprops[i][:id]) for i in edges(g)]
    gplot(g, nodelabel=vlabels, edgelabel=elabels)
end

"""
    paths_through(g, v::Integer; dir=:out)

Return a vector of the paths going through the given vertex. If `dir` is specified,
use the corresponding edge direction (`:in` and `:out` are acceptable values).
"""
function paths_through(g, v::Integer; dir=:out)
    if dir == :out
        out = outneighbors(g, v)
        es = [Edge(v, i) for i in out]
    else
        in = inneighbors(g, v)
        es = [Edge(i, v) for i in in]
    end
    union(Set{eltype(g)}(), get_prop.(Ref(g), es, :id)...)
end

function paths_through(g, dep::Pair; dir=:out)
    intersect(paths_through(g, dep[2], dir=dir), paths_through(g, dep[1], dir=dir))
end

function paths_through(g, val::NamedTuple; dir=:out)
    paths_through(g, get_node_index(g, val), dir=dir)
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

function walkpath(g, path::Set, start, neighborfn; stopcond=(g,v)->true)
    result = Set{eltype(g)}()
    sizehint!(result, length(path))
    for p ∈ path
        push!(result, walkpath(g, p, start, neighborfn, stopcond=stopcond))
    end
    return result
end

function walkpath(g, path::Integer, start, neighborfn; stopcond=(g,v)->true)
    while stopcond(g, start)
        neighbors = neighborfn(g, start)
        nexti = findfirst(n->on_path(g, n, path), neighbors)
        if nexti isa Nothing
            return start
        end
        start = neighbors[nexti]
    end
    return start
end

end # module
