using Symbolics
using SymbolicUtils
using LinearAlgebra
#= x' = exp(x+exp(x^2+x))=# 
@variables x
initial_expr = exp(x + exp(x+x^2)) + exp(x + x^2)
expr_expr = Symbolics.toexpr(initial_expr)


D = Differential(x)
substdict = Dict{Any, Any}()
derivatives_subst_dict = Dict{Any, Any}()

function normalization_of_z(dict)
    for (i,f) in enumerate(keys(dict))
        dict[f] = Symbol("z$i")
    end
end

function substsearch(substdict, expression)
    if typeof(expression) <: Int
        return
    end
    if (typeof(expression) == Symbol) || (operation(expression) == exp)
        if !(expression in keys(substdict))
            substdict[expression] = Symbol("z$i")
        end
        return
    end
    for expr in arguments(expression)
        substsearch(substdict, expr)
    end
end


function Derivative_func(inp, initial_expr::Any) 
    result = []
    for i in inp
        push!(result, dot(simplify(expand_derivatives(D(eval(i)))),initial_expr))
    end
    return result
end


function substchange(expression, substdict)
    if typeof(expression) <: Int
        return expression
    end
    if (typeof(expression) == Symbol) || (operation(expression) == exp)
        return substdict[expression]
    end
    tree = [substchange(substitution, substdict) for substitution in arguments(expression)]
    return Expr(:call, operation(expression), tree...)
end

substsearch(substdict, expr_expr)

derivatives_subst = Derivative_func(keys(substdict), initial_expr)

for i in derivatives_subst
    substsearch(derivatives_subst_dict, Symbolics.toexpr(i))
end

normalization_of_z(derivatives_subst_dict)

derivatives_subst = Derivative_func(keys(derivatives_subst_dict), initial_expr)

result = []
for i in derivatives_subst
    push!(result,substchange(Symbolics.toexpr(i), derivatives_subst_dict))
end

result