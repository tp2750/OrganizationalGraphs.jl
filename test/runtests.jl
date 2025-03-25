using OrganizationalGraphs
using Test
using DataFrames

org1 = DataFrame("employee" => ["A", "B", "C", "D", "T"], "manager" => ["T", "A", "B", "B","T"])
org_depth!(org1)
sort!(org1, :index)

@testset "OrganizationalGraphs.jl" begin
    @test org1.org_depth == [1., 2., 3., 3., 0.] 
end
