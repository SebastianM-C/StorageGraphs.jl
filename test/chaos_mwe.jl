module Chaos_MWE

using LightGraphs
using StorageGraphs
VERSION ≥ v"1.1" && using Serialization
using JLD
using BSON
using Test

g = StorageGraph()

# We can add the nodes progressively
add_nodes!(g, (A=1,)=>(D=0.4,)=>(B=0.5,))
# or in bulk
add_bulk!(g, (A=1,)=>(D=0.4,)=>(B=0.5,), (E=[10., 20., 30.],))
add_bulk!(g, (A=1,)=>(D=0.4,)=>(B=0.55,), (E=[10., 25.],))

plot_graph(g)

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


dep = (A=1,)=>(D=0.4,)=>(B=0.55,)=>(E=10.,)=>(ic_alg=FirstAlg(2),)
q₀, q₂ = initial_conditions(FirstAlg(2))
add_bulk!(g, dep, (q₀=q₀, q₂=q₂))

dep = (A=1,)=>(D=0.4,)=>(B=0.5,)=>(E=10.,)=>(ic_alg=SecondAlg(2, true),)
q₀, q₂ = initial_conditions(SecondAlg(2, true))
add_bulk!(g, dep, (q₀=q₀, q₂=q₂))

plot_graph(g)

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

ic_dep = ((A=1,),(D=0.4,),(B=0.55,),(E=10.,),(ic_alg=FirstAlg(2),))
q₀, q₂ = g[(:q₀, :q₂), ic_dep...]
ic = (q₀=q₀, q₂=q₂)

l = (l=sim1(q₀, q₂, Alg1()),)
l_alg = (alg=Alg1(),)

add_derived_values!(g, ic_dep, ic, l, l_alg)

plot_graph(g)

@testset "Persistence external" begin
    if VERSION ≥ v"1.1"
        serialize("test.jls", g)
        g_serialize = deserialize("test.jls")
        @test g == g_serialize
        @test eltype(g_serialize) == eltype(g)
        @test eltype(g_serialize.data) == eltype(g.data)
        @test eltype(g_serialize.index) == eltype(g.index)
        @test eltype(g_serialize.paths) == eltype(g.paths)
        rm("test.jls")
    end

    save("test.jld", "g", g)
    g_jld = load("test.jld", "g")
    @test g == g_jld
    @test eltype(g_jld) == eltype(g)
    @test eltype(g_jld.data) == eltype(g.data)
    @test eltype(g_jld.index) == eltype(g.index)
    @test eltype(g_jld.paths) == eltype(g.paths)
    rm("test.jld")

    bson("test.bson", g=g)
    g_bson = BSON.load("test.bson")[:g]
    @test g == g_bson
    @test eltype(g_bson) == eltype(g)
    @test eltype(g_bson.data) == eltype(g.data)
    @test eltype(g_bson.index) == eltype(g.index)
    @test eltype(g_bson.paths) == eltype(g.paths)

    rm("test.bson")
end

end  # module Chaos_MWE

@testset "API test" begin
    using .Chaos_MWE
end
