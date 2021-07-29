clearvars;
clc;
%% hot side - input constants
hot_side.m_dot=0.1; %[kg/s]
hot_side.cp=4186; %[J/Kg*K]
hot_side.mu=8.9*10^-4; %[Pa*s]
hot_side.rho=998; %[kg/m^3]
hot_side.k_fluid=0.6; %[W/m*K]
hot_side.r_fouling=0.7*10^-5; % fouling factor (constant)
%% cold side - input constants
cold_side.m_dot=0.20; %[kg/s]
cold_side.cp=4186; %[J/Kg*K]
cold_side.mu=8.9*10^-4; %[Pa*s]
cold_side.rho=998; %[kg/m^3]
cold_side.k_fluid=0.6; %[W/m*K]
cold_side.r_fouling=0.7*10^-5; % fouling factor (constant)
%% heat exchanger stainless steel properties - input constants
PHE_properties.flow_direction='Counter Flow';
PHE_properties.k_plate=17; %[W/m*K]
PHE_properties.roughness=0.001*1e-5; %[m] % plate absolute roughness
%% define the discrete ranges for the input varaibles
nvars = 6;   % Number of decision variables
% each cell contains the discrete values that can be passed to the GA
% 'range' is a cell array. Each cell refers to the design variables. In
% each cell, an array of discrete values is stored.
range=cell(1, nvars);
range{1} = [0.05:0.01:0.5]; % w -> heat exchanger plate width [m]
range{2} = [0.10:0.01:1];  % L -> heat exchanger plate length [m]
range{3} = [1.11:0.01:1.25]; % Fi -> corrugation factor (dimensionless)
range{4} = [1.5:0.5:5].*10^-3;  % b -> half distance in [mm] between 2 plates
range{5} = [10:1:150];   % n_plates -> # of plates
range{6} = [0.2:0.1:5].*10^-3;  % t -> plate thickness

% define lower and upper bounds for the mapped variables.
lb = ones(1, nvars);
ub=cellfun(@numel, range);
Bound = [lb; ub];
%% pass custom functions to enable mixed-integer optimization with gamultiobj
fitnessFunction = @(x)PHE_obj(x, range, hot_side, cold_side, ...
    PHE_properties);  % Function handle to the fitness function
%% set up optimization customized options
populationSize = min(max(10*nvars,40),100);
stallGenLimit = 100;
generations = 500; % max number of iterations can be adjusted if required
FunctionTolerance=1e-4; % this is a reasonable value for this problems
options = optimoptions('gamultiobj','PopulationSize',populationSize,...
    'CreationFcn', @int_pop,...
    'MutationFcn', @int_mutation,...
    'CrossoverFcn',@int_crossoverarithmetic,...
     'StallGenLimit', stallGenLimit,...
    'Generations', generations,...
    'PopulationSize',populationSize, 'FunctionTolerance', FunctionTolerance,...
    'PopInitRange', Bound, 'UseVectorized',true);
%% define problem constraints
% min and max values for the fluid velocity through the channels
velocity_boundaries=[0.1, 1];

% effectiveness boundary values
efficiency_boundaries=[0.10, 0.99];

% max pressure feasable drops for both cold and hot side
dp_max_hot_side=0.1*1.01*10^5; %[Pa]
dp_max_cold_side=0.1*1.01*10^5;
max_pressure_drops_constraint=[dp_max_hot_side, dp_max_cold_side];

% define the constraint function handle
constraintFunction=@(x) PHE_nlinconstraint(x, range, hot_side, ... 
    cold_side, PHE_properties, velocity_boundaries, ...
    max_pressure_drops_constraint, efficiency_boundaries);
%% call the multi-objective solver
[xbest, ybest, exitflag, output, population] = gamultiobj(fitnessFunction,...
     nvars, [], [], [], [], lb, ub, constraintFunction, options);
 %% post-process the results
 if exitflag >0
     [config,~]=size(xbest);
     
     % assign an index array
     idx=linspace(1,config,config)';
     
     % convert the mapped variables into the "real world" values
     for k=1:config
         xbest_mapped(k,:)=map_variables(xbest(k,:), range);
     end
     
     % recall the solver to get all inputs and outputs in a unique matrix
     [epsilon, delta_p_hot, delta_p_cold, v_hot, v_cold, h_hot, ...
         h_cold, U, A, NTU] = PHE_solve(xbest, range, hot_side, cold_side, ...
         PHE_properties);
     complete_matrix=[xbest_mapped, epsilon, delta_p_hot, delta_p_cold, ...
         v_hot, v_cold, h_hot, h_cold, U, A, NTU];
     
     % convert the obtained results in a table
     results=array2table(complete_matrix);
     results.Properties.VariableNames={'width [m]','length [m]','Fi', ...
         'b [m]', 'n_plates', 't [m]','effectiveness','delta p hot [Pa]'...
         'delta p cold [Pa]','v_hot [m/s]','v_cold [m/s]','h_hot [W/m^2*K]',...
         'h_cold [W/m^2*K]', 'U [W/m^2*K]','A_total [m^2]','NTU'};
     
     % correct the output sign (revert negative objective values)
     min_max=[1, -1, 1, 1, 1];
     idx=linspace(1,config,config)';
     obj=[idx,ybest].*min_max;
     
     % rank the configurations according to the TOPSIS method
     % Note that the first '0' of the custom weights, inside the TOPSIS
     % function in order to discard the 'ranking' array, which only acts
     % as a design identificator.
     %
     % A possible choice for the pre-defined weights is:
     % effectiveness -> 0.5
     % pressure drops (both) -> 0.1
     % total exchange area -> 0.3
     ranked_obj=topsis(obj, [0, 0.50, 0.10, 0.10, 0.30], -min_max);
     for k=1:height(results)
         row=ranked_obj(k,1);
         ranked_results(k,:)=results(row,:);
     end
     
     % plot a parallel plot for the ranked desings
     ranked_results=addvars(ranked_results, idx, 'Before','width [m]','NewVariableNames','ranking');
     PP=parallelplot(ranked_results,'GroupVariable','ranking');
     PP.LegendVisible=false;
     
     % diplay number of iterations
     fprintf('\n algorithm converged after %d/%d iterations.', output.generations, options.MaxGenerations);
 else
     warning("the optimization algorithm did not converge to a feasible solution.");
 end
