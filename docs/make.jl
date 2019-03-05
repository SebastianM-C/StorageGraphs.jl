using Documenter, StorageGraphs

makedocs(;
    modules=[StorageGraphs],
    format=Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true"
    ),
    pages=[
        "Home" => "index.md",
        "Adding data" => "add.md",
        "Querying the graph" => "query.md",
        "Internals" => "internals.md",
    ],
    repo="https://github.com/SebastianM-C/StorageGraphs.jl/blob/{commit}{path}#L{line}",
    sitename="StorageGraphs.jl",
    authors="Sebastian Micluța-Câmpeanu",
    assets=[],
)

deploydocs(;
    repo="github.com/SebastianM-C/StorageGraphs.jl",
)
