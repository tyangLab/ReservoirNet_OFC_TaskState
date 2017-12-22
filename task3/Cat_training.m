function [trainingList, weightSet, DM_resp, Output_resp,weightout] = Cat_training(modelPara,...
    network, weightSet, timePara)

weightout = cell(2,1);
if modelPara.detail
	DM_resp = zeros(modelPara.numTrials,network.nNeurons_rec,length(timePara.simuTime)+1);
else
	DM_resp = zeros(modelPara.numTrials,network.nNeurons_rec,2);
end
Output_resp = zeros(modelPara.numTrials,network.nNeurons_output);
trainingList = zeros(modelPara.numTrials,10);


early_delay = timePara.offer_on:1:ceil((timePara.offer_off+timePara.offer_on)/2);

rel_value = modelPara.relative_value;
for n=1:modelPara.numTrials

    condition = ceil(rand*length(modelPara.value));
    temp1 = modelPara.value(condition,:)./modelPara.value_range;
    num_A = modelPara.value(condition,1);
    num_B = modelPara.value(condition,2);
    range_numA = temp1(1);
    range_numB = temp1(2);
    value_A = num_A * rel_value / max(max(modelPara.value*diag([rel_value,1])));
    value_B = num_B / max(max(modelPara.value*diag([rel_value,1])));
        % activity of RNL
	[action_E, newWeight, response,Output,pa] = Cat_actRNL(network,weightSet,timePara,...
        modelPara,range_numA,range_numB,value_A,value_B);
    if modelPara.detail
        DM_resp(n,:,:) = response;
    else
        DM_resp(n,:,1) = response(:,end);
        DM_resp(n,:,2) = mean(response(:,early_delay),2);
    end
    Output_resp(n,:) = Output;
    trainingResult = [num_A,num_B,value_A,value_B action_E',Output(:,end)',pa,condition];
    trainingList(n,:) = trainingResult;
    weightout{1,1}(:,n) = weightSet.wDR1;
    weightout{2,1}(:,n) = weightSet.wDR2;
    weightSet = newWeight;
    
end


