module StorageGraphs

export StorageGraph, add_nodes!, add_vertex!, add_derived_values!, add_path!,
    add_bulk!, nextid, paths_through, on_path, walkpath, walkdep, final_neighborhs,
    findnodes, nodevals, get_prop, set_prop!, plot_graph

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

function plot_graph(g; args...)
    vlabels = [g.data[i] for i in vertices(g)]
    elabels = [g.paths[i] for i in edges(g)]
    gplot(g; nodelabel=vlabels, edgelabel=elabels, args...)
end

end # module
