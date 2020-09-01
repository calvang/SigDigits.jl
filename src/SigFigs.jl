module SigFigs

using Decimals

function print_color(text, r, g, b)
    """Output text in specified color"""
    print("\e[1m\e[38;2;$r;$g;$b;249m",text)
end

function start()
    """Start significant figure evaluation mode with default colors"""
    start(100, 200, 255)
end

function start(r, g, b)
    """Start significant figure evaluation mode with specified colors."""
    println("Starting input mode...")
    while true
        print_color("sig>", 100, 200, 255)
        print_color(" ", 240, 240, 240)
        input = chomp(readline())
        if strip(input) == "exit"; break
        elseif strip(input) == "help"
            print("In input mode, any valid math expression ")
            println("you input will be handled along with its significant figures.")
        else
            try
                ex = Meta.parse(input)
                println(sigdigits(ex))
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

function sigdigits(ex)
    """Calculate the solution for an expression to the correct number of significant figures."""
    return eval_sigdigits(ex)
    # Meta.show_sexpr(ex)
    # println(num_sigfigs)
    # ans = eval(ex)
    # return round(ans, sigdigits=num_sigfigs)
end

function find_min_sig(args, f::Function)
    min = typemax(Float32)
    for el in args
        if typeof(el) == Expr
            eval_sigdigits(el)
        elseif typeof(el) != Symbol 
            tmp = f(el)
            if tmp < min; min = tmp; end
        end
    end
    return floor(Int, min)
end

function eval_sigdigits(ex)
    """Recursively calculate number of significant figures to round to for expression."""
    # print(args)
    operator = ex.args[1]
    min = 0.0
    calc = (ex, minval) -> floor(Int, minval); answer = eval(ex); answer
    if operator == :* || operator == :/
        ans = eval(ex)
        return round(ans, sigdigits=find_min_sig(ex.args, count_sigdigits))
    elseif operator == :+ || operator == :-
        ans = eval(ex)
        return round(ans, digits=find_min_sig(ex.args, count_decimalplaces))
    end
end

function replace(str, first, last, new)
    """Return string with indexes from 'first' to 'last' replaced by 'new.'"""
    front = str[1: first]
    back = str[last+1: end]
    return front * new * back;
end

function count_sigdigits(val)
    """Find the number of significant figures,"""
    if val == 0 return 0 end
    num = string(decimal(val))
    # numdigits = 1
    sigdigits = 0
    unwrapped_zeros = 0 # resets every time zeros are wrapped
    prevnonzero = false
    for i in 1:length(num)
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

function count_decimalplaces(val)
    """Find the number of decimal places a float has, ignores trailing zeros."""
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

function count_nonzero_decimalplaces(val)
    """Find the number of decimal places a float has, ignores trailing zeros."""
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

end # module
