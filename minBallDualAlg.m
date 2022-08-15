function [x_opt, r_opt, S_opt, iter, time] = minBallDualAlg (P)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [x_opt, r_opt, S_opt, iter, time] = minBallDualAlg (P)
%
% Author       : Marta Cavaleiro
% Description  : Finds the minimum ball that encloses the points in P
%                following the Dearing and Zeck algorithm:
%                Dearing, P., & Zeck, C. R. "A dual algorithm 
%                for the minimum covering ball problem in ℝn", Operations Research 
%                Letters, 37(3), 171–175.
% Input        : P ~ matrix with the points in its columns
% Output       : x_opt ~ center of the minimum ball
%                r_opt ~ radius of the minimum ball
%                S_opt ~ support set of the minimum ball
%                iter ~ number of iterations
%                time ~ CPU time
% Last revised : October 2016

tic

global epsTol
epsTol = 10^-8;
m = size(P, 2);

if m==1
    x_opt = P;
    r_opt = 0;
    S_opt = P;
    iter = 0;
    time = 0;
    return
end

S = [P(:,1), P(:,2)];
x = (S(:,1)+S(:,2))/2;
z = 1/2*sqrt((S(:,1)-S(:,2))'*(S(:,1)-S(:,2)));
iter = 0;
isOpt = 0;
normsOfPsq = sum(P.^2, 1);

while isOpt == 0
    iter = iter+1;

    distances = - 2*x'*P + normsOfPsq;
    [maxdist, ip] = max(distances);
    if sqrt(maxdist + x'*x) < z + epsTol       
        break;
    end
    
    p = P(:, ip);
    S = updateS(S, p, x);
    
    flag = 1;
    while flag ~= 0
        [x, flag] = lineSearch (x, S, p);
        
        if flag == 0
            z = norm(x-p);
            break
        end
        S(:,flag)=[];
    end    
    S = [S, p];
end

x_opt = x;
r_opt = z;
S_opt = S;
time = toc;

end