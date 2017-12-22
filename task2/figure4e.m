function F = figure4e(filename)

%% analysis all the result in the folder
load(filename);
data = result_list;
clear result_list;
numTrials = data{1,1}.modelPara.numTrials;
nNeurons = data{1,1}.network.nNeurons_rec;
nBlocks = length(data);
weight_diff_tri_trialtype = cell(1,8);
%%
for k = 1:nBlocks;  %block number
    label_trial = data{1,k}.trainingResult(:,8);%1:A1B1R;2:A1B1N;3:A1B2R;
    % 4:A1B2N;5:A2B1R;6:A2B1N;7:A2B1R;8A2B2N
    response = data{1,k}.dmresp;
    if size(response,1)~=nNeurons
        response = response';
    end
    % response labelled by the trial condition
    resp_latrl = zeros(8,data{1,1}.network.nNeurons_rec);
    for i= 1:8
        % mean response in each conditions for all neurons
        resp_latrl(i,:) = arrayfun(@(x) mean(response(x,label_trial==i)),1:nNeurons);
    end
    [~,index_trial] = sort(resp_latrl);% index show the strongest firing in all four condition
    [~,~,stats] = arrayfun(@(x) anova1(response(x,:),label_trial,'off'),...
        1:nNeurons,'UniformOutput',false);
    c = cellfun(@multcompare,stats,'UniformOutput',false);
    %% find the neurons which response specifically____trible/all three units
    max_trial =	index_trial(end,:); %show the condition in which the neuron fire most strongly
    compare_tri_trial = arrayfun(@(x) find(c{1,x}(:,1:2) == max_trial(x)),...
        1:nNeurons,'UniformOutput',false);
    compare_tri_trial = cell2mat(compare_tri_trial);
    compare_tri_trial(compare_tri_trial>28) = compare_tri_trial(compare_tri_trial>28)-28;
    sign_tri_neuron = arrayfun(@(x) sum(c{1,x}(compare_tri_trial(:,x),6)< 10^-6)==7,1:nNeurons);
    Max_tri_trialtype = arrayfun(@(x) find((sign_tri_neuron==1)&(max_trial==x)==1),...
        1:8,'UniformOutput',false);
    
    %% Tri/get the weights between the neurons which response specifically and output
    weight_diff_Unarranged_tri = arrayfun(@(x) ...
        data{1,k}.weightout{1,1}(Max_tri_trialtype{1,x},:)...
        -data{1,k}.weightout{2,1}(Max_tri_trialtype{1,x},:),1:8,'UniformOutput',false);
    for ii = 1:8
        weight_diff_tri_trialtype{1,ii} = [weight_diff_tri_trialtype{1,ii};...
            weight_diff_Unarranged_tri{ii}];
    end
    clear Max_tri_trialtype weight_diff_Unarranged_tri;
end

%%
F = figure('Name','-weight_diff'); hold on
[size_cell,~] = cellfun(@size,weight_diff_tri_trialtype,'UniformOutput', false);
size_cell = cell2mat(size_cell);
colormap = distinguishable_colors(4);
group_type = {[1,3,6,8],[2,4,5,7],[1,4,5,8],[2,3,6,7]};% A1R, A2R B1R B2R
for i = 1:4
    [x,y] = getMeanSte(group_type{i},weight_diff_tri_trialtype, size_cell);
    [F,~,h{i}] = plot_PatchErrorbar(F,1:numTrials,x,y,[],{'patch',...
        'FaceColor',colormap(i,:)/2,'EdgeColor','none','FaceAlpha','0.3'},...
        {'line','color',colormap(i,:)/2,'linewidth',2});
    hold on
end
xlim([-50 numTrials+50])
legend([h{1},h{2},h{3},h{4}],'A1R','A2R','B1R','B2R','Location','northwest');
ax = gca;
ntrial = data{1, 1}.modelPara.per_reversal;
for n = 0:2:numTrials/100-2
    x = [n*ntrial (n+1)*ntrial (n+1)*ntrial n*ntrial];
    y = [ax.YLim(1) ax.YLim(1) ax.YLim(2) ax.YLim(2) ];
    patch(x,y,'black','EdgeColor','none','FaceAlpha','0.1');
end
end
%%
function [x,y] = getMeanSte(group, origin_fire, typesize)
x = mean([origin_fire{1,group(1)};origin_fire{1,group(2)};...
    origin_fire{1,group(3)};origin_fire{1,group(4)}],1);
y = std([origin_fire{1,group(1)};origin_fire{1,group(2)};...
    origin_fire{1,group(3)};origin_fire{1,group(4)}],0,1)...
    /sqrt(sum(typesize(group)));
end