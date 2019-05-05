module StorageGraphs

export StorageGraph, add_nodes!, add_bulk!,
    nextid, paths_through, on_path, walkpath, walkdep, final_neighborhs,
    get_prop, has_prop, set_prop!, plot_graph,
    SGNativeFormat, SGJLDFormat, SGBSONFormat

using LightGraphs
using LightGraphs.SimpleGraphs: SimpleEdge

using GraphPlot

abstract type AbstractStorageGraph{T} <: AbstractGraph{T} end

struct StorageGraph{T<:Integer, N<:NamedTuple} <: AbstractStorageGraph{T}
    graph::SimpleDiGraph{T}
    data::Dict{T,N}
    paths::Dict{SimpleEdge{T},Set{T}}
    maxid::Ref{T}
    index::Dict{N,T}
end

function StorageGraph()
    g = SimpleDiGraph()
    T = eltype(g)
    data = Dict{T,NamedTuple}()
    paths = Dict{SimpleEdge{T},Set{T}}()
    maxid = Ref(one(T))
    index = Dict{NamedTuple,T}()

    StorageGraph(g, data, paths, maxid, index)
end

function StorageGraph{T}() where {T <: Integer}
    graph = SimpleDiGraph{T}()
    data = Dict{T,NamedTuple}()
    paths = Dict{SimpleEdge{T},Set{T}}()
    maxid = Ref(one(T))
    index = Dict{NamedTuple,T}()
    StorageGraph(graph, data, paths, maxid, index)
end

# converts StorageGraph{Int} to StorageGraph{UInt8}
function StorageGraph{T}(g::StorageGraph) where {T <: Integer}
    graph = SimpleDiGraph{T}(g.graph)
    data = Dict{T,NamedTuple}(g.data)
    k = SimpleEdge{T}.(keys(g.paths))
    paths = Dict{SimpleEdge{T},Set{T}}(k.=>values(g.paths))
    maxid = Ref{T}(g.maxid[])
    index = Dict{NamedTuple,T}(g.index)
    StorageGraph(graph, data, paths, maxid, index)
end

function StorageGraph(g::SimpleDiGraph{T}, data::Dict{T, N},
        paths::Dict{SimpleEdge{T},Set{T}}) where {T, N <: NamedTuple}
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
    format(s) = replace(string(s), r"Set\(\[(?<i>\d*(?>, \d*)*)\]\)"=>s"{\g<i>}")
    vlabels = [g.data[i] for i in vertices(g)]
    elabels = [format(g.paths[i]) for i in edges(g)]
    gplot(g; nodelabel=vlabels, edgelabel=elabels, args...)
end

end # module
