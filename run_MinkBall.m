function [rOpt, xOpt] = run_MinkBall(P, k, outputfile, options)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author       : Marta Cavaleiro
% Last revised : 18 June 2021
% Description  : Runs the minimum k ball algorithm
%                Please select the options below
% Input        : P ~ matrix of the points of P (points on the columns)
%                k ~ number of points to cover (1 <= k <= m)
%                outputfile ~ name of the file to store algorithm's data
%                options ~ struct with the algorithm's options:
%
%-options.tree ~ CHOOSE A POINT-NODE ASSIGNMENT OPTION
%1 - lexicographic order; 
%2 - the points to be assigned to the child nodes of a node are farthest points 
%    from the node's ball center, in descending order by distance;
%
%-options.minTree ~ USE MINIMUM SOLUTION  TREE
% 1 - yes; 0 - no
%
%-options.nodeLB ~ CHOOSE A METHOD TO OBTAIN A LOWER BOUND ON THE SUBTREE'S BEST SOLUTION
% 0 - none; 
% 1 - SOCP relaxation ****requires GUROBI*****; 
% 2 - QP relaxation ****requires GUROBI*****; 
% 
%-options.maxTime ~ MAXIMUM RUNNING TIME
%
%-options.feasTol ~ FEASIBILITY TOLERANCE
%Note: A point is considered enclosed by B(c,r) if ||p-c||<=r+epsTol
%-options.initSol ~ CHOOSE A METHOD TO OBTAIN AN INITIAL SOLUTION (1 to 6):
% 1 - MEB of a random k-subset of P;
% 2 - MEB of the k closest points to a random point (inclusive) from P;
% 3 - Spherical ordering;
% 4 - Random spherical ordering;
% 5 - Spherical peeling;
% 6 - Random spherical peeling;
% other - results in a initial solution with a radius +Inf.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin == 0 %no input arguments provided 
        m = 100; d = 3;
        P = randn(d, m); %generates randomly a normal set of 100 3-dimensional points
        k = randi([2,m-1]);  %k is also random
        outputfile = 'output_rand_instance.mat';
end
if nargin == 0 || nargin == 3 %struct options not provided
        options.tree = 2;
        options.minTree = 1;
        options.nodeLB = 0; 
        options.maxTime = Inf;
        options.feasTol = 1e-8;
        options.initSol = 3;  
end


%=========================================================%
%              Do not edit below this point               %
%=========================================================%
sizeP = size(P);
fprintf('==================================================\n');
fprintf(' PROBLEM PROPERTIES\n');
fprintf('  dimension...................: %d\n', sizeP(1));
fprintf('  number of points............: %d\n', sizeP(2));
fprintf('  k ..........................: %d\n', k);
fprintf('==================================================\n');

[initx, initr] = getInitialSol (P, k, options.initSol, options.feasTol);
I = input_new(options.tree, options.nodeLB, options.minTree, options.maxTime, options.feasTol, initx, initr);
input_print(I);

[rOpt, xOpt, O] = minkBall(P, k, I); 

output_print(O);

save (outputfile);
end