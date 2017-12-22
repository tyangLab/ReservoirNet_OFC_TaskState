function [F, finishpoint, errortrials] = figure1c2e(filename)
%

num_file = numel(filename);
for i = 1:num_file
    load([filename{1,i}]);
    data = result_list;
    clearvars result_list
    %%
    numSessions = size(data,2);
    numReversed = data{1,1}.modelPara.numReversed;
    numTrials = data{1,1}.modelPara.numTrials;
    numBlocks = numTrials/numReversed;
    for k = 1:numSessions
        reward_info = data{1,k}.trainingResult(:,3);
        corr_rate = arrayfun(@(x) sum(reward_info(x-29:x)==1)/30,30:length(reward_info));
        corr_rate = [zeros(1,29) corr_rate];
        corr_rate = reshape(corr_rate,numReversed,[])';
        corr_rate(:,1:29)=0;
        finish_trial_or = arrayfun(@(x) find(corr_rate(x,:)>=0.8,1),...
            1:numBlocks,'UniformOutput',false);
        finish_trial(~cellfun(@isempty,finish_trial_or)) = [finish_trial_or{:}];
        finish_trial(cellfun(@isempty,finish_trial_or)) = numReversed;
        % accoding to the cited paper, differet criterion for the first block
        
        finish_trial_firstblock =  find(corr_rate(1,:)>=0.93,1);
        if isempty(finish_trial_firstblock)
            finish_trial(1) = 100;
        else
            finish_trial(1) = finish_trial_firstblock;
        end
        finishpoint{i}(k,:) = finish_trial;
        errortrials{i}(k,:) = arrayfun(@(x) sum(reward_info((x-1)*numReversed+1:...
            (x-1)*numReversed+finish_trial(x))==0),1:numBlocks);
    end
    error_mean(i,:) = mean(errortrials{i},1);
    error_std(i,:) = std(errortrials{i},0,1)./sqrt(numSessions);
end
F = figure('name','errornum');
hold on;
errorbar(error_mean', error_std','linewidth',2);
set(gca,'xtick',[1 10:10:70],'xticklabel',{'initial','R10','R20','R30',...
    'R40','R50','R60','R70'});
ylabel('mean error to criterion');

