using Logging

@testset "Graph traversal" begin
    g = StorageGraph()
    @test walkdep(g, (a=1,)=>(b=1,)) == ((a=1,), Int[])
    StorageGraphs.add_vertex!(g, (a=1,))
    @test nextid(g, (a=1,)=>(b=1,)) == 1
    add_nodes!(g, (a=1,)=>(b=1,))
    @test walkdep(g, (a=1,)=>(b=1,)) == ((b=1,), [1])

    dep = (a=1,)=>(b=1,)=>(c=1,)
    @test walkdep(g, dep) == ((b=1,), [1])
    @test nextid(g, dep) == 1
    add_nodes!(g, dep)
    @test walkdep(g, dep) == ((c=1,), [1])
    @test walkdep(g, dep, stopcond=(g,v)->has_prop(g,g[v],:b)) == ((b=1,), [1])

    add_nodes!(g, (a=1,)=>(b=1,)=>(c=2,))
    add_nodes!(g, (a=1,)=>(b=2,)=>(c=1,))
    v = walkpath(g, 1, g[(a=1,)])
    @test g[v] == (c=1,)
    @test length(v) == 1
    v = walkpath(g, 1, g[(a=1,)], stopcond=(g,v)->has_prop(g,v,:b))
    @test g[v] == (b=1,)
    a(g,v,n) = @debug v
    @test @test_logs((:debug, 1), (:debug, 2), (:debug, 3),
        min_level=Logging.Debug, match_mode=:all,
        StorageGraphs.walkpath!(g, 1, g[(a=1,)], outneighbors, a)) == 3

end
