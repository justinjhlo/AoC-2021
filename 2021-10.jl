const bracs = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>')
const scores = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
const digs = Dict(')' => '1', ']' => '2', '}' => '3', '>' => '4')

function check_bracs(str, incomplete::Bool)
    x = Vector{Char}()
    for c in str
        if haskey(bracs, c)
            push!(x, bracs[c])
        elseif length(x) > 0 && c == x[end]
            pop!(x)
        else
            return incomplete ? 0 : scores[c]
        end
    end
    length(x) == 0 && return 0
    !incomplete && return 0

    nx = reverse(join(map(i -> digs[i], x)))
    return parse(Int, nx, base = 5)
end

function day10(f, incomplete)
    total = open(f) do file
        [check_bracs(l, incomplete) for l in eachline(file)]
    end
    if incomplete
        filter!(x -> x > 0, total)
        return Int(median(total))
    end
    return sum(total)
end