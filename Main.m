% Speech Recognition
% _EEEM030 Assignment 2_

% Function List:

% Forward.m
% Backward.m
% Occupation.m
% Transition.m
% W.m
% -------------------------------------------------------------------------

% Main.m
close all; clear all ;clc;

A = [ 0 0.40 0.25 0.35 0 ...
    ; 0 0.80 0.05 0.05 0.1 ...
    ; 0 0.15 0.70 0.05 0.1 ... 
    ; 0 0.05 0.10 0.75 0.1 ...
    ; 0 0 0 0 0 ];
% -------------------------------------------------------------------------

B = [ 0.30 0.20 0.25 0.10 0.05 0.05 0.00 0.05 ...
    ; 0.00 0.00 0.05 0.05 0.05 0.20 0.30 0.35 ...
    ; 0.00 0.05 0.05 0.20 0.35 0.25 0.05 0.05 ];
% -------------------------------------------------------------------------

O1 = [ 6 4 2 1 3 ];
O2 = [ 8 7 6 8 7 3 6 3 ];
O3 = [ 5 4 6 7 ];
O4 = [ 5 7 5 5 8 8 6 ];
O5 = [ 3 2 2 2 2 1 8 7 7 3 ];
Observations = {O1 O2 O3 O4 O5};
% -------------------------------------------------------------------------

NB1 = [ 3 3 1 1 1 ];
NB2 = [ 2 2 3 2 2 1 3 1 ];
NB3 = [ 3 3 3 2 ];
NB4 = [ 3 2 3 3 2 2 3 ];
NB5 = [ 1 1 1 1 1 1 2 2 2 1 ];
Naive_Bayes = {NB1 NB2 NB3 NB4 NB5};
% -------------------------------------------------------------------------

A_vit = [ 0 0.40 0.20 0.40 0 ...
        ; 0 0.73 0.07 0.00 0.20 ...
        ; 0 0.18 0.73 0.00 0.09 ...
        ; 0 0.00 0.13 0.75 0.13 ...
        ; 0 0 0 0 0 ];
% -------------------------------------------------------------------------

B_vit = [ 0.13 0.33 0.33 0.07 0.00 0.13 0.00 0.00 ...
        ; 0.00 0.00 0.00 0.00 0.00 0.18 0.36 0.45 ...
        ; 0.00 0.00 0.00 0.13 0.50 0.13 0.25 0.00 ];
% -------------------------------------------------------------------------

% Evaluate alpha, beta, gamma, xi and estimated A and B values for set of observations 
for i = 1:(size(Observations,2))
    O = Observations{i};
    [alpha,PO1] = Forward(A,B,O);
    alpha_matrix(i) = {alpha};
    [beta,PO2] = Backward(A,B,O);
    beta_matrix(i) = {beta};
    PO1_matrix(i) = {PO1};
    PO2_matrix(i) = {PO2};
    gamma = Occupation(alpha,beta,PO1);
    gamma_matrix(i) = {gamma};
    [A_underscore(:,:,i),A_bar(:,:,i),B_underscore(:,:,i),B_bar(:,:,i),xi,entry,exit] = Transition(alpha,beta,PO1,A,B,O,gamma);
    xi_matrix(i) = {xi};
    entry_matrix(i) = {entry};
    exit_matrix(i) = {exit};
end

% Evaluate numerator and denominator for estimated A & B
 A_numerator = zeros(size(A));
 A_denominator = zeros(size(A_bar(:,:,1)));
 B_numerator = zeros(size(B));
 B_denominator = zeros(size(B_bar(:,:,1)));

for i = 1:(size(Observations,2))
    A_numerator = A_underscore(:,:,i) + A_numerator;
    A_denominator = A_bar(:,:,i) + A_denominator;
    B_numerator = B_underscore(:,:,i) + B_numerator;
    B_denominator = B_bar(:,:,i) + B_denominator;
end

% Evaluate A_BW and B_BW
A_BW = A_numerator./A_denominator;
A_BW(isnan(A_BW)) = 0;
B_BW = B_numerator./B_denominator;
B_BW(isnan(B_BW)) = 0;
% -------------------------------------------------------------------------

%Plots
%{
figure(1)
hold on
[M,I] = max(gamma_matrix{5});
y = [I;NB5];
x = 1:1:(size(O5,2));
b = bar(x,y);
b(1).FaceColor = [0 0.4470 0.7410];
b(2).FaceColor = [0.6350 0.0780 0.1840];
t = title('Occupation Likelihood vs Naive Bayes (O5)');
ax = gca;
ax.TitleHorizontalAlignment = 'left';
xlabel('Observation(frame)')
ylabel('State(n)')
lgd = legend('Occupation Likelihood','Naive Bayes');
legend('boxoff','Location','northwest');
hold off

figure(2)
hold on
t = tiledlayout(2,1);
xlabel(t,'Samples(n)')
ylabel(t,'Probability')

ax1 = nexttile;
bar(ax1,B_vit','stacked')
t1 = title(ax1,'Viterbi Output Probability (B^{Vit})');
ax1.TitleHorizontalAlignment = 'left';


ax2 = nexttile;
bar(ax2,B_BW','stacked')
t2 = title(ax2,'Re-estimated Output Probability (B^{BW})');
ax2.TitleHorizontalAlignment = 'left';
lgd = legend('State 1','State 2','State 3');
legend('boxoff');
hold off
%}