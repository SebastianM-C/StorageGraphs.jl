@testset "Graph traversal" begin
    g = StorageGraph()
    @test walkdep(g, (a=1,)=>(b=1,)) == ((a=1,), Int[])
    add_vertex!(g, (a=1,))
    @test nextid(g, (a=1,)=>(b=1,)) == 1
    add_nodes!(g, (a=1,)=>(b=1,))
    @test walkdep(g, (a=1,)=>(b=1,)) == ((b=1,), [1])
    dep = (a=1,)=>(b=1,)=>(c=1,)
    @test walkdep(g, dep) == ((b=1,), [1])
    @test nextid(g, dep) == 1
    add_nodes!(g, dep)
    @test walkdep(g, dep) == ((c=1,), [1])
    @test walkdep(g, dep, stopcond=(g,v)->has_prop(g,g[v],:b)) == ((b=1,), [1])
end
