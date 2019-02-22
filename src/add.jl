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
        set_prop!(g, :id, id+1)
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
    sv = haskey(g, source) ? g[source, :data] : nv(g) + 1
    sv > nv(g) && add_node!(g, source)
    dv = haskey(g, dest) ? g[dest, :data] : nv(g) + 1
    dv > nv(g) && add_node!(g, dest)
    if has_edge(g, sv, dv)
        push!(g.eprops[Edge(sv,dv)][:id], id)
        unique!(g.eprops[Edge(sv,dv)][:id])
    else
        add_edge!(g, sv, dv, Dict(:id=>[id]))
    end
end

"""
    add_node!(g, val::NamedTuple)

Add a new node to the storage graph.
"""
function add_node!(g, val::NamedTuple)
    add_vertex!(g)
    set_prop!(g, nv(g), :data, val)
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
be vectors. Each added node will correspond to an element of the vectors.
Note: The dependency chain must contain all relevant information for
identifying the values.
"""
function add_bulk!(g, dep, vals)
    dep_end = endof(dep)
    for i in eachindex(values(vals[1]))
        add_nodes!(g, dep)
        # decrease the id to stay on the same path
        id = nextid(g, dep)
        if id == maxid(g)
            id -= 1
            g.gprops[:id] -= 1
        end
        val = (v[i] for v in vals)
        add_nodes!(g, dep_end=>NamedTuple{keys(vals)}(val), id=id)
    end
end

"""
    ordered_dependency(a, b, inner_deps...)

Return a vector of dependency chains such that the elements of `a` are linked
to the ones in `b` in such a way that the order is preserved.
"""
function ordered_dependency(a, b, inner_deps...)
    deps = Tuple[]
    for i in eachindex(values(a[1]), values(b[1]))
        val = (v[i] for v in a)
        node_a = NamedTuple{keys(a)}(val)
        val = (v[i] for v in b)
        node_b = NamedTuple{keys(b)}(val)
        push!(deps, (node_a, inner_deps..., node_b))
    end
    return deps
end

"""
    add_derived_values!(g, base_dep, base_val, val, inner_deps...)

Add multiple values such that the elements in `base_val` and `val` are
linked in such a way that the order is preserved. This is useful when
one wants to add a vector of values derived from another vector.
The dependency for the base values (`base_dep`) must be given as a collection
of `NamedTuple`s instead of a nested `Pair`. Also, any inner dependencies (`inner_deps`)
must be given as individual `NamedTuple`s.
A new path is created for each value, but if a part already exists,
it is continued (see [`nextid`](@ref)).
"""
function add_derived_values!(g, base_dep, base_val::NamedTuple, val::NamedTuple, inner_deps...)
    deps = ordered_dependency(base_val, val, inner_deps...)
    for dep in deps
        full_dep = foldr(=>, (base_dep..., dep...))
        # @show full_dep
        add_nodes!(g, full_dep)
    end
end

function add_derived_values!(g, base_val::NamedTuple, val::NamedTuple, inner_deps...)
    deps = ordered_dependency(base_val, val, inner_deps...)
    for dep in deps
        full_dep = foldr(=>, dep)
        add_nodes!(g, full_dep)
    end
end
