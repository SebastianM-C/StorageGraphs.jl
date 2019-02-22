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
    paths_through(g, g[node, :data], dir=dir)
end

"""
    final_neighborhs(g, dep::Pair; dir=:out)

Return the vertex indices for the neighbors at the end of the dependency chain.
"""
function final_neighborhs(g, dep::Pair; dir=:out)
    v = g[endof(dep), :data]
    dir == :out ? outneighbors(g, v) : inneighbors(g, v)
end
