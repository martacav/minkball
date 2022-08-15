function S = updateS (S, p, x)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function S = updateS (S, p, x)
%
% Author       : Marta Cavaleiro
% Description  : Updates set S, such that the S is affinely independent following 
%                the algorithm in Dearing, P., & Zeck, C. R. "A dual algorithm 
%                for the minimum covering ball problem in ℝn", Operations Research 
%                Letters, 37(3), 171–175.
% Input        : x ~ current solution
%                S ~ n x r matrix of r affinely independent points
%                p ~ point to enter S
% Output       : S ~ matrix of r or r-1 points in R^n such that: if {S, p} 
%                is affinely independent it returns S, otherwise removes 
%                a point q from S such that {S,p}\q is affinely independent
% Last revised : October 2016


[n,r] = size(S);
A = [ones(1,r); S - x*ones(1,r)];
b = -[1; p-x];

if rank ([A,b]) == r   

    c = [1; zeros(n,1)];
    Z = A \ [b, c];
    minratio = Inf; ii = 0;
    TT = -Z(:,2)./Z(:,1);
       
    for i = 1:r
        if Z(i,1)<0 && TT(i) < minratio
            ii = i; 
            minratio = TT(i);
        end
    end
    S(:,ii) = [];  
end
end