using Test
using OrganizationalGraphs
using DataFrames

org1 = DataFrame("employee" => ["A", "B", "C", "D", "T"], "manager" => ["T", "A", "B", "B","T"])
od1 = org_depth(org1)
sort!(od1, :index)
rm1_t = recursive_managers_tall(od1)
rm1_w = recursive_managers_wide(od1)


org2 = reverse(org1) # different order
od2 = org_depth(org2)
sort!(od2, :index)

@testset "OrganizationalGraphs.jl" begin
    @test od1.org_depth == [1., 2., 3., 3., 0.]
    @test od1 == od2
    @test all(subset(rm1_t, :Level => ByRow(==("L2"))).LevelManager .== "A")
    @test all(skipmissing(rm1_w.L2) .== "A")
end
