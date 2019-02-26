module GraphStorage

export StorageGraph, add_nodes!, nextid, add_derived_values!, add_path!,
    add_bulk!, paths_through, on_path, walkpath, walkdep, final_neighborhs,
    findnodes, nodevals, plot_graph

using LightGraphs
using LightGraphs.SimpleGraphs: SimpleEdge

using GraphPlot

struct StorageGraph{T<:Integer} <: AbstractGraph{T}
    graph::SimpleDiGraph{T}
    data::Dict{T,NamedTuple}
    paths::Dict{SimpleEdge{T},Vector{T}}
    maxid::Ref{T}
    index::Dict{NamedTuple,T}
end

function StorageGraph(x)
    T = eltype(x)
    g = SimpleDiGraph(x)
    data = Dict{T,NamedTuple}()
    paths = Dict{SimpleEdge{T},Vector{T}}()
    maxid = Ref(one(T))
    index = Dict{NamedTuple,T}()

    StorageGraph(g, data, paths, maxid, index)
end

StorageGraph() = StorageGraph(SimpleDiGraph())
StorageGraph{T}() where {T <: Integer} = StorageGraph(SimpleDiGraph{T}())
StorageGraph{T}(x::Integer) where {T <: Integer} = StorageGraph(T(x))

# converts StorageGraph{Int} to StorageGraph{UInt8}
StorageGraph{T}(g::StorageGraph) where {T <: Integer} = StorageGraph(SimpleDiGraph{T}(g.graph))

include("interface.jl")
include("add.jl")
include("query.jl")
include("walk.jl")

"""
    nextid(g, dep::Pair)

Find the next available id such that a dead end (a node with no outgoing paths)
along the dependency chain (`dep`) is continued. If there is no such case, it
gives the maximum id (see [`walkdep`](@ref)).
"""
function nextid(g, dep::Pair)
    dep_end, cpath = walkdep(g, dep)
    !haskey(g.data, dep_end) && return g.maxid[]
    v = g[dep_end]
    if length(outneighbors(g, v)) > 0
        return maxid(g)
    else
        neighbors = inneighbors(g, v)
        # there is only one possible edge
        previ = findfirst(n->on_path(g, n, cpath, dir=:out), neighbors)
        e = Edge(neighbors[previ], v)
        id = g.path[e]
        # There cannot be more than one path since ids are unique and a different
        # path id would be neended only if there were a difference "further down"
        # the graph, but this is not the case since this node has no outgoing paths.
        @assert length(id) == 1
        return id[1]
    end
end

function plot_graph(g; args...)
    vlabels = [g.data[i] for i in vertices(g)]
    elabels = [g.paths[i] for i in edges(g)]
    gplot(g; nodelabel=vlabels, edgelabel=elabels, args...)
end

end # module
