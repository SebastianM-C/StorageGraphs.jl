"""
    get_node_index(g, val; createnew=true)

Get the index of a node identified by a `NamedTuple`. If it doesn't exist,
it can be created.
"""
function get_node_index(g, val; createnew=true)
    i = -1
    ki = key_index(g, val)
    if ki isa Nothing
        for (k,v) in g.vprops
            if v == Dict(pairs(val))
                i = k
                break
            end
        end
        if i == -1
            createnew && add_node!(g, val)
            @debug "Node not found"
            return nv(g)
        end
    else
        k = keys(val)[ki]
        if !haskey(g[k], val[k])
            createnew && add_node!(g, val)
            @debug "Node not found"
            return nv(g)
        else
            i = g[k][val[k]]
        end
    end
    return i
end

"""
    paths_through(g, v::vType; dir=:out) where {vType <: Integer}

Return a vector of the paths going through the given vertex. If `dir` is specified,
use the corresponding edge direction (`:in` and `:out` are acceptable values).
"""
function paths_through(g, v::vType; dir=:out) where {vType <: Integer}
    v == 0 && return vType[]
    if dir == :out
        out = outneighbors(g, v)
        if isempty(out)
            return vType[]
        else
            es = [Edge(v, i) for i in out]
        end
    else
        in = inneighbors(g, v)
        if isempty(in)
            return vType[]
        else
            es = [Edge(i, v) for i in in]
        end
    end
    union(vType[], get_prop.(Ref(g), es, :id)...)
end

function paths_through(g, dep::Pair; dir=:out)
    intersect(paths_through(g, dep[2], dir=dir), paths_through(g, dep[1], dir=dir))
end

function paths_through(g, val::NamedTuple; dir=:out)
    paths_through(g, get_node_index(g, val, createnew=false), dir=dir)
end

function paths_through(g, prop, val; dir=:out)
    paths_through(g, g[prop][val], dir=dir)
end
