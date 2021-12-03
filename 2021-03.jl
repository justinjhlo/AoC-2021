# Part 1
function majority(A)
    nbit = length(A[1])
    B = [sum(map(x -> parse(Bool, x[i]), A)) for i = 1:nbit]
    return B .> length(A)/2
end

bv2int(A) = sum([A[i] << (length(A) - i) for i = 1:length(A)])

function part1(A)
    c = majority(A)
    gamma = bv2int(c)
    epsilon = bv2int(.!c)
    return gamma * epsilon
end

# Part 2
function rating(A, i, o2)
    length(A) == 1 && return A[1]
    s_one = findfirst(x -> x[i] == '1', A)
    mid = Int(cld(length(A) + 1, 2))
    B = o2 ⊻ (s_one > mid) ? A[s_one:end] : A[1:(s_one-1)]
    return rating(B, i+1, o2)
end

function part2(A)
    sort!(A)
    o2 = rating(A, 1, true)
    co2 = rating(A, 1, false)
    return parse(Int, o2, base = 2) * parse(Int, co2, base = 2)
end

function day3(f, part)
    nums = open(f) do file
        readlines(file)
    end
    part == 1 ? part1(nums) : part2(nums)
end