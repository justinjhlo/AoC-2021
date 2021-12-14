function update_pairs(Dp, Dr)
    Dp_new = Dict{String, Int}()
    for (p, c) in Dp
        if haskey(Dr, p)
            p1 = p[1] * Dr[p]
            p2 = Dr[p] * p[2]
            Dp_new[p1] = get!(Dp_new, p1, 0) + c
            Dp_new[p2] = get!(Dp_new, p2, 0) + c
        else
            Dp_new[p] = c
        end
    end
    return Dp_new
end

function elcount(Dp)
    Dc = Dict{Char, Int}()
    for (k, v) in Dp
        Dc[k[1]] = get!(Dc, k[1], 0) + v
        Dc[k[2]] = get!(Dc, k[2], 0) + v
    end
    for (k, v) in Dc
        Dc[k] = cld(v, 2)
    end
    return Dc
end

function eldiff(D)
    Dc = elcount(D)
    return maximum(values(Dc)) - minimum(values(Dc))
end

function read_polymer(f)
    l = readlines(f)
    rules = Dict{String, Char}()
    for i = 3:length(l)
        rules[l[i][1:2]] = l[i][7]
    end
    return l[1], rules
end


function day14(f, step)
    template, rules = read_polymer(f)
    pairs = Dict{String, Int}()
    for i = 2:length(template)
        pairs[template[(i-1):i]] = get!(pairs, template[(i-1):i], 0) + 1
    end

    for i = 1:step
        pairs = update_pairs(pairs, rules)
    end

    return eldiff(pairs)
end