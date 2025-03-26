using OrganizationalGraphs
using Test
using DataFrames

org1 = DataFrame("employee" => ["A", "B", "C", "D", "T"], "manager" => ["T", "A", "B", "B","T"])
od1 = org_depth(org1)
sort!(od1, :index)

org2 = reverse(org1) # different order
od2 = org_depth(org2)
sort!(od2, :index)

@testset "OrganizationalGraphs.jl" begin
    @test od1.org_depth == [1., 2., 3., 3., 0.]
    @test od1 == od2
end
