function bound_xvel(xrange)
    xmin = 1
    while triang(xmin) < xrange.start
        xmin += 1
    end
    return xmin:(xrange.stop)
end

triang(v) = Int(v * (v + 1) / 2)
calc_xpos(u, t) = t ≤ u ? u * t - triang(t-1) : triang(u)

function day17(str, part)
    m = match(r"x=(?<xmin>-?\d+)\.\.(?<xmax>-?\d+),\sy=(?<ymin>-?\d+)\.\.(?<ymax>-?\d+)", str)
    xrange = parse(Int, m[:xmin]):parse(Int, m[:xmax])
    yrange = parse(Int, m[:ymin]):parse(Int, m[:ymax])
    maxy = 0
    success = Dict{Tuple{Int, Int}, Bool}()
    xvel = bound_xvel(xrange)
    for v in -yrange.start:-1:yrange.start
        t = v ≥ 0 ? 2 * v + 2 : 1
        ypos = 0
        while true
            ypos += v - t + 1
            ypos < yrange.start && break
            if ypos ∈ yrange
                counts = filter(i -> calc_xpos(i, t) ∈ xrange, xvel)
                length(counts) > 0 && triang(v) > maxy && (maxy = triang(v))
                if part > 1
                    for u in counts
                        success[u, v] = 1
                    end
                end
            end
            t += 1
        end
    end
    return part == 1 ? maxy : length(success)
end