import LightGraphs: loadgraph, savegraph, AbstractGraphFormat
VERSION ≥ v"1.1" && using Serialization
using JLD
using BSON

struct SGNativeFormat <: AbstractGraphFormat end
struct SGJLDFormat <: AbstractGraphFormat end
struct SGBSONFormat <: AbstractGraphFormat end

@static if VERSION ≥ v"1.1"
    function savegraph(fn::AbstractString, g::StorageGraph, ::SGNativeFormat)
        serialize(fn, g)
    end

    function loadgraph(fn::AbstractString, ::SGNativeFormat)
        deserialize(fn)
    end
end

function savegraph(fn::AbstractString, g::StorageGraph, gname::String, ::SGJLDFormat)
    save(fn, gname, g)
end

function loadgraph(fn::AbstractString, gname::String, ::SGJLDFormat)
    load(fn, gname)
end

function savegraph(fn::AbstractString, g::StorageGraph, gname::Symbol, ::SGBSONFormat)
    bson(fn, Dict(gname=>g))
end

function loadgraph(fn::AbstractString, gname::Symbol, ::SGBSONFormat)
    BSON.load(fn)[gname]
end
