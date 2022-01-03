struct Step
    on::Bool
    x::UnitRange{Int}
    y::UnitRange{Int}
    z::UnitRange{Int}
end

find_overlap(s1::Step, s2::Step) = Step(s1.on & s2.on, intersect(s1.x, s2.x), intersect(s1.y, s2.y), intersect(s1.z, s2.z))
stepempty(s::Step) = isempty(s.x) || isempty(s.y) || isempty(s.z)

function split_overlap(s::Step, os::Step, skip::Bool = false)
    parts = Vector{Step}()
    for x in (os.x, s.x.start:(os.x.start-1), (os.x.stop+1):s.x.stop), y in (os.y, s.y.start:(os.y.start-1), (os.y.stop+1):s.y.stop), z in (os.z, s.z.start:(os.z.start-1), (os.z.stop+1):s.z.stop)
        (isempty(x) || isempty(y) || isempty(z)) && continue
        x == os.x && y == os.y && z == os.z && skip && continue
        push!(parts, Step(true, x, y, z))
    end
    return parts
end

total(A::Vector{Step}) = sum(length(i.x) * length(i.y) * length(i.z) for i in A)

function parse_line(str)
    m = match(r"(?<on>on|off)\sx=(?<xs>-?\d+)\.\.(?<xe>-?\d+),y=(?<ys>-?\d+)\.\.(?<ye>-?\d+),z=(?<zs>-?\d+)\.\.(?<ze>-?\d+)", str)
    Step(m[:on] == "on", parse(Int,m[:xs]):parse(Int,m[:xe]), parse(Int,m[:ys]):parse(Int,m[:ye]), parse(Int,m[:zs]):parse(Int,m[:ze]))
end

function day22(f, part)
    reboot = Vector{Step}()
    open(f) do file
        for l in eachline(file)
            step = parse_line(l)
            part == 1 && (step = find_overlap(step, Step(step.on, -50:50, -50:50, -50:50)))
            stepempty(step) && continue
            newstep = [step]
            curr = 1
            while curr ≤ length(reboot)
                new_curr = 1
                replace_empty = false
                while new_curr ≤ length(newstep)
                    overlap = find_overlap(reboot[curr], newstep[new_curr])
                    if !stepempty(overlap)
                        replacements = split_overlap(reboot[curr], overlap, !step.on)
                        isempty(replacements) && (replace_empty = true)
                        splice!(reboot, curr, replacements)
                        step.on && splice!(newstep, new_curr, split_overlap(newstep[new_curr], overlap, true))
                    end
                    new_curr += 1
                end
                replace_empty || (curr += 1)
            end
            step.on && append!(reboot, newstep)
        end
    end
    return total(reboot)
end