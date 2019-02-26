@testset "Graph traversal" begin
    g = StorageGraph()
    @test walkdep(g, (a=1,)=>(b=1,)) == ((a=1,), Int[])
    add_nodes!(g, (a=1,)=>(b=1,))
    @test walkdep(g, (a=1,)=>(b=1,)) == ((b=1,), [1])
    dep = (a=1,)=>(b=1,)=>(c=1,)
    @test walkdep(g, dep) == ((b=1,), [1])
    @test nextid(g, dep) == 1
    add_nodes!(g, dep)
    @test walkdep(g, dep) == ((c=1,), [1])
end
