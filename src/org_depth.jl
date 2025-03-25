"""
        Compute organizational depth based on DataFrame with columns given by
        `employee`and `manager`
        
"""
function org_depth!(df; employee = :employee, manager = :manager, top = missing)
    g1 = MetaDiGraph(df, manager, employee) # directed graph
    graph_id = DataFrame("name" => collect(keys(g1.metaindex[:name])), "index" => collect(values(g1.metaindex[:name])))
    leftjoin!(df, graph_id, on = employee => :name)
    if ismissing(top) # find self manager
        top_idx = only(findall(df[:,employee] .== df[:,manager])) # self manager
    else
        top_idx = only(findall(df[:,employee] .== top))
    end
    top_id = df[top_idx, :index]
    d1 = dijkstra_shortest_paths(g1, top_id)
    org_depth = DataFrame(index = 1:nv(g1), org_depth = d1.dists)
    leftjoin!(df, org_depth, on = :index)
    df
end

function org_depth(df; employee = :employee, manager = :manager, top = missing)
    df1 = copy(df)
    org_depth!(df1; employee, manager, top)
    df1
end
