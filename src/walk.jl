using Base.Threads

"""
    nextid(g, dep::Pair)

Find the next available id such that a dead end (a node with no outgoing paths)
along the dependency chain (`dep`) is continued. If there is no such case, it
gives the maximum id (see [`walkdep`](@ref)).
"""
function nextid(g, dep::Pair)
    dep_end, cpath = walkdep(g, dep)
    !haskey(g.index, dep_end) && return get_prop(g)
    v = g[dep_end]
    if outdegree(g, v) > 0
        return get_prop(g)
    else
        neighbors = inneighbors(g, v)
        # there is only one possible edge
        previ = findfirst(n->on_path(g, n, cpath, dir=:out), neighbors)
        # check if the node is isolated and there are no ingoing edges
        previ === nothing && return get_prop(g)
        e = Edge(neighbors[previ], v)
        id = g.paths[e]
        # There cannot be more than one path since ids are unique and a different
        # path id would be neended only if there were a difference "further down"
        # the graph, but this is not the case since this node has no outgoing paths.
        @assert length(id) == 1
        return id[1]
    end
end

"""
    on_path(g, v, path)

Check if the vertex is on the given path.
"""
function on_path(g, v, path; dir=:in)
    !isempty(paths_through(g, v, dir=dir) ∩ path)
end

"""
    function walkdep(g, dep::Pair; stopcond=(g,v)->false)

Walk along the dependency chain, but only on already existing paths, and return
the last node and the compatible paths.
"""
function walkdep(g, dep::Pair; stopcond=(g,v)->false)
    current_node = dep[1]
    remaining = dep[2]
    compatible_paths = paths_through(g, current_node) ∪ paths_through(g, current_node, dir=:in)
    # @debug compatible_paths
    while !stopcond(g, current_node)
        p = paths_through(g, current_node)
        if remaining isa Pair
            node = remaining[1]
            possible_paths = paths_through(g, node, dir=:in)
            if !isempty(possible_paths ∩ p)
                current_node = node
                intersect!(compatible_paths, possible_paths)
            else
                return current_node, compatible_paths
            end
            remaining = remaining[2]
        else
            possible_paths = paths_through(g, remaining, dir=:in)
            if !isempty(possible_paths ∩ p)
                return remaining, intersect!(compatible_paths, possible_paths)
            else
                return current_node, compatible_paths
            end
        end
    end
    return current_node, compatible_paths
end

"""
    walkpath(g, paths, start; dir=:out, stopcond=(g,v)->false)

Walk on the given `paths` starting from `start` and return the last nodes.
If `dir` is specified, use the corresponding edge direction
(`:in` and `:out` are acceptable values).
"""
function walkpath(g, paths, start::Integer; dir=:out, stopcond=(g,v)->false)
    (dir == :out) ? walkpath(g, paths, start, outneighbors, stopcond=stopcond) :
        walkpath(g, paths, start, inneighbors, stopcond=stopcond)
end

function walkpath(g, paths, start::Integer, neighborfn; stopcond=(g,v)->false)
    result = Vector{eltype(g)}(undef, length(paths))
    @threads for i ∈ eachindex(paths)
        result[i] = walkpath(g, paths[i], start, neighborfn, stopcond=stopcond)
    end
    return result
end

function walkpath(g, path::Integer, start::Integer, neighborfn; stopcond=(g,v)->false)
    walkpath!(g, path, start, neighborfn, (g,v,n)->nothing, stopcond=stopcond)
end

"""
    walkpath!(g, path, start, neighborfn, action!; stopcond=(g,v)->false)

Walk on the given `path` and take an action at each node. The action is specified
by a function `action!(g, v, neighbors)` and it can modify the graph.
"""
function walkpath!(g, path, start, neighborfn, action!; stopcond=(g,v)->false)
    while !stopcond(g, start)
        neighbors = neighborfn(g, start)
        action!(g, start, neighbors)
        nexti = findfirst(n->on_path(g, n, path), neighbors)
        if nexti isa Nothing
            return start
        end
        start = neighbors[nexti]
    end
    return start
end

function walkcond(g, path, conditions, nodes, neighborfn; stopcond=(g,v)->false)
    start = g[nodes[1]]
    # @show path
    while !stopcond(g, start)
        neighbors = neighborfn(g, start)
        nexti = findfirst(n->on_path(g, n, path), neighbors)
        if nexti isa Nothing
            break
        end
        found = false
        satisfies_cond = false
        for (name,cond) in conditions
            # @show g[start]
            if has_prop(g, start, name)
                found = true
                satisfies_cond = cond(g[start])
                # @show cond(g[start])
                break
            end
        end
        (found && !satisfies_cond) && return false
        start = neighbors[nexti]
    end
    return true
end
