function F = figure4f(filename)

load(filename);

Datafile = result_list;
clearvars result_list
numBlock = length(Datafile);
numTrial = Datafile{1, 1}.modelPara.numTrials;
pre_trial_num = 10;
coff = zeros(numBlock,4*pre_trial_num);
[com_rew_all, com_unr_all, rar_rew_all, rar_unr_all] = ...
    deal(zeros(numTrial-pre_trial_num, pre_trial_num));
for k = 1:numBlock  %block number
    action = Datafile{1,k}.trainingResult(:,1);
    stimulus = Datafile{1,k}.trainingResult(:,3);
    
    transition = (action==stimulus);
    outcome = Datafile{1,k}.trainingResult(:,5);
    
    com_rew = (transition & outcome)./2;
    com_unr = (transition & ~outcome)./2;
    rar_rew = (~transition & outcome)./2;
    rar_unr = (~transition & ~outcome)./2;
    
    for i = 1:pre_trial_num
        com_rew_all(:,i) = com_rew(i:end+i-pre_trial_num-1);
        com_unr_all(:,i) = com_unr(i:end+i-pre_trial_num-1);
        rar_rew_all(:,i) = rar_rew(i:end+i-pre_trial_num-1);
        rar_unr_all(:,i) = rar_unr(i:end+i-pre_trial_num-1);
    end
    
    X = [com_rew_all com_unr_all rar_rew_all rar_unr_all];
    % %     X = [X(:,1) ones(size(X,1),1) X(:,2:end)];
    %discard the repeat trials
    Y = 1-abs(diff(action(pre_trial_num:end))); % stay_ornot
    
    % Initialize fitting parameters
    initial_theta = zeros(size(X, 2), 1);
    
    % Set regularization parameter lambda to 1
    lambda = 1;
    % Set Options
    options = optimset('GradObj', 'on', 'MaxIter', 40000);
    
    % Optimize
    [theta, ~, ~] = fminunc(@(t)(costFunctionReg(t, X, Y, lambda)),...
        initial_theta, options);
    
    coff(k,:) = theta;
end

coff_mean = mean(coff,1);
coff_ste = std(coff,0,1)/sqrt(numBlock);
%%
F = figure('name','  -effect caused by previous trials');
for i = 1:4
    errorbar(coff_mean(10*(i-1)+1:10*i),coff_ste(10*(i-1)+1:10*i));
    hold on
end
set(gca,'xtick',1:2:9,'xticklabel',{'-10','-8','-6','-4','-2'});
legend('common reward','common unreward','rare rewrad','rare unreward');
ylabel('Log odds');
