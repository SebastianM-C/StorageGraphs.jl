using LightGraphs

@testset "Constructors" begin
   @test @inferred(StorageGraph()) == StorageGraph(SimpleDiGraph())
   @test eltype(StorageGraph()) == eltype(SimpleDiGraph())
   @test edgetype(StorageGraph()) == edgetype(SimpleDiGraph())
   @test nv(StorageGraph()) == 0
   @test ne(StorageGraph()) == 0
   @test is_directed(StorageGraph)
   @test eltype(@inferred(StorageGraph{UInt8}())) == UInt8
   g = SimpleDiGraph(3)
   sg = StorageGraph(g)
   @test @inferred(StorageGraphs.fadj(sg, 2)) == LightGraphs.SimpleGraphs.fadj(g, 2)
   @test @inferred(StorageGraphs.badj(g, 2)) == LightGraphs.SimpleGraphs.badj(g, 2)
end

@testset "Elementary operations" begin
   g = StorageGraph()
   @test add_vertex!(g, (a=1,))
   @test nv(g) == 1
   @test ne(g) == 0
   @test g.data == Dict(1=>(a=1,))
   @test g.index == Dict((a=1,)=>1)
   @test has_prop(g, 1, :a)
   @test sprint(show, g) == "{1, 0} $(eltype(g)) storage graph"
   @test add_vertex!(g, (b=2,))
   @test nv(g) == 2
   @test ne(g) == 0
   @test g.data == Dict(1=>(a=1,), 2=>(b=2,))
   @test g.index == Dict((a=1,)=>1, (b=2,)=>2)
   @test has_prop(g, 2, :b)
   @test add_edge!(g, 1, 2, 1)
   @test nv(g) == 2
   @test ne(g) == 1
   @test g.paths == Dict(Edge(1,2)=>[1])
   @test has_prop(g, 1, 2, 1)
   @test g.maxid[] == get_prop(g) == 1
   set_prop!(g, 2)
   @test get_prop(g) == 2
   @test rem_edge!(g, 1, 2)
   @test ne(g) == 0
   @test !has_prop(g, 1, 2, 1)
   @test rem_vertex!(g, 2)
   @test nv(g) == 1
   @test !has_prop(g, 2, :b)
   @test rem_vertex!(g, 1)
   @test nv(g) == 0
   @test !has_prop(g, 1, :a)
   @test g == StorageGraph()
end
