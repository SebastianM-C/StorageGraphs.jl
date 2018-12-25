using MetaGraphs

g = MetaDiGraph()
dep = [(A=1,)=>(D=0.4,)=>(B=0.5,)=>(E=e,) for e in 1.:3.]
add_nodes!.(Ref(g), dep)

@testset "Data Query" begin
    p = paths_through(g, (A=1,)=>(B=0.5,))
    @test length(p) == 3
    @test length(paths_through(g, (A=1,)=>(B=0.5,)=>(E=1.,))) == 0

    v = walkpath(g, [1], 3)
    @test length(v) == 1
    @test props(g, v...) == Dict(:E=>1.)
end
