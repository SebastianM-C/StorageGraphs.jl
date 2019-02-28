var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#LightGraphs.SimpleGraphs.add_vertex!-Tuple{StorageGraph}",
    "page": "Home",
    "title": "LightGraphs.SimpleGraphs.add_vertex!",
    "category": "method",
    "text": "add_vertex!(g)\nadd_vertex!(g, data)\n\nAdd a vertex to the StorageGraph g with optional data given by the NamedTuple data. Return true if the vertex has been added, false otherwise.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.add_bulk!-Tuple{Any,Any,Any}",
    "page": "Home",
    "title": "StorageGraphs.add_bulk!",
    "category": "method",
    "text": "add_bulk!(g, dep, vals)\n\nAdd the multiple values (vals) of the things identified by the keys of vals, with the dependency chain given by dep. The values of vals are assumed to be vectors. Each added node will correspond to an element of the vectors. Note: The dependency chain must contain all relevant information for identifying the values.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.add_derived_values!-Tuple{Any,Any,NamedTuple,NamedTuple,Vararg{Any,N} where N}",
    "page": "Home",
    "title": "StorageGraphs.add_derived_values!",
    "category": "method",
    "text": "add_derived_values!(g, base_dep, base_val, val, inner_deps...)\n\nAdd multiple values such that the elements in base_val and val are linked in such a way that the order is preserved. This is useful when one wants to add a vector of values derived from another vector. The dependency for the base values (base_dep) must be given as a collection of NamedTuples instead of a nested Pair. Also, any inner dependencies (inner_deps) must be given as individual NamedTuples. A new path is created for each value, but if a part already exists, it is continued (see nextid).\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.add_nodes!-Tuple{Any,Pair}",
    "page": "Home",
    "title": "StorageGraphs.add_nodes!",
    "category": "method",
    "text": "add_nodes!(g, dep::Pair; id=nextid(g))\n\nRecursively add nodes via the dependency chain specified by dep. If any intermediarry node doesn\'t exist, it is created. A new path is created starting from the first node to the last one, but if there is an existing part, it is continued (see nextid).\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.add_path!-Tuple{Any,Any,Any}",
    "page": "Home",
    "title": "StorageGraphs.add_path!",
    "category": "method",
    "text": "add_path!(g, source, dest; id=maxid(g))\n\nCreate a path between the source node and the destination one. If the nodes do not exist, they are created.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.final_neighborhs-Tuple{Any,Pair}",
    "page": "Home",
    "title": "StorageGraphs.final_neighborhs",
    "category": "method",
    "text": "final_neighborhs(g, dep::Pair; dir=:out)\n\nReturn the vertex indices for the neighbors at the end of the dependency chain. Note: this assumes that the dependency chain is valid (all the nodes exist).\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.findnodes-Tuple{Any,Symbol}",
    "page": "Home",
    "title": "StorageGraphs.findnodes",
    "category": "method",
    "text": "findnodes(g, name::Symbol)\n\nFinds the nodes containing name.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.get_prop-Tuple{Any}",
    "page": "Home",
    "title": "StorageGraphs.get_prop",
    "category": "method",
    "text": "get_prop(g)\nget_prop(g, v)\nget_prop(g, e)\nget_prop(g, s, d)\n\nReturn the specific property (data for vertices, ids for edges, max id for the graph) defined for graph g, vertex v, or edge e (optionally referenced by source vertex s and destination vertex d). If property does not exist, return an empty collection.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.has_prop-Tuple{StorageGraph,Integer,Symbol}",
    "page": "Home",
    "title": "StorageGraphs.has_prop",
    "category": "method",
    "text": "has_prop(g, v, prop)\nhas_prop(g, e, prop)\nhas_prop(g, s, d, prop)\n\nReturn true if the property prop belongs to the specific property (data for vertices, ids for dges) for graph g, vertex v, or edge e (optionally referenced by source vertex s and destination vertex d). For nodes this will check if prop is a key of the node, while for edges it will check if prop belongs to the id list.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.nextid-Tuple{Any,Pair}",
    "page": "Home",
    "title": "StorageGraphs.nextid",
    "category": "method",
    "text": "nextid(g, dep::Pair)\n\nFind the next available id such that a dead end (a node with no outgoing paths) along the dependency chain (dep) is continued. If there is no such case, it gives the maximum id (see walkdep).\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.on_path-Tuple{Any,Any,Any}",
    "page": "Home",
    "title": "StorageGraphs.on_path",
    "category": "method",
    "text": "on_path(g, v, path)\n\nCheck if the vertex is on the given path.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.paths_through-Tuple{Any,Integer}",
    "page": "Home",
    "title": "StorageGraphs.paths_through",
    "category": "method",
    "text": "paths_through(g, v::Integer; dir=:out)\n\nReturn a vector of the paths going through the given vertex. If dir is specified, use the corresponding edge direction (:in and :out are acceptable values).\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.set_prop!-Tuple{StorageGraph,Integer,NamedTuple}",
    "page": "Home",
    "title": "StorageGraphs.set_prop!",
    "category": "method",
    "text": "set_prop!(g, val)\nset_prop!(g, v, val)\nset_prop!(g, e, val)\nset_prop!(g, s, d, val)\n\nSet (replace) the specific property (data for vertices, ids for edges, max id for the graph) with value val in graph g, vertex v, or edge e (optionally referenced by source vertex s and destination vertex d). Will return false if vertex or edge does not exist, true otherwise.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.walkdep-Tuple{Any,Pair}",
    "page": "Home",
    "title": "StorageGraphs.walkdep",
    "category": "method",
    "text": "function walkdep(g, dep::Pair; stopcond=(g,v)->false)\n\nWalk along the dependency chain, but only on already existing paths, and return the last node and the compatible paths.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.walkpath-Tuple{Any,Array{T,1} where T,Integer}",
    "page": "Home",
    "title": "StorageGraphs.walkpath",
    "category": "method",
    "text": "walkpath(g, paths, start; dir=:out, stopcond=(g,v)->false)\n\nWalk on the given paths starting from start and return the last nodes. If dir is specified, use the corresponding edge direction (:in and :out are acceptable values).\n\n\n\n\n\n"
},

