module SigDigits

using Decimals

include("sigfunctions.jl")

export use_sigdigits,
    use_sigdigits,
    sig_start,
    str_replace,
    count_digits,
    count_sigdigits,
    count_decimalplaces, 
    count_nonzero_decimalplaces

end
