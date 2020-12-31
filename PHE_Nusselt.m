function  Nu = PHE_Nusselt(Re, Pr)
% This function calculates the Nusselt number for a plate heat exchanger
% (PHE) given the Reynolds number and the Prandtl number.
%   
% The Nusselt number (Nu) is the ratio of convective to conductive heat
% transfer at a boundary in a fluid. Convection includes both advection 
% (fluid motion) and heat diffusion (conduction). 
%
% Knowing the Nu, it is possible to compute the advective coefficient h,
% being Nu = h * L /k
%    where h is the advective coefficient [W/m^2*K]
%          L is the characteristic dimension of the problem e.g. the
%          hydraulic diameter
%          k is the conductivity of the fluid [W/m*K]
%
% this formula is valid for a PHE, neglecting the wall effect for the fluid
% viscosity and the dynamic viscosity changes due to temperature across the
% fluid channel.
% 
% For a PHE, the general formulation for the Nu is:
%       Nu = A * Re^B * Pr^C
% with A, B, C constants.
% The latter term depends from the fluid nature and properties, such as
% fluid temperature. This is due to the definition of the Pr number. The C
% number is normally 0.30 < C < 0.40 for water-like fluids.
% For water, many authors use C=1/3.
%
% A and B depend from the flow (laminar or turbulent) and from some PHE
% charachteristics, like: the presence of riblets or the inclination of
% plates corrugated shapes.
% The choice of well defined values is not trivial. For our purpose,
% assuming that the plate shapes have been manufactured to enhance the heat
% exchange (for example: 60° inclination of corrugated pattern), the values
% below can be selected. These values shall be modified if the user wants
% to perform the optimization with working fluids different from water.
%
% See the references for clarifications.
Nu=0.2267*Re.^0.631*Pr.^(1/3); 
end

