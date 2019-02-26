using Documenter, StorageGraphs

makedocs(;
    modules=[StorageGraphs],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/SebastianM-C/StorageGraphs.jl/blob/{commit}{path}#L{line}",
    sitename="StorageGraphs.jl",
    authors="sebastian",
    assets=[],
)

deploydocs(;
    repo="github.com/SebastianM-C/StorageGraphs.jl",
)
