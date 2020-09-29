using ITensors
using PastaQ
using Random
using HDF5

Random.seed!(1234)

N = 4
depth = 4
nshots = 10000
gates = randomcircuit(N,depth)

# 1. Generation of measurement data on the quantum states
# at the output of a circuit. Each data-point is a projetive
# measurement in an arbitrary local basis.Default local basis 
# is `["X","Y","Z"]`.
# a) Unitary circuit
ψ,data = getsamples(N,gates,nshots;return_state=true)
# Returns output state as MPS
@show maxlinkdim(ψ)
@show ψ 
savedata(ψ,data,"data/qst_circuit.h5")

# Note: the above is equivalent to:
#> bases = randombases(N,nshots,localbasis=["X","Y","Z"])
#> ψ = runcircuit(N,gates)
#> data = getsamples(ψ,nshots,bases)

# b) Noisy circuit
ρ,data = getsamples(N,gates,nshots;
                      noise="AD",γ=0.01,
                      return_state=true)
# Return the mixed density operator as MPO
@show maxlinkdim(ρ)
@show ρ
savedata(ρ,data,"data/qst_circuit_noisy.h5")

# 2. Generation of measurerment data for quantum process
# tomography. Each measurement consist of a input product 
# state and an output projective measurement in a arbitrary
# local basis. By default, the single-qubit input states are 
# the 6 eigenstates of Pauli operators.
U,data_in,data_out=getsamples(N,gates,nshots;
                                  process=true,
                                  return_state=true)
# Return the MPO for the unitary circuit
@show maxlinkdim(U)
@show U
savedata(U,data_in,data_out,"data/qpt_circuit.h5")

Λ,data_in,data_out=getsamples(N,gates,nshots;
                                  process=true,
                                  noise="AD",γ=0.01,
                                  return_state=true)
# Return the Choi matrix `Λ` as MPO wiith `2N` sites
@show maxlinkdim(Λ.M)
@show Λ
savedata(Λ,data_in,data_out,"data/qpt_circuit_noisy.h5")
