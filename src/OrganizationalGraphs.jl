module OrganizationalGraphs

using DataFrames
using Graphs
using MetaGraphs
using GraphDataFrameBridge

include("org_depth.jl")

export org_depth!, org_depth, recursive_managers_tall, recursive_managers_wide

end
