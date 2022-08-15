function [rLB, xLB] = nodeLB_QP (P, Q, k, M, normSqP, normSqQ)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [rLB, xLB] = nodeLB_QP (P, Q, k, M, normSqP, normSqQ)
%
% Author       : Marta Cavaleiro
% Description  : Lower bound for a subtree's best solution calulation (QP)
%                finds a lower bound on the radius of the ball that encloses
%                P and |P|-k of the points in Q by solving:
%                   min r^2
%                   s.t. ||p_i - x||^2 <= r^2,           for p_i in P                    
%                   ||q_j - x||^2 <= r^2 + (1-b_j)*M,    for s_j in Q
%                   sum_j b_j >= k
%                   0 <= b_j <= 1
% Input        : P ~ points covered
%                Q ~ points not covered
%                k ~ number of points to cover
%                M ~ maximum of squared distances between points of P U Q
%                nomrSqP ~ vector with the squared norms of points in P
%                nomrSqQ ~ vector with the squared norms of points in Q 
% Output       : rLB ~ lower bound on the radius found    
% Note         : Requires GUROBI
% Last revised : 22 March 2017


[n, m1] = size(P);
m2 = size(Q, 2);

%BUILD THE MODEL:
Qof = zeros(n+1+m2, n+1+m2);
Qof(1:n, 1:n) = eye(n);
model.Q = sparse(Qof); %Q

model.obj = zeros(n+m2+1, 1); %c
model.obj(n+1) = 1;

A = zeros(m1+m2+1, n+1+m2);
A(1:m1, 1:n) = 2*P';
A(m1+1:m1+m2, 1:n) = 2*Q';
A(1:m1+m2, n+1) = ones(m1+m2, 1);
A(m1+1:m1+m2, n+2:n+1+m2) = -M*eye(m2);
A(m1+m2+1, n+2:n+1+m2) = ones(1, m2);
model.A = sparse(A); %A

model.sense = char(62*ones(m1+m2+1,1)); %>=
if m2 == 0
    model.rhs = [normSqP; normSqQ; k-m1]; %b
else
    model.rhs = [normSqP; normSqQ-M*ones(m2,1); k-m1]; %b
end
model.lb = [-Inf*ones(n+1,1); zeros(m2,1)];
model.ub = [Inf*ones(n+1,1); ones(m2,1)];


%SET PARAMETERS
parameters.method = 1; %dual simplex
parameters.PSDTol = 10^-4;
parameters.outputFlag = 0;
parameters.logToConsole = 0;

%SOLVE
solution = gurobi(model, parameters);

if ~strcmp(solution.status,'OPTIMAL')
    rLB = 0;      
    return
end

rLB = sqrt(solution.objval);
xLB = solution.x(1:n);
% z = solution.x(n+2:n+m+1);
% nodes = solution.nodecount; %Number of branch-and-cut nodes explored
% iter = solution.itercount; %Number of simplex iterations
% time = solution.runtime;
end