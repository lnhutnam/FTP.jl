using FTP
using Test
using LinearAlgebra

@testset "Testing fun_val function" begin

    # Test Case 1: Basic example for fun_val
    A = [-2 0; 0 2; 2 0]
    x = [0.0, 0.0]
    expected_fun_val = norm([-2, 0]) + norm([0, 2]) + norm([2, 0])  # 2 + 2 + 2 = 6
    @test fun_val(A, x) ≈ expected_fun_val

    # Test Case 2: Another case for fun_val
    A = [3 4; -3 -4; 6 8]
    x = [0.0, 0.0]
    expected_fun_val = norm([3, 4]) + norm([-3, -4]) + norm([6, 8])  # 5 + 5 + 10 = 20
    @test fun_val(A, x) ≈ expected_fun_val
    
    println("All tests passed!")
end


@testset "Testing weaksub function" begin
    # Test Case 1: Checking weaksub output on a simple set
    A = [-2 0; 0 2; 2 0]
    x = [0.0, 0.0]
    z = weaksub(A, x)
    expected_z = [-2, 2, 2] ./ [2, 2, 2]  # Normalized unit vectors
    expected_z = sum(expected_z, dims=1)[:]  # Sum along rows
    @test z ≈ expected_z  # Checking if computed subgradient matches expectation

    # Test Case 2: Checking weaksub with a single point
    A = [3 4]
    x = [0.0, 0.0]
    z = weaksub(A, x)
    expected_z = [(3/5, 4/5)]  # Unit vector direction
    @test z ≈ expected_z  # Should return the unit vector towards (3,4)
    
    println("All tests passed!")
end
