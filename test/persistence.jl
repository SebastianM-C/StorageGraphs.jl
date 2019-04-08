using Random
using LightGraphs
import Base: ==
using JLD

struct TestStruct{T}
    a::Dict{Symbol,Vector}
    b::Set
    c::Array{T,1}
end

function TestStruct()
    TestStruct(Dict{Symbol,Vector}(), Set(), Int[])
end

==(x::TestStruct, y::TestStruct) = (x.a==y.a) && (x.b==y.b) && (x.c==y.c)

@testset "Persistence" begin
    g = StorageGraph()
    dep = ((a=1,),(b=2,),(c=3,))
    add_bulk!(g, foldr(=>, dep), (d=rand(2),))
    d = g[:d, dep...]
    add_derived_values!(g, dep, (d=d,), (x=randstring.(1:2),), (y=TestStruct(),))

    if VERSION ≥ v"1.1"
        savegraph("test.jls", g, SGNativeFormat())
        g_serialize = loadgraph("test.jls", SGNativeFormat())
        @test g == g_serialize
        @test eltype(g_serialize) == eltype(g)
        @test eltype(g_serialize.data) == eltype(g.data)
        @test eltype(g_serialize.index) == eltype(g.index)
        @test eltype(g_serialize.paths) == eltype(g.paths)
        rm("test.jls")
    end

    savegraph("test.jld", g, "g", SGJLDFormat())
    g_jld = loadgraph("test.jld", "g", SGJLDFormat())
    @test g == g_jld
    @test g.data == g_jld.data
    @test eltype(g_jld) == eltype(g)
    @test eltype(g_jld.data) == eltype(g.data)
    @test eltype(g_jld.index) == eltype(g.index)
    @test eltype(g_jld.paths) == eltype(g.paths)
    rm("test.jld")

    savegraph("test.bson", g, :g, SGBSONFormat())
    g_bson = loadgraph("test.bson", :g, SGBSONFormat())
    @test g == g_bson
    @test eltype(g_bson) == eltype(g)
    @test eltype(g_bson.data) == eltype(g.data)
    @test eltype(g_bson.index) == eltype(g.index)
    @test eltype(g_bson.paths) == eltype(g.paths)

    rm("test.bson")
end
