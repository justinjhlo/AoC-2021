function fold!(dots, instruction)
    for dot in keys(dots)
        if dot[instruction[1]] > instruction[2]
            new_dot = instruction[1] == 1 ? (2 * instruction[2] - dot[1], dot[2]) : (dot[1], 2 * instruction[2] - dot[2])
            pop!(dots, dot)
            dots[new_dot] = get!(dots, new_dot, 0) + 1
        end
    end
    return dots
end

function boundary(A)
    x = minimum(j -> j[2], filter(i -> i[1] == 1, A))
    y = minimum(j -> j[2], filter(i -> i[1] == 2, A))
    return x, y
end

function print_dots(dots, bounds)
    for j = 0:(bounds[2]-1)
        for i = 0:(bounds[1]-1)
            print(haskey(dots, (i, j)) ? '*' : '.')
        end
        print('\n')
    end
end

function day13(f, all::Bool)
    dots = Dict()
    instructions = Vector{Tuple{Int, Int}}()
    open(f) do file
        for l in eachline(file)
            d = match(r"(?<x>\d+),(?<y>\d+)", l)
            inst = match(r"fold along (?<dir>[xy])=(?<pos>\d+)", l)

            !isnothing(d) && (dots[(parse(Int, d[:x]), parse(Int, d[:y]))] = true)
            !isnothing(inst) && push!(instructions, (inst[:dir] == "x" ? 1 : 2, parse(Int, inst[:pos])))
        end
    end

    if !all
        fold!(dots, instructions[1])
        return length(dots)
    end

    for inst in instructions
        fold!(dots, inst)
    end

    print_dots(dots, boundary(instructions))
end