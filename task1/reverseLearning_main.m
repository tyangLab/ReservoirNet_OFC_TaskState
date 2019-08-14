rng('shuffle');

%% You need to set up the specific paths (pathname) for your machine

pathname_task1 = pwd;
pathname_task1 = [pathname_task1, sep];

%% figure 1c
disp('Simulation');
disp('data for 1c.');
nSimu = 10;
varyPara = {'modelPara.withRF',[],[]};
varyPara_num = {[1 0],[],[]};
filename_1c = {[pathname_task1,'withRF_1c.mat'], [pathname_task1,'withoutRF_1c.mat']};
reversal(nSimu,varyPara,varyPara_num,filename_1c);

%% figure 2a/2b
disp('data for 2a/2b.');
nSimu = 1;
varyPara = {'modelPara.detail','modelPara.numTrials',[]};
varyPara_num = {1,400,[]};
filename_2ab = {[pathname_task1,'withRF_detailedInformation_2ab.mat']};
reversal(nSimu,varyPara,varyPara_num,filename_2ab);
%% figure 2c/2e
disp('data for 2c/2e.');
nSimu = 10;
varyPara = {'modelPara.withRF','modelPara.numTrials','modelPara.StopTrainingTrials'};
varyPara_num = {1,7000,5000};
filename_2ce = {[pathname_task1,'withRF_2ce.mat']};
reversal(nSimu,varyPara,varyPara_num,filename_2ce);
%% figure 2d
disp('data for 2d.');
global target_file
target_file = filename_2ce{1};
nSimu = 10;
varyPara = {'modelPara.blocking','modelPara.numTrials',...
    'modelPara.StopTrainingTrials'};
varyPara_num = {[1 2 3],2000,0};
filename_2d = {[pathname_task1,'withRF_2d_randBlocking.mat'],...
    [pathname_task1,'withRF_2d_A_Blocking.mat'],...
    [pathname_task1,'withRF_2d_AR_Blocking.mat']};
reversal(nSimu,varyPara,varyPara_num,filename_2d);

%%  block; 2:A block; 3: AR block
%%%%%%%%%%%%%
disp('analysing');

%% figure 1c
disp('1c.');
[F1c,~,~] = figure1c2e(filename_1c);

%% figure 2a, show ten neurons activities, did not conside the selectivity
disp('2a.');
figure2a(filename_2ab{1});

%% figure 2b
disp('2b.');
F2b = figure2b(filename_2ab{1});

%% figure 2c
disp('2c.');
F2c = figure2c(filename_2ce{1});
set(F2c,'visible','on');

%% figure 2d
disp('2d.');
F2d = figure2d(filename_2d);

%% figure 2e
disp('2e.');
[F2e,~,~] = figure1c2e(filename_2ce);

%% figure S1
disp('S_1.');
[F_S1] = figureS1(filename_2ab{1});

%% figure S2
disp('S_2.');
[F_S2a,F_S2b] = figureS2(filename_1c{1});

%% figure S3
disp('S_3.');
[F_S3] = figureS3(filename_1c{1});
%%
cd ..