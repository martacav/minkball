function [x_new, flag] = lineSearch (x, S, p)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [x_new, flag] = lineSearch (x, S, p)
%
% Author       : Marta Cavaleiro
% Description  : Finds the direction d and performs the line search: computes 
%                the stepsize alpha that minimizes x + alpha*d, following the
%                the algorithm in Dearing, P., & Zeck, C. R. "A dual algorithm 
%                for the minimum covering ball problem in ℝn", Operations Research 
%                Letters, 37(3), 171–175.
% Input        : x ~ current solution
%                S ~ n x r matrix of r affinely independent points in R^n
%                p ~ point in R^n s.t. {S, p} is affinely independent
% Output       : x_new ~ new solution
%                flag ~ flag = 0 if x+alpha*d intersects the bisectors related 
%                       to p first; OR flag = i if x+alpha*d intersects the 
%                       opposite facet to point i
% Last revised : September 2016

global epsTol;
[n, r] = size(S);

%0. Finds the direction d to do the line search
[Q, R] = qr(S - p*ones(1,r));
A = [Q(:,r+1:n), S(:,1:r-1) - S(:,r)*ones(1,r-1), p - S(:,r)]';
b = [zeros(n-1,1); 1];
d = A\b;

%1. Intersection of x+alpha*d and the bisectors related to p:
alphas = zeros(1,r+1);
alphas(1) = ((S(:,1)-p)'*(1/2*(p+S(:,1))-x)) / ((S(:,1)-p)'*d);

%2. Intersection of x+alpha*d with the facets:
for i = r:-1:1
    
     if i == r
         Q2 = Q;
         R2 = R(:, 1:r-1);
     else 
        v = zeros(r-1,1);
        v(i) = 1;
        [Q2, R2] = qrupdate(Q2,R2,S(:,i+1)-S(:,i),v);
    end                

    aux = d'*Q2(:, r:n); 
    k = find(abs(aux) > epsTol, 1);
    if isempty(k)
        alphas(i+1) = Inf;   
    else
        alphas(i+1) = ((p-x)'*Q2(:,k+r-1))/aux(k);
    end
end

alphas(alphas < 0) = Inf;
[alpha, flag] = min(alphas);
flag = flag-1;
x_new = x+alpha*d;
end