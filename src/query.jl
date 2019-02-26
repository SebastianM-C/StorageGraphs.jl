function getindex(g::StorageGraph, data::NamedTuple)
    !haskey(g.index, data) && error("':$data' is not an index")
    return g.index[data]
end

function getproperty(g::StorageGraph, s::Symbol)
    allkeys = keys.(keys(g.index))
    if haskey(allkeys, s)
        return extractvals(g, s)
    else # fallback to getfield
        return getfield(obj, sym)
    end
end

"""
    paths_through(g, v::Integer; dir=:out)

Return a vector of the paths going through the given vertex. If `dir` is specified,
use the corresponding edge direction (`:in` and `:out` are acceptable values).
"""
function paths_through(g, v::Integer; dir=:out)
    v == 0 && return Int[]
    if dir == :out
        out = outneighbors(g, v)
        if isempty(out)
            return Int[]
        else
            es = [Edge(v, i) for i in out]
        end
    else
        in = inneighbors(g, v)
        if isempty(in)
            return Int[]
        else
            es = [Edge(i, v) for i in in]
        end
    end
    union(Int[], get.(Ref(g), es, Int[])...)
end

function paths_through(g, dep::Pair; dir=:out)
    intersect(paths_through(g, dep[2], dir=dir), paths_through(g, dep[1], dir=dir))
end

function paths_through(g, node::NamedTuple; dir=:out)
    !haskey(g.index, node) && return Int[]
    paths_through(g, g[node], dir=dir)
end

"""
    final_neighborhs(g, dep::Pair; dir=:out)

Return the vertex indices for the neighbors at the end of the dependency chain.
"""
function final_neighborhs(g, dep::Pair; dir=:out)
    v = g[endof(dep), :data]
    dir == :out ? outneighbors(g, v) : inneighbors(g, v)
end

"""
    findnodes(g, name::Symbol)

Finds the nodes containing `name`.
"""
function findnodes(g, name::Symbol)
    findall(v -> haskey(g.data[v], name), g.index)
end

"""
    extractvals(nodes, name)

Return an array of values corresponding to `name` form the array of `NamedTuple`s
`nodes`.
"""
function extractvals(nodes, name)
    [n[name] for n in nodes]
end

"""
    nodevals(g, name::Symbol)

Return an array of the values corresponding to `name`. See also [`findnodes`](@ref).
"""
function nodevals(g, name::Symbol)
    extractvals(findnodes(g, name), name)
end
