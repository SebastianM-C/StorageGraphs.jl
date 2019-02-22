module GraphStorage

export add_nodes!, nextid, maxid, indexof, add_path!, indexby,
    paths_through, on_path, walkpath, walkdep, add_bulk!, add_derived_values!,
    final_neighborhs, plot_graph

using LightGraphs, MetaGraphs
using GraphPlot

include("add.jl")
include("query.jl")
include("walk.jl")

maxid(g) = haskey(g.gprops, :id) ? g.gprops[:id] : 1

"""
    nextid(g, dep::Pair)

Find the next available id such that a dead end (a node with no outgoing paths)
along the dependency chain (`dep`) is continued. If there is no such case, it
gives the maximum id (see [`walkdep`](@ref)).
"""
function nextid(g, dep::Pair)
    dep_end, cpath = walkdep(g, dep)
    v = indexof(g, dep_end)
    v == 0 && return maxid(g)
    if length(outneighbors(g, v)) > 0
        return maxid(g)
    else
        neighbors = inneighbors(g, v)
        # there is only one possible edge
        previ = findfirst(n->on_path(g, n, cpath, dir=:out), neighbors)
        e = Edge(neighbors[previ], v)
        id = g.eprops[e][:id]
        # Can there be multiple path ids?
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
