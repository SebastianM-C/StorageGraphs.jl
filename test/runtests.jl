using GraphStorage
using Test

testdir = dirname(@__FILE__)

tests = [
    "creation",
    "query"
]

@testset "GraphStorage.jl" begin
for t in tests
    tp = joinpath(testdir, "$(t).jl")
    include(tp)
end
end
