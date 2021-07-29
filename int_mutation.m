function mutationChildren = int_mutation(parents, options, GenomeLength, ...
    ~, state, ~, ~)
% Function that creates the mutated children using the Gaussian
% distribution. 
%
% Taken and adapted by:
% https://www.mathworks.com/matlabcentral/answers/103369-is-it-possible-...
% to-solve-a-mixed-integer-multi-objective-optimization-problem-using-...
% global-optimizati#answer_112709
%
% lookup the range for integer variables
range = options.PopInitRange;
[~,integer_variables]=size(range); 
IntCon=1:1:integer_variables;
%
% buid the mutated population 
shrink = 0.01; 
scale = 1;
scale = scale - shrink * scale * state.Generation/options.Generations;
lower = range(1,:);
upper = range(2,:);
scale = scale * (upper - lower);
mutationPop =  length(parents);

mutationChildren =  repmat(lower,mutationPop,1) +  ...
    repmat(scale, mutationPop,1) .* rand(mutationPop, GenomeLength);

x = rand;
if x>=0.5
    mutationChildren(:, IntCon) = floor(mutationChildren(:,IntCon));
else
    mutationChildren(:, IntCon) = ceil(mutationChildren(:,IntCon));
end

mutationChildren = checkboundsIntGA(mutationChildren, range);
end