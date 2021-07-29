function [f, message] = colebrook(Re, k)
% Compute the friction factor given the Reynolds number, the roughness
% epsilon and the reference inner pipe diameter D.
%
% inputs: - Reynolds number [-]
%         - relative roughness [-]
%
%   pay attention: epsilon and D shall have the same dimension!
%
% outputs: - friction factor (dimensionless)
%          - message (0 = calculation did not converge)
%                    (1 = calculation successful)
%
if Re <=0 || k <=0 
    error('inputs must be all positive values');
    return;
else
    if Re < 2300
        % laminar flow
        f = 64/Re;
        message=1;
    else
        % rewrite fun(f) == 0
        fun=@(f) (1/sqrt(f)+2*log10(k/3.71+2.51/(Re*sqrt(f))));
        [f, ~, flag]=fsolve(fun, 0.1,  optimset('Display','off'));
        % discuss solutions
        if flag <= 0
            % refuse solution
            f=NaN;
            message=-1;
            % algorithm did not converge to a solution.
        else 
            % accept solution
            message=1;
        end
    end
end

