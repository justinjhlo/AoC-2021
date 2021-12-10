using Combinatorics

# Part 1
count_unique(A) = count(x -> x ∉ [5, 6], length.(A))

# Part 2
const digit_disp = Dict("abcefg" => "0", "cf" => "1", "acdeg" => "2", "acdfg" => "3", "bcdf" => "4",
                        "abdfg" => "5", "abdefg" => "6", "acf" => "7", "abcdefg" => "8", "abcdfg" => "9")
const digs = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]

seg2dig(A) = parse(Int, join([digit_disp[x] for x in A]))
decode(A, D) = @. join(sort(collect(map(x -> D[x], A))))

function solve_disp(A, B)
    for p in permutations("abcdefg")
        conv = Dict(zip(p, "abcdefg"))
        decoded = decode(A, conv)
        isempty(setdiff(decoded, digs)) && return seg2dig(decode(B, conv))
    end
end

function day8(f, part)
    total = 0
    open(f) do file
        for l in eachline(file)
            disp = split(l)
            if part == 1
                total += count_unique(disp[12:15])
            else
                total += solve_disp(disp[1:10], disp[12:15])
            end
        end
    end
    return total
end