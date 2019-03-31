import Base: getindex, getproperty

function getindex(g::StorageGraph, v::Integer)
    get_prop(g, v)
end

function getindex(g::StorageGraph, dep::Pair)
    paths = paths_through(g, dep)
    neighbors = final_neighborhs(g, dep)
    Iterators.filter(v->on_path(g, v, paths), neighbors)
end

function getindex(g::StorageGraph, dep::Pair, name::Symbol)
    get.(get_prop.(Ref(g), g[dep]), name, nothing)
end

function getindex(g::StorageGraph, f::Function, nodes::Vararg{NamedTuple})
    paths = filter_paths(g, f, nodes...)
    vs = Iterators.filter(v->on_path(g,v,paths), outneighbors(g, g[nodes[end]]))
    get_prop.(Ref(g), vs)
end

function getindex(g::StorageGraph, name::Symbol, f::Function, nodes::Vararg{NamedTuple})
    paths = filter_paths(g, f, nodes...)
    outn = outneighbors(g, g[nodes[end]])
    i = findfirst(n->has_prop(g, n, name), outn)
    if i === nothing
        vs = walkpath(g, paths, g[nodes[1]], stopcond=(g,v)->has_prop(g,v,name))
        # filter out the cases where it stopped before reaching stopcond
        filter!(v->has_prop(g,v,name), vs)
        unique!(vs)
    else
        # there is no need to traverse the graph if the last given node has the
        # desired nodes as outneighbors
        vs = Iterators.filter(v->on_path(g,v,paths), outn)
    end
    get.(get_prop.(Ref(g), vs), name, nothing)
end

function getindex(g::StorageGraph, nodes::Vararg{NamedTuple})
    return getindex(g, (g,p,n)->true, nodes...)
end

function getindex(g::StorageGraph, data::NamedTuple)
    return g.index[data]
end

function getindex(g::StorageGraph, name::Symbol, nodes::Vararg{NamedTuple})
    getindex(g, name, (g,p,n)->true, nodes...)
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
    paths = Int[]
    for e in es
        append!(paths, g.paths[e])
    end
    return paths
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

function filter_paths(g, f, nodes...)
    filter(p->f(g,p,nodes), intersect(paths_through.(Ref(g), nodes)...))
end

function with(g::StorageGraph, name::Symbol, cond::Function)
    (g,p,n)->begin
        v = walkpath(g, p, g[n[1]], stopcond=(g,v)->has_prop(g,v,name))
        cond(g[v])
    end
end

function with(g::StorageGraph, conditions::Dict{Symbol,T}; stopcond=(g,v)->false) where {T<:Function}
    (g,path,nodes) -> begin
        walkcond(g, path, conditions, nodes, outneighbors; stopcond=stopcond)
    end
end
