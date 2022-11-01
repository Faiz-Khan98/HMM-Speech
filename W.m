% W.m
% Function to check if current observation matches k
function out = W(k,t,O)

if k == O(t)
    out = 1;
else
    out = 0;
end
end