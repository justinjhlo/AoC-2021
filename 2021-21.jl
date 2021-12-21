const move100 = cumsum(dropdims(sum(reshape(repeat(1:100, 6), 3, 2, :), dims = 1), dims = 1), dims = 2)
const prob = Dict(3 => 1, 4 => 3, 5 => 6, 6 => 7, 7 => 6, 8 => 3, 9 => 1)

mutable struct Game
    pos::Vector{Int}
    score::Vector{Int}
    throws::Int
end

function part1!(G::Game, threshold)
    while true
        pos_list = mod1.(move100 .+ G.pos, 10)
        scores = cumsum(pos_list, dims = 2) .+ G.score
        round = findfirst(x -> x ≥ threshold, scores)
    
        if round === nothing
            G.pos = pos_list[:, end]
            G.score = scores[:, end]
            G.throws += 600
        else
            if round[1] == 1
                G.pos = [pos_list[round]; pos_list[2, round[2] - 1]]
                G.score = [scores[round]; scores[2, round[2] - 1]]
                G.throws += 6 * round[2] - 3
            else
                G.pos = pos_list[:, round[2]]
                G.score = scores[:, round[2]]
                G.throws += 6 * round[2]
            end
            return G
        end
    end
end

function part2(G::Game, threshold)
    w1, w2 = 0, 0
    for i = 3:9
        posn = mod1.(G.pos .+ [i; 0], 10)
        scoren = G.score .+ posn
        if scoren[1] ≥ threshold
            w1 += prob[i]
        else
            for j = 3:9
                posn = mod1.(G.pos .+ [i; j], 10)
                scoren = G.score .+ posn
                if scoren[2] ≥ threshold
                    w2 += prob[i] * prob[j]
                else
                    (w1, w2) = (w1, w2) .+ prob[i] .* prob[j] .* part2(Game(posn, scoren, 0), threshold)
                end
            end
        end
    end
    return w1, w2
end

function day21(p1, p2, threshold, part)
    game = Game([p1; p2], [0; 0], 0)
    if part == 1
        part1!(game, threshold)
        return game.score[3 - mod1(game.throws, 2)] * game.throws
    end

    w1, w2 = part2(game, threshold)
    return w1 > w2 ? w1 : w2
end