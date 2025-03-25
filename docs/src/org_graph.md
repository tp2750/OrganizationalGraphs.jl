# Organizational Graphs

``` julia
using Graphs
using DataFrames
using MetaGraphs
using GraphDataFrameBridge
org1 = DataFrame("employee" => ["A", "B", "C", "D", "T"], "manager" => ["T", "A", "B", "B","T"])
g1 = MetaDiGraph(org1, :manager, :employee) # directed graph

using GLMakie
using GraphMakie
using CairoMakie
using GraphMakie.NetworkLayout

# graphplot(g1, arrow_show=true, layout=Spectral(), nlabels = string.(vertices(g1)))
graphplot(g1, arrow_show=true, nlabels = string.(vertices(g1)))

d1 = dijkstra_shortest_paths(g1, 1)
d1.dists
```

This gives the organizational depth of all employees.

![Simple Org](img/g1.png)

