using LightGraphs

@testset "Constructors" begin
   @test @inferred(StorageGraph()) == StorageGraph(SimpleDiGraph())
   @test eltype(StorageGraph()) == eltype(SimpleDiGraph())
   @test edgetype(StorageGraph()) == edgetype(SimpleDiGraph())
   @test nv(StorageGraph()) == 0
   @test ne(StorageGraph()) == 0
   @test is_directed(StorageGraph)
end

@testset "Elementary operations" begin
   g = StorageGraph()
   @test add_vertex!(g, (a=1,))
   @test nv(g) == 1
   @test ne(g) == 0
   @test g.data == Dict(1=>(a=1,))
   @test g.index == Dict((a=1,)=>1)
   @test add_vertex!(g, (b=2,))
   @test nv(g) == 2
   @test ne(g) == 0
   @test g.data == Dict(1=>(a=1,), 2=>(b=2,))
   @test g.index == Dict((a=1,)=>1, (b=2,)=>2)
   @test add_edge!(g, 1, 2, 1)
   @test nv(g) == 2
   @test ne(g) == 1
   @test g.paths == Dict(Edge(1,2)=>[1])
   @test g.maxid[] == 1
   StorageGraphs.set_prop!(g, 2)
   @test g.maxid[] == 2
   @test rem_edge!(g, 1, 2)
   @test ne(g) == 0
   @test rem_vertex!(g, 2)
   @test nv(g) == 1
   @test rem_vertex!(g, 1)
   @test nv(g) == 0
   @test g == StorageGraph()
end
