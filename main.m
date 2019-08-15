clc;
clearvars;
clearvars -global;
disp(datetime);
disp('Clearing workspace.');

%% set the main path of the analysis code
if ismac | isunix
    sep = '/';
elseif ispc
    sep = '\';
else
    disp('Platform not supported')
end

fname = mfilename('fullpath');
fname = split(fname, sep);
fname(end) = [];
fpath = join(fname, sep);
dir = fpath{:};
main_pathname = [dir, sep];
disp(['Main pathway: ',main_pathname])

%% task 1, figure 1/2/S1/S2/S3
cd(main_pathname);
cd 'task1';
disp('task 1');
reverseLearning_main; 
%% task 2, figure 4/S4/S5
cd(main_pathname);
cd 'task2';
disp('task 2');
twolayer_main; 

%% task 2, figure 4/S4/S5
cd(main_pathname);
cd 'task3';
disp('task 3');
value_based_main; 

