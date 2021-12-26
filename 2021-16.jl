mutable struct Packet
    version::Int
    tid::Int
    value::Int
    parent::Int
end

hex2bin(str) = join(string.(parse.(Int, collect(str), base = 16), base = 2, pad = 4))
groups2dec(str) = parse(Int, str[setdiff(1:end, 1:5:end)], base = 2)
get_n_groups(str) = findfirst(x -> str[x] == '0', 7:5:length(str))

function grab_packet!(A, str, parent)
    length(str) < 11 && return ""

    v = parse(Int, str[1:3], base = 2)
    t = parse(Int, str[4:6], base = 2)
    if t == 4
        n_group = get_n_groups(str)
        push!(A, Packet(v, t, groups2dec(str[7:(6+n_group*5)]), parent))
        return str[(7+n_group*5):end]
    end
    push!(A, Packet(v, t, 0, parent))
    currindex = length(A)
    lid = parse(Int, str[7], base = 2)
    if lid == 0
        l = parse(Int, str[8:22], base = 2)
        str_sub = str[23:(22+l)]
        while !isempty(str_sub)
            str_sub = grab_packet!(A, str_sub, currindex)
        end
        length(str) > 22+l && return str[(23+l):end]
    else
        l = parse(Int, str[8:18], base = 2)
        str_rmn = str[19:end]
        for i = 1:l
            str_rmn = grab_packet!(A, str_rmn, currindex)
        end
        return str_rmn
    end
end

const ops = [sum, prod, minimum, maximum, >, <, ==]
update_operator(tid, A) = tid < 4 ? ops[tid + 1](A) : ops[tid](A...)
version_sum(A) = sum(map(x -> x.version, A))
get_values(A) = map(x -> x.value, A)

function update_value!(A, i)
    A[i].tid == 4 && return A[i].value

    children = findall(x -> x.parent == i, A)
    for p in children
        update_value!(A, p)
    end
    c_values = get_values(A[children])
    A[i].value = update_operator(A[i].tid, c_values)
    return A[i].value
end

function day16(f, part)
    hex = readlines(f)[1]
    packets = Vector{Packet}()
    grab_packet!(packets, hex2bin(hex), 0)
    outermost = update_value!(packets, 1)
    return part == 1 ? version_sum(packets) : outermost
end