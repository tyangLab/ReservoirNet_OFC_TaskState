clc;
clearvars;
clearvars -global;
disp(datetime);
disp('Clearing workspace.');

%% set the main path of the analysis code
main_pathname = 'E:\Desktop\code_for_submit';

%% task 1, figure 1/2/S1/S2/S3
cd(main_pathname);
cd './task1';
disp('task 1');
reverseLearning_main; 

%% task 2, figure 4/S4/S5
cd(main_pathname);
cd './task2';
disp('task 2');
twolayer_main; 

%% task 2, figure 4/S4/S5
cd(main_pathname);
cd './task3';
disp('task 3');
value_based_main; 

