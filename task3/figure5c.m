function F = figure5c(filename)

load(filename);
data = result_list;
nBlocks = length(data);
trial_num = length(data{1, 1}.trainingResult(:,5));
trail_range = 0.8*trial_num:trial_num;
nConditions = size(data{1, 1}.modelPara.value,1);

chooseB_rate = zeros(nBlocks,nConditions);
for k = 1:nBlocks
    choice = ~data{1, k}.trainingResult(trail_range,5);
    
    for i = 1:nConditions
        tar_trial = data{1, k}.trainingResult(trail_range,10)==i;
        chooseB_rate(k,i) = sum(choice(tar_trial))/sum(tar_trial);
    end
end
F = figure('name','psychophysic curve');hold on
errorbar(mean(chooseB_rate,1),std(chooseB_rate,0,1),'o');
xlabel('');
ylabel('Chosen-B rate','Fontsize',14);
set(gca,'Xtick',1:nConditions);
axis([0 nConditions+1 -0 1])
x_label = num2str(data{1,1}.modelPara.value);
x_label(:,3) = '-';
set(gca,'xticklabel',x_label);
set(gca,'ytick',[0 0.25 0.5 0.75 1]);

param = sigm_fit(1:nConditions,nanmean(chooseB_rate,1),[0 1 NaN NaN]);
fsigm = @(param,xval) param(1)+(param(2)-param(1))./(1+10.^((param(3)-xval)*param(4)));
x = -10:0.1:10;
y = fsigm(param,x);
plot(x,y)
  
