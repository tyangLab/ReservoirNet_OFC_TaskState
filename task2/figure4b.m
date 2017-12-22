function [F_index,index_frsed] = figure4b(filename)

num_file = numel(filename);
F_index = figure('name','index');hold on;
for i = 1:num_file
    load([filename{1,i}]);
    numSessions = size(result_list,2);
    numTrials = size(result_list{1,1}.trainingResult,1);
    thTrials = 10;
    step = round(numTrials/thTrials);
    index_frsed = zeros(thTrials, numSessions);
    stay_p = zeros(numSessions,4);
    %%
    for n = 1:thTrials
        for k = 1:numSessions
            ncr_stay = 0;
            nrr_stay = 0;
            ncn_stay = 0;
            nrn_stay = 0;
            
            num_comm_reward = 0;
            num_raw_reward = 0;
            num_comm_noreward = 0;
            num_raw_noreward = 0;
            
            trainingResult = result_list{1,k}.trainingResult;
            for i = step*(n-1)+1:step*n-1
                rw = trainingResult(i, 5);
                if trainingResult(i, 1) - trainingResult(i, 3) == 0  % common
                    if rw % with reward
                        num_comm_reward = num_comm_reward+1;
                        if trainingResult(i, 1) - trainingResult(i+1, 1)==0 % stay
                            ncr_stay = ncr_stay + 1;
                        end
                    else % without reward
                        num_comm_noreward = num_comm_noreward+1;
                        if trainingResult(i, 1)-trainingResult(i+1, 1)==0 % stay
                            ncn_stay = ncn_stay + 1;
                        end
                    end
                else % rare
                    if rw % with reward
                        num_raw_reward = num_raw_reward+1;
                        if trainingResult(i, 1)-trainingResult(i+1,1)==0 % stay
                            nrr_stay = nrr_stay + 1;
                        end
                    else % without reward
                        num_raw_noreward = num_raw_noreward+1;
                        if trainingResult(i, 1)-trainingResult(i+1, 1)==0 % stay
                            nrn_stay = nrn_stay + 1;
                        end
                    end
                end
            end
            stay_p(k,1) = ncr_stay/num_comm_reward;
            stay_p(k,2) = nrr_stay/num_raw_reward;
            stay_p(k,3) = ncn_stay/num_comm_noreward;
            stay_p(k,4) = nrn_stay/num_raw_noreward;
            index_frsed(n,k) = sum(stay_p(k,[1,4])-stay_p(k,[2,3]),2)./...
                sum(stay_p(k,:),2);
        end
        
    end
    % plot the task structure index
    figure(F_index);
    hold on
    errorbar(mean(index_frsed,2),std(index_frsed,0,2)/sqrt(numSessions),...
        'parent',F_index.CurrentAxes);
end

end

function plot_stay_prob(mean_stay_p, ste_stay_p)
hold on
errorbar([1 3],mean_stay_p(1,[1,3]),ste_stay_p(1,[1 3]),...
    'LineStyle','none','Color',[0 .15 .75],'LineWidth',4);
errorbar([2 4],mean_stay_p(1,[2,4]),ste_stay_p(1,[2 4]),...
    'LineStyle','none','Color',[0.75 .15 0],'LineWidth',4);
a3 = bar([1,3],mean_stay_p(1,[1,3]),0.4,'FaceColor',[0 .1 .5],...
    'EdgeColor',[0 .1 .5],'LineWidth',1.5);
a4 = bar([2,4],mean_stay_p(1,[2,4]),0.4,'FaceColor',[0.5 .1 0],...
    'EdgeColor',[0.5 .1 0],'LineWidth',1.5);
legend([a3,a4],{'common','rare'},'Fontsize',14);
ylim([0.1 0.8]);
ylabel('stay probability');
xlim([0.25 4.75]);
end