function [xUB, rUB, zUB, time] = getInitialSol (P, k, method, feasTol)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [rUB, xUB, time] = getInitialSol (P, k, method, epsTol)
%
% Author       : Marta Cavaleiro
% Description  : Finds a ball that covers at least k points of P
%                accordingly to the method selected
% Input        : P ~ matrix of the points of P (points on the columns)
%                k ~ number of points to cover (1 <= k <= m)
%                feasTol ~ feasibility tolerance
%                method ~ a number between 1 and 6 representing the method 
%                selected to obtain an initial solution (a number other
%                than the six options results in an infinite initial radius)
%                **Methods:**   
%                1 - Selects a random k-subset of P. Finds the MEB of it
%                2 - Selects a random point from P. Finds the k-1 closest
%                    points to it and finds the MEB of that set
%                3 - Spherical ordering: First, finds the MEB of P. Next, 
%                    picks the k closest points to the center of the ball 
%                    and finds the MEB of that set
%                4 - Random spherical ordering: same as option 3 but at the
%                    beginning instead of finding the MEB of P, it finds the
%                    MEB of a random k-subset of P
%                5 - Spherical peeling: Finds the MEB of P, discards one of 
%                    the points from the boundary, and then finds the MEB of 
%                    the remaining points. This is repeated until k points remain 
%                6 - Random spherical peeling: same as option 5 but at the
%                    beginning instead of finding the MEB of P, it finds the
%                    MEB of a random k-subset of P
%                7 - Combo Spherical Order and Spherical Peeling: picks the
%                best
% Output        :rUB ~ radius
%                xUB ~ center
%                zUB ~ vector that has 1 if the point is cover and 0
%                otherwise
%                time ~ time to get the initial solution
% Last revised : 5 Sept 2019



[n, m] = size(P);
rUB = Inf;
xUB = zeros(n,1);
zUB = zeros(m,1);
global epsTol
epsTol = feasTol;

tic

switch method
    case 1 %random k-subset
        I = randperm(m, k);
        [xUB, rUB] = minBallDualAlg (P(:, I));
 
    case 2 %(k-1)-closest to a point
        i = randi(m, 1);
        dists = pdist2(P',P(:,i)');
        [~, I] = sort(dists);
        [xUB, rUB] = minBallDualAlg (P(:, I(1:k)));
    
    case {3, 4} %spherical ordering and random spherical ordering       
        %initial ball
        if method==4
            I = randperm(m, k);
            xUB = minBallDualAlg (P(:, I));
        else
            xUB = minBallDualAlg (P);
        end
        %spherically order the points of P w.r.t the initial ball
        dists = pdist2(P', xUB');
        [~, I] = sort(dists);
        [xUB, rUB] = minBallDualAlg (P(:, I(1:k)));
        
     case {5, 6} %spherical peeling and random spherical peeling
        
        if method == 5  
            [xUB, rUB, S] = minBallDualAlg (P);
            Q = P;
        else  
            I = randperm(m, k);    
            [xUB, rUB, S] = minBallDualAlg (P(:,I)); 
            %Q is the subset of P covered by the ball:
            distToxUB = -2*P'*xUB + sum(P.^2, 1)';
            aux = (rUB+epsTol)^2 - xUB'*xUB;
            J = 1:m;
            J = J(distToxUB <= aux);
            Q = P(:,J);
        end
  
        while size(Q, 2) > k  %size(Q,2) always at least k
            
            %find a point on the boundary of the ball
            found = 0; i=0;
            while found == 0
                i = i+1;
                for j=1:size(S,2) 
                    if Q(:, i) == S(:,j)
                        found = 1;
                        Q = Q(:,1:size(Q,2)~=i); %remove that point from Q
                    end
                end
            end
            [xUB, rUB, S] = minBallDualAlg (Q);
        end
        
    case 7 %best between spherical orderding and peeling              
        
        %spherical ordering
        xUB_SO = minBallDualAlg (P);        
        dists = pdist2(P', xUB_SO');
        [~, I] = sort(dists);
        [xUB_SO, rUB_SO] = minBallDualAlg (P(:, I(1:k)));
        
        
        %Spherical peeling
        [xUB_SP, rUB_SP, S] = minBallDualAlg (P);
        Q = P;        
        while size(Q, 2) > k  %size(Q,2) always at least k
            
            %find a point on the boundary of the ball
            found = 0; i=0;
            while found == 0
                i = i+1;
                for j=1:size(S,2) 
                    if Q(:, i) == S(:,j)
                        found = 1;
                        Q = Q(:,1:size(Q,2)~=i); %remove that point from Q
                    end
                end
            end
            [xUB_SP, rUB_SP, S] = minBallDualAlg (Q);
        end
        
        rUB = min(rUB_SO, rUB_SP);
        if rUB == rUB_SO
            xUB = xUB_SO;
        else
            xUB = xUB_SP;
        end
end

distToxUB = -2*P'*xUB + sum(P.^2, 1)';
aux = (rUB+epsTol)^2 - xUB'*xUB;
zUB(distToxUB <= aux) = 1;

time = toc;

end