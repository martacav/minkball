function output_print (O)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function output_print (O)
%
% Author       : Marta Cavaleiro
% Description  : Prints the output statistics
% Input        : O ~ output struct
% Last revised : 24 June 2016

fprintf('==================================================\n');
fprintf(' ALGORITHM STATISTICS\n');
fprintf('\n  Status: %s\n', O.status);
if ~strcmp (O.status, 'Optimal')
    fprintf('       upper bound on radius: %.5d\n', O.rUB);  
end

fprintf('\n');
fprintf('  # of branched nodes /iterations.......: %d\n', O.BN);
fprintf('  # of explored nodes...................: %d\n', O.EN);
fprintf('  # of min ball dual iterations.........: %d\n', O.DA);
fprintf('  # of expl. nodes when opt. found......: %d\n', O.optEN);
fprintf('  # of lower bound calculations.........: %d\n', O.LBCalls);
fprintf('  # of CPU seconds......................: %.5f\n', O.time);
fprintf('==================================================\n');

end