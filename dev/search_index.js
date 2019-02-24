var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#GraphStorage.add_bulk!-Tuple{Any,Any,Any}",
    "page": "Home",
    "title": "GraphStorage.add_bulk!",
    "category": "method",
    "text": "add_bulk!(g, dep, vals)\n\nAdd the multiple values (vals) of the things identified by the keys of vals, with the dependency chain given by dep. The values of vals are assumed to be vectors. Each added node will correspond to an element of the vectors. Note: The dependency chain must contain all relevant information for identifying the values.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.add_derived_values!-Tuple{Any,Any,NamedTuple,NamedTuple,Vararg{Any,N} where N}",
    "page": "Home",
    "title": "GraphStorage.add_derived_values!",
    "category": "method",
    "text": "add_derived_values!(g, base_dep, base_val, val, inner_deps...)\n\nAdd multiple values such that the elements in base_val and val are linked in such a way that the order is preserved. This is useful when one wants to add a vector of values derived from another vector. The dependency for the base values (base_dep) must be given as a collection of NamedTuples instead of a nested Pair. Also, any inner dependencies (inner_deps) must be given as individual NamedTuples. A new path is created for each value, but if a part already exists, it is continued (see nextid).\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.add_nodes!-Tuple{Any,Pair}",
    "page": "Home",
    "title": "GraphStorage.add_nodes!",
    "category": "method",
    "text": "add_nodes!(g, dep::Pair; id=nextid(g))\n\nRecursively add nodes via the dependency chain specified by dep. If any intermediarry node doesn\'t exist, it is created. A new path is created starting from the first node to the last one, but if there is an existing part, it is continued (see nextid).\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.add_path!-Tuple{Any,Any,Any}",
    "page": "Home",
    "title": "GraphStorage.add_path!",
    "category": "method",
    "text": "add_path!(g, source, dest; id=maxid(g))\n\nCreate a path between the source node and the destination one. If the nodes do not exist, they are created.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.final_neighborhs-Tuple{Any,Pair}",
    "page": "Home",
    "title": "GraphStorage.final_neighborhs",
    "category": "method",
    "text": "final_neighborhs(g, dep::Pair; dir=:out)\n\nReturn the vertex indices for the neighbors at the end of the dependency chain.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.findnodes-Tuple{Any,Symbol}",
    "page": "Home",
    "title": "GraphStorage.findnodes",
    "category": "method",
    "text": "findnodes(g, name::Symbol)\n\nFinds the nodes containing name.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.nextid-Tuple{Any,Pair}",
    "page": "Home",
    "title": "GraphStorage.nextid",
    "category": "method",
    "text": "nextid(g, dep::Pair)\n\nFind the next available id such that a dead end (a node with no outgoing paths) along the dependency chain (dep) is continued. If there is no such case, it gives the maximum id (see walkdep).\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.nodevals-Tuple{Any,Symbol}",
    "page": "Home",
    "title": "GraphStorage.nodevals",
    "category": "method",
    "text": "nodevals(g, name::Symbol)\n\nReturn an array of the values corresponding to name. See also findnodes.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.on_path-Tuple{Any,Any,Any}",
    "page": "Home",
    "title": "GraphStorage.on_path",
    "category": "method",
    "text": "on_path(g, v, path)\n\nCheck if the vertex is on the given path.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.paths_through-Tuple{Any,Integer}",
    "page": "Home",
    "title": "GraphStorage.paths_through",
    "category": "method",
    "text": "paths_through(g, v::Integer; dir=:out)\n\nReturn a vector of the paths going through the given vertex. If dir is specified, use the corresponding edge direction (:in and :out are acceptable values).\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.walkdep-Tuple{Any,Pair}",
    "page": "Home",
    "title": "GraphStorage.walkdep",
    "category": "method",
    "text": "function walkdep(g, dep::Pair; stopcond=(g,v)->false)\n\nWalk along the dependency chain, but only on already existing paths, and return the last node and the compatible paths.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.walkpath-Tuple{Any,Array{T,1} where T,Integer}",
    "page": "Home",
    "title": "GraphStorage.walkpath",
    "category": "method",
    "text": "walkpath(g, paths, start; dir=:out, stopcond=(g,v)->false)\n\nWalk on the given paths starting from start and return the last nodes. If dir is specified, use the corresponding edge direction (:in and :out are acceptable values).\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.add_node!-Tuple{Any,NamedTuple}",
    "page": "Home",
    "title": "GraphStorage.add_node!",
    "category": "method",
    "text": "add_node!(g, val::NamedTuple)\n\nAdd a new node to the storage graph.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.extractvals-Tuple{Any,Any}",
    "page": "Home",
    "title": "GraphStorage.extractvals",
    "category": "method",
    "text": "extractvals(nodes, name)\n\nReturn an array of values corresponding to name form the array of NamedTuples nodes.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.ordered_dependency-Tuple{Any,Any,Vararg{Any,N} where N}",
    "page": "Home",
    "title": "GraphStorage.ordered_dependency",
    "category": "method",
    "text": "ordered_dependency(a, b, inner_deps...)\n\nReturn a vector of dependency chains such that the elements of a are linked to the ones in b in such a way that the order is preserved.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.walkpath!-NTuple{5,Any}",
    "page": "Home",
    "title": "GraphStorage.walkpath!",
    "category": "method",
    "text": "walkpath!(g, path, start, neighborfn, action!; stopcond=(g,v)->false)\n\nWalk on the given path and take an action at each node. The action is specified by a function action!(g, v, neighbors) and it can modify the graph.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.jl-1",
    "page": "Home",
    "title": "GraphStorage.jl",
    "category": "section",
    "text": "Modules = [GraphStorage]"
},

]}
