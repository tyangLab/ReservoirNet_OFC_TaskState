function [trainingList, weightout,DM_resp,Rec_resp] = two_training(modelPara,...
    network, weightSet, timePara)

weightout = cell(2,1);
trainingList = zeros(modelPara.numTrials,8);
DM_resp = zeros(modelPara.numTrials, network.nNeurons_rec);
if modelPara.detail
    Rec_resp = zeros(modelPara.numTrials, network.nNeurons_rec,...
        length(timePara.simuTime));
else
    Rec_resp= [];
end

a = rand<0.5;
aind = 2-a;
actionA_E = zeros(2,1);
actionB_E = zeros(2,1);
actionA_E(aind) = 1;
reward_E = 0;
reverse = 0;

for n=1:modelPara.numTrials
    %%     reverse or not
    if n/modelPara.per_reversal == fix(n/modelPara.per_reversal)
        modelPara.reinforcedProb_1 = 1 - modelPara.reinforcedProb_1;
        modelPara.reinforcedProb_2 = 1 - modelPara.reinforcedProb_2;
        reverse = reverse + 1;
    end
    %% which B is selected
    if n == 1
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
    end
    actionA_P = actionA_E;
    actionB_P = actionB_E;
    
    %% get reward
    if n == 1
        if actionB_P(1)
            reward = rand < modelPara.reinforcedProb_1;
        else
            reward = rand > modelPara.reinforcedProb_2;
        end
        x0_rec = network.x_ini*randn(network.nNeurons_rec, 1);
        x_rec = x0_rec;
    else
        reward = reward_E;
    end
    
    type = trial_type(actionA_P, actionB_P, reward);
    %% activity of RNL
    weightout{1,1}(:,n) = weightSet.wDR1;
    weightout{2,1}(:,n) = weightSet.wDR2;
    [actionA_E, actionB_E, pa, newWeight,reward_E,r_rec,r_list,x_rec] = ...
        two_actRNL(network,weightSet, timePara, modelPara,actionA_P,...
        actionB_P,reward,x_rec);% for total reservior network
    %%  save data
    if modelPara.detail
        Rec_resp(n,:,:) = r_list;
    end
    trainingResult = [actionA_P(1),actionA_P(2),actionB_P(1),actionB_P(2),reward,pa,reverse,type];
    weightSet = newWeight;
    DM_resp(n,:) = r_rec;
    trainingList(n,:) = trainingResult;
end