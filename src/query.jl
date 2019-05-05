import Base: getindex, getproperty
using Base.Threads

function getindex(g::StorageGraph, v::Integer)
    get_prop(g, v)
end

function getindex(g::StorageGraph, dep::Pair)
    (lastn, cpaths), t = @timed walkdep(g, dep)
    @debug "Finding last node on path took $t seconds."
    if lastn == endof(dep) && length(cpaths) ≠ 0
        neighbors = outneighbors(g, lastn)
        mask = Vector{Bool}(undef, length(neighbors))
        @threads for i in eachindex(neighbors)
            mask[i] = on_path(g, neighbors[i], cpaths)
        end
        return neighbors[mask]
    else
        return eltype(g)[]
    end
end

function getindex(g::StorageGraph, name::Symbol, dep::Pair)
    get.(get_prop.(Ref(g), g[dep]), name, nothing)
end

function getindex(g::StorageGraph, conditions::Dict{Symbol,F}, nodes::Vararg{NamedTuple}) where {F<:Function}
    paths = filter_paths(g, nodes, conditions)
    vs = Iterators.filter(v->on_path(g,v,paths), outneighbors(g, nodes[end]))
    get_prop.(Ref(g), vs)
end

function getindex(g::StorageGraph, name::Symbol, conditions::Dict{Symbol,F}, nodes::Vararg{NamedTuple}) where {F<:Function}
    paths = filter_paths(g, nodes, conditions)
    outn = outneighbors(g, g[nodes[end]])
    i = findfirst(n->has_prop(g, n, name), outn)
    if i === nothing
        vs = walkpath(g, paths, g[nodes[1]], stopcond=(g,v)->has_prop(g,v,name))
        # filter out the cases where it stopped before reaching stopcond
        filter!(v->has_prop(g,v,name), vs)
    else
        # there is no need to traverse the graph if the last given node has the
        # desired nodes as outneighbors
        vs = filter(v->on_path(g,v,paths), outn)
    end
    get.(get_prop.(Ref(g), vs), name, nothing)
end

function getindex(g::StorageGraph, nodes::Vararg{NamedTuple})
    return getindex(g, Dict{Symbol,Function}(), nodes...)
end

function getindex(g::StorageGraph, data::NamedTuple)
    return g.index[data]
end

function getindex(g::StorageGraph, name::Symbol, nodes::Vararg{NamedTuple})
    getindex(g, name, Dict{Symbol,Function}(), nodes...)
end

function getindex(g::StorageGraph, names::NTuple{N, Symbol}, nodes::Vararg{NamedTuple}) where {N}
    (getindex(g, n, nodes...) for n in names)
end

function getindex(g::StorageGraph, name::Symbol)
    extractvals(findnodes(g, name), name)
end

getindex(g::StorageGraph) = []

"""
    paths_through(g, v::Integer; dir=:out)

Return a vector of the paths going through the given vertex. If `dir` is specified,
use the corresponding edge direction (`:in` and `:out` are acceptable values).
"""
paths_through(g, v; dir=:out) = paths_through!(Set{eltype(g)}(), g, v, dir=dir)

function paths_through!(paths, g, v::Integer; dir=:out)
    v == 0 && return paths
    if dir == :out
        out = outneighbors(g, v)
        if isempty(out)
            return paths
        else
            es = [Edge(v, i) for i in out]
        end
    elseif dir == :in
        in = inneighbors(g, v)
        if isempty(in)
            return paths
        else
            es = [Edge(i, v) for i in in]
        end
    else
        in = inneighbors(g, v)
        out = outneighbors(g, v)
        l = length(in)
        n = l + length(out)
        n == 0 && return paths
        es = Vector{Edge}(undef, n)
        for i in eachindex(in)
            es[i] = Edge(in[i], v)
        end
        for i in eachindex(out)
            es[i+l] = Edge(v, out[i])
        end
    end
    for e in es
        union!(paths, g.paths[e])
    end
    return paths
end

function paths_through!(paths, g, dep::Pair; dir=:out)
    intersect!(paths_through!(Set{eltype(g)}(), g, dep[2], dir=dir), paths_through!(paths, g, dep[1], dir=dir))
end

function paths_through!(paths, g, node::NamedTuple; dir=:out)
    !haskey(g.index, node) && return paths
    paths_through!(paths, g, g[node], dir=dir)
end

"""
    final_neighborhs(g, dep::Pair; dir=:out)

Return the vertex indices for the neighbors at the end of the dependency chain.
Note: this assumes that the dependency chain is valid (all the nodes exist).
"""
function final_neighborhs(g, dep::Pair; dir=:out)
    v = g[endof(dep)]
    dir == :out ? outneighbors(g, v) : inneighbors(g, v)
end

"""
    findnodes(g, name::Symbol)

Finds the nodes containing `name`.
"""
function findnodes(g, name::Symbol)
    findall(v -> has_prop(g, v, name), g.index)
end

"""
    extractvals(nodes, name::Symbol)

Return an array of values corresponding to `name` form the array of `NamedTuple`s
`nodes`.
"""
function extractvals(nodes, name::Symbol)
    [n[name] for n in nodes]
end

function filter_paths!(paths, g, conditions)
    for (name, cond) in conditions
        target = findnodes(g, name)
        valid_vals = target[cond.(target)]
        all_valid_paths = paths_through.(Ref(g), valid_vals)
        valid_paths = Set{eltype(g)}()
        for p in all_valid_paths
            union!(valid_paths, p)
        end
        intersect!(paths, valid_paths)
    end
end

function filter_paths(g, nodes, conditions)
    possible_paths = paths_through.(Ref(g), nodes)
    paths = possible_paths[1]
    for p in possible_paths
        intersect!(paths, p)
    end
    filter_paths!(paths, g, conditions)

    return paths
end
