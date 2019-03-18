import SparseArrays
const MAX_CONSTRAINS = 10000000
mutable struct LinearCombination
    value::SparseArrays.SparseVector{ff,Int64}
    function LinearCombination(value::SparseArrays.SparseVector{ff,Int64})
        if value.n != MAX_CONSTRAINS
            return new(SparseArrays.SparseVector(MAX_CONSTRAINS, value.nzind, value.nzval))
        else
            return new(value)
        end
    end
end
LinearCombination() = LinearCombination(SparseArrays.SparseVector(MAX_CONSTRAINS, Int64[], ff[]))
LinearCombination(a::Tuple{<:Integer,Int64}) = LinearCombination(SparseArrays.SparseVector(MAX_CONSTRAINS, [a[2]], [ff(a[1])]))
LinearCombination(a::Tuple{<:Integer,Signal}) = LinearCombination(SparseArrays.SparseVector(MAX_CONSTRAINS, [a[2].id], [ff(a[1])]))


Base.:+(a::LinearCombination, b::LinearCombination) = LinearCombination(a.value + b.value)
Base.:-(a::LinearCombination, b::LinearCombination) = LinearCombination(a.value - b.value)
Base.:*(a::LinearCombination, b::T) where T <: Integer = LinearCombination(a.value * b)
Base.:/(a::LinearCombination, b::T) where T <: Integer = LinearCombination(a.value / b)
Base.:+(a::LinearCombination, b::Tuple{<:Integer,Int64}) = a + LinearCombination(b)
Base.:-(a::LinearCombination, b::Tuple{<:Integer,Int64}) = a - LinearCombination(b)
