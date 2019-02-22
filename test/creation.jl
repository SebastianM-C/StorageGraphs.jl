using LightGraphs, MetaGraphs

@testset "Graph creation" begin
    g = StorageGraph()
    @test maxid(g) == 1
    @test nextid(g, (A=1,)=>(D=0.4,)) == 1
    add_nodes!(g, (A=1,)=>(D=0.4,)=>(B=0.5,))
    @test nv(g) == 3
    @test ne(g) == 2
    @test props(g, 1) == Dict(:data=>(D=0.4,))
    @test props(g, 2) == Dict(:data=>(B=0.5,))
    @test props(g, 3) == Dict(:data=>(A=1,))
    @test has_prop(g, :id)
    @test maxid(g) == 2
    dep = (A=1,)=>(D=0.4,)=>(B=0.5,)
    dep2 = (A=1,)=>(D=0.4,)=>(B=0.6,)
    dep3 = (A=1,)=>(D=0.5,)=>(B=0.5,)
    dep4 = (A=2,)=>(D=0.4,)
    @test nextid(g, dep) == 1
    @test nextid(g, dep2) == 2
    @test nextid(g, dep3) == 2
    @test nextid(g, dep3) == 2
    @test :B ∈ g.indices
end

@testset "Adding data proggresively" begin
    g = StorageGraph()

    @testset "add_nodes!" begin
        add_nodes!(g, (A=1,)=>(B=0.4,))
        @test nv(g) == 2
        @test ne(g) == 1
    end

    val1 = (q₀=[[0,1],[0,2],[0,3]], q₂=[[2,1],[2,2],[2,3]])
    @testset "add_bulk!" begin
        add_bulk!(g, (A=1,)=>(B=0.4,), val1)
        @test nv(g) == 5
        @test ne(g) == 4
        @test props(g, 1) == Dict(:data=>(A=1,))
        @test props(g, 2) == Dict(:data=>(B=0.4,))
        @test props(g, 3) == Dict(:data=>(q₀=[0,1],q₂=[2,1]))
        @test props(g, 4) == Dict(:data=>(q₀=[0,2],q₂=[2,2]))
        @test props(g, 5) == Dict(:data=>(q₀=[0,3],q₂=[2,3]))
        @test props(g, 1, 2) == Dict(:id=>[1,2,3])
        @test props(g, 2, 3) == Dict(:id=>[1])
        @test props(g, 2, 4) == Dict(:id=>[2])
        @test props(g, 2, 5) == Dict(:id=>[3])

        @test nextid(g, (A=1,)=>(B=0.5,)=>(x=1,)) == 4
        add_bulk!(g, (A=1,)=>(B=0.5,), (q₀=[[0,-1],[0,-2]], q₂=[[2,-1],[2,-2]]))
        @test nv(g) == 8
        @test ne(g) == 7
        @test props(g, 6) == Dict(:data=>(B=0.5,))
        @test props(g, 7) == Dict(:data=>(q₀=[0,-1],q₂=>[2,-1]))
        @test props(g, 8) == Dict(:data=>(q₀=[0,-2],q₂=[2,-2]))
        @test props(g, 1, 6) == Dict(:id=>[4,5])
        @test props(g, 6, 7) == Dict(:id=>[4])
        @test props(g, 6, 8) == Dict(:id=>[5])
    end

    l = (l=0.1:0.1:0.3,)
    @testset "add_bulk!" begin
        add_derived_values!(g, ((A=1,), (B=0.4,)), val1, l, (t=1,))
        @test nv(g) == 12
        @test ne(g) == 13
        @test props(g, 1, 2) == Dict(:id=>[1,2,3])
        @test props(g, 9) == Dict(:data=>(t=1,))
        @test props(g, 2, 3) == props(g, 3, 9) == props(g, 9, 10) == Dict(:id=>[1])
        @test props(g, 2, 4) == props(g, 4, 9) == props(g, 9, 11) == Dict(:id=>[2])
        @test props(g, 2, 5) == props(g, 5, 9) == props(g, 9, 12) == Dict(:id=>[3])
    end
end

@testset "Adding data from scratch" begin
    g = StorageGraph()

    @testset "add_nodes!" begin
        add_nodes!(g, (A=1,)=>(B=0.4,))
        @test nv(g) == 2
        @test ne(g) == 1
    end

    g = StorageGraph()

    @testset "add_bulk!" begin
        dep = (q₀=[[0,1],[0,2],[0,3]], q₂=[[2,1],[2,2],[2,3]])
        add_bulk!(g, (A=1,)=>(B=0.4,), dep)
        @test nv(g) == 5
        @test ne(g) == 4
    end

    g = StorageGraph()

    @testset "add_derived_values!" begin
        dep = (q₀=[[0,1],[0,2]], q₂=[[2,1],[2,2]])
        l1 = (l=[0.1,0.2],)
        add_derived_values!(g, ((A=1,), (B=0.4,)), dep, l1, (t=1,))
        @test nv(g) == 7
        @test ne(g) == 7
    end
end
