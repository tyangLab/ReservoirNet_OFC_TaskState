function F = figure4c(filename)

num_file = numel(filename);
for i = 1:num_file
    load([filename{1,i}]);   
    if i == 1
        numTrial = result_list{1, 1}.modelPara.numTrials;
        numBlock = length(result_list);
        para_fit = zeros(num_file,numBlock,5);
    end
    for k = 1:numBlock  %block number
        all.input_sA = result_list{1, k}.trainingResult(:,1);
        all.input_sB = result_list{1, k}.trainingResult(:,3);
        all.input_R = result_list{1, k}.trainingResult(:,5);
        
        %% model fitting
        trial_range = 2000:numTrial;
        input_sA = all.input_sA(trial_range);
        input_sB = all.input_sB(trial_range);
        input_R = all.input_R(trial_range);
        
        para = [0 0 0 0 0];% lr_free /lr_based /lambda /weight /beta /perseveration
        ub = [1, 1, 1, 1, inf];
        lb = [0, 0, 0, 0, -inf];
        while true
            para_fit(i ,k,:) = fmincon(@(params)cost_fit_frsed(input_sA, input_sB, input_R ,params),...
                para,[],[],[],[],lb,ub); %% fminunc
            temp_para = squeeze(para_fit(i ,k,:))';
            if sum(abs(para-temp_para))<0.1
                break
            end
            para = temp_para;
        end
    end
end

para_fit = squeeze(para_fit);

para_WR = squeeze(para_fit(1,:,:));
para_WOR = squeeze(para_fit(2,:,:));
range_para_WR_max = mean(para_WR(:,4))+3*std(para_WR(:,4));
range_para_WR_min = mean(para_WR(:,4))-3*std(para_WR(:,4));
range_para_WOR_max = mean(para_WOR(:,4))+3*std(para_WOR(:,4));
range_para_WOR_min = mean(para_WOR(:,4))-3*std(para_WOR(:,4));
target_para_WR = para_WR(:,4)<range_para_WR_max & para_WR(:,4) > range_para_WR_min;
target_para_WOR = para_WOR(:,4)<range_para_WOR_max & para_WOR(:,4) > range_para_WOR_min;

F = figure;
b1 = boxplot([para_WR(target_para_WR,4);para_WOR(target_para_WOR,4)],...
    [zeros(1,sum(target_para_WR)),ones(1,sum(target_para_WOR))],...
    'notch','on','whisker',50);
hold on;

h1 = plot(1.85+rand(sum(target_para_WOR),1)*0.3,para_WOR(target_para_WOR,4),'.');
h2 = plot(0.85+rand(sum(target_para_WR),1)*0.3,para_WR(target_para_WR,4),'.');
set(gca,'xtick',[1,2],'xticklabel',{'With Reward','Without Reward'});
