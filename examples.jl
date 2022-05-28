include("polynom.jl")

@variables x, y
ode = Dict(x => exp(x + y), y => exp(x * y))
println("Original ODEs:")
print_ode(ode)

res = polynomialize(ode)
println("New variables:")
for (k, v) in res[:newvars]
    println("$v = $(k)")
end

println("New ODEs:")
print_ode(res[:new_ode])
