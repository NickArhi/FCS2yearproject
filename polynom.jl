using Symbolics
using SymbolicUtils
using LinearAlgebra
#= x' = exp(x+exp(x^2+x))=# 
@variables x
ex_var = []
test = []
initial_expr = exp(x + exp(x+x^2)) + exp(x + x^2)
expr_expr = Symbolics.toexpr(initial_expr)
oper_expr = Symbolics.operation(expr_expr)
arg_expr = arguments(expr_expr)
counter = 0

substdict = Dict{Any, Any}()

function substsearch(substdict, expression, i)
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
        i = i + 1
        substsearch(substdict, expr, i)
    end
    if !(x in keys(substdict))
        i = i + 1
        substdict[Symbolics.toexpr(x)] = Symbol("z$i")
    end
end

substsearch(substdict, expr_expr, counter)

function Subst_(inp, initial_expr::Any) 
    result = []
    for i in inp
        push!(result, dot(simplify(expand_derivatives(D(eval(i)))),initial_expr))
    end
    return result
end

D = Differential(x)

derivatives_subst = Subst_(keys(substdict), initial_expr)

function substchange(expression, substdict)
    if typeof(expression) <: Int
        return expression
    end
    if (typeof(expression) == Symbol) || (operation(expression) == exp)
        return substdict[expression]
    end
    new_tree = [substchange(new_expression, substdict) for new_expression in arguments(expression)]
    return Expr(:call, operation(expression), new_tree...)
end


result = []
for i in derivatives_subst
    push!(result,substchange(Symbolics.toexpr(i), substdict))
end

result