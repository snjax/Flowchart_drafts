using TickTock


mutable struct BoxedFloat
  x::Float64
end

function Base.getproperty(n::BoxedFloat, p::Symbol)
  if p === :getx
    return () -> n.x
  else
    return getfield(n, p)
  end
end


function main(N::Int)
  s::Float64 = 0
  data = Vector{BoxedFloat}(undef, N)
  for i=1:N
    data[i] = BoxedFloat(Float64(i))
  end

  tick()
  for i=1:N
    s+=sin(data[i].x*data[i].x)
  end
  tock()
  tick()
  for i=1:N
    s+=sin(data[i].x*data[i].x)
  end
  tock()
  tick()
  for i=1:N
    s+=sin(data[i].getx()*data[i].getx())
  end
  tock()
  tick()
  for i=1:N
    s+=sin(data[i].getx()*data[i].getx())
  end
  tock()
end

main(1000000)