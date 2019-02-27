@testset "Data Query" begin
    g = StorageGraph()

    dep = (A=1,)=>(D=0.4,)=>(B=0.5,)
    add_bulk!(g, dep, (E=1:3,))
    dep = (A=1,)=>(D=0.4,)=>(B=0.6,)
    add_bulk!(g, dep, (E=1:3,))

    @test get_prop(g, g[(B=0.5,)]) == (B=0.5,)
    @test get_prop(g, g[(B=0.6,)]) == (B=0.6,)

    @test isempty(setdiff(findnodes(g, :A), [(A=1,)]))
    @test isempty(setdiff(findnodes(g, :D), [(D=0.4,)]))
    @test isempty(setdiff(findnodes(g, :B), [(B=0.5,),(B=0.6,)]))
    @test isempty(setdiff(findnodes(g, :E), [(E=1,),(E=2,),(E=3,)]))
    @test findnodes(g, :x) == NamedTuple[]

    @test isempty(setdiff(g.A, [1]))
    @test isempty(setdiff(g.D, [0.4]))
    @test isempty(setdiff(g.B, [0.5, 0.6]))
    @test isempty(setdiff(g.E, [1, 2, 3]))

    p = paths_through(g, (A=1,)=>(B=0.5,))
    @test length(p) == 3
    @test p == [1, 2, 3]
    @test length(paths_through(g, (A=1,)=>(B=0.5,)=>(E=1.,))) == 0
    @test length(paths_through(g, (A=1,))) == 6

    v = walkpath(g, [1], 3)
    @test length(v) == 1
    @test get_prop(g, v...) == (E=1.,)
    g[1]

    # v = walkpath(g, p, g[:D][0.4], stopcond=(g,v)->has_prop(g, v, :B))
    # @test length(unique(v)) == 1
    # @test get_prop(g, v[1]) == Dict(:B=>0.5)

    g[(A=1,)=>(D=0.4,)=>(B=0.5,), :E]
    g[:B, (A=1,), (D=0.4,)]
end
