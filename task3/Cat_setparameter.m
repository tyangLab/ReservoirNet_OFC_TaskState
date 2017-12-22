function [modelPara, network, time] = Cat_setparameter()

modelPara.numTrials = 10000;
modelPara.value = [1,0;3,1;2,1;1,1;1,2;1,3;1,4;1,6;0,2];
modelPara.value_range = max(modelPara.value)-min(modelPara.value);
modelPara.step = 0;
modelPara.detail = 0;% 0: not save the activity of the DM and output layer;1:save
modelPara.relative_value = 2;% A/B = 2

network.eta_r = 0.005; % learning rate
network.delta_a = 4;  %  inverse-temperature parameter that determines the tradeoff between exploiting and exploring
network.noise_gain = 0.05;
network.x_ini = 0.2;
network.baseline = 0.2;
% parameters between input layer and reservoir network
network.nNeurons_OV = 2; % offer value /the third one is the received reward in last trial
network.prob_inpOV_rec = 0.2;  % probability of sparsely connection
network.gain_inpOV_rec = 2;

% parameters between reservoir network and output layer 
network.nNeurons_output = 2;
network.gain_rec_dec = 0.001;
% parameters in reservoir network
network.nNeurons_rec = 500;
network.prob_rec = 0.1; 
network.gain_rec = 2.5;  

% set the time
time.dt = 0.001;                     
time.t1 = 0.3;               % upon time of stimulus
time.delay = 0.1;
time.sdur = 1;             % duration of the stimulus 
time.tau = 0.1;
