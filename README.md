# FTP

[![Build Status](https://github.com/lnhutnam/FTP.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/lnhutnam/FTP.jl/actions/workflows/CI.yml?query=branch%3Amain)

```julia
using FTP
using Plots

# Define points
A = [-2 0; 0 2; 2 0]

# Solve the Fermat-Torricelli problem
optimal_point, convergence_history = solve_fermat_torricelli(A)

# Visualize the solution
p = plot_solution(A, optimal_point)
display(p)
```