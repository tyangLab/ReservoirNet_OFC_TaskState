function F = figure2d(filename)

num_file = length(filename);
F = figure('name',strcat([filename{:}],'figure2d'));

%%
[F1,finishpoint, errortrials] = figure1c2e(filename);
close(F1);
%%
[mean_errnum,ste_errnum,unfinished_per_mean,unfinished_per_ste] =...
    deal(zeros(numel(finishpoint),1));
unfinished_per = zeros(numel(finishpoint), size(finishpoint{1,1},1));
numblock = size(finishpoint{1,1},2);
for i= 1:numel(finishpoint)
    unfinished{i} = finishpoint{i}(:,1:2:numblock)==100;
    temp = errortrials{i}(:,1:2:end);
    mean_errnum(i) = mean(temp(~unfinished{i}));
    ste_errnum(i) = std(temp(~unfinished{i}))./sqrt(length(temp(~unfinished{i})));
    unfinished_per(i,:) = sum(unfinished{i},2)./size(unfinished{i},2);
    unfinished_per_mean(i) = mean(unfinished_per(i,:));
    unfinished_per_ste(i) = std(unfinished_per(i,:))./numel(unfinished_per(i,:));
end

subplot(1,2,1);hold on;
title 'unfinished blocks(%)'
errorbar(unfinished_per_mean,unfinished_per_ste, '.');
bar(unfinished_per_mean);
set(gca,'xtick',[1:3],'xticklabel',{'control','A Blocking','AR Blocking'});
subplot(1,2,2);hold on
errorbar(mean_errnum,ste_errnum, '.');
bar(mean_errnum);
title 'mean error to criterion'
set(gca,'xtick',[1:3],'xticklabel',{'control','A Blocking','AR Blocking'})

