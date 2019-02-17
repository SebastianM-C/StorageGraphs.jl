using Base.Threads

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
    while !stopcond(g, current_node)
        p = paths_through(g, current_node)
        if remaining isa Pair
            # @show compatible_paths
            node = remaining[1]
            if on_path(g, node, p)
                current_node = node
                compatible_paths = compatible_paths ∩ paths_through(g, node, dir=:in)
            else
                return current_node, compatible_paths
            end
            remaining = remaining[2]
        else
            if on_path(g, remaining, p)
                return remaining, compatible_paths ∩ paths_through(g, remaining, dir=:in)
            else
                return current_node, compatible_paths
            end
        end
    end
    return remaining, compatible_paths
end

"""
    walkpath(g, paths, start; dir=:out, stopcond=(g,v)->false)

Walk on the given `paths` starting from `start` and return the last nodes.
If `dir` is specified, use the corresponding edge direction
(`:in` and `:out` are acceptable values).
"""
function walkpath(g, paths::Vector, start::Integer; dir=:out, stopcond=(g,v)->false)
    (dir == :out) ? walkpath(g, paths, start, outneighbors, stopcond=stopcond) :
        walkpath(g, paths, start, inneighbors, stopcond=stopcond)
end

function walkpath(g, paths::Vector, start::Integer, neighborfn; stopcond=(g,v)->false)
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
