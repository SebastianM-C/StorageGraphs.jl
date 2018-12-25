using Documenter, GraphStorage

makedocs(;
    modules=[GraphStorage],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/SebastianM-C/GraphStorage.jl/blob/{commit}{path}#L{line}",
    sitename="GraphStorage.jl",
    authors="sebastian",
    assets=[],
)

deploydocs(;
    repo="github.com/SebastianM-C/GraphStorage.jl",
)
