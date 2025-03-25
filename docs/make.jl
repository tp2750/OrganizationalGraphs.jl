using OrganizationalGraphs
using Documenter

DocMeta.setdocmeta!(OrganizationalGraphs, :DocTestSetup, :(using OrganizationalGraphs); recursive=true)

makedocs(;
    modules=[OrganizationalGraphs],
    authors="Thomas Poulsen <ta.poulsen@gmail.com> and contributors",
    sitename="OrganizationalGraphs.jl",
    format=Documenter.HTML(;
        canonical="https://tp2750.github.io/OrganizationalGraphs.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/tp2750/OrganizationalGraphs.jl",
    devbranch="main",
)
