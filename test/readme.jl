using LightGraphs
using MetaGraphs
using GraphPlot, GraphPlot.Compose
using GraphStorage


g = MetaDiGraph(3)
g.vprops[1] = Dict(:x=>1)
g.vprops[2] = Dict(:x=>2)
g.vprops[3] = Dict(:x=>3)

g = MetaDiGraph()
add_derived_values!(g, (x=[1,2,3],), (y=[1,4,9],))
layout = (x...)->spring_layout(x...; C=9)
ns = 1
plot_graph(g, layout=layout, nodesize=ns)
draw(SVG("assets/ex2.svg", 12cm, 4cm),
    plot_graph(g, layout=layout, nodesize=ns, edgelabeldistx=0.5, edgelabeldisty=0.5))

# g.eprops

indexof(g, (x=1,))

indexby(g, :z)
GraphStorage.add_node!(g, (z=1,))

keys(g[:z])


using LightGraphs, MetaGraphs
using GraphStorage

g = MetaDiGraph()
indexby(g, :P)

# We can add the nodes one by one
add_nodes!(g, (P=1,)=>(alg="alg1",))
# or in bulk
add_bulk!(g, (P=1,)=>(alg="alg1",), (x=[10., 20., 30.],))

plot_graph(g)
