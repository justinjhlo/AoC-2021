# Part 1
function move!(pos, dir, amt)
    if dir == "forward"
        pos[2] += amt
    elseif dir == "up"
        pos[1] -= amt
    else
        pos[1] += amt
    end
    return pos
end

# Part 2
function move!(pos, aim, dir, amt)
    if dir == "forward"
        pos[2] += amt
        pos[1] += aim * amt
    end
    return pos
end

function reaim(aim, dir, amt)
    dir == "forward" && return aim
    dir == "up" && return aim - amt
    return aim + amt
end

function day2(f, track::Bool)
    pos = [0, 0]
    aim = 0
    open(f) do file
        for l in eachline(file)
            cmd = split(l)
            amt = parse(Int, cmd[2])
            if !track # Part 1
                move!(pos, cmd[1], amt)
            else # Part 2
                aim = reaim(aim, cmd[1], amt)
                move!(pos, aim, cmd[1], amt)
            end
        end
    end
    return pos[1] * pos[2]
end