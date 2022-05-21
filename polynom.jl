using Symbolics
using Reduce
#= x' = exp(x+exp(x^2+x))=# 
@variables x 
ex_var = []
initial_expression = exp(x + exp(x+x^2)) + exp(x + x^2)
expr_expression = Symbolics.toexpr(initial_expression)
oper_expression = Symbolics.operation(expr_expression)
argum_expression = arguments(expr_expression)


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


function DFS_(express::Any, ex_var)                                   #Here we represent our initial expression as a tree and use search 
    if (typeof(express) == Symbol) ||  (typeof(express) == Int64)  #in order to detect our substitutions 
        println(express)
        return 0
    end
    if typeof(express) == Num
        println(express)
    else typeof(express) == Int64 
        println(express)
    end
    oper_express = operation(Symbolics.toexpr(express))
    arg_express = arguments(Symbolics.toexpr(express))
    if (oper_express == eval(exp))
        push!(ex_var, eval(express))
    end
    for i in arg_express
        DFS_(i, ex_var)
    end
    return nothing
end
  
DFS_(initial_expression, ex_var)
ex_var = unique(ex_var)
print(ex_var)


#=function operations(l::Any)
    for i in DFS_(l)
        if (Symbiolics.operation(l) = exp)
            
end=#
