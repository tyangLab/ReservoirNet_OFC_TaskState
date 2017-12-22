function rate = Cat_activity2rate(x, r0, rmax)

% The firing rate of the neuron i is a function of the activation variable xi 
% relative to a fixed baseline firing rate y0 (= 0.1) and the maximal rate

if nargin < 2, r0=0.1; rmax = 1; end % baseline fire rate r0 and maximal fire rate rmax

if ~isempty(find(x<=0)) && ~isempty(find(x>0))
    px = x;
    px(find(px<=0)) = 0;
    nx = x;
    nx(find(nx>0)) = 0;
    nr = r0*tanh(nx/r0);
    pr = (rmax - r0)*tanh(px/(rmax - r0));
    rate = r0 + nr + pr;
elseif ~isempty(find(x<=0))
    rate = r0 + r0*tanh(x/r0);
elseif ~isempty(find(x>0))
    rate = r0 + (rmax - r0)*tanh(x/(rmax - r0));
end