module GraphStorage

export add_nodes!, nextid, maxid, get_node_index, add_path!, indexby,
    paths_through, on_path, walkpath, walkdep, add_bulk!, plot_graph

using LightGraphs, MetaGraphs
using GraphPlot
using Base.Threads

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
    v = get_node_index(g, dep_end, createnew=false)
    v == 0 && return 1
    if length(outneighbors(g, v)) > 0
        return maxid(g)
    else
        # what to do if there are multiple path ids?
        neighbors = inneighbors(g, v)
        previ = findfirst(n->on_path(g, n, cpath, dir=:out), neighbors)
        e = Edge(neighbors[previ], v)
        id = g.eprops[e][:id]
        return length(id) == 1 ? id[1] : id
    end
end

"""
    indexby(g, key)

Set `key` as an indexing property.
"""
function indexby(g, key)
    if key ∉ g.indices
        g.metaindex[key] = Dict{Any,Integer}()
        push!(g.indices, key)
    end
end

key_index(g, val) = findfirst(i -> i ∈ g.indices, keys(val))

function plot_graph(g)
    formatprop(p::Dict) = replace(string(p), "Dict{Symbol,Any}"=>"")
    vlabels = [formatprop(g.vprops[i]) for i in vertices(g)]
    elabels = [g.eprops[i][:id] for i in edges(g)]
    gplot(g, nodelabel=vlabels, edgelabel=elabels)
end

end # module
