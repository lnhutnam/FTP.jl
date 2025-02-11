function fun_val(A, x)
    m = size(A, 1)  # Number of rows in A
    y = 0.0
    for i in 1:m
        y += norm(x - A[i, :])  # Compute Euclidean norm and sum
    end
    return y
end

function weaksub(A, x)
    n = size(A, 1)  
    B = repeat(x', n, 1)  
    C = B - A 
    N = norm.(eachrow(C))
    IndZ = N .== 0
    N[IndZ] .= 1
    K = C ./ N
    z = sum(K, dims=1)[:]
    return z
end