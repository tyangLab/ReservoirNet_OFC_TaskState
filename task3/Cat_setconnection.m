function weight = Cat_setconnection(network)

% set the synaptic weights in the recurrent
% Synaptic weights are randomly initialized with Gaussian distribution with zero mean and a variance of gain2 / N
scale = 1.0/sqrt(network.prob_rec * network.nNeurons_rec);
wRR = sprandn(network.nNeurons_rec, network.nNeurons_rec, network.prob_rec)*network.gain_rec*scale;
wRR = full(wRR); 


% the connections between input and recurrent sparsely and randomly
% Synaptic weights are randomly initialized with Gaussian distribution with zero mean and a variance of gain2 / N
wIROV = sprandn(network.nNeurons_rec, network.nNeurons_OV, network.prob_inpOV_rec);
wIROV = full(wIROV);
wIROV = network.gain_inpOV_rec*wIROV;

% initial the output conncetions 
% Synaptic weights are randomly initialized with uniform distribution[0,gain]
wDR1 = rand(network.nNeurons_rec,1)*network.gain_rec_dec; 
wDR2 = rand(network.nNeurons_rec,1)*network.gain_rec_dec;
wDR1 = wDR1./norm(wDR1);
wDR2 = wDR2./norm(wDR2);

% set structure of weights
weight.wRR = wRR;
weight.wDR1 = wDR1;
weight.wDR2 = wDR2;
weight.wIRA = wIROV;
