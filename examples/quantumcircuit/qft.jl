using PastaQ
using ITensors
using Random

N = 5
number = 10 
number_bin = digits(number, base=2, pad=N) |> reverse

println("Number of qubits: ",N)
println("Number for QFT: ",number," -> ",number_bin)

println("\nGenerating QFT|number> manually..")
# Apply QFT manually
psi0 = qubits(N)
gates = []
hadamardlayer!(gates,N)
for j in 1:N
  angle = number * π / 2^(j-1)
  push!(gates,(gate = "Rn", site = N-j+1, params = (θ = 0.0,ϕ = 0.0, λ = angle)))
end
prep_tensors = compilecircuit(psi0,gates)
runcircuit!(psi0,prep_tensors)

println("Running inverse QFT..")
# Run inverse QFT
psi = copy(psi0)
gates = qft(N,inverse=true)
qft_tensors = compilecircuit(psi,gates)
runcircuit!(psi,qft_tensors)

println("Measuring the output..")
samples = measure(psi,5)
println("\nOutput samples: ",samples)

