import Base: getindex, getproperty

function getindex(g::StorageGraph, v::Integer)
    get_prop(g, v)
end

function getindex(g::StorageGraph, data::NamedTuple)
    !haskey(g.index, data) && error("':$data' is not an index")
    return g.index[data]
end

function getindex(g::StorageGraph, dep::Pair)
    paths = paths_through(g, dep)
    neighbors = final_neighborhs(g, dep)
    Iterators.filter(v->on_path(g, v, paths), neighbors)
end

function getindex(g::StorageGraph, dep::Pair, name::Symbol)
    get.(get_prop.(Ref(g), g[dep]), name, nothing)
end

function getindex(g::StorageGraph, name::Symbol, nodes::Vararg{NamedTuple})
    paths = intersect(paths_through.(Ref(g), nodes)...)
    neighbors = Iterators.filter(v->on_path(g,v,paths), outneighbors(g, g[nodes[end]]))
    get.(get_prop.(Ref(g), neighbors), name, nothing)
end

function getproperty(g::StorageGraph, s::Symbol)
    if s ∉ fieldnames(StorageGraph)
        return extractvals(findnodes(g, s), s)
    else # fallback to getfield
        return getfield(g, s)
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
    union(get.(Ref(g.paths), es, Ref(Int[]))...)
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
