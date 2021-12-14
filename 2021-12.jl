mutable struct Node
    name::String
    type::String
    edges::Vector{String}
end
function Node(name)
    if name ∈ ("start", "end")
        type = name
    else
        type = uppercase(name) == name ? "big" : "small"
    end
    Node(name, type, Vector{String}())
end

node_names(A::Vector{Node}) = map(x -> x.name, A)

function add_edge!(A::Vector{Node}, x, y)
    node = findfirst(i -> i.name == x, A)
    push!(A[node].edges, y)
end
n_big(A) = sum(uppercase.(A) .== A)

function direct(from, to)
    total = 0
    total += to.name ∈ from.edges
    total += n_big(intersect(from.edges, to.edges))
    return total
end

function walk(to_visit, visited, from, to, twice)
    total = direct(from, to)
    for (i, node) in enumerate(to_visit)
        d = direct(from, node)
        d == 0 && continue
        if twice
            if node.name ∉ visited
                total += d * walk(to_visit, vcat(visited, node.name), node, to, twice)
            else
                total += d * walk(to_visit[1:end .!= i], vcat(visited, node.name), node, to, false)
            end
        else
            if node.name ∉ visited
                total += d * walk(to_visit[1:end .!= i], vcat(visited, node.name), node, to, false)
            end
        end
    end
    return total
end

function day12(f, twice::Bool)
    caves = Vector{Node}()
    open(f) do file
        for l in eachline(file)
            x = split(l, '-')
            x[1] ∈ node_names(caves) || push!(caves, Node(x[1]))
            x[2] ∈ node_names(caves) || push!(caves, Node(x[2]))
            add_edge!(caves, x[1], x[2])
            add_edge!(caves, x[2], x[1])
        end
    end

    smalls = filter(x -> x.type == "small", caves)
    s = caves[findfirst(x -> x.type == "start", caves)]
    e = caves[findfirst(x -> x.type == "end", caves)]
    
    return walk(smalls, Vector{String}(), s, e, twice)
end