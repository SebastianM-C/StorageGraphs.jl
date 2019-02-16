using LightGraphs, MetaGraphs
using GraphStorage

g = MetaDiGraph()
indexby(g, :B)
indexby(g, :E)

# We can add the nodes progressively
add_nodes!(g, (A=1,)=>(D=0.4,)=>(B=0.5,))
# or in bulk
add_quantity!(g, (A=1,)=>(D=0.4,)=>(B=0.5,), (E=[10., 20., 30.],))
add_quantity!(g, (A=1,)=>(D=0.4,)=>(B=0.55,), (E=[10., 25.],))

plot_graph(g)
using GraphPlot.Compose
draw(SVG("assets/param_graph.svg", 10cm, 10cm), plot_graph(g))

using Parameters

abstract type AbstractAlgorithm end
abstract type InitialConditionsAlgorithm <: AbstractAlgorithm end

@with_kw struct FirstAlg <: InitialConditionsAlgorithm
    n::Int
    @assert n > 0
end

@with_kw struct SecondAlg <: InitialConditionsAlgorithm
    n::Int
    x::Bool
end

function initial_conditions(alg::FirstAlg)
    n = alg.n
    q₀ = [rand(2) for _=1:n]
    q₂ = [rand(2) for _=1:n]
    return q₀, q₂
end

function initial_conditions(alg::SecondAlg)
    @unpack n, x = alg
    q₀ = [x ? rand(2) : 10 .+ rand(2) for _=1:n]
    q₂ = [x ? rand(2) : 10 .+ rand(2) for _=1:n]
    return q₀, q₂
end
```

Then adding initial conditions would look like this:
```julia
dep = (A=1,)=>(D=0.4,)=>(B=0.55,)=>(E=10.,)=>(ic_alg=FirstAlg(2),)
q₀, q₂ = initial_conditions(FirstAlg(2))
add_quantity!(g, dep, (q₀=q₀, q₂=q₂))

dep = (A=1,)=>(D=0.4,)=>(B=0.5,)=>(E=10.,)=>(ic_alg=SecondAlg(2, true),)
q₀, q₂ = initial_conditions(SecondAlg(2, true))
add_quantity!(g, dep, (q₀=q₀, q₂=q₂))

plot_graph(g)
draw(SVG("assets/ic_graph.svg", 10cm, 10cm), plot_graph(g))

abstract type SimulationAlgorithm <: AbstractAlgorithm end
using LinearAlgebra

@with_kw struct Alg1{R <: Real} <: SimulationAlgorithm @deftype R
    a = 10.
    b = 0.1
end

@with_kw struct Alg2{R <: Real} <: SimulationAlgorithm @deftype R
    a = 100.
end

function sim1(q₀, q₂, alg::Alg1)
    @unpack a, b = alg
    @assert axes(q₀) == axes(q₂)
    return [(a.*q₀[i]) ⋅ (b.*q₂[i]) for i in axes(q₀, 1)]
end

function sim2(q₀, q₂, alg::Alg2)
    a = alg.a
    @assert axes(q₀) == axes(q₂)
    return a*[norm(q₀[i] - q₂[i]) for i in axes(q₀, 1)]
end

l = sim1(q₀, q₂, Alg1())
m = sim2(q₀, q₂, Alg2())

add_dependent_quantity!(g, ic_dep, ic, dep, vals)
