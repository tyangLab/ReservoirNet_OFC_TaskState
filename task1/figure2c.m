function [F, weight_diff, Max] = figure2c(filename)

load(filename);
data = result_list;
clear result_list
[pathname,fname,~] = fileparts(filename);

global sep;
if ismac | isunix
    sep = '/';
elseif ispc
    sep = '\';
else
    disp('Platform not supported')
end

numSessions = size(data,2);
numTrials = data{1,1}.modelPara.numTrials;
nNeurons = data{1,1}.network.nNeurons_rec;

response_label_trial = zeros(4,data{1,1}.network.nNeurons_rec);

for k = 1:numSessions  %block number
    label_action = data{1,k}.trainingResult(:,1);
    label_reward = data{1,k}.trainingResult(:,3);
    type_set = [1;2];
    label_trial = data{1,k}.trainingResult(:,2:3)*type_set+1;%1:ANR;2:BNR;3:AR;4:BR
    response = reshape(data{1,k}.rateRec(:,:,end),numTrials,nNeurons);
    
    for i= 1:4
        response_label_trial(i,:) = arrayfun(@(x) mean(response(label_trial==i,x)),1:nNeurons);
    end
    [~,index_trial] = sort(response_label_trial);% index show the strongest firing in all four condition
    response_label_action(1,:) = arrayfun(@(x) mean(response(label_trial==1|label_trial==3,x)),1:nNeurons);%A
    response_label_action(2,:) = arrayfun(@(x) mean(response(label_trial==2|label_trial==4,x)),1:nNeurons);%B
    response_label_reward(1,:) = arrayfun(@(x) mean(response(label_trial==1|label_trial==2,x)),1:nNeurons);%NR
    response_label_reward(2,:) = arrayfun(@(x) mean(response(label_trial==3|label_trial==4,x)),1:nNeurons);%R
    [~,index_action] = max(response_label_action);% index show the strongest firing in all two actions
    [~,index_reward] = max(response_label_reward);% index show the strongest firing in all two outcomes
    
    %% anova
    p_value_action = arrayfun(@(x) anova1(response(:,x),label_action,'off'),1:nNeurons);
    p_value_reward = arrayfun(@(x) anova1(response(:,x),label_reward,'off'),1:nNeurons);
    [~,~,stats] = arrayfun(@(x) anova1(response(:,x),label_trial,'off'),1:nNeurons,'UniformOutput',false);
    sdf = [0 1 2 3 0 4 0 5 0 0 0 6];
    compare_trial =	sdf(arrayfun(@(x) index_trial(3,x).*index_trial(4,x),1:nNeurons));%1:AN&BN;2:AR&AN;3:AR&BR;4:BN&AR;5:BR&BN;6:AR&BR
    c = cellfun(@multcompare,stats,'UniformOutput',false);
    p_value_trial = arrayfun(@(x) c{1,x}(compare_trial(x),6),1:nNeurons);
    
    %% find the neurons which response specifically
    Max.AR = p_value_trial<0.001 & index_trial(4,:)==3;
    Max.BR = p_value_trial<0.001 & index_trial(4,:)==4;
    Max.AN = p_value_trial<0.001 & index_trial(4,:)==1;
    Max.BN = p_value_trial<0.001 & index_trial(4,:)==2;
    
    Max.A = p_value_action<0.001 & index_action==1;
    Max.B = p_value_action<0.001 & index_action==2;
    Max.N = p_value_reward<0.001 & index_reward==1;
    Max.R = p_value_reward<0.001 & index_reward==2;
    
    %% get the weights between the neurons which response specifically and output
    weight_diff(k) = structfun(@(x)mean(data{1,k}.weightout{1,1}(:,x)-data{1,k}.weightout{1,2}(:,x),2),...
        Max,'UniformOutput',false);
    weight_A(k) = structfun(@(x)mean(data{1,k}.weightout{1,1}(:,x),2),...
        Max,'UniformOutput',false);
    weight_B(k) = structfun(@(x)mean(data{1,k}.weightout{1,2}(:,x),2),Max,...
        'UniformOutput',false);
    %%
    Max_output.AR(k,:) = Max.AR;
    Max_output.BR(k,:) = Max.BR;
    Max_output.AN(k,:) = Max.AN;
    Max_output.BN(k,:) = Max.BN;
    
    Max_output.A(k,:) = Max.A;
    Max_output.B(k,:) = Max.B;
    Max_output.N(k,:) = Max.N;
    Max_output.R(k,:) = Max.R;
    
end
F = figure('name',fname,'visible','off');
colormap = distinguishable_colors(8);
group_name = fieldnames(weight_diff);
for i = 1:length(group_name)
    if ~any(strcmp(group_name{i},{'AN','BN','N','R'}))
        eval(['variable = [weight_diff(:).',group_name{i},'];']);
        [F,~,handle_line{i}] = plot_PatchErrorbar(F,1:numTrials,mean([variable],2),...
            std([variable],0,2)./sqrt(numSessions), [],...
            {'patch','FaceColor',colormap(i,:)/2},...
            {'line','Linewidth',4,'color',colormap(i,:)});
    end
end
legend([handle_line{:}],{'AR','BR','A','B'});
set(F,'visible','off');
%%
clearvars Max
Max = Max_output;
save([pathname,sep,fname,'_Max.mat'],'fname','Max');


