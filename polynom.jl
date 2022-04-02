using AbstractTrees
using Graphs
using Symbolics
#= x' = exp(x+exp(x^2+x))=# 
coun = 0
@variables x 
inp = []
m = exp(x + exp(x+x^2))
n = Symbolics.toexpr(m)
k = Symbolics.operation(n)
l = arguments(n)




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


function DFS_(l::Any, inp)
    if (typeof(l) == Symbol) ||  (typeof(l) == Int64)
        println(l)
        return 0
    end
    if typeof(l) == Num
        println(l)
    else typeof(l) == Int64 
        println(l)
    end
    line2 = operation(Symbolics.toexpr(l))
    line = arguments(Symbolics.toexpr(l))
    if (line2 == eval(exp))
        push!(inp, eval(l))
    end
    for i in line
        DFS_(i, inp)
    end
    return nothing
end
  
DFS_(m, inp)

print(inp)


#=function operations(l::Any)
    for i in DFS_(l)
        if (Symbiolics.operation(l) = exp)
            
end=#
