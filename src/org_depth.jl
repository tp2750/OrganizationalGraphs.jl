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
    org_paths = DataFrame("index" => 1:nv(g1),
                          "path_index" => map(x->Graphs.path_from_parents(x,d1.parents), 1:nv(g1)),
                          )
    transform!(org_paths, :path_index => ByRow(y -> map(x->g1.vprops[x][:name], y)) => :path_name)
    leftjoin!(df, org_paths, on = :index)        
    transform!(df, :org_depth => ByRow(Int) => :org_depth)
end

function org_depth(df; employee = :employee, manager = :manager, top = missing) # Rename to `reporting_lines`?
    df1 = copy(df)
    org_depth!(df1; employee, manager, top)
    df1
end

"""
        get recursive managers after calling `org_depth`
"""
function recursive_managers_tall(df; maxlevel = 5)
    if !in("path_name", names(df))
        @warn "Calling org_depth to get reporting lines"
        df1 = org_depth(df)
    else
        df1 = copy(df)
    end
    maxlev1 = min(maxlevel, maximum(df1.org_depth)) |> Int
    res = DataFrame[]
    for row in eachrow(df1)
        lev = row.org_depth+1
        push!(res, hcat(repeat(DataFrame(row), lev), DataFrame(Level = string.("L",1:lev), LevelManager = row.path_name)))
    end
    reduce(vcat, res)
end

function recursive_managers_wide(df; maxlevel = 5)
    df1 = recursive_managers_tall(df; maxlevel)
    unstack(df1, :Level, :LevelManager)
end

function recursive_managers1(df; maxlevel = 5)
    if !in("path_name", names(df))
        @warn "Calling org_depth to get reporting lines"
        df1 = org_depth(df)
    else
        df1 = copy(df)
    end
    maxlev1 = min(maxlevel, maximum(df.org_depth)) |> Int
    for lev in 1:maxlev1
        df1[!,"L$lev"] = map(x -> length(x) >= lev && x[lev], df1.path_name)
    end
    df1
end
