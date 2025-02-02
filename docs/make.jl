using AquiferSense
using Documenter

DocMeta.setdocmeta!(AquiferSense, :DocTestSetup, :(using AquiferSense); recursive=true)

makedocs(;
    modules=[AquiferSense],
    authors="Vitor Cantarella",
    sitename="AquiferSense.jl",
    format=Documenter.HTML(;
        canonical="https://vcantarella.github.io/AquiferSense.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/vcantarella/AquiferSense.jl",
    devbranch="master",
)
