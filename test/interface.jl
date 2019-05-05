using LightGraphs

@testset "Constructors" begin
   @test @inferred(StorageGraph()) == StorageGraph()
   @test eltype(StorageGraph{UInt8}()) == UInt8
   @test eltype(StorageGraph()) == eltype(SimpleDiGraph())
   @test edgetype(StorageGraph()) == edgetype(SimpleDiGraph())
   @test nv(StorageGraph()) == 0
   @test ne(StorageGraph()) == 0
   @test is_directed(StorageGraph)
   @test is_directed(StorageGraph())
   @test eltype(@inferred(StorageGraph{UInt8}())) == UInt8
   @test @inferred(SimpleDiGraph(StorageGraph())) == SimpleDiGraph()

   g = SimpleDiGraph(3)
   add_edge!(g, 1, 2)
   add_edge!(g, 2, 3)
   data = Dict(1=>(a=1,),2=>(a=2,),3=>(a=3,))
   paths = Dict(Edge(1, 2)=>Set(1), Edge(2, 3)=>Set(1))
   sg = StorageGraph(g, data, paths)
   @test @inferred(StorageGraph(g, data, paths)) == sg
   @test nv(sg) == nv(g)
   @test ne(sg) == ne(g)
   @test sg.data == data
   @test sg.paths == paths
   @test sg.maxid[] == 2
   @test sg.index == Dict((a=1,)=>1,(a=2,)=>2,(a=3,)=>3)

   @test @inferred(StorageGraphs.fadj(sg, 2)) == LightGraphs.SimpleGraphs.fadj(g, 2)
   @test @inferred(StorageGraphs.badj(sg, 2)) == LightGraphs.SimpleGraphs.badj(g, 2)

   @test outneighbors(sg, 1) == outneighbors(sg, (a=1,)) == [2]

   ng = StorageGraph{UInt8}(sg)
   @test eltype(ng) == UInt8
   @test eltype(ng.data) == Pair{UInt8,NamedTuple}
   @test eltype(ng.maxid) == UInt8
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
   @test !set_prop!(g, 3, (x="doesn't exist",))
   @test !set_prop!(g, 1, 2, 0)

   @test add_edge!(g, 1, 2, 1)
   @test nv(g) == 2
   @test ne(g) == 1
   @test g.paths == Dict(Edge(1,2)=>Set(1))
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
