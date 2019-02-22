module GraphStorage

export StorageGraph, add_nodes!, nextid, maxid, add_derived_values!, add_path!,
    add_bulk!, paths_through, on_path, walkpath, walkdep, final_neighborhs,
    plot_graph

using LightGraphs, MetaGraphs
using GraphPlot

include("add.jl")
include("query.jl")
include("walk.jl")

function StorageGraph()
    g = MetaDiGraph()
    set_indexing_prop!(g, :data)
    return g
end

maxid(g) = haskey(g.gprops, :id) ? g.gprops[:id] : 1

"""
    nextid(g, dep::Pair)

Find the next available id such that a dead end (a node with no outgoing paths)
along the dependency chain (`dep`) is continued. If there is no such case, it
gives the maximum id (see [`walkdep`](@ref)).
"""
function nextid(g, dep::Pair)
    dep_end, cpath = walkdep(g, dep)
    haskey(g[:data], end_dep) && return maxid(g)
    v = g[dep_end, :data]
    if length(outneighbors(g, v)) > 0
        return maxid(g)
    else
        neighbors = inneighbors(g, v)
        # there is only one possible edge
        previ = findfirst(n->on_path(g, n, cpath, dir=:out), neighbors)
        e = Edge(neighbors[previ], v)
        id = g.eprops[e][:id]
        # There cannot be more than one path since ids are unique and a different
        # path id would be neended only if there were a difference "further down"
        # the graph, but this is not the case since this node has no outgoing paths.
        @assert length(id) == 1
        return id[1]
    end
end

function plot_graph(g; args...)
    formatprop(p::Dict) = replace(string(p), "Dict{Symbol,Any}"=>"")
    vlabels = [formatprop(g.vprops[i]) for i in vertices(g)]
    elabels = [g.eprops[i][:id] for i in edges(g)]
    gplot(g; nodelabel=vlabels, edgelabel=elabels, args...)
end

end # module
