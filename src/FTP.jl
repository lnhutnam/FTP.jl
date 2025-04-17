module FTP

using LinearAlgebra
using Plots
using Random

"""
Compute the mean of a matrix along a specified dimension.

# Arguments
- `A`: Input matrix
- `dim`: Dimension along which to compute mean (1 for column-wise, 2 for row-wise)

# Returns
Mean values
"""
function custom_mean(A::AbstractMatrix, dim::Int = 1)
    if dim == 1
        # Column-wise mean
        return sum(A, dims=1) ./ size(A, 1)
    else
        # Row-wise mean
        return sum(A, dims=2) ./ size(A, 2)
    end
end

"""
Compute the total Euclidean distance from a point x to all points in matrix A.

# Arguments
- `A`: Matrix of points, where each row represents a point
- `x`: The point from which distances are calculated

# Returns
Total sum of Euclidean distances
"""
function fun_val(A::AbstractMatrix, x::AbstractVector)
    # Convert input to Float64 to ensure consistent type
    A_float = float(A)
    x_float = float(x)
    
    m = size(A_float, 1)  # Number of rows in A
    y = 0.0
    for i in 1:m
        y += norm(x_float - A_float[i, :])  # Compute Euclidean norm and sum
    end
    return y
end

"""
Compute a weak subgradient for the Fermat-Torricelli problem.

# Arguments
- `A`: Matrix of points, where each row represents a point
- `x`: Current point for subgradient calculation

# Returns
Weak subgradient vector
"""
function weaksub(A::AbstractMatrix, x::AbstractVector)
    # Convert input to Float64 to ensure consistent type
    A_float = float(A)
    x_float = float(x)
    
    n = size(A_float, 1)  
    B = repeat(x_float', n, 1)  
    C = B - A_float 
    N = norm.(eachrow(C))
    IndZ = N .== 0
    N[IndZ] .= 1
    K = C ./ N
    z = sum(K, dims=1)[:]
    return z
end

"""
Solve the Fermat-Torricelli problem using subgradient method.

# Arguments
- `A`: Matrix of points to find the optimal location
- `x0`: Initial point (optional)
- `N`: Number of iterations (default: 500)

# Returns
Optimal point and convergence history
"""
function solve_fermat_torricelli(
    A::AbstractMatrix, 
    x0::Union{AbstractVector, Nothing} = nothing, 
    N::Int = 500
)
    # Convert inputs to Float64
    A_float = float(A)
    
    # Set default initial point if not provided
    if isnothing(x0)
        x0 = vec(custom_mean(A_float, 1))
    else
        x0 = float(x0)
    end
    
    x = x0
    v = [fun_val(A_float, x)]  # Store function values

    for i in 2:N
        x -= (1 / i) .* weaksub(A_float, x)  # Update x using subgradient
        push!(v, min(v[end], fun_val(A_float, x)))  # Track best function value
    end

    return x, v
end

"""
Visualize the Fermat-Torricelli problem solution.

# Arguments
- `A`: Matrix of points
- `x`: Optimal point found
"""
function plot_solution(A::AbstractMatrix, x::AbstractVector)
    # Convert inputs to Float64
    A_float = float(A)
    x_float = float(x)
    
    # Plotting
    p = scatter(A_float[:, 1], A_float[:, 2], label="Points in A", alpha=0.6, color=:blue)
    scatter!(p, [x_float[1]], [x_float[2]], label="Optimizing point x", color=:red, markersize=6, markerstrokecolor=:black)

    # Draw dashed lines connecting x to A
    for i in 1:size(A_float, 1)
        plot!(p, [x_float[1], A_float[i, 1]], [x_float[2], A_float[i, 2]], line=:dash, color=:blue, alpha=0.5, label=false)
    end

    # Set axis limits dynamically
    x_min, x_max = min(minimum(A_float[:, 1]), x_float[1]), max(maximum(A_float[:, 1]), x_float[1])
    y_min, y_max = min(minimum(A_float[:, 2]), x_float[2]), max(maximum(A_float[:, 2]), x_float[2])
    plot!(p, xlims=(x_min - 1, x_max + 1), ylims=(y_min - 1, y_max + 1))

    title!(p, "Fermat-Torricelli Problem Solution")
    xlabel!(p, "X coordinate")
    ylabel!(p, "Y coordinate")
    
    return p
end

# Exports
export fun_val, weaksub, solve_fermat_torricelli, plot_solution, custom_mean

end # module
