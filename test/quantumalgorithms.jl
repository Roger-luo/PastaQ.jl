using ITensors
using PastaQ
using Test
using Random

@testset "quantum fourier transform" begin
  N = 5
  maxnum = 1<<N

  for n in 1:20
    number = rand(0:maxnum-1)
    number_bin = digits(number, base=2, pad=N) |> reverse

    # Prepare QFT state manually
    psi0 = qubits(N)
    gates = []
    hadamardlayer!(gates,N)
    for j in 1:N
      angle = number * π / 2^(j-1)
      push!(gates,(gate = "Rn", site = N-j+1, params = (θ = 0.0,ϕ = 0.0, λ = angle)))
    end
    prep_tensors = compilecircuit(psi0,gates)
    runcircuit!(psi0,prep_tensors)

    # Prepare number into qubits
    psi_number = copy(psi0)
    psi_number = resetqubits!(psi_number)
    for j in 1:N
      if number_bin[j] == 1
        applygate!(psi_number,"X",j)
      end
    end
    
    # Run QFT
    gates = qft(N)
    psi = copy(psi_number)
    qft_tensors = compilecircuit(psi,gates)
    runcircuit!(psi,qft_tensors)
    @test inner(psi0,psi) ≈ 1.0
    
    # Run inverse QFT
    psi = copy(psi0)
    gates = qft(N,inverse=true)
    qft_tensors = compilecircuit(psi,gates)
    runcircuit!(psi,qft_tensors)
    @test inner(psi,psi_number) ≈ 1.0
  end
end
