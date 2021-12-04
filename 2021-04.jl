function day4(f, first::Bool)
    gs = open(f) do file
        readlines(file)
    end

    draws = parse.(Int, split(gs[1], ','))
    cards = reshape(parse.(Int, split(join(gs[2:end], ' '))), 5, 5, :)
    
    orders = map(x -> findfirst(isequal(x), draws), cards)
    colmins = dropdims(minimum(maximum(orders, dims = 2), dims = 1), dims = (1, 2))
    rowmins = dropdims(minimum(maximum(orders, dims = 1), dims = 2), dims = (1, 2))

    bingos = vec(minimum(hcat(colmins, rowmins), dims = 2))
    bingo = first ? findmin(bingos) : findmax(bingos) # Part 1 finds first, Part 2 finds last

    return draws[bingo[1]] * sum(cards[:, :, bingo[2]] .* (orders[:, :, bingo[2]] .> bingo[1]))
end