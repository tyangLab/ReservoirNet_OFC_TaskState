function F_prob = figure4a(filename)

F_prob = figure('name','stay_prob');
%%
num_file = numel(filename);
for nfile = 1:num_file
    load([filename{1,nfile}]);
    numSessions = size(result_list,2);
    numTrials = size(result_list{1,1}.trainingResult,1);
    if nfile == 1
        stay_p = zeros(num_file,numSessions,4);
    end
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
        for i = 1:numTrials-1
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
        stay_p(nfile,k,1) = ncr_stay/num_comm_reward;
        stay_p(nfile,k,2) = nrr_stay/num_raw_reward;
        stay_p(nfile,k,3) = ncn_stay/num_comm_noreward;
        stay_p(nfile,k,4) = nrn_stay/num_raw_noreward;
    end
    % plot the stay probability
    figure(F_prob);
    subplot(1,num_file,nfile);
    mean_stay_p = squeeze(nanmean(stay_p(nfile,:,:),2));
    ste_stay_p = squeeze(nanstd(stay_p(nfile,:,:),0,2))./sqrt(numSessions);
    plot_stay_prob(mean_stay_p',ste_stay_p');
    hold on
    set(gca,'xtick',[1.5 3.5],'xticklabel',{'Reward','Unreward'})
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