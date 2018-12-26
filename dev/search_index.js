var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#GraphStorage.add_nodes!-Tuple{Any,Pair}",
    "page": "Home",
    "title": "GraphStorage.add_nodes!",
    "category": "method",
    "text": "add_nodes!(g, dep::Pair; id=maxid(g))\n\nRecursively add nodes via the dependency chain specified by dep. If any intermediarry node doesn\'t exist, it is created. A new path is created starting from the first node to the last one.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.add_path!-Tuple{Any,Any,Any}",
    "page": "Home",
    "title": "GraphStorage.add_path!",
    "category": "method",
    "text": "add_path!(g, source, dest; id=maxid(g))\n\nCreate a path between the source node and the destination one. If the nodes do not exist, they are created.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.add_quantity!-Tuple{Any,Any,Any}",
    "page": "Home",
    "title": "GraphStorage.add_quantity!",
    "category": "method",
    "text": "add_quantity!(g, dep, vals)\n\nAdd the multiple values (vals) of the things identified by the keys of vals, with the dependency chain given by dep. The values of vals are assumed to be vectors. Each added node will correspond to an element of the vectors. Note: The dependency chain must contain all relevant information for identifying the values.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.get_node_index-Tuple{Any,Any}",
    "page": "Home",
    "title": "GraphStorage.get_node_index",
    "category": "method",
    "text": "get_node_index(g, val; createnew=true)\n\nGet the index of a node identified by a NamedTuple. If it doesn\'t exist, it can be created.\n\n\n\n\n\n"
},

{
    "location": "#GraphStorage.indexby-Tuple{Any,Any}",
    "page": "Home",
    "title": "GraphStorage.indexby",
    "category": "method",
    "text": "indexby(g, key)\n\nSet key as an indexing property.\n\n\n\n\n\n"
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
