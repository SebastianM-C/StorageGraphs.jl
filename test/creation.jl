using LightGraphs, MetaGraphs

@testset "Graph creation" begin
    g = MetaDiGraph()
    indexby(g, :B)
    @test maxid(g) == 1
    add_nodes!(g, (A=1,)=>(D=0.4,)=>(B=0.5,))
    @test nv(g) == 3
    @test ne(g) == 2
    @test props(g, 1) == Dict(:D=>0.4)
    @test props(g, 2) == Dict(:B=>0.5)
    @test props(g, 3) == Dict(:A=>1)
    @test has_prop(g, :id)
    @test maxid(g) == 2
    @test :B ∈ g.indices
end

@testset "Adding data" begin
    g = MetaDiGraph()
    indexby(g, :B)
    add_quantity!(g, (A=1,)=>(B=0.4,), (q₀=[[1,2],[2,3]], q₂=[[0,1],[2,4]]))
    @test nv(g) == 4
    @test ne(g) == 3
    @test props(g, 1) == Dict(:A=>1)
    @test props(g, 2) == Dict(:B=>0.4)
    @test props(g, 3) == Dict(:q₀=>[1,2],:q₂=>[0,1])
    @test props(g, 4) == Dict(:q₀=>[2,3],:q₂=>[2,4])
    @test props(g, 1, 2) == Dict(:id=>[1,2])
    @test props(g, 2, 3) == Dict(:id=>[1])
    @test props(g, 2, 4) == Dict(:id=>[2])

    add_quantity!(g, (A=1,)=>(B=0.5,), (q₀=[[-1,2],[-2,3]], q₂=[[0,-1],[2,-4]]))
    @test nv(g) == 7
    @test ne(g) == 6
    @test props(g, 5) == Dict(:B=>0.5)
    @test props(g, 6) == Dict(:q₀=>[-1,2],:q₂=>[0,-1])
    @test props(g, 7) == Dict(:q₀=>[-2,3],:q₂=>[2,-4])
    @test props(g, 1, 5) == Dict(:id=>[3,4])
    @test props(g, 5, 6) == Dict(:id=>[3])
    @test props(g, 5, 7) == Dict(:id=>[4])
end
