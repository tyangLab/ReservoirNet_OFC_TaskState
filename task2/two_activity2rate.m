function rate = two_activity2rate(x, r0, rmax)

if nargin < 2, r0=0.1; rmax = 1; end

if ~isempty(find(x<=0)) && ~isempty(find(x>0))
    px = x;
    px(find(px<=0)) = 0;
    nx = x;
    nx(find(nx>0)) = 0;
    nr = r0*tanh(nx/r0);
    pr = (rmax - r0)*tanh(px/(rmax - r0));
    rate = r0 + nr + pr;

% %     nr = r0*tanh(nx/r0);
% %     pr =  (rmax - 2*r0)*tanh(px/(rmax - 2*r0));
% %     rate = 2*r0 + nr + pr;
elseif ~isempty(find(x<=0))
    rate = r0 + r0*tanh(x/r0);
% %     rate = 2*r0 + r0*tanh(x/r0);
elseif ~isempty(find(x>0))
    rate = r0 +(rmax - r0)*tanh(x/(rmax - r0));
% % %     rate = 2*r0 + (rmax - 2*r0)*tanh(x/(rmax - 2*r0));
end