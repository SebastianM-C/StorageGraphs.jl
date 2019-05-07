"""
    add_nodes!(g, dep::Pair; id=nextid(g))

Recursively add nodes via the dependency chain specified by `dep`.
If any intermediarry node doesn't exist, it is created.
A new path is created starting from the first node to the last one, but
if there is an existing part, it is continued (see [`nextid`](@ref)).
"""
function add_nodes!(g, dep::Pair; id=nextid(g, dep))
    if dep[2] isa Pair
        dest = add_nodes!(g, dep[2], id=id)
    else
        dest = dep[2]
        if id == get_prop(g)
            # We are on a new path
            set_prop!(g, id+1)
        end
    end
    add_path!(g, dep[1], dest, id=id)

    return dep[1]
end

"""
    add_path!(g, source, dest; id=maxid(g))

Create a path between the source node and the destination one.
If the nodes do not exist, they are created.
"""
function add_path!(g, source, dest; id=maxid(g))
    sv = haskey(g.index, source) ? g[source] : nv(g) + 1
    sv > nv(g) && add_vertex!(g, source)
    dv = haskey(g.index, dest) ? g[dest] : nv(g) + 1
    dv > nv(g) && add_vertex!(g, dest)
    if has_edge(g, sv, dv)
        set_prop!(g, sv, dv, id)
    else
        add_edge!(g, sv, dv, id)
    end
end

function endof(dep)
    if dep[2] isa Pair
        return endof(dep[2])
    else
        return dep[2]
    end
end

"""
    add_bulk!(g, dep, vals)

Add the multiple values (`vals`) of the things identified by the keys of `vals`,
with the dependency chain given by `dep`. The values of `vals` are assumed to
be _equal length_ vectors. Each added node will correspond to an element of the vectors.
Note: The dependency chain must contain all relevant information for
identifying the values.

The function returns the ids of the paths corresponding to the added values.
"""
function add_bulk!(g, dep, vals)
    dep_end = endof(dep)
    # nextid(g, dep) is expensive
    # We can campute all ids in advance with only one call (for the first)
    ids = range(nextid(g, dep), length=length(values(vals[1])), step=1)
    for i in eachindex(values(vals[1]))
        # created the path up to the nodes to be added
        add_nodes!(g, dep, id=ids[i])
        val = (v[i] for v in vals)
        # add the values
        add_nodes!(g, dep_end=>NamedTuple{keys(vals)}(val), id=ids[i])
    end
    return ids
end
