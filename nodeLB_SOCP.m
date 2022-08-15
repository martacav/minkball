 function [rLB, xLB] = nodeLB_SOCP(P, Q, k, pairDistsPQ)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [rLB, xLB] = nodeLB_SOCP(P, Q, k, pairDistsPQ)
%
% Author       : Marta Cavaleiro
% Description  : Lower bound for a subtree's best solution calulation (SOCP)
%                finds a lower bound on the radius of the ball that encloses
%                P and |P|-k of the points in Q by solving:
%                   min r
%                   s.t. ||p_i - x|| <= r,                  for p_i in P                    
%                   ||b_j*q_j + (1-b_j)*s_j - x || <= r,    for s_j in Q
%                   sum b_j >= k-|P|
%                   0 <= b_j <= 1
% Input        : P ~ points covered
%                Q ~ points not covered
%                k ~ number of points to cover
% Output       : rLB ~ lower bound on the radius found
% Note         : Requires GUROBI
% Last revised : 22 March 2017

m1 = size(P,2);
[n,m2] = size(Q);

%1.CHOOSING THE POINTS s_j IN THE CONSTRAINTS
if m1==1
    T = P*ones(1,m2);
else
    [~, I] = min(pairDistsPQ);
    T = P(:, I);
end

%BUILD THE MODEL:
model.obj = zeros(n+1+m2+(m1+m2)*n, 1); %c
model.obj(n+1) = 1;

%-Linear constraints (equality and inequality)
A = zeros((m1+m2)*n+1, n+1+m2+(m1+m2)*n);
A(1:end-1, 1:n) = repmat(eye(n), m1+m2, 1);
list = mat2cell(T-Q,n,ones(m2,1));
A(m1*n+1:end-1, n+1+1:n+1+m2) = blkdiag(list{:});
A(1:end-1, n+1+m2+1:end) = eye((m1+m2)*n);
A(end, n+1+1:n+1+m2) = ones(1, m2);
model.A = sparse(A); %A
model.sense = char([61*ones(m1*n+m2*n,1); 62]); %= and the last one is >=
model.rhs = [P(:); T(:); k-m1]; %b 

%-SOCP constraints
aux = n+1+m2;
for i = 1:m1
    model.cones(i).index = [n+1 aux+(i-1)*n+1:aux+i*n];
end
aux = n+1+m2+n*m1;
for j = 1:m2
    model.cones(m1+j).index = [n+1 aux+(j-1)*n+1:aux+j*n];
end

%-Lower and upper bounds
model.lb = [-Inf*ones(n+1,1); zeros(m2,1); -Inf*ones((m1+m2)*n,1)];
model.ub = [Inf*ones(n+1,1); ones(m2,1); Inf*ones((m1+m2)*n,1)];


%SET PARAMETERS
parameters.outputFlag = 0;
parameters.logToConsole = 0;

%SOLVE
solution = gurobi(model, parameters);
rLB = solution.objval;
xLB = solution.x(1:n);

if ~strcmp(solution.status,'OPTIMAL') 
    rLB = 0;    
    xLB = [];
end

end