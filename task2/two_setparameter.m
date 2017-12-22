function [modelPara, network, time] = two_setparameter()

modelPara.numTrials = 4000;
modelPara.BA = 0;
modelPara.transitionProb = [0.8, 0.8];
modelPara.reinforcedProb_1 = 0.8;
modelPara.reinforcedProb_2 = 0.8;
modelPara.per_reversal = 100; % how many trials do reversal at first
modelPara.detail = 0;
modelPara.withRF = 1;
modelPara.reset = 1;

network.eta_r = 0.001; % learning rate  
network.delta_a = 2;
network.noise_gain = 0.01;
network.x_ini = 0.01;  

network.nNeurons_input_A = 2;
network.prob_inpA_rec = 0.2;
network.gain_inpA_rec = 2;

network.nNeurons_input_B = 2;
network.prob_inpB_rec = 0.2;
network.gain_inpB_rec = 2;

network.nNeurons_input_R = 2;
network.prob_inpR_rec = 0.2;
network.gain_inpR_rec = 2;

network.nNeurons_output = 2;
network.gain_rec_dec = 1;
network.baseline = 0.2;

network.nNeurons_rec = 500;
network.prob_rec = 0.1;
network.gain_rec = 2.25;


% set the time
time.dt = 0.001;            
time.fix = 0.2;
time.Sdur = 0.5;    % duration of the stimulus 
time.SSinter = 0.1;    % interval between the stimuli
time.Rdur = 0.5;    % duration of the stimulus 
time.SRinter = 0.1;    % interval between the stimulus and reward
time.delay = 0.2;
time.tau = 0.5;
