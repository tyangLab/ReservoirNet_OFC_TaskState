function F = figureS3(filename)
load(filename);
data = result_list;
clear result_list
%%
numSessions = size(data,2);
numTimestep = length(data{1, 1}.timePara.simuTime);

for k = 1:numSessions
    type = sum(data{1,k}.trainingResult(:,[1 3])*diag([1 2]),2)+1;% 1:AN 2:BN 3:AR 4:BR
    expected_reward_AR_BN{k} = 1-data{1, k}.pa(type==2|type==3,:);
    expected_reward_AN_BR{k} = 1-data{1, k}.pa(type==1|type==4,:);
end
expected_reward_AR_BN = cell2mat(expected_reward_AR_BN');
expected_reward_AN_BR = cell2mat(expected_reward_AN_BR');
expected_reward_AR_BN(:,end) = [];
expected_reward_AN_BR(:,end) = [];

F = figure;
[F,~,~] = plot_PatchErrorbar(F,1:numTimestep-1,mean(expected_reward_AR_BN,1),...
    std(expected_reward_AR_BN,0,1)./sqrt(numSessions), [2,1,1]);
[F,~,~] = plot_PatchErrorbar(F,1:numTimestep-1,mean(expected_reward_AN_BR,1),...
    std(expected_reward_AN_BR,0,1)./sqrt(numSessions), [2,1,2]);
