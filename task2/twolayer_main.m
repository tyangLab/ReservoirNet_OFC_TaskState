rng('shuffle');

%% You need to set up the specific paths (pathname) for your machine
pathname_task2 = pwd;
%% data for figure 4abcefg
disp('Simulation');
disp('figure 4.');
disp('...');
nSimu = 50;
varyPara = {'modelPara.withRF',[],[]};
varyPara_num = {[1 0],[],[]};
filename_4 = {[pathname_task2,'\withRF_4.mat'], [pathname_task2,'\withoutRF_4.mat']};
twolayer(nSimu,varyPara,varyPara_num,filename_4);

%% data for figure 4d
disp('figure 4b pca.');
disp('...');
nSimu = 1;
varyPara = {'modelPara.detail','modelPara.numTrials',[]};
varyPara_num = {1,400,[]};
filename_4pca = {[pathname_task2,'\withRF_detailedInformation_4.mat']};
twolayer(nSimu,varyPara,varyPara_num,filename_4pca);
%% data for figure S5a
disp('figure S5a.');
disp('...');
nSimu = 20;
varyPara = {'modelPara.withRF','time.tau',[]};
varyPara_num = {[1 0],0.1,[]};
filename_S5a = {[pathname_task2,'\withRF_4_S5_smallertau.mat'],...
    [pathname_task2,'\withoutRF_4_S5_smallertau.mat']};
twolayer(nSimu,varyPara,varyPara_num,filename_S5a);
%% data for figure S5b
disp('figure S5a.');
disp('...');
nSimu = 20;
varyPara = {'modelPara.withRF','modelPara.BA',[]};
varyPara_num = {[1 0],1,[]};
filename_S5b = {[pathname_task2,'\withRF_4_S5_BA.mat'],...
    [pathname_task2,'\withoutRF_4_S5_BA.mat']};
twolayer(nSimu,varyPara,varyPara_num,filename_S5b);
%% data for figure S5c
disp('figure S5a.');
disp('...');
nSimu = 20;
varyPara = {'modelPara.withRF','time.tau','modelPara.BA'};
varyPara_num = {[1 0],0.1,1};
filename_S5c = {[pathname_task2,'\withRF_4_S5_BA_smallertau.mat'],...
    [pathname_task2,'\withoutRF_4_S5_BA_smallertau.mat']};
twolayer(nSimu,varyPara,varyPara_num,filename_S5c);

%%
%%%%%%%%%%%%%
disp('analysing');

%% figure 4a
disp('4a.');
[F4a] = figure4a({filename_4{1}});
%% figure 4b
disp('4b.');
[F4b,~] = figure4b(filename_4);

%% figure 4c
disp('4c.');
F4c = figure4c(filename_4);
set(F4c,'visible','on');

%% figure 4d
disp('4d.');
F4d = figure4d(filename_4pca{1});

%% figure 4e
disp('4e.');
F4e = figure4e(filename_4{1});

%% figure 4f
disp('4f.');
F4f = figure4f(filename_4{1});

%% figure 4g
disp('4g.');
F4g = figure4g(filename_4{1});

%% figure S4
disp('S_4.');
F_S4 = figure4a(filename_4);

%% figure S5a
disp('S_5a.');
F_S5a1 = figure4b(filename_S5a);
F_S5a2 = figure4c(filename_S5a);

%% figure S5b
disp('S_5b.');
F_S5b1 = figure4b(filename_S5b);
F_S5b2 = figure4c(filename_S5b);

%% figure S5c
disp('S_5c.');
F_S5c1 = figure4b(filename_S5c);
F_S5c2 = figure4c(filename_S5c);
%%
cd ..