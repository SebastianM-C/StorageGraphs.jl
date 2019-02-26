import LightGraphs:
    edgetype, nv, ne, vertices, edges, is_directed,
    add_vertex!, add_edge!, rem_vertex!, rem_edge!,
    has_vertex, has_edge, inneighbors, outneighbors,
    indegree, outdegree, degree,
    induced_subgraph,
    loadgraph, savegraph, AbstractGraphFormat,
    reverse

import LightGraphs.SimpleGraphs:
    SimpleDiGraph,
    SimpleEdge, fadj, badj

function show(io::IO, g::StorageGraph)
    print(io, "{$(nv(g)), $(ne(g))} $dir $(eltype(g)) storage graph")
end

@inline fadj(g::StorageGraph, x...) = fadj(g.graph, x...)
@inline badj(g::StorageGraph, x...) = badj(g.graph, x...)

eltype(g::StorageGraph) = eltype(g.graph)
edgetype(g::StorageGraph) = edgetype(g.graph)
nv(g::StorageGraph) = nv(g.graph)
vertices(g::StorageGraph) = vertices(g.graph)

ne(g::StorageGraph) = ne(g.graph)
edges(g::StorageGraph) = edges(g.graph)

has_vertex(g::StorageGraph, x...) = has_vertex(g.graph, x...)
@inline has_edge(g::StorageGraph, x...) = has_edge(g.graph, x...)

inneighbors(g::StorageGraph, v::Integer) = inneighbors(g.graph, v)
outneighbors(g::StorageGraph, v::Integer) = fadj(g.graph, v)

issubset(g::T, h::T) where T <: StorageGraph = issubset(g.graph, h.graph)

"""
    add_edge!(g, u, v, d)

Add an edge `(u, v)` to the StorageGraph `g` with the given `id`.
Return true if the edge has been added, false otherwise.
"""
@inline add_edge!(g::StorageGraph, x...) = add_edge!(g.graph, x...)
function add_edge!(g::StorageGraph, u::Integer, v::Integer, id::Integer)
    add_edge!(g, u, v) || return false
    set_prop!(g, u, v, id)
    return true
end

@inline function rem_edge!(g::StorageGraph, x...)
    rem_prop!(g, x...)
    rem_edge!(g.graph, x...)
end

"""
    add_vertex!(g)
    add_vertex!(g, data)

Add a vertex to the StorageGraph `g` with optional data given by the
NamedTuple `data`.
Return true if the vertex has been added, false otherwise.
"""
add_vertex!(g::StorageGraph) = add_vertex!(g.graph)
function add_vertex!(g::StorageGraph, data::NamedTuple)
    add_vertex!(g) || return false
    set_props!(g, nv(g), d)
    return true
end

function rem_vertex!(g::StorageGraph, v::Integer)
    rem_prop!(g, v)
    rem_vertex!(g.graph, v)
end

SimpleDiGraph(g::StorageGraph) = g.graph
is_directed(::Type{StorageGraph}) = true
is_directed(::Type{StorageGraph{T}}) where {T} = true
is_directed(g::StorageGraph) = true

"""
    set_prop!(g, val)
    set_prop!(g, v, val)
    set_prop!(g, e, val)
    set_prop!(g, s, d, val)

Set (replace) the specific property (data for vertices, ids for edges, max id for the graph)
with value `val` in graph `g`, vertex `v`, or edge `e` (optionally referenced by
source vertex `s` and destination vertex `d`).
Will return false if vertex or edge does not exist, true otherwise.
"""
function set_prop!(g::StorageGraph, v::Integer, val::NamedTuple)
    if has_vertex(g, v)
        keys(val) ∈ g.names && push!(g.names, keys(val))
        g.data[v] = val
        return true
    end
    return false
end

set_prop!(g::StorageGraph{T}, u::Integer, v::Integer, val::Integer) where {T} = set_prop!(g, Edge(T(u), T(v)), val)

function set_prop!(g::StorageGraph, e::SimpleEdge, val::Integer)
    if has_edge(g, e)
        push!(g.paths[e], val)
        return true
    end
    return false
end

function set_prop!(g::StorageGraph, val)
    g.maxid[] = val
end

"""
    rem_prop!(g, v)
    rem_prop!(g, e)
    rem_prop!(g, s, d)

Remove the specific property (data for vertices, ids for edges) from graph `g`,
vertex `v`, or edge `e` (optionally referenced by source vertex `s` and destination vertex `d`).
If property, vertex, or edge does not exist, will not do anything.
"""
rem_prop!(g::StorageGraph, v::Integer) = delete!(g.data, v)
rem_prop!(g::StorageGraph, e::SimpleEdge) = deleteat!(g.paths, e)
rem_prop!(g::StorageGraph{T}, u::Integer, v::Integer) where {T} = rem_prop!(g, Edge(T(u), T(v)))

==(x::StorageGraph, y::StorageGraph) = (x.graph == y.graph) && (x.data == y.data) && (x.paths == y.paths)

copy(g::T) where T <: StorageGraph = deepcopy(g)

zero(g::StorageGraph{T}) where {T} = StorageGraph{T}(SimpleDiGraph{T}())
