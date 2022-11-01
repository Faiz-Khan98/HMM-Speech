close all; clear all ;clc;
A = [ 0 1 0 0 ...
    ; 0 0.8 0.2 0 ...
    ; 0 0 0.6 0.4 ...
    ; 0 0 0 0];

B = [ 0.5 0.2 0.3 ...
    ; 0 0.9 0.1];

O = [3 2 2];

[alpha,PO1] = Forward(A,B,O);
[beta,PO2] = Backward(A,B,O);
gamma = Occupation(alpha,beta,PO1);

xi = zeros(size(A));
abar = zeros(size(A));
T = size(O,2);
N = size(B,1);

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

ex2 = numer ./ denom;
ex2(isnan(ex2)) = 0;

%{
for t = 2:T
    for i = 1:N
        for j = 1:N
            xi((i+1),(j+1)) = (alpha(i,(t-1)) * beta(j,t) * A((i+1),(j+1)) * B(j,O(t))) / PO1;
        end
    end
    abar = xi + abar;
end

for i = 1:N
    abar(1,(i+1)) = gamma(i,1);
end

for i = 1:N
    abar((i+1),T) = gamma(i,T);
end

abar_rowsums = sum(abar,2);
ex1 = abar./abar_rowsums;
ex1(isnan(ex1)) = 0;
%}

