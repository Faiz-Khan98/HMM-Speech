% Backward.m
function [beta,PO] = Backward(A,B,O)

T = size(O,2); 
N = size(B,1); 
sum = 0;

beta = zeros(N,T);
for t = T: -1: 1
    if t == T
        for i = 1:N
            beta(i,t) = A((i+1),size(A,2));
        end
    else
        for i = 1:N
            for j = 1:N
                sum = sum + A((i+1),(j+1)) * B(j,O(t+1)) * beta(j,(t+1));
            end
            beta(i,t) = sum;
            sum = 0;
        end
    end
end

PO = 0;
for i = 1:N
    PO = PO + A(1,(i+1)) * B(i,O(1)) * beta(i,1); 
end

end