function xoverKids  = int_crossoverarithmetic(parents,options,GenomeLength,...
    FitnessFcn,unused,thisPopulation)
% This function implements the crossover operation for integer variables.
%
% Taken and adapted by:
% https://www.mathworks.com/matlabcentral/answers/103369-is-it-possible-...
% to-solve-a-mixed-integer-multi-objective-optimization-problem-using-...
% global-optimizati#answer_112709
%
% the number of integer variables is given by the number of columns of 
% the range matrix
range = options.PopInitRange;
[~,integer_variables]=size(range); 
IntCon=1:1:integer_variables;

% How many children to produce?
nKids = length(parents)/2;
% Allocate space for the kids
xoverKids = zeros(nKids,GenomeLength);
% To move through the parents twice as fast as the kids are
% being produced, a separate index for the parents is needed
index = 1;
% for each kid...
for i=1:nKids
    % get parents
    r1 = parents(index);
    index = index + 1;
    r2 = parents(index);
    index = index + 1;
    % Children are arithmetic mean of two parents
    % ROUND will guarantee that they are integer.
    alpha = rand;
    xoverKids(i,:) = alpha*thisPopulation(r1,:) + ...
        (1-alpha)*thisPopulation(r2,:);
end

x = rand;
if x>=0.5
    xoverKids(:, IntCon) = floor(xoverKids(:, IntCon));
else
    xoverKids(:, IntCon) = ceil(xoverKids(:, IntCon));
end
xoverKids = checkboundsIntGA(xoverKids, range);
end