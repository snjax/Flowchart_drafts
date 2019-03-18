
include("ff.jl")
include("linearcombination.jl")


mutable struct Constraint
    a::LinearCombination
    b::LinearCombination
    c::LinearCombination
end



mutable struct Protoboard 
    witness::Vector{ff}
    signals::Vector{Union{missing,ff}}
    constraints::Vector{Constraint}
    cursor::Int64
    mode::Int64
end

mutable struct Signal
    id::Int64
end

pb = Protoboard(Vector{ff}(), Vector{Union{missing,ff}}(), Vector{Constraint}(), 0, 0)

function Signal()
    if pb.mode == 0 
        push!(pb.signals, missing)
        return Signal(length(pb.signals))
    else
        pb.cursor += 1
        return Signal(pb.cursor)
    end
end

function enforce(a::LinearCombination, b::LinearCombination, c::LinearCombination)
    push!(pb.constraints, Constraint(a, b, c))
end

function conduct(s::Signal, v::Union{Missing,<:Integer})
    pb.signals[s.id] = ff(v)
end

function value(s::Signal)
    return pb.signals[s.id].v
end


function Num2Bits(n::Int64, in::Signal)
    out = Vector{Signal}()
    lc1 = LinearCombination()
    l0 = LinearCombination()

    for i = 1:n
        s = Signal()
        push!(out, s)
        lc1 = lc1 + (1 << (i - 1), s)
        enforce(l0 + (1, s), l0 + (1, s) - (1, 1), l0)
        conduct(s, value(in) >> (i - 1) & 1)
    end
    enforce(l0, l0, lc1 - (1, in))
    return out
end



# template Num2Bits(n) {
#     signal input in;
#     signal output out[n];
#     var lc1=0;

#     for (var i = 0; i<n; i++) {
#         out[i] <-- (in >> i) & 1;
#         out[i] * (out[i] -1 ) === 0;
#         lc1 += out[i] * 2**i;
#     }

#     lc1 === in;
# }