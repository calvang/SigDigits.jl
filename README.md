# SigFigs.jl

Got tired of manually calculating significant figures, so I made this.

SigFigs.jl is a Julia package that automatically handles significant figures in all rudimentary calculations, namely addition, subtraction, multiplication, and division.

## Description

Calculations are achieved using Julia's built-in metaprogramming and significant figure rounding.

This module can handle nested elementary operations while respecting significant figures.

## Usage

To start input mode, simply type `start`, and you will be prompted with the significant figure evaluation mode.

To exit input mode, type `exit`.