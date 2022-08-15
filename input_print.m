function input_print (I)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function input_print (I)
%
% Author       : Marta Cavaleiro
% Description  : Prints the input information
% Input        : I ~ input struct
% Last revised : 18 June 2021


fprintf('==================================================\n');
fprintf(' INITIAL OPTIONS / CONDITIONS\n');
fprintf('\n');
fprintf('  tree design option...................: %d\n', I.treeDesign);
fprintf('  lower bound on a node leaves option..: %d\n', I.nodeLB);
fprintf('  minimum tree adopted?................: %d\n', I.minTree);
fprintf('  maximum time.........................: %d\n', I.maxTime);
fprintf('  feasibility tolerance................: %d\n', I.feasTol);
fprintf('  upper bound on the radius............: %.4d\n', I.initr);
fprintf('==================================================\n');

end