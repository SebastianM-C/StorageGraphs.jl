using MetaGraphs

g = MetaDiGraph()
indexby(g, :B)
indexby(g, :D)
dep = [(A=1,)=>(D=0.4,)=>(B=0.5,)=>(E=e,) for e in 1.:3.]
add_nodes!.(Ref(g), dep)
dep = [(A=1,)=>(D=0.4,)=>(B=0.6,)=>(E=e,) for e in 1.:3.]
add_nodes!.(Ref(g), dep)

@testset "Data Query" begin
    @test props(g, g[:B][0.5])[:B] == 0.5
    @test props(g, g[:B][0.6])[:B] == 0.6

    p = paths_through(g, (A=1,)=>(B=0.5,))
    @test length(p) == 3
    @test length(paths_through(g, (A=1,)=>(B=0.5,)=>(E=1.,))) == 0

    @test paths_through(g, :D, 0.4) == paths_through(g, (D=0.4,))

    v = walkpath(g, [1], 3)
    @test length(v) == 1
    @test props(g, v...) == Dict(:E=>1.)

    v = walkpath(g, p, g[:D][0.4], stopcond=(g,v)->has_prop(g, v, :B))
    @test length(unique(v)) == 1
    @test props(g, v[1]) == Dict(:B=>0.5)
end
