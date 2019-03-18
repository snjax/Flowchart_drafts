const _P_ = 21888242871839275222246405745257275088548364400416034343698204186575808495617

mutable struct ff <: Integer
    v::BigInt
    ff(v::BigInt) = begin 
        t = v % _P_
        return (t >= 0) ? new(t) : new(t + _P_) 
    end 
    ff(v::ff) = v
    аа(v::Missing) = missing
    ff(v::T) where T <: Integer = ff(big(v))
end


Base.:+(a::ff, b::T) where T <: Integer = ff((a.v + b + _P_) % _P_)
Base.:+(a::T, b::ff) where T <: Integer = ff((a + b.v + _P_) % _P_)
Base.:+(a::ff, b::ff) where T <: Integer = ff((a.v + b.v + _P_) % _P_)


Base.:-(a::ff, b::T) where T <: Integer = ff((a.v - b + _P_) % _P_)
Base.:-(a::T, b::ff) where T <: Integer = ff((a - b.v + _P_) % _P_)
Base.:-(a::ff, b::ff) where T <: Integer = ff((a.v - b.v + _P_) % _P_)


Base.:*(a::ff, b::T) where T <: Integer = ff((a.v * b) % _P_)
Base.:*(a::T, b::ff) where T <: Integer = ff((a * b.v) % _P_)
Base.:*(a::ff, b::ff) where T <: Integer = ff((a.v * b.v) % _P_)

Base.:/(a::ff, b::T) where T <: Integer = ff((a.v * invmod(b, _P_)) % _P_)
Base.:/(a::T, b::ff) where T <: Integer = ff((a * invmod(b.v, _P_)) % _P_)
Base.:/(a::ff, b::ff) where T <: Integer = ff((a.v * invmod(b.v, _P_)) % _P_)