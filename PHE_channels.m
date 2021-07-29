function [n_ch_hot, n_ch_cold] = PHE_channels(n_plates)
% Assign the number of channels to the hot and cold side of a plate heat
% exchanger (PHE).
%
% Input: 
%           - n_plates is the number of plates. Can be odd or even but > 3.
%
% Outputs:
%
%           - n_ch_hot is the # of channels for the hot side
%           -n_ch_cold is the # of channels for the cold side
%
n_ch_cold=zeros(size(n_plates));
n_ch_hot=zeros(size(n_plates));
for j=1:length(n_plates)
    if mod(n_plates(j), 2)==0 % n_plates is even
        n_ch_cold(j)=n_plates(j)/2;
        n_ch_hot(j)=n_plates(j)/2;
    else % n_plates is odd
        n_ch_cold(j)=(n_plates(j)+1)./2;
        n_ch_hot(j)=(n_plates(j)-1)./2;
    end
end
end

