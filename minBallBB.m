function [x, z, S, iter, expc] = minBallBB (P1, P2, S, x, z, bestr, normSqP1, normSqP2, pairDists)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [x, z, S, iter, expc] = minBallBB (P1, P2, S, x, z, bestr, normSqP1, normSqP2, pairDists)  
%
% Author       : Marta Cavaleiro
% Description  : Starting from the minimum enclosing ball of P1, it finds 
%                the minimum ball that encloses points in P1 and P2, using
%                the algorithm in Dearing, P., & Zeck, C. R. "A dual algorithm 
% %              for the minimum covering ball problem in ℝn", Operations Research 
% %              Letters, 37(3), 171–175.
% Input        : P1 ~ points that are covered by the initial ball
%                P2 ~ points that are not covered by the initial ball
%                S ~ points on the support set of the initial ball
%                x ~ center of the initial ball
%                z ~ radius of the initial ball
%                bestr ~ best radius found so far
%                normSqP1 ~ squared norms of the points in P1
%                normSqP2 ~ squared norms of the points in P2
%                pairDists ~ pairwise distances between points P1 and P2
% Output       : x ~ center of the enclosing ball of P1 and P2
%                z ~ radius of the enclosing ball of P1 and P2
%                S ~ points on the support set of the enclosing ball of P1 and P2
%                iter ~ number of dual iterations
%                expc ~ if this node will be counted as an explored node or not
% Last revised : 16 February 2019


global epsTol
iter = 0;
isOpt = 0;
expc = 0;

%------We're at LEVEL 1:
if isempty(P1) 
    if size(P2,2)==1 
        x = P2;
        z = 0;
        S = P2;
        expc = 1;
        iter = 1;
        return
    else  
        S = [P2(:,1), P2(:,2)];
        x = (S(:,1)+S(:,2))/2;
        z = 1/2*sqrt((S(:,1)-S(:,2))'*(S(:,1)-S(:,2)));
        expc = 1;
    end
end

%------We're at LEVEL >= 2
%FEASIBILITY CHECK and CHOOSE POINT TO ENTER: the "more infeasible" one
distances = - 2*P2'*x + normSqP2; 
xx = x'*x;
[dist, ip] = max(distances);
if dist + xx < (z + epsTol)^2
    return
end
p = P2(:, ip);

%LOWER BOUND ON THE RADIUS OF A NODE: check if node can be killed:
if bestr <= ( sqrt(xx + dist) + z )/2
      lb = sqrt( (xx+dist) + z^2 )/2;      
      if bestr <= lb
          z = lb;
          expc = 0;
          return
      else
        lb = max(pairDists(:, ip))/2;        
        if bestr <= lb
            z = lb;
            expc = 0;
            return
        end
     end
end

%------If we're at LEVEL 2: no need to run the algorithm, solution is middle point
if size(P1,2)==1 && size(P2,2)==1
    S = [P1, P2];
    x = (S(:,1)+S(:,2))/2;
    z = 1/2*sqrt((S(:,1)-S(:,2))'*(S(:,1)-S(:,2)));
    expc = 1;
    iter = 1;
    return
end


%------We're at LEVEL >=3:
expc = 1;
P = [P1, P2];
normSqP = [normSqP1; normSqP2];

while isOpt == 0
    iter = iter+1;
    
    S = updateS(S, p, x);
   
    %SOLVE MEB(S)
    flag = 1;
    while flag ~= 0
        [x, flag] = lineSearch (x, S, p); 
        z = norm(x-S(:,1));
        
        if z > bestr            
            return
        end
        
        if flag == 0
            break
        end
        S(:,flag)=[];
    end
    S = [S, p];
    
    %OPTIMALITY CHECK and CHOOSE POINT TO ENTER: the "more infeasible" one
    distances = - 2*P'*x + normSqP; 
    [dist, ip] = max(distances);
    
    if dist + x'*x < (z + epsTol)^2
        break;
    end    
    p = P(:, ip);
        
end

return
end