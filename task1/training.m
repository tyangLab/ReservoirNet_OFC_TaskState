function [trainingList, rateout, weightout,pa_alltrial] = training(modelPara, network, weightSet, timePara)

trainingList = zeros(modelPara.numTrials,7);
reinforcedSchedule = modelPara.reinforcedSchedule;
x_rec = network.x_ini*randn(network.nNeurons_rec, 1);
if modelPara.detail
    temp = 1:1:timePara.dec;
    rateout = zeros(modelPara.numTrials,network.nNeurons_rec,length(temp));
else
    rateout = zeros(modelPara.numTrials,network.nNeurons_rec);
end
weightout = cell(1,2);
pa_alltrial = zeros(modelPara.numTrials,length(1:timePara.dec)+1);

for n=1:modelPara.numTrials
    
    % set the reverse
    if mod(n-1, modelPara.numReversed)==0 && n >= modelPara.numReversed
        reinforcedSchedule = 1-reinforcedSchedule;
    end
    
    if n==1
        a = rand>0.5;
        action_P = [a;1-a];
        reward = reinforcedSchedule>rand;
        baited = [reward; 1-reward];
        reward_P = baited' * action_P;
    end
    % activity of RNL / choice for the next trial
    [action_E, pa, r_list,x_rec,v1,v2,pa_all] = actRNL(network,modelPara,weightSet, timePara,...
        action_P,reward_P,x_rec);
    % reward or not for the next trial
    reward = reinforcedSchedule>rand;
    baited = [reward; 1-reward];
    reward_E = baited' * action_E;
    % learning
    if n <= modelPara.StopTrainingTrials && modelPara.blocking==0
        if action_E(1)
            weightSet.wDR1 = weightSet.wDR1 + network.eta*(reward_E-pa)*(r_list(:,...
                timePara.dec)-network.baseline);
            weightSet.wDR1 = weightSet.wDR1./norm(weightSet.wDR1);
        else
            weightSet.wDR2 = weightSet.wDR2 + network.eta*(reward_E-1+pa)*(r_list(:,...
                timePara.dec)-network.baseline);
            weightSet.wDR2 = weightSet.wDR2./norm(weightSet.wDR2);
        end
    end
    trainingResult = [action_P(1),action_P(2), reward_P, reinforcedSchedule, pa,v1,v2];
    trainingList(n,:) = trainingResult;
    pa_alltrial(n,:) = pa_all;
    reward_P = reward_E;
    action_P = action_E;
    if modelPara.detail
        rateout(n,:,:) = r_list(:,temp);
        weightout{1,1}(n,:) = weightSet.wDR1;
        weightout{1,2}(n,:) = weightSet.wDR2;
    else
        rateout(n,:) = r_list(:,timePara.dec);
        weightout{1,1}(n,:) = weightSet.wDR1;
        weightout{1,2}(n,:) = weightSet.wDR2;
    end
end