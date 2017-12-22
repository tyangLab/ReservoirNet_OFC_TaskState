function[actionA_E, actionB_E, pa, newWeight,reward_E, r_rec,r_list,x_rec] =...
    two_actRNL(network, weightSet, timePara, modelPara,actionA_P,actionB_P,...
    reward,x_rec)

dt = timePara.dt;
tau = timePara.tau;
dt_tau = dt/tau;
simutime_len = length(timePara.simuTime);
% initial the recurrent network
r_ipA = zeros(network.nNeurons_input_A, simutime_len);
r_ipB = zeros(network.nNeurons_input_B, simutime_len);
r_ipR = zeros(network.nNeurons_input_R, simutime_len);
if modelPara.reset
    x0_rec = network.x_ini*randn(network.nNeurons_rec, 1);
    x_rec = x0_rec;
end
r_rec = two_activity2rate(x_rec);
if modelPara.detail
    r_list = zeros(network.nNeurons_rec,length(timePara.simuTime));
else
    r_list = [];
end
if modelPara.BA == 1
    if actionA_P(1)
        r_ipA(1,timePara.Bonset:timePara.Boffset) = 1;
    else
        r_ipA(2,timePara.Bonset:timePara.Boffset) = 1;
    end
    if actionB_P(1)
        r_ipB(1,timePara.Aonset:timePara.Aoffset) = 1;
    else
        r_ipB(2,timePara.Aonset:timePara.Aoffset) = 1;
    end
elseif modelPara.BA == 0
    if actionA_P(1)
        r_ipA(1,timePara.Aonset:timePara.Aoffset) = 1;
    else
        r_ipA(2,timePara.Aonset:timePara.Aoffset) = 1;
    end
    if actionB_P(1)
        r_ipB(1,timePara.Bonset:timePara.Boffset) = 1;
    else
        r_ipB(2,timePara.Bonset:timePara.Boffset) = 1;
    end
end
if modelPara.withRF
    if reward
        r_ipR(1,timePara.Ronset:timePara.Roffset) = 1;
    else
        r_ipR(2,timePara.Ronset:timePara.Roffset) = 1;
    end
end

ti = 0;
% % % r_list = zeros(network.nNeurons_rec, simutime_len);
for t = timePara.simuTime
    ti = ti + 1;
    % the responses of the recurrent
    x_rec = (1.0-dt_tau)*x_rec + weightSet.wRR*(r_rec*dt_tau) + weightSet.wIRA*(r_ipA(:,ti)*dt_tau)+...
        weightSet.wIRB*(r_ipB(:,ti)*dt_tau)+ weightSet.wIRR*(r_ipR(:,ti)*dt_tau)+...
        network.noise_gain*randn(network.nNeurons_rec, 1).*dt_tau;
    r_rec = two_activity2rate(x_rec);
    if modelPara.detail
        r_list(:,ti) = r_rec;
    end
end

%%  prediction
en1 = weightSet.wDR1'*r_rec;
en2 = weightSet.wDR2'*r_rec;
pa = 1./(1+exp(network.delta_a*(en2-en1)));
en = rand<pa;   %en2 is larger, pa is smaller, en is more likely to be 0 ---- actionA_E(2) = 1;
actionA_E = zeros(2,1);
actionA_E(2-en) = 1;

%% judge the next trial
actionB_E = zeros(2, 1);
if actionA_E(1)
    if rand < modelPara.transitionProb(1)
        actionB_E(1,1) = 1;
    else
        actionB_E(2,1) = 1;
    end
else
    if rand < modelPara.transitionProb(2)
        actionB_E(2,1) = 1;
    else
        actionB_E(1,1) = 1;
    end
end

% get reward
if actionB_E(1)
    reward_E = rand < modelPara.reinforcedProb_1;
else
    reward_E = rand > modelPara.reinforcedProb_2;
end

action = actionA_E(1);

%% reinforcement learning
if action
    weightSet.wDR1 = weightSet.wDR1 + network.eta_r*(reward_E-pa)*(r_rec-network.baseline);
    weightSet.wDR1 = weightSet.wDR1./norm(weightSet.wDR1);
else
    weightSet.wDR2 = weightSet.wDR2 + network.eta_r*(reward_E-(1-pa))*(r_rec-network.baseline);
    weightSet.wDR2 = weightSet.wDR2./norm(weightSet.wDR2);
end

newWeight = weightSet;