function [modelPara, network, time] = setparameter()

modelPara.numTrials = 1000;
modelPara.StopTrainingTrials = 5000;
modelPara.numReversed = 100;
modelPara.reinforcedSchedule = 1; % determined or prob
modelPara.withRF = 1;  % reward feedback
modelPara.numMod = 1;
modelPara.detail = 0;
modelPara.REinitial = 1;
modelPara.simutan= 1;
modelPara.blocking = 0; % 0:no block; 1: random block; 2:A block; 3: AR block 
network.eta = 0.001; % learning rate
network.delta = 4; % parameter for the softmax function
network.noise_gain = 0.01;
network.x_ini = 0.01;
network.baseline = 0.2;

network.nNeurons_input = 3;
network.nNeurons_rec = 500;
network.prob_rec = 0.1;
network.gain_rec = 2;
% the forward connections between two layers
network.gain_input_rec = 4;
network.prob_input_rec = 0.2;
network.gain_rec_dec = 0.01;

% set the time
time.dt = 0.001;
time.start = 0.2;    % upon time of stimulus
time.sdur = 0.5;    % duration of the stimulus
time.inter = 0;   % interval between stimulus and reward
time.rdur = 0.5;    % duration of reward input
time.delay = 0.2;   % delay before decision
time.intertrial = 0;
time.tau = 0.1; % time constant 
