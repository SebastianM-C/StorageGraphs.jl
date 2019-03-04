using StorageGraphs
using Test

testdir = dirname(@__FILE__)

tests = [
    "interface",
    "walk",
    "creation",
    "query",
    "persistence",
    "readme",
    "chaos_mwe"
]

@testset "StorageGraphs.jl" begin
    for t in tests
        tp = joinpath(testdir, "$(t).jl")
        include(tp)
    end
end
