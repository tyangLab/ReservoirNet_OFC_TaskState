rng('shuffle');

%% 
pathname_task3 = pwd;
pathname_task3 = [pathname_task3, sep];

%% figure 5c/6a/6c
disp('Simulation');
disp('data for 5c/6ac.');
nSimu = 20;
varyPara = [];
varyPara_num = [];
filename_5c = {[pathname_task3,'value_based.mat']};
value_based_task(nSimu,varyPara,varyPara_num,filename_5c);

%% figure S6a
disp('S6 a.');
nSimu = 10;
varyPara = 'network.gain_inpOV_rec';
varyPara_num = 2;
filename_S6a = {[pathname_task3,'value_based_S6a.mat']};
value_based_task(nSimu,varyPara,varyPara_num,filename_S6a);
%% figure S6b
disp('S6 b.');
nSimu = 10;
varyPara = 'network.noise_gain';
varyPara_num = 0.5;
filename_S6b = {[pathname_task3,'value_based_S6b.mat']};
value_based_task(nSimu,varyPara,varyPara_num,filename_S6b);
%% figure S6c
disp('S6 c.');
nSimu = 10;
varyPara = 'modelPara.step';
varyPara_num = 1;
filename_S6c = {[pathname_task3,'value_based_S6c.mat']};
value_based_task(nSimu,varyPara,varyPara_num,filename_S6c);

%%  block; 2:A block; 3: AR block
%%%%%%%%%%%%%
disp('analysing');

%% figure 5c
disp('5c.');
F5c = figure5c(filename_5c{1});

%% figure 6a, show ten neurons activities, did not conside the selectivity
disp('6a.');
figure6a(filename_5c{1});

%% figure 6c
disp('6c.');
F6c = figure6c(filename_5c{1});

%% figure S6a
disp('S_6a.');
F_S6a = figure6c(filename_S6a{1});

%% figure S6b
disp('S_6b.');
F_S6b = figure6c(filename_S6b{1});

%% figure S6c
disp('S_6c.');
F_S6c = figure6c(filename_S6c{1});
%%
cd ..