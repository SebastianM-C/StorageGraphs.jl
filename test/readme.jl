using LightGraphs
using MetaGraphs
using GraphPlot, GraphPlot.Compose
using GraphStorage

layout = (x...)->spring_layout(x...; C=9)
ns = 1

g = MetaDiGraph(3)
g.vprops[1] = Dict(:x=>1)
g.vprops[2] = Dict(:x=>2)
g.vprops[3] = Dict(:x=>3)

draw(SVG("$(@__DIR__)/../assets/ex1.svg", 12cm, 4cm),
    plot_graph(g, layout=layout, nodesize=ns, edgelabeldistx=0.5, edgelabeldisty=0.5))

g = MetaDiGraph()
add_derived_values!(g, (x=[1,2,3],), (y=[1,4,9],))

plot_graph(g, layout=layout, nodesize=ns)
draw(SVG("$(@__DIR__)/../assets/ex2.svg", 12cm, 4cm),
    plot_graph(g, layout=layout, nodesize=ns, edgelabeldistx=0.5, edgelabeldisty=0.5))

using LightGraphs, MetaGraphs
using GraphStorage

g = MetaDiGraph()
indexby.(Ref(g), [:P, :alg])

# We can add the nodes one by one
add_nodes!(g, (P=1,)=>(alg="alg1",))
# or in bulk
add_bulk!(g, (P=1,)=>(alg="alg1",), (x=[10., 20., 30.],))

plot_graph(g)
draw(SVG("$(@__DIR__)/../assets/ic_graph.svg", 12cm, 4.5cm),
    plot_graph(g, layout=layout, nodesize=ns, edgelabeldistx=0.5, edgelabeldisty=0.5))

simulation(x; alg) = alg == "alg1" ? x.+2 : x.^2

# retrieve the previously stored initial conditions
x = [g.vprops[v][:x] for v in final_neighborhs(g, (P=1,)=>(alg="alg1",))]
results = simulation(x, alg="alg1")
add_derived_values!(g, ((P=1,),(alg="alg1",)), (x=x,), (r=results,))

plot_graph(g)
draw(SVG("$(@__DIR__)/../assets/sim_graph.svg", 12cm, 6cm),
    plot_graph(g, layout=layout, nodesize=ns, edgelabeldistx=0.5, edgelabeldisty=0.5))

add_derived_values!(g, ((P=2,),(alg="alg1",)), (x=2x,), (r=2results,))

plot_graph(g)
draw(SVG("$(@__DIR__)/../assets/complicated_graph.svg", 12cm, 10cm),
    plot_graph(g, layout=layout, nodesize=ns, edgelabeldistx=0.5, edgelabeldisty=0.5))
