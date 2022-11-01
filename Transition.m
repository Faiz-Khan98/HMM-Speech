% Transition.m
function [A_underscore,A_bar,B_underscore,B_bar,xi,entry,exit] = Transition(alpha,beta,PO1,A,B,O,gamma)

xi = zeros(size(A));
A_underscore = zeros(size(A));
T = size(O,2);
N = size(B,1);
%--------------------------------------------------------------------------
% Calculate Transition likelihood and a_underscore and a_bar

for t = 2:T
    for i = 1:N
        for j = 1:N
            xi((i+1),(j+1),(t-1)) = (alpha(i,(t-1)) * beta(j,t) * A((i+1),(j+1)) * B(j,O(t))) / PO1;
        end
    end
    A_underscore = xi(:,:,(t-1)) + A_underscore;
end

for i = 1:N
    A_underscore(1,(i+1)) = gamma(i,1);
    entry(1,(i+1)) = gamma(i,1);
end
for i = 1:N
    A_underscore((i+1),size(A,2)) = gamma(i,T);
    exit((i+1),1) = gamma(i,T);
end

A_bar = sum(A_underscore,2);
%--------------------------------------------------------------------------
% Calculate b_underscore and b_bar

denom = zeros(N,1);
for j = 1:N
    for t = 1:T
        denom(j,1) = denom(j,1) + gamma(j,t);
    end
end

numer = zeros(size(B));
for k = 1:size(B,2)
    for j = 1:N
        for t = 1:T
            numer(j,k) = (gamma(j,t) * W(k,t,O)) + numer(j,k);
        end
    end
end

B_underscore = numer;
B_bar = denom;

end