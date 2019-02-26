@testset "Graph traversal" begin
    g = StorageGraph()
    @test walkdep(g, (a=1,)=>(b=1,)) == ((a=1,), Int[])
end
