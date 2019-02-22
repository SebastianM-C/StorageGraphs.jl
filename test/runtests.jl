using GraphStorage
using Test

testdir = dirname(@__FILE__)

tests = [
    "creation",
    "query",
    "readme"
]

@testset "GraphStorage.jl" begin
for t in tests
    tp = joinpath(testdir, "$(t).jl")
    include(tp)
end
@testset "API test" begin
    include("chaos_mwe.jl")
    using .Chaos_MWE
end
end
