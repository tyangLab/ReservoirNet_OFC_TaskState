function F = figure4g(filename)
load(filename);
Datafile = result_list;
clearvars result_list
numBlock = length(Datafile);
coff = zeros(numBlock,5);

for k = 1:numBlock  %block number
    action = Datafile{1,k}.trainingResult(2:end,1)-0.5;
    stimulus = Datafile{1,k}.trainingResult(2:end,3)-0.5;
    
    transition = (action==stimulus)-0.5;
    outcome = Datafile{1,k}.trainingResult(2:end,5)-0.5;
    interact = (transition==outcome)-0.5;
    corr_choice = 0.5-mod(Datafile{1,k}.trainingResult(2:end,7),2);
    X = [corr_choice transition outcome interact];
    X = [X(:,1) ones(size(X,1),1) X(:,2:end)];
    %discard the repeat trials
    Y = 1-abs(diff(Datafile{1,k}.trainingResult(:,1))); % stay_ornot
    
    % Initialize fitting parameters
    initial_theta = zeros(size(X, 2), 1);
    % Set regularization parameter lambda to 1
    lambda = 1;
    % Set Options
    options = optimset('GradObj', 'on', 'MaxIter', 40000);
    
    % Optimize
    [theta, ~, ~] = fminunc(@(t)(costFunctionReg(t, X, Y, lambda)), initial_theta, options);
    coff(k,:) = theta;
end

coff_mean = mean(coff);
coff_std = std(coff);
%%
F = figure('name','  -effect caused by several factors');
errorbar(coff_mean,coff_std,'.');
set(gca,'xtick',1:5,'xticklabel',{'Correct','Stay','Outcome','Transion',...
    'Trans x out'});
ylabel('Log odds');


