using FTP
using Plots

function main()
    # Parameters
    # A = 10 .* rand(100, 2)
    A = [-2  0;
      0  2;
      2  0]
      
    x = [-5.0, 5.0] 
    N = 500 

    # Subgradient method
    v = [fun_val(A, x)]  # Store function values
    for i in 2:N
        x -= (1 / i) .* weaksub(A, x)  # Update x using subgradient
        push!(v, min(v[end], fun_val(A, x)))  # Track best function value
    end

    print(x)

    # Plotting setup
    scatter(A[:, 1], A[:, 2], label="Points in A", alpha=0.6, color=:blue)
    scatter!([x[1]], [x[2]], label="Optimizing point x", color=:red, markersize=6, markerstrokecolor=:black)

    # Draw dashed lines connecting x to A
    for i in 1:size(A, 1)
        plot!([x[1], A[i, 1]], [x[2], A[i, 2]], line=:dash, color=:blue, alpha=0.5, label=false)
    end

    # Set axis limits dynamically
    x_min, x_max = min(minimum(A[:, 1]), x[1]), max(maximum(A[:, 1]), x[1])
    y_min, y_max = min(minimum(A[:, 2]), x[2]), max(maximum(A[:, 2]), x[2])
    plot!(xlims=(x_min - 1, x_max + 1), ylims=(y_min - 1, y_max + 1))

    title!("Optimization Connections")
    xlabel!("X coordinate")
    ylabel!("Y coordinate")
    savefig("optimization_result.png")
end

main()