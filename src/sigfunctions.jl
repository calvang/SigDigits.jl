"""
    use_sigdigits(str)
Evaluate input string while respecting significant digits.

# Examples
```julia-repl
julia> use_sigdigits("1.801 + 3.5")
5.3
```
"""
function use_sigdigits(str::String)
    ex = Meta.parse(str)
    return eval_sigdigits(ex)
end


"""
    use_sigdigits(expr)
Evaluate input expression while respecting significant digits.

# Examples
```julia-repl
julia> ex = Meta.parse("1.801 + 3.5")
julia> use_sigdigits(ex)
5.3
```
"""
function use_sigdigits(ex::Expr)
    return eval_sigdigits(ex)
end

"""
Output text in specified color.
"""
function print_color(text, r::Int, g::Int, b::Int)
    print("\e[1m\e[38;2;$r;$g;$b;249m",text)
end

"""
    sig_start()
Start significant digit evaluation mode with default colors.
"""
function sig_start()
    sig_start(100, 200, 255)
end

"""
    sig_start(r::Int, g::Int, b::Int)
Start significant digit evaluation mode with specified colors.
"""
function sig_start(r::Int, g::Int, b::Int)
    println("Starting input mode...")
    while true
        print_color("sig>", r, g, b)
        print_color(" ", 240, 240, 240)
        input = chomp(readline())
        if strip(input) == "exit"; break
        elseif strip(input) == "help"
            print("In input mode, any valid math expression ")
            println("you input will be handled along with its significant digits.")
        else
            try
                ex = Meta.parse(input)
                println(eval_sigdigits(ex))
            catch e
                if isa(e, ErrorException)
                    print_color("Error: invalid input!", 255, 100, 100)
                    print_color(" \n", 240, 240, 240) 
                else
                    stacktrace(catch_backtrace())
                end
            end
        end
    end
end

"""
Calculate the minimum significant digits in the arguments of an expression.
"""
function find_min_sig(args, minset::Tuple, ismult)#hasmult, hasadd)
    new_minsig = minset[1]
    new_mindec = minset[2]
    tmpsets = Vector{Tuple}()
    # iterate through expression args and handle nested expressions and minimums
    for el in args
        if typeof(el) == Expr
            tmpset = calc_sig(el, minset)
            push!(tmpsets, tmpset)
        elseif typeof(el) != Symbol
            tmpsig = count_sigdigits(el)
            tmpdec = count_decimalplaces(el)
            if ismult && tmpsig < new_minsig; new_minsig = tmpsig; end
            if !ismult && tmpdec < new_mindec; new_mindec = tmpdec; end
        end
    end
    # interate through nested expression outputs to find minimum significant digits and decimal places
    for set in tmpsets
        if set[1] < new_minsig; new_minsig = set[1] end
        if set[2] < new_mindec; new_mindec = set[2] end
    end
    if new_minsig != Inf; new_minsig = floor(Int, new_minsig) end
    if new_mindec != Inf; new_mindec = floor(Int, new_mindec) end
    println("new_minset: ", (new_minsig, new_mindec))
    return (new_minsig, new_mindec)
end

"""
Calculate the minimum significant digits in an expression.
"""
function calc_sig(ex, minset::Tuple)
    operator = ex.args[1]
    ismult = false
    if operator == :* || operator == :/; ismult = true
    elseif operator == :+ || operator == :-; ismult = false
    end
    println("minset: ", minset)
    return find_min_sig(ex.args, minset, ismult)
end

"""
    eval_digdigits(ex:Expr)
Evaluate an expression while respecting significant digits.
"""
function eval_sigdigits(ex)
    minset = calc_sig(ex, (typemax(Float32), typemax(Float32)))
    ans = eval(ex)
    println(minset)
    if minset[1] != Inf; ans = round(ans, sigdigits=minset[1]) end
    nondec = count_digits(ans) - count_decimalplaces(ans)
    println("DIGITS: ", count_digits(ans), " ", count_decimalplaces(ans), " ", minset)
    if minset[2] != Inf; ans = round(ans, digits=nondec+minset[2]) end
    return ans
end

"""
    str_replace(str::String, first::Int, last::Int, new::String)
Return new string with replaced substring.
"""
function str_replace(str::String, first::Int, last::Int, new::String)
    front = str[1: first]
    back = str[last+1: end]
    return front * new * back;
end

"""
    count_digits(val)
Enumerate the number of digits in a number.
"""
function count_digits(val)
    if val == 0 return 0 end
    strval = string(decimal(val))
    len = length(strval)
    if val < 0; len -= 1 end
    if findfirst(".", strval) != nothing; len -= 1 end
    return len
end

"""
    count_sigdigits(val)
Enumerate the number of significant digits in a number.
"""
function count_sigdigits(val)
    if val == 0 return 0 end
    num = string(decimal(val))
    len = length(num)
    if val < 0; len -= 1; num = num[2:end] end
    sigdigits = 0
    unwrapped_zeros = 0 # resets every time zeros are wrapped
    prevnonzero = false
    for i in 1:len
        placeval = num[i]
        if placeval == '.'; continue
        elseif placeval == '0'; prevnonzero && (unwrapped_zeros += 1; true)
        elseif unwrapped_zeros > 0
            sigdigits += unwrapped_zeros + 1
            unwrapped_zeros = 0
            prevnonzero = true
        else
            sigdigits += 1
            prevnonzero = true
        end
    end
    return sigdigits
end

"""
    count_decimalplaces(val)
Enumerate the number of decimal places a float contains.
"""
function count_decimalplaces(val)
    num = decimal(val)
    decimalslug = num - trunc(num)
    if decimalslug == 0; return 0; end
    decimals = 0
    while decimalslug > 0
        decimals += 1
        placeval = trunc(decimalslug, digits=decimals)
        decimalslug -= placeval
    end 
    return decimals
end

"""
    count_decimalplaces(val)
Enumerate the number of nonzero decimal places a float contains.
"""
function count_nonzero_decimalplaces(val)
    num = decimal(val)
    decimalslug = num - trunc(num)
    if decimalslug == 0; return 0; end
    decimals = 0
    nonzeros = 0
    while decimalslug > 0
        decimals += 1
        placeval = trunc(decimalslug, digits=decimals)
        decimalslug -= placeval
        if placeval > 0; nonzeros += 1; end
    end 
    return nonzeros
end