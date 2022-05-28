using Symbolics
using SymbolicUtils
using LinearAlgebra

#------------------------------------------------------------------------------
""" 
        normalization_of_z!(dict)
    Input: dictionary of substitutions which is unstructured.
    Output: dictionary with numerated, structured substitutions .   
"""
function normalization_of_z!(dict)
    for (i,f) in enumerate(keys(dict))
        dict[f] = Symbol("z$i")
    end
end

#------------------------------------------------------------------------------
""" 
            substsearch!(substdict, expression)
        Input: get dictionary,in which functions(our future substitutions) are added, which are extracted from system(expression).
        Output: Found substitutions are pushed into dictionary.
"""
function substsearch!(substdict, expression)
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
        substsearch!(substdict, expr)
    end
end

#------------------------------------------------------------------------------
"""
        Derivative_func(derivat, initial_expr, variables)
    Input: Recieves functions from which derivatives are taken, initial ode system, which denotes 
    derivatives for x', y' and so on and initial variables, on which derivatives are taken(x, y and etc).
    Output: Returns an array with derivatives of input functions.
"""
function Derivative_func(derivat, initial_expr, variables) 
    result = []
    k = length(initial_expr) - length(variables)
    if k > 0
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
"""
        substchange(expression, substdict) 
    Input: Gets an expression and dictionary with defined substitutions
    Output: Going through the expression and using substitutions, changes expression into polynomic one.
"""
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
"""
        print_ode(ode)
    Input: Gets an ODE adictionary as an input
    Output: prints the given dictionary
"""
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
    
    """ 
        Below data structures are presented, which will be used futher:
   result - final array, with transformation of initial ODE system into polynomic representation(f(z_i)). 
   substdict - is temporary dictionary, which is used to store some of the potential changes.
   derivatives_subst_dict - is dictionary, where substitutions are defined.
   """
    result = []
    substdict = Dict{Any, Any}()
    derivatives_subst_dict = Dict{Any, Any}()

    for i in expr_expr
        substsearch!(substdict, i)
    end
    
    derivatives_subst = Derivative_func(keys(substdict), rhs, vars)
    
    for i in derivatives_subst
        substsearch!(derivatives_subst_dict, Symbolics.toexpr(i))
    end
    
    normalization_of_z!(derivatives_subst_dict)
    derivatives_subst = Derivative_func(keys(derivatives_subst_dict), rhs, vars)
    
    for i in derivatives_subst
        push!(result, substchange(Symbolics.toexpr(i), derivatives_subst_dict))
    end
    
    return Dict(
        :newvars => derivatives_subst_dict,
        :new_ode => Dict(Symbol("z$i") => result[i] for i in 1:length(result))
    )
end

eqs = Dict(x => exp(exp(x*y)), y => exp(x+y))
print_ode(polynomialize(eqs))