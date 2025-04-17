using FTP
using Test
using LinearAlgebra

@testset "FTP.jl Tests" begin
    @testset "fun_val function" begin
        # Test Case 1: Basic example
        A = [-2 0; 0 2; 2 0]
        x = [0.0, 0.0]
        expected_fun_val = sum(norm.(eachrow(A)))
        @test fun_val(A, x) ≈ expected_fun_val

        # Test Case 2: Another point configuration
        A = [3 4; -3 -4; 6 8]
        x = [0.0, 0.0]
        expected_fun_val = sum(norm.(eachrow(A)))
        @test fun_val(A, x) ≈ expected_fun_val
    end

    @testset "weaksub function" begin
        # Test unit vector normalization
        A = [-2 0; 0 2; 2 0]
        x = [0.0, 0.0]
        z = weaksub(A, x)
        
        # Verify the subgradient has correct properties
        @test length(z) == 2  # 2D vector
        @test norm(z) ≈ 1.0  # Normalized direction

        # Single point test
        A_single = [3 4]
        x_single = [0.0, 0.0]
        z_single = weaksub(A_single, x_single)
        @test length(z_single) == 2
    end

    @testset "solve_fermat_torricelli" begin
        # Test with various point configurations
        A_configs = [
            [-2 0; 0 2; 2 0],  # Symmetric configuration
            [1 1; 4 4; 7 7],   # Linear configuration
            [0 0; 1 1; -1 -1]  # Centered configuration
        ]

        for A in A_configs
            optimal_point, convergence = solve_fermat_torricelli(A)
            
            # Verify basic properties of the solution
            @test length(optimal_point) == 2  # 2D point
            @test length(convergence) > 1     # Convergence history exists
            
            # Verify convergence (last value should be minimum)
            #@test all(convergence[i] <= convergence[i+1] for i in 1:length(convergence)-1)
        end
    end
end

println("All FTP.jl tests passed successfully!")
