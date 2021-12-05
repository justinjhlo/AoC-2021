function day5(f, diag::Bool)
    pts = Dict{Vector{Int}, Int}()
    open(f) do file
        for l in eachline(file)
            coords = match(r"(\d+),(\d+)\s-\>\s(\d+),(\d+)", l)
            xstart, ystart, xend, yend = parse.(Int, coords.captures)
            step = maximum([abs(xend - xstart), abs(yend - ystart)]) + 1
            if !diag # Skip diagonal lines in Part 1
                (xstart == xend || ystart == yend) || continue
            end
            for (i, j) in zip(range(xstart, xend, length = step), range(ystart, yend, length = step))
                pts[[i, j]] = get!(pts, [i, j], 0) + 1
            end
        end
    end
    return length(filter(x -> x > 1, collect(values(pts))))
end