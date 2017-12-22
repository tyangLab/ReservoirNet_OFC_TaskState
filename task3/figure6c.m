function  F = figure6c(filename)

load(filename);

Factor = {'total_value','chosen_value','unchosen_value','ChminUnc',...
    'ChdivUnc','value_A','value_B','chosen_valueA','chosen_valueB','choice'};
nFactor = size(Factor,2);  


data = result_list;
clearvars result_list;

nBlocks = size(data,2);
numTotalTrials = data{1,1}.modelPara.numTrials;
nNeurons = data{1,1}.network.nNeurons_rec;
TrianlRange = round(0.8*numTotalTrials):1:numTotalTrials;
numTrialRange = length(TrianlRange);

[num_best_sign,num_sign] = deal(zeros(nBlocks,nFactor));
label = struct();

for k = 1:nBlocks
    %% find the neuron type(decode which kind information)
    label(k).value_A = data{1,k}.trainingResult(TrianlRange,3);
    label(k).value_B = data{1,k}.trainingResult(TrianlRange,4);
    label(k).chosen_value = sum(data{1,k}.trainingResult(TrianlRange,3:4)...
        .*data{1,k}.trainingResult(TrianlRange,5:6),2);
    label(k).unchosen_value = sum(data{1,k}.trainingResult(TrianlRange,3:4)...
        .*data{1,k}.trainingResult(TrianlRange,[6 5]),2);
    label(k).total_value = label(k).chosen_value+label(k).unchosen_value;
    label(k).ChminUnc = label(k).chosen_value - label(k).unchosen_value;
    label(k).ChdivUnc = label(k).unchosen_value./label(k).chosen_value;
    label(k).chosen_valueA = data{1,k}.trainingResult(TrianlRange,3)...
        .*data{1,k}.trainingResult(TrianlRange,5);
    label(k).chosen_valueB = data{1,k}.trainingResult(TrianlRange,4)...
        .*data{1,k}.trainingResult(TrianlRange,6);
    label(k).choice = data{1,k}.trainingResult(TrianlRange,5);
    
    if data{1,1}.modelPara.detail
        early_delay = timePara.offer_on:1:ceil((timePara.offer_off+timePara.offer_on)/2);
        resp = reshape(mean(data{1,k}.dmresp(TrianlRange,:,early_delay),3),...
            numTrialRange,nNeurons);
    else
        resp = data{1,k}.dmresp(TrianlRange,:,2);
    end
    %% linear regression of each factors in each period
    %  early delay
    for iFactor = 1:nFactor
        eval(['curr_var = label(k).',Factor{iFactor},';']);
        LinRe = arrayfun(@(x) fitlm(resp(:,x),curr_var),...
            1:nNeurons,'UniformOutput',false);
        pValue = arrayfun(@(x) LinRe{1,x}.Coefficients{'x1','pValue'},1:nNeurons,...
            'UniformOutput',false);
        eval(['pVal.',Factor{iFactor},' = cell2mat(pValue);']);
    end
    %%  find the number of neurons which show the association with factor
    %   response for each types of neurons in each condition
    %
    pVal_m = cell2mat(struct2cell(pVal));
    
    sign_order = pVal_m < 0.00001;
    num_sign(k,:) = arrayfun(@(x) sum(sign_order(x,:) == 1),1:nFactor);

end

%%  figure
F = figure('name','neuron type');
bar(mean(num_sign,1));
title('explained')
hold on
errorbar(mean(num_sign,1),std(num_sign,0,1)/sqrt(nBlocks),'.');
set(gca,'Xtick',1:nFactor);
set(gca,'xticklabel',{'total value','chosen value','unchosen value',...
    'ChminUnc','ChdivUnc','value A','value B','chosen valueA',...
    'chosen valueB','choice'});
ylabel('Period','FontSize',14);    xlabel('Factor','FontSize',14);
