var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
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
    "location": "#StorageGraphs.paths_through-Tuple{Any,Integer}",
    "page": "Home",
    "title": "StorageGraphs.paths_through",
    "category": "method",
    "text": "paths_through(g, v::Integer; dir=:out)\n\nReturn a vector of the paths going through the given vertex. If dir is specified, use the corresponding edge direction (:in and :out are acceptable values).\n\n\n\n\n\n"
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
    "location": "#StorageGraphs.walkdep-Tuple{Any,Pair}",
    "page": "Home",
    "title": "StorageGraphs.walkdep",
    "category": "method",
    "text": "function walkdep(g, dep::Pair; stopcond=(g,v)->false)\n\nWalk along the dependency chain, but only on already existing paths, and return the last node and the compatible paths.\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs.walkpath-Tuple{Any,Any,Integer}",
    "page": "Home",
    "title": "StorageGraphs.walkpath",
    "category": "method",
    "text": "walkpath(g, paths, start; dir=:out, stopcond=(g,v)->false)\n\nWalk on the given paths starting from start and return the last nodes. If dir is specified, use the corresponding edge direction (:in and :out are acceptable values).\n\n\n\n\n\n"
},

{
    "location": "#StorageGraphs-1",
    "page": "Home",
    "title": "StorageGraphs",
    "category": "section",
    "text": "StorageGraphs is a package for storing hierarchical data in graphs in a non-redundant way. This package aims to be useful when one has a combination of data and metadata or parameters and the use of tables would lead to a lot of redundancy in the corresponding columns.Modules = [StorageGraphs]\nPages = [\n  \"add.jl\",\n  \"query.jl\",\n  \"walk.jl\"\n]\nPrivate = false"
},

]}
