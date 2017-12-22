function figure2a(filename)

load(filename);
data = result_list;
clearvars result_list
fname = filename(1:end-4);

numSessions = size(data,2);
numTrials = data{1,1}.modelPara.numTrials;
nNeurons = data{1,1}.network.nNeurons_rec;
time_step = length(data{1,1}.timePara.simuTime);
type = sum(data{1,1}.trainingResult(:,[1 3])*diag([1 2]),2)+1;% 1:AN 2:BN 3:AR 4:BR

%%
for k = 1:numSessions
    neurons = [1:10];
    colormap = distinguishable_colors(4);
    for i = 1:length(neurons)
        F1 = figure('name','example_neuron');
        hold on
        for ii = 1:4
            mean_ii = reshape(mean(data{1,k}.rateRec(type==ii,...
                neurons(i),:)),1,time_step-1);
            ste_ii = reshape(std(data{1,k}.rateRec(type==ii,...
                neurons(i),:)),1,time_step-1)./sqrt(sum(type==ii));
            [F1,~,a{ii}] = plot_PatchErrorbar(F1,1:numel(ste_ii),mean_ii,ste_ii,[],...
                {'patch','FaceColor', colormap(ii,:)/2,'EdgeColor',...
                colormap(ii,:)/2,'LineWidth',1},...
                {'line','Color',colormap(ii,:),'LineWidth',4});
        end
        set(gca,'XLim',[-50 1000]);
        set(gca,'YLim',[-0.05 1]);
        set(gca,'XTick',[0 200 300 600 700 900] );
        set(gca,'YTick',[0:0.25:1] );
        xlabel 'time(ms)'
        ylabel 'response(normalized)'
        title(num2str(neurons(i)))
        legend([a{1},a{2},a{3},a{4}],'AN','BN','AR','BR','Location','northwest','FontSize',8);
    end
end


