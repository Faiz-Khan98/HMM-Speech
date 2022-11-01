% Forward.m
function [alpha,PO] = Forward(A,B,O)

T = size(O,2); % No. of observations
N = size(B,1); % No. of states
sum = 0;

alpha = zeros(N,T);
for t = 1:T
    if t == 1
        for i = 1:N
            alpha(i,t) = A(t,(i+1))*B(i,O(t));
        end
    else
        for j = 1:N
            for i = 1:N
                sum = sum + alpha(i,(t-1)) * A((i+1),(j+1));
            end
            alpha(j,t) = sum * B(j,O(t));
            sum = 0;
        end
    end
end

PO = 0;
for i = 1:N
    PO = PO + alpha(i,T) * A((i+1),size(A,2)); 
end

end

