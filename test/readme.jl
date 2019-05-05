module Readme

using LightGraphs
using GraphPlot, GraphPlot.Compose
using StorageGraphs
using Test
using Logging

log = SimpleLogger(stdout, Logging.Debug)

function draw_graph(g, x, y, name::String, args...; ns=1, C=5)
    layout = (x...)->spring_layout(x...; C=C)
    draw(SVG("$(@__DIR__)/../assets/$name.svg", x*cm, y*cm),
        plot_graph(g, layout=layout, nodesize=ns))
end

g = StorageGraph()
@test StorageGraphs.add_vertex!.(Ref(g), [(x=1,),(x=2,),(x=3,)]) |> all
@test get_prop(g, 1) == (x=1,)
@test get_prop(g, 2) == (x=2,)
@test get_prop(g, 3) == (x=3,)

draw_graph(g, 10, 4, "ex1")

# with_logger(log) do
#     add_derived_values!(g, (x=[1,2,3],), (y=[1,4,9],))
# end

g = StorageGraph()
add_nodes!(g, (x=[1,2,3],)=>(y=[1,4,9],))

@test nv(g) == 2
@test ne(g) == 1
@test get_prop(g, 1) == (x=[1,2,3],)
@test get_prop(g, 2) == (y=[1,4,9],)

draw_graph(g, 10, 4, "ex2", C=8)

# Code snippets

using StorageGraphs

g = StorageGraph()
add_nodes!(g, (x=[1,2,3],)=>(y=[1,4,9],))

###

@test isempty(setdiff(g[:x][1], [1,2,3]))

###

using StorageGraphs

g = StorageGraph()

add_nodes!(g, (P=1,)=>(alg="alg1",)=>(x=[10., 20., 30.],))

draw_graph(g, 10, 4, "ic_graph", C=8)

simulation(x; alg) = alg == "alg1" ? x.+2 : x.^2

# retrieve the previously stored initial conditions
x = g[:x, (P=1,)=>(alg="alg1",)][1]
# there is only one node depending on (P=1,)=>(alg="alg1",), so that's why
# we take only the first element
results = simulation(x, alg="alg1")
add_nodes!(g, foldr(=>, ((P=1,), (alg="alg1",), (x=x,), (r=results,))))
# foldr(=>, dep) can be useful for building long dependency chanis form parts

draw_graph(g, 10, 6, "sim_graph", C=8)

add_nodes!(g, foldr(=>,((P=2,), (alg="alg1",), (x=2x,), (r=2results,))))

draw_graph(g, 11, 11, "complicated_graph", C=6)

end  # module Readme

@testset "Readme" begin
    using .Readme
end
