# Plate heat exchanger sizing: an application of multi-objective genetic algorithm for thermo-hydraulic optimization 
This repository contains the MATLAB code for the thermo-hydraulic optimization of a plate heat exchanger. It is packaged as project with a main program file, called "optimize_plate_heat_exchanger.m", calling many other utility functions (grouped in this repository as well).
PHEs are widely used components for industrial applications. They are used to exchange heat from a hot fluid to a colder fluid, with a compact shape. A PHE consists of a stack of thin metal plates with portholes for the fluid passage, mounted on a frame. A bordering gasket is in the middle of 2 consecutive plates, to seal the fluid channels. Hot and cold fluids flow in adjacent channels without mixing.

## PHE patterns and types
PHEs can be arranged in many different ways, determining the fluid flow directions, and can be equipped with corrugated thin plates to improve the heat exchange between the channels.
In this study, I have considered the so called 'chevron' type, which has a herringbone surface pattern, with an equal number of plates for both hot and cold fluids.
For a matter of simplicity, the fluid flow has been considered to be counter-flow. 

## Design variables 
Following dimensions have been considered as design variables:
- plate width [m]
- plate length [m]
- plate thickness [m]
- enlargement factor [-]
- plate spacing [m]
- overall number of plates

## Objectives
This study deals with the thermal and hydraulic computational problem of a plate heat exchanger (PHE), used to exchange heat flow from 2 liquid, single-phased fluids. 
Objective functions are:
- pressure drops [Pa] on the hot and cold sides
- PHE effectiveness
- global PHE exchange area

Pressure drop is related to hydraulic performance and operational cost, the effectiveness indicates the thermal efficiency of the component, while the overall exchange area is related to the component size and cost.

The user can customize the fluid properties on both sides, and upper/lower bounds of all variables.

## Constraints
There are some inequality constraints passed to the solver:
- max pressure drop allowed for both cold and hot side
- upper and lower thresholds for the PHE effectiveness

## Problem statement
The problem of choosing the best set of geometric dimensions for a PHE can be formalized as a:
- multi-objective
- bounded variable
- discrete (or 'integer') variable type
- constrained
- non-linear 

optimization task.

### Multi-objective
There are at least 2 or 3 competitive objectives to be optimized. The desired PHE should have high effectiveness (heat exchanged in an efficient way) with low pressure drops. High pressure drops will affect operational cost, due to the bigger amount of energy demanded by the pump to maintain the circulation. Finally, the PHE should be as compact as possible, to reduce its cost. Without going into too deeper economic details, one can assume that the cost is directly dependent of its size. For our purpose, the overall heat exchange area is a good indicator of the PHE 'useful' size.
These objectives are concurrent, which means that if one is maximized, the other one is supposed to be penalized. 
There is always a trade-off between effectiveness, pressure drop and overall heat exchange size.

### Bounded variables
Geometric dimensions aren't arbitrary but should have upper and lower bounds. For example, establishing an upper bound for the PHE length should be necessary, due to transport reasons or installation requirements.

### Discrete variables type
PHE manufacturing and tolerances limit the design variables to take value in a discrete range, rather than in a continuous range.

### Constraints
Design solutions should satisfy some constraints on the max allowed pressure drop and e.g. max/min allowed effectiveness.

### Non-linearity
The problem is highly non-linear, meaning that both objectives and inequality constraints are non-linear functions of the design variables.

## Methodology
In this study, a customized integer-variable version of the popular NSGAII (non dominated sorting genetic algorithm) is applied, using its multi-objective formulation.
The MATLAB impementation of the multi-objective (MO) genetic algorithm relies on the 'gamultiobj' function, which natively does not handle discrete design variables. To overcome this limitation, I coded 2 functions that map the variables from float to int, thus influencing both mutation and crossover operations.

The solution of the multi-objectuive optimization problem leads to an approximation of the 3-dimensional Pareto front with respect to the defined objectives. The Pareto front is a set of non-domianted, feasible solutions.

### Multi criteria decision making
To rank the solutions set according to the user preferences ans to select the 'most desirable' alternative, a multi criteria decision making (MCDM) approach is applied.
In details, the TOPSIS method with user-defined objectives weights is used to rank the solutions.

## References
[1] R.K. Shah, D.P. Sekulic, Fundamentals of heat exchanger design, John Wiley & Sons, Inc., USA, 2003, http://dx.doi.org/10.1007/BF00740254.

[2] Fábio A.S. Mota, E.P. Carvalho, Mauro A.S.S. Ravagnani, Modeling and Design of Plate Heat Exchanger, Chapter 7, 165-200, intechopen, 
DOI: 10.5772/60885.

[3] Muhammad Imran, Nugroho Agung Pambudib, Muhammad Farooq, Thermal and hydraulic optimization of plate heat exchanger using multi objective
genetic algorithm, Case Studies in Thermal Engineering, 10, (2017) 570-578 http://dx.doi.org/10.1016/j.csite.2017.10.003

[4] Muhammad Imran, Muhammad Usman, Byung-Sik Park, Hyouck-Ju Kim, Dong-Hyun Lee, Multi-objective optimization of evaporator of organic Rankine cycle (ORC) for low temperature geothermal heat source, Applied Thermal Engineering 80 (2015) 1-9.

[5] Jorge A.W. Gut, Jose M. Pinto, Optimal configuration design for plate heat exchangers, International Journal of Heat and Mass Transfer 47 (2004) 4833–4848, doi:10.1016/j.ijheatmasstransfer.2004.06.002

[6] R. L. Pradhan, Dheepa Ravikumar1, D. L. Pradhan, Review of Nusselt Number Correlation for Single Phase Fluid Flow through a Plate Heat Exchanger to Develop C# Code Application Software, IOSR Journal of Mechanical and Civil Engineering (IOSR-JMCE), ISSN (e): 2278-1684, ISSN (p): 2320–334X, PP: 01-08.

[7] T.S. Khan, M.S. Khan, Ming-C. Chyu, Z.H. Ayub, Experimental investigation of single phase convective heat transfer coefficient in a corrugated plate heat exchanger for multiple plate configurations, Applied Thermal Engineering 30 (2010) 1058–1065
