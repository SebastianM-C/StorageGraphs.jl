module StorageGraphs

export StorageGraph, add_nodes!, add_derived_values!, add_bulk!,
    nextid, paths_through, on_path, walkpath, walkdep, final_neighborhs,
    get_prop, has_prop, set_prop!, with, plot_graph,
    SGNativeFormat, SGJLDFormat

using LightGraphs
using LightGraphs.SimpleGraphs: SimpleEdge

using GraphPlot

struct StorageGraph{T<:Integer, N<:NamedTuple} <: AbstractGraph{T}
    graph::SimpleDiGraph{T}
    data::Dict{T,N}
    paths::Dict{SimpleEdge{T},Vector{T}}
    maxid::Ref{T}
    index::Dict{N,T}
end

function StorageGraph()
    g = SimpleDiGraph()
    T = eltype(g)
    data = Dict{T,NamedTuple}()
    paths = Dict{SimpleEdge{T},Vector{T}}()
    maxid = Ref(one(T))
    index = Dict{NamedTuple,T}()

    StorageGraph(g, data, paths, maxid, index)
end

function StorageGraph{T}() where {T <: Integer}
    graph = SimpleDiGraph{T}()
    data = Dict{T,NamedTuple}()
    paths = Dict{SimpleEdge{T},Vector{T}}()
    maxid = Ref(one(T))
    index = Dict{NamedTuple,T}()
    StorageGraph(graph, data, paths, maxid, index)
end

# converts StorageGraph{Int} to StorageGraph{UInt8}
function StorageGraph{T}(g::StorageGraph) where {T <: Integer}
    graph = SimpleDiGraph{T}(g.graph)
    data = Dict{T,NamedTuple}(g.data)
    k = SimpleEdge{T}.(keys(g.paths))
    paths = Dict{SimpleEdge{T},Vector{T}}(k.=>values(g.paths))
    maxid = Ref{T}(g.maxid[])
    index = Dict{NamedTuple,T}(g.index)
    StorageGraph(graph, data, paths, maxid, index)
end

function StorageGraph(g::SimpleDiGraph{T}, data::Dict{T, N},
        paths::Dict{SimpleEdge{T},Vector{T}}) where {T, N <: NamedTuple}
    maxid = Ref(maximum(maximum.(values(paths)))+one(T))
    index = Dict(values(data).=>keys(data))

    StorageGraph(g, data, paths, maxid, index)
end

include("interface.jl")
include("add.jl")
include("query.jl")
include("walk.jl")
include("persistence.jl")

function plot_graph(g; args...)
    vlabels = [g.data[i] for i in vertices(g)]
    elabels = [g.paths[i] for i in edges(g)]
    gplot(g; nodelabel=vlabels, edgelabel=elabels, args...)
end

end # module