{
    "location": "#LightGraphs.SimpleGraphs.add_edge!-Tuple{StorageGraph,Vararg{Any,N} where N}",
    "page": "Home",
    "title": "LightGraphs.SimpleGraphs.add_edge!",
    "category": "method",
    "text": "add_edge!(g, u, v, d)\n\nAdd an edge (u, v) to the StorageGraph g with the given id. Return true if the edge has been added, false otherwise.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.extractvals-Tuple{Any,Symbol}",
    "page": "Home",
    "title": "StorageGraphs.extractvals",
    "category": "method",
    "text": "extractvals(nodes, name::Symbol)\n\nReturn an array of values corresponding to name form the array of NamedTuples nodes.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.ordered_dependency-Tuple{Any,Any,Vararg{Any,N} where N}",
    "page": "Home",
    "title": "StorageGraphs.ordered_dependency",
    "category": "method",
    "text": "ordered_dependency(a, b, inner_deps...)\n\nReturn a vector of dependency chains such that the elements of a are linked to the ones in b in such a way that the order is preserved.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.rem_prop!-Tuple{StorageGraph,Integer}",
    "page": "Home",
    "title": "StorageGraphs.rem_prop!",
    "category": "method",
    "text": "rem_prop!(g, v)\nrem_prop!(g, e)\nrem_prop!(g, s, d)\n\nRemove the specific property (data for vertices, ids for edges) from graph g, vertex v, or edge e (optionally referenced by source vertex s and destination vertex d). If property, vertex, or edge does not exist, will not do anything.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.walkpath!-NTuple{5,Any}",
    "page": "Home",
    "title": "StorageGraphs.walkpath!",
    "category": "method",
    "text": "walkpath!(g, path, start, neighborfn, action!; stopcond=(g,v)->false)\n\nWalk on the given path and take an action at each node. The action is specified by a function action!(g, v, neighbors) and it can modify the graph.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.jl-1",
    "page": "Home",
    "title": "StorageGraphs.jl",
    "category": "section",
    "text": "Modules = [StorageGraphs]"
},

]}
