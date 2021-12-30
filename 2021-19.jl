const all_axes = [[1,2,3], [1,3,2], [2,3,1], [2,1,3], [3,1,2], [3,2,1]]
const all_dirs = reshape([[1,1,1], [1,-1,-1], [-1,1,-1], [-1,-1,1], [1,1,-1], [1,-1,1], [-1,1,1], [-1,-1,-1]], 4, 2)

struct Scanner
    pos::Vector{Int}
    axis::Vector{Int}
    direction::Vector{Int}
end
Scanner() = Scanner([0,0,0], [1,2,3], [1,1,1])

function read_scanners(f)
    lines = readlines(f)
    maps = Vector{AbstractArray}()
    start, stop = 0, 0
    while true
        start = findnext(x -> contains(x, "---"), lines, start + 1)
        stop = findnext(isempty, lines, stop + 1)
        stop === nothing && (stop = length(lines) + 1)
        push!(maps, reduce(hcat, map(x -> parse.(Int, x), split.(lines[(start + 1):(stop - 1)], ","))))
        stop > length(lines) && break
    end
    return maps
end

function check_overlap(Da, Db)
    for (ind, p) in enumerate(all_axes)
        for q in all_dirs[:, mod1(ind, 2)]
            overlaps = intersect(collect(values(Da)), map(x -> x[p] .* q, collect(values(Db))))
            length(overlaps) ≥ 132 && return p, q, [get_overlap_beacons(Db, p, q, overlaps), get_overlap_beacons(Da, [1,2,3], [1,1,1], overlaps)]
        end
    end
    return nothing, nothing, nothing
end
get_overlap_beacons(A, p, q, P) = unique(vcat((filter(x -> A[x][p] .* q ∈ P, collect(keys(A)))...)...))

reorient(A, axis, direction) = A[axis, :] .* direction
mat2set(A) = Set(collect(eachcol(A)))
count_beacons(maps) = length(mat2set(reduce(hcat, maps)))

function solve_map(A)
    scanners = Vector{Scanner}(undef, length(A))
    scanners[1] = Scanner()
    solved = [1]
    curr = 1
    while curr < length(A)
        curr_dists = construct_dists(A[solved[curr]])
        for i in setdiff(1:length(A), solved)
            i_dists = construct_dists(A[i])
            i_axis, i_direction, i_beacons = check_overlap(curr_dists, i_dists)
            if !isnothing(i_axis)
                A[i] = reorient(A[i], i_axis, i_direction)
                for j = 1:length(i_beacons[1])
                    shift = vec(A[solved[curr]][:, i_beacons[2][j]] .- A[i][:, i_beacons[1][1]])
                    if mat2set(A[i][:, i_beacons[1]] .+ shift) == mat2set(A[solved[curr]][:, i_beacons[2]])
                        scanners[i] = Scanner(shift, i_axis, i_direction)
                        A[i] = A[i] .+ shift
                        break
                    end
                end
                push!(solved, i)
            end
        end
        curr += 1
    end
    return scanners, A
end
construct_dists(A) = Dict((m, n) => A[:,m] .- A[:,n] for m in 1:size(A,2) for n in 1:size(A,2) if m != n)

# Part 2 functions
dist(s::Scanner, t::Scanner) = sum(abs.(t.pos .- s.pos))
find_max_dist(A) = maximum([dist(s, t) for s in A for t in A if s != t])

function day19(f, part)
    maps = read_scanners(f)
    scanners, maps_shifted = solve_map(maps)
    return part == 1 ? count_beacons(maps_shifted) : find_max_dist(scanners)
end