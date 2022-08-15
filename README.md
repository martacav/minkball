# minkball
Branch-and-bound method for the minimum k-enclosing ball problem

## Introduction
The minimum k-enclosing ball problem seeks the ball with smallest radius that contains at least k of m given points. This problem is NP-hard. This is the Matlab code of a branch-and-bound algorithm on the tree of the subsets of k points to solve this problem. Our method is able to solve the problem exactly in a short amount of time for small and medium sized datasets.
For further information on the algorithm, please consult the respective paper (see Reference / Citation)

## Running the code
To run the code, call function `run_MinkBall`:  `[rOpt, xOpt] = run_MinkBall(P, k, outputfile, options)`

### Input of run_MinkBall
- P ~ matrix containing the data points - each column corresponds to a point (use genRandPoints.m to generate random datasets with specific features);
- k ~ number of points to enclose (1 <= k <= m) by the ball;
- outputfile ~ name of the file to store output info (.mat file);
- options ~ struct containing the options to apply to the algorithm. For a description of the options, see `run_MinkBall.m`.

Notes: 
- If no inputs provided, run_MinkBall will generate a randomly normal dataset of 100 3-dimensional points; k is also random; the default options are used;
- If options is not provided, then the default options will be used.

### Output of run_MinkBall
- rOPT ~ radius of the optimal k-enclosing ball;
- xOPT ~ center of the optimal k-enclosing ball.

## Reference / Citation:
[Cavaleiro, M., Alizadeh, F. A Branch-and-Bound algorithm for the minimum radius k-enclosing ball problem. Operations Research Letters 50(3), 274-280 (2022)](https://www.sciencedirect.com/science/article/abs/pii/S0167637722000323)
