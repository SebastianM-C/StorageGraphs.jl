using LightGraphs, MetaGraphs

@testset "Graph creation" begin
    g = MetaDiGraph()
    add_node!(g, (A=1,)=>(D=0.4,)=>(B=0.5,))
    @test nv(g) == 3
    @test ne(g) == 2
end
