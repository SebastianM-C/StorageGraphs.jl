"""
    indexof(g, node; createnew=true)

Get the index of a node identified by a `NamedTuple`. If the node doesn't
exist the next available index can be returned.
"""
function indexof(g, node; next=false)
    i = nothing
    ki = key_index(g, node)
    if ki isa Nothing
        i = findfirst(v->v == Dict(pairs(node)), g.vprops)
        if i isa Nothing
            @debug "Node not found"
            return !next ? 0 : nv(g) + 1
        end
    else
        k = keys(node)[ki]
        if !haskey(g[k], node[k])
            @debug "Node not found"
            return !next ? 0 : nv(g) + 1
        else
            i = g[k][node[k]]
        end
    end
    return i
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

key_index(g, node) = findfirst(i -> i ∈ g.indices, keys(node))

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

function paths_through(g, node::NamedTuple; dir=:out)
    paths_through(g, indexof(g, node), dir=dir)
end

function paths_through(g, prop, val; dir=:out)
    paths_through(g, g[prop][val], dir=dir)
end
