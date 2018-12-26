using LightGraphs, MetaGraphs

@testset "Graph creation" begin
    g = MetaDiGraph()
    indexby(g, :B)
    add_nodes!(g, (A=1,)=>(D=0.4,)=>(B=0.5,))
    @test nv(g) == 3
    @test ne(g) == 2
    @test props(g, 1) == Dict(:D=>0.4)
    @test props(g, 2) == Dict(:B=>0.5)
    @test props(g, 3) == Dict(:A=>1)
    @test has_prop(g, :id)
    @test :B ∈ g.indices
end
