function [action_E, newWeight,response,Output,pa] = Cat_actRNL(network,...
    weightSet,timePara,modelPara,range_numA,range_numB,value_A,value_B)

dt = timePara.dt;
tau = timePara.tau;
dt_tau = dt/tau;
simutime_len = length(timePara.simuTime);
% initial the recurrent network
x0_rec = network.x_ini*randn(network.nNeurons_rec, 1);
x_rec = x0_rec;
r_rec = Cat_activity2rate(x_rec);

% input
r_ipOV = zeros(network.nNeurons_OV, simutime_len);
if ~modelPara.step
    t = 1:timePara.offer_off;
    g_t(t) = 1./(1+exp(-(t-175-timePara.offer_on)/30))./(1+exp((t-400-timePara.offer_on)/100));
    f_t = g_t/max(g_t);
    r_ipOV(1,timePara.offer_on:timePara.offer_off) = ...
        range_numA*f_t(timePara.offer_on:timePara.offer_off);
    r_ipOV(2,timePara.offer_on:timePara.offer_off) = ...
        range_numB*f_t(timePara.offer_on:timePara.offer_off);
else
    r_ipOV(1,timePara.offer_on:timePara.offer_off) = range_numA;
    r_ipOV(2,timePara.offer_on:timePara.offer_off) = range_numB;
end

ti = 1;
response = zeros(network.nNeurons_rec,length(timePara.simuTime));
for t = timePara.simuTime+1
    %     the responses of the recurrent
    x_rec = (1.0-dt_tau)*x_rec + weightSet.wRR*(r_rec*dt_tau) +...
        weightSet.wIRA*(r_ipOV(:,ti)*dt_tau)+...
        network.noise_gain*randn(network.nNeurons_rec,1).*dt_tau;
    r_rec = Cat_activity2rate(x_rec);
    ti = ti + 1;
    response(:,ti) = r_rec;% firing rate
end

en1 = weightSet.wDR1'*r_rec;  %choice a
en2 = weightSet.wDR2'*r_rec;  %choice b

pa = 1./(1+exp(network.delta_a*(en2-en1)));
en = rand > pa; % en = 1 indicated that en2 > en1
Output = [en1;en2];
action_E = zeros(2,1);
action_E(en+1) = 1;

value_baseline = pa*value_A+(1-pa)*value_B;
action = action_E(1);

if action
    weightSet.wDR1 = weightSet.wDR1+network.eta_r*(value_A-value_baseline)...
        *(r_rec-network.baseline);
    weightSet.wDR1 = weightSet.wDR1./norm(weightSet.wDR1);
else
    weightSet.wDR2 = weightSet.wDR2+network.eta_r*(value_B-value_baseline)...
        *(r_rec-network.baseline);
    weightSet.wDR2 = weightSet.wDR2./norm(weightSet.wDR2);
end

newWeight = weightSet;
