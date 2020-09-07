# SigDigits.jl

![build](https://travis-ci.org/calvang/SigDigits.svg?branch=master)

Got tired of manually calculating significant digits, so I made this.

SigDigits.jl is a Julia package that automatically handles significant digits in all rudimentary calculations, namely addition, subtraction, multiplication, and division.

## Description

Calculations are achieved using Julia's built-in metaprogramming and significant digit rounding.

This module can handle nested elementary operations while respecting significant digits.

## Usage

To start input mode, simply type `sig_start()`, and you will be prompted with the significant digit evaluation mode.

To exit input mode, type `exit`.

You can also directly evaluate using significant digits by calling `use_sigdigits(<expression>)`.

This package also provides the functionality to calculate the number of significant digits a value has via the command: `count_sigdigits(<value>)`, as well as support for counting decimal places with `count_decimalplaces(<value>)` and nonzero decimal places with `count_nonzero_decimalplaces(<value>)`.

I also included the random functionality of replacing a part of a string because I implemented it during the development of this package: `str_replace(<string>,<start_index>,<end_index>,<value>)`.

## TODO:

- [ ] Update documentation
- [ ] Complete unit testing of all cases
- [X] Implement more accessible functions
- [ ] Define build
- [ ] Publish package
