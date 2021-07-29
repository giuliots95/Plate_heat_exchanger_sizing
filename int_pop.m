function Population = int_pop(GenomeLength, ~, options)
% This function creates an initial population satisfying bounds and
% integer constraints.
% 
% Inputs:
%           - GenomeLength: the total number of optimization variables
%           - options: the optimization options
%
% Pay attention to the empty ~ sign between the 2 input arguments
% The identification of the integer variables is done thanks to the options
% struct.
% 
% Output: 
%          - The initial population to begin optimization. This population
%          is constrained within the given variable bounds.
%
% Taken and adapted by:
% https://www.mathworks.com/matlabcentral/answers/103369-is-it-possible-...
% to-solve-a-mixed-integer-multi-objective-optimization-problem-using-...
% global-optimizati#answer_112709
%
totalPopulation = sum(options.PopulationSize);
range = options.PopInitRange; % lookup the upper and lower integer values 
                              % for the design variables
% the number of integer variables is given by the number of columns of 
% the range matrix
[~,integer_variables]=size(range); 
IntCon=1:1:integer_variables;
%
lower = range(1,:);
span =  range(2,:) - lower;

% buid the initial population applying random sampling 
Population = repmat(lower,totalPopulation,1 )+  ...
    repmat(span,totalPopulation,1) .* rand(totalPopulation, GenomeLength);

% round the non-integer values
x = rand;
if x>=0.5
    Population(:,IntCon) = floor(Population(:, IntCon));
else
    Population(:,IntCon) = ceil(Population(:, IntCon));
end

% check that the initial population is constrained within the given bounds
Population = checkboundsIntGA(Population, range);
end