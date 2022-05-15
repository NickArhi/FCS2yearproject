using Symbolics
using SymbolicUtils
#= x' = exp(x+exp(x^2+x))=# 
#@syms x(t::Real)::Num
@variables x
ex_var = []
test = []
initial_expr = exp(x + exp(x+x^2)) + exp(x + x^2)
expr_expr = Symbolics.toexpr(initial_expr)
oper_expr = Symbolics.operation(expr_expr)
arg_expr = arguments(expr_expr)


function DFS_(expression::Any, sub_list)                                      #Here we represent our equation as a tree and 
    if (typeof(expression) == Symbol) ||  (typeof(expression) == Int64)       #search for correct substitutions
        println(expression)
        return 0
    end
    if typeof(expression) == Num
        println(expression)
    else typeof(expression) == Int64 
        println(expression)
    end
    line2 = operation(Symbolics.toexpr(expression))
    line = arguments(Symbolics.toexpr(expression))
    if (line2 == exp)
        push!(sub_list, expression)
    end
    for i in line
        DFS_(i, sub_list)
    end
    return nothing
end
  
DFS_(initial_expr, ex_var)
ex_var = unique(ex_var)


D = Differential(x)


function Subst_(inp, initial_expr::Any)
    result = []
    subs = []
    for i in inp
        push!(result, simplify(expand_derivatives(D(eval(i))))*initial_expr)
    end
    
    return result
end

varl = Subst_(ex_var, initial_expr)

DFS_(varl[2], test)

vars[Symbol("z$i") for i in 1:100]