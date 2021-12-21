mutable struct Snailfish
    num::Vector{Int}
    depth::Vector{Int}
end

function parse_snailfish(str)
    openb = findall(x -> x == '[', str)
    closeb = findall(x -> x == ']', str)
    digs = reduce(vcat, (collect.(findall(r"\d+", str))))

    num = parse.(Int, collect(str)[digs])
    depth = map(x -> sum(openb .< x) - sum(closeb .< x), digs)
    return Snailfish(num, depth)
end

function to_explode(a::Snailfish)
    for i = 1:(length(a.depth) - 1)
        a.depth[i] ≥ 5 && (a.depth[i] == a.depth[i+1]) && return i
    end
    return nothing
end
to_split(a::Snailfish) = findfirst(x -> x ≥ 10, a.num)

function explode!(a::Snailfish, i)
    l = popat!(a.num, i)
    r = popat!(a.num, i)
    d = popat!(a.depth, i)
    popat!(a.depth, i)
    i > 1 && (a.num[i - 1] += l)
    i ≤ length(a.num) && (a.num[i] += r)
    insert!(a.num, i, 0)
    insert!(a.depth, i, d - 1)
    return a
end

function split!(a::Snailfish, i)
    n = popat!(a.num, i)
    d = popat!(a.depth, i)
    insert!(a.num, i, Int(cld(n, 2)))
    insert!(a.num, i, Int(fld(n, 2)))
    insert!(a.depth, i, d + 1)
    insert!(a.depth, i, d + 1)
    return a
end

function add(a::Snailfish, b::Snailfish)
    c = Snailfish(vcat(a.num, b.num), vcat(a.depth, b.depth) .+ 1)
    while true
        iex = to_explode(c)
        isp = to_split(c)
        isnothing(iex) && isnothing(isp) && break
        isnothing(iex) ? split!(c, isp) : explode!(c, iex)
    end
    return c
end

add(A::Vector{Snailfish}) = length(A) > 2 ? add([add(A[1], A[2]), A[3:end]...]) : add(A[1], A[2])

function magnitude(a::Snailfish)
    length(a.num) == 1 && return a.num[1]

    d, i = findmax(a.depth)
    while a.depth[i] != d || a.depth[i + 1] != d
        i += 1
    end
    l = popat!(a.num, i)
    r = popat!(a.num, i)
    popat!(a.depth, i)
    popat!(a.depth, i)
    insert!(a.num, i, 3 * l + 2 * r)
    insert!(a.depth, i, d - 1)
    return magnitude(a)
end

function day18(f, part)
    fishes = parse_snailfish.(readlines(f))
    if part == 1
        final = add(fishes)
        return magnitude(final)
    end

    mag = 0
    for i = 1:length(fishes), j = 1:length(fishes)
        i == j && continue
        tmp = magnitude(add(fishes[i], fishes[j]))
        tmp > mag && (mag = tmp)
    end
    return mag
end