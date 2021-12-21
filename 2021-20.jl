const powers = [2^i for i = 8:-1:0]

function parse_input(lines)
    iea = collect(lines[1]) .== '#'
    imap = lines[3:end]
    return iea, imap
end

function map2dict(strs)
    D = Dict{Vector{Int}, Bool}()
    for (a, str) in enumerate(strs)
        for (b, char) in enumerate(str)
            D[[a, b]] = char == '#'
        end
    end
    return D
end

function twostep(D, xrange, yrange, alg)
    Dn = Dict{Vector{Int}, Bool}()
    for i = (xrange[1]-2):(xrange[2]+2), j = (yrange[1]-2):(yrange[2]+2)
        onestep = Vector{Bool}()
        for k = (i-1):(i+1), l = (j-1):(j+1)
            push!(onestep, getpx(D, k, l, alg))
        end
        Dn[[i, j]] = alg[sum(powers .* onestep) + 1]
    end
    return Dn
end

getpx(D, x, y, alg) = alg[sum(powers .* get.(Ref(D), [[i, j] for i=(x-1):(x+1) for j=(y-1):(y+1)], 0)) + 1]
move_boundary(xmin, xmax, ymin, ymax) = (xmin - 2, xmax + 2, ymin - 2, ymax + 2)
count_light(D) = sum(collect(values(D)))

function day20(f, times)
    iea, imap = parse_input(readlines(f))
    xmin, ymin, xmax, ymax = 1, 1, length(imap), length(imap[1])
    img = map2dict(imap)
    for t = 1:Int(times/2)
        img = twostep(img, (xmin, xmax), (ymin, ymax), iea)
        xmin, xmax, ymin, ymax = move_boundary(xmin, xmax, ymin, ymax)
    end
    return count_light(img)
end