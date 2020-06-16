function qft(N::Int; inverse::Bool=false)
  gates = []
  if inverse
    for j in N:-1:1
      for k in N:-1:j+1
        angle = -π / 2^(k-j)
        push!(gates,(gate = "CRz", site = [k,j] ,params = (ϕ=angle,)))
      end
      push!(gates,(gate = "H", site = j))
    end
  else
    for j in 1:N
      push!(gates,(gate = "H", site = j))
      for k in j+1:N
        angle = π / 2^(k-j)
        push!(gates,(gate = "CRz", site = [k,j] ,params = (ϕ=angle,)))
      end
    end
  end
  return gates
end

function qpe(N::Int)

end
