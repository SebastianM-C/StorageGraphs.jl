using StorageGraphs
using Test

testdir = dirname(@__FILE__)

tests = [
    "interface",
    "walk",
    "creation",
    "query",
    "readme"
]

@testset "StorageGraphs.jl" begin
for t in tests
    tp = joinpath(testdir, "$(t).jl")
    include(tp)
end
@testset "API test" begin
    include("chaos_mwe.jl")
    using .Chaos_MWE
end
end
