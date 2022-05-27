using Symbolics
using SymbolicUtils
using LinearAlgebra

#------------------------------------------------------------------------------

function normalization_of_z(dict)
    for (i,f) in enumerate(keys(dict))
        dict[f] = Symbol("z$i")
    end
end

#------------------------------------------------------------------------------

function substsearch(substdict, expression)
    if typeof(expression) <: Int
        return
    end
    if (typeof(expression) == Symbol) || (operation(expression) == exp)
        if !(expression in keys(substdict))
            substdict[expression] = Symbol("z")
        end
        return
    end
    for expr in arguments(expression)
        substsearch(substdict, expr)
    end
end

#------------------------------------------------------------------------------

function Derivative_func(derivat, initial_expr, variables) 
    result = []
    k = length(initial_expr) - length(variables)
    if k>0
        for i in 1:k
            push!(variables, 1)
        end
    end
    for i in derivat
        push!(result, dot(Symbolics.gradient(eval(i), variables), eval.(initial_expr)))
    end
    return result
end

#------------------------------------------------------------------------------

function substchange(expression, substdict)
    if typeof(expression) <: Int
        return expression
    end
    if (typeof(expression) == Symbol) || (operation(expression) == exp)
        return substdict[expression]
    end
    tree = [substchange(substitution, substdict) for substitution in arguments(expression)]
    return Expr(:call, Symbol(operation(expression)), tree...)
end

#------------------------------------------------------------------------------

function print_ode(ode)
    for (k, v) in ode
        println("$k' = $(v)")
    end
end

#------------------------------------------------------------------------------

"""
    polynomialize(eqs)

Takes as input a dictionary from state variables to their derivatives.
Returns a new ODE system also represented as a dictionary and a dictionary expressing new
variables in terms of the original ones
"""
function polynomialize(eqs)
    vars = collect(keys(eqs))
    rhs = collect(values(eqs))
    expr_expr = Symbolics.toexpr.(rhs)
    
    result = []
    substdict = Dict{Any, Any}()
    derivatives_subst_dict = Dict{Any, Any}()

    for i in expr_expr
        substsearch(substdict, i)
    end
    
    derivatives_subst = Derivative_func(keys(substdict), rhs, vars)
    
    for i in derivatives_subst
        substsearch(derivatives_subst_dict, Symbolics.toexpr(i))
    end
    
    normalization_of_z(derivatives_subst_dict)
    derivatives_subst = Derivative_func(keys(derivatives_subst_dict), rhs, vars)
    
    for i in derivatives_subst
        push!(result, substchange(Symbolics.toexpr(i), derivatives_subst_dict))
    end
    
    return Dict(
        :newvars => derivatives_subst_dict,
        :new_ode => Dict(Symbol("z$i") => result[i] for i in 1:length(result))
    )
end

#------------------------------------------------------------------------------
