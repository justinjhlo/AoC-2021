using ShiftedArrays

check_east(A) = (A .== 1) .& (ShiftedArrays.circshift(A, (-1, 0)) .== 0)
check_south(A) = ((A .== 2) .& (ShiftedArrays.circshift(A, (0, -1)) .== 0)) .* 2
move_east(A) = ShiftedArrays.circshift(check_east(A), (1, 0)) .+ (A .⊻ check_east(A))
move_south(A) = ShiftedArrays.circshift(check_south(A), (0, 1)) .+ (A .⊻ check_south(A))
move(A) = move_south(move_east(A))

function day25(f)
    seamap = open(f) do file
        lines = readlines(file) 
        x = reshape(collect(join(lines)), :, length(lines))
        @. (x == '>') + (x == 'v') * 2
    end
    total = 0

    while true
        nextmap = move(seamap)
        total += 1
        (seamap == nextmap) && break
        seamap = nextmap
    end

    return total
end