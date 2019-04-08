using StorageGraphs: findnodes

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
    @test g[] == []

    @test isempty(setdiff(g[:A], [1]))
    @test isempty(setdiff(g[:D], [0.4]))
    @test isempty(setdiff(g[:B], [0.5, 0.6]))
    @test isempty(setdiff(g[:E], [1, 2, 3]))
    B, E = g[(:B,:E)]
    @test isempty(setdiff(B, [0.5, 0.6]))
    @test isempty(setdiff(E, [3,2,1]))

    p = paths_through(g, (A=1,)=>(B=0.5,))
    @test length(p) == 3
    @test p == Set([1, 2, 3])
    @test length(paths_through(g, (A=1,)=>(B=0.5,)=>(E=1.,))) == 0
    @test length(paths_through(g, (A=1,))) == 6

    @test g[1] == get_prop(g, 1) == (D=0.4,)
    @test g[g[(A=1,)]] == (A=1,)
    @test isempty(setdiff(get_prop.(Ref(g), g[(A=1,)=>(D=0.4,)]), [(B=0.5,),(B=0.6,)]))
    @test isempty(setdiff(g[(A=1,)=>(D=0.4,), :B], [0.5, 0.6]))
    @test isempty(setdiff(g[(A=1,)=>(D=0.4,)=>(B=0.5,), :E], [1, 2, 3]))
    @test isempty(setdiff(g[:B, (A=1,), (D=0.4,)], [0.5, 0.6]))

    add_bulk!(g, (A=1,)=>(D=0.5,)=>(B=0.5,), (E=[5, 6],))
    @test isempty(setdiff(g[:E, (D=0.5,), (B=0.5,)], [5, 6]))
    @test isempty(setdiff(g[:E, (A=1,), (B=0.5,)], [1, 2, 3, 5, 6]))

    @test isempty(setdiff(g[:E, (D=0.5,)], [5,6]))
    @test isempty(setdiff(g[:E, with(g,:D,v->v.D>0.4), (A=1,)], [5,6]))
    @test g[with(g,:D,v->v.D>0.4), (A=1,),(B=0.5,)] == [(E=5,),(E=6,)]
    @test isempty(setdiff(g[:E, with(g,:D,v->v.D<0.5), (A=1,),(B=0.6,)], [1,2,3]))

    add_nodes!(g, (A=1,)=>(D=0.4,)=>(B=0.5,)=>(E=1,)=>(x=1,y=2))
    @test isempty(setdiff(g[(:x,:y), (A=1,),(E=1,)], ([1],[2])))
    @test g[:x, (A=1,)] == [1]
    @test isempty(setdiff(g[(:x,:y), (A=1,),(B=0.5,)],([1],[2])))

    add_nodes!(g, (A=1,)=>(D=0.4,)=>(B=0.5,)=>(E=2,)=>(x=2,y=0))
    conditions = Dict(:D=>v->v.D < 0.5, :E=>v->v.E > 1)
    @test g[:y, with(g,conditions), (A=1,)] == [0]
end
