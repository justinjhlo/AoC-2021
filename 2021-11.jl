incr!(A) = A .= A .+ 1
incr!(A, i, j) = i ∈ axes(A, 1) && j ∈ axes(A, 2) && (A[i, j] += 1)

function flash!(A)
    to_flash = Tuple.(findall(x -> x == 10, A))
    for (i, j) in to_flash
        flash!(A, i, j, true)
    end
end

function flash!(A, i, j, init::Bool)
    i ∈ axes(A, 1) && j ∈ axes(A, 2) || return
    if init || A[i, j] == 10
        for x = -1:1, y = -1:1
            i == 0 && j == 0 && continue
            incr!(A, i + x, j + y)
            flash!(A, i + x, j + y, false)
        end
    end
end

function reset!(A)
    flashed = A .>= 10
    nflash = sum(flashed)
    @. A = A * !flashed
    return nflash
end

function day11(f, step = 0)
    total, i = 0, 0
    grid = open(f) do file
        reduce(hcat, [collect(x) .- '0' for x in eachline(file)])
    end

    while true
        i += 1
        incr!(grid)
        flash!(grid)
        nflash = reset!(grid)
        if step != 0 # Part 1
            total += nflash
            i == step && return total
        else # Part 2
            nflash == 100 && return i
        end
    end
end