using Symbolics
#= x' = exp(x+exp(x^2+x))=# 
coun = 0
@variables t, x(t) 
ex_var = []
initial_expr = exp(x + exp(x+x^2)) + exp(x + x^2)
expr_expr = Symbolics.toexpr(initial_expr)
oper_expr = Symbolics.operation(expr_expr)
arg_expr = arguments(expr_expr)




#=function DFS_(l::Any)
    println("зашел")
    global coun += 1
    if (typeof(l) == Symbol) ||  (typeof(l) == Int64)
        println(l)
        return 0
    end
    if typeof(l) == Num
        println(l)
    else typeof(l) == Int64
        println(l)
    end
    line = arguments(Symbolics.toexpr(l))
    for i in line
        DFS_(i)
    end
    return nothing
end=#


function DFS_(expression::Any, sub_list)                                      #Here we represent our equation as a tree and 
    if (typeof(expression) == Symbol) ||  (typeof(expression) == Int64)     #search for correct substitutions
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
print(ex_var)


....
function Subst_(inp)
    D = Differential(t)
    for i in inp
        println(i)
        simplify(expand_derivatives(D(i)))
        println(i)
    end
    return nothing
end

Subst_(ex_var)



#=function operations(l::Any)
    for i in DFS_(l)
        if (Symbiolics.operation(l) = exp)
            
end=#
