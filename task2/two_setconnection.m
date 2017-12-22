function weightSet = two_setconnection(network)

% set the synaptic weights in the recurrent
scale = 1.0/sqrt(network.prob_rec * network.nNeurons_rec);
wRR = sprandn(network.nNeurons_rec, network.nNeurons_rec, network.prob_rec)*network.gain_rec*scale; % zero mean and variance g2/(N*prob)
wRR = full(wRR); 

% the connections between input and recurrent
wIRA =  sprandn(network.nNeurons_rec, network.nNeurons_input_A, network.prob_inpA_rec); % used to be sprandn 20151203, the birthday of xiao caipu
wIRA =  full(wIRA);
wIRA =  network.gain_inpA_rec*wIRA;

wIRB =  sprandn(network.nNeurons_rec, network.nNeurons_input_B, network.prob_inpB_rec);% used to be sprandn 20151203, the birthday of xiao caipu
wIRB =  full(wIRB);
wIRB =  network.gain_inpB_rec*wIRB;

wIRR =  sprandn(network.nNeurons_rec, network.nNeurons_input_R, network.prob_inpR_rec);% used to be sprandn 20151203, the birthday of xiao caipu
wIRR =  full(wIRR);
wIRR =  network.gain_inpR_rec*wIRR;

% initial the output conncetions
wDR1 = (rand(network.nNeurons_rec,1))*network.gain_rec_dec;
wDR2 = (rand(network.nNeurons_rec,1))*network.gain_rec_dec;
wDR1 = wDR1./norm(wDR1);
wDR2 = wDR2./norm(wDR2);

% set structure of weights
weightSet.wRR = wRR;
weightSet.wDR1 = wDR1;
weightSet.wDR2 = wDR2;
weightSet.wIRA = wIRA;
weightSet.wIRB = wIRB;
weightSet.wIRR = wIRR;

