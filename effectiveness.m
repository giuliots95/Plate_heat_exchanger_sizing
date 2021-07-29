function epsilon=effectiveness(NTU,C_r,type,N)
% This function calculates the effectiveness of a heat exchanger.
% NTU is the number of transfer units of the Heat Exchanger:
% NTU = U*A / C_min
% epsilon = f (NTU,C_r)
% where C_min is the total heat capacity of the hot or cold flow, whichever
% is smaller and C_max is total heat capacity of other flow:
% C_min = min(C_hot,C_cold); 
% C_max = max(C_hot,C_cold); 
% C_r is the ratio of C_min and C_max:
% C_r=C_min/C_max;
%
% Regardless of heat exchanger type, if C_r=0, either hot flow is
% condensing ( means no change in T_hot) or cold flow is evaporating ( no
% change in T_cold), therefore C_max =inf its temperature does not change. 
%
% HE_Type defines the type of heat exchanger: (see reference)
%   'Parallel Flow'
%   'Counter Flow'
%   'One Shell Pass'
%   'N Shell Pass'
%   'Cross Both Unmixed'
%   'Cross Cmax Mixed'
%   'Cross Cmin Mixed'
%
% Reference:
% Frank P. Incropera, Introduction to heat transfer. New York:Wiley, 1985, Section 11.4. 
% Programmer: Seyyed Ali Hedayat Mofidi (seyyed4li@yahoo.com)
if nargin == 3
    N=1;
end
%% ===== Calculating effectiveness =====
% Special case of boiling or condensing:
if C_r == 0
    epsilon = 1-exp(-NTU); %ok
    return;
end
switch type
    case 'Parallel Flow' 
        epsilon = (1-exp(-NTU.*(1+C_r)))/(1+C_r);
    case 'Counter Flow' 
        if C_r==1
            epsilon = NTU./(1+NTU);
        else
            epsilon = (1-exp(-NTU.*(1-C_r)))./(1-C_r*exp(-NTU.*(1-C_r)));
        end
    case 'One Shell Pass'
        num=2;
        den_1=1+C_r+sqrt(1+C_r.^2);
        den_2=1+exp(-NTU.*sqrt(1+C_r.^2));
        den_3=1-exp(-NTU.*sqrt(1+C_r.^2));
        epsilon=num./(den_1.*den_2./den_3);
    case 'N Shell Pass'
        NTUN = NTU/N;
        num=2;
        den_1=1+C_r+sqrt(1+C_r.^2);
        den_2=1+exp(-NTU.*sqrt(1+C_r.^2));
        den_3=1-exp(-NTU.*sqrt(1+C_r.^2));
        epsilon1=num./(den_1.*den_2./den_3);
        epsilon = (((1-epsilon1*C_r)/(1-epsilon1)).^N-1) ./ (((1-epsilon1.*C_r)/(1-epsilon1)).^N-C_r);
    case 'Cross Both Unmixed'
        epsilon = 1-exp(1/C_r.* NTU.^0.22.*(exp(-C_r.*NTU.^0.78)-1));
    case 'Cross Cmax Mixed'
        epsilon = 1/C_r*(1-exp(-C_r.*(1-exp(-NTU))));
    case 'Cross Cmin Mixed'
        epsilon = 1 - exp(-1/C_r.*(1-exp(-C_r*NTU)));
    otherwise % the type is not in the list, therefore we assume there's no heat exchanger.
        error('select ana available heat exchanger geometry');
        return;
end
