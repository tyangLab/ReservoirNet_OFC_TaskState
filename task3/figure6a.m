function figure6a(filename)


load(filename);
data = result_list;
nBlocks = length(data);
nTrials = data{1, 1}.modelPara.numTrials;
for nBlock = 1:nBlocks;
    n_type = size(data{1, 1}.modelPara.value,1);
    startTrial = 0.8*nTrials;
    neuronOrder = [1:5];
    trialType = data{1,nBlock}.trainingResult(startTrial+1:end,end);
    choice = data{1,nBlock}.trainingResult(startTrial+1:end,5);
    for neuron_num = neuronOrder
        response = arrayfun(@(x) data{1,nBlock}.dmresp...
            (startTrial+find(trialType==x),neuron_num,1),...
            1:n_type,'UniformOutput',false);
        % choose A
        response_A = arrayfun(@(x) data{1,nBlock}.dmresp...
            (startTrial+find(trialType==x & choice == 1),neuron_num,1),...
            1:n_type,'UniformOutput',false);
        % choose B
        response_B = arrayfun(@(x) data{1,nBlock}.dmresp...
            (startTrial+find(trialType==x & choice == 0),neuron_num,1),...
            1:n_type,'UniformOutput',false);
        
        mean_A = cellfun(@mean,response_A);
        mean_B = cellfun(@mean,response_B);
        ste_A = cellfun(@std,response_A)./cellfun(@length,response_A);
        ste_B = cellfun(@std,response_B)./cellfun(@length,response_B);
        mean_all = cellfun(@mean,response);
        ste_all = cellfun(@std,response)./cellfun(@length,response);
        
        figure;hold on;
        all_line = errorbar(mean_all,ste_all,'.k');
        set(gca,'xtick',[1:n_type],'xticklabel',...
            {'1:0','3:1','2:1','1:1','1:2','1:3','1:4','1:6','0:2'});
        ylabel 'Firing rate (a.u.)';
        figure;hold on;
        a_line = errorbar(mean_A,ste_A,'.b');
        b_line = errorbar(mean_B,ste_B,'.r');
        set(gca,'xtick',[1:n_type],'xticklabel',...
            {'1:0','3:1','2:1','1:1','1:2','1:3','1:4','1:6','0:2'});
        ylabel 'Firing rate (a.u.)';
        legend('A is chosen','B is chosen')
    end
end