function weights = setconnection(network)

% set the synaptic weights in the recurrent
scale = 1.0/sqrt(network.prob_rec * network.nNeurons_rec);
wRR = sprandn(network.nNeurons_rec, network.nNeurons_rec, network.prob_rec)*...
    network.gain_rec*scale;
wRR = full(wRR);

% the connections between input and recurrent
wIR =  sprandn(network.nNeurons_rec, network.nNeurons_input, network.prob_input_rec);
wIR =  full(wIR);
wIR =  network.gain_input_rec*wIR;

% initial the output conncetions
wDR1 = (rand(network.nNeurons_rec,1))*network.gain_rec_dec;
wDR2 = (rand(network.nNeurons_rec,1))*network.gain_rec_dec;
wDR1 = wDR1./norm(wDR1);
wDR2 = wDR2./norm(wDR2);

% set structure of weights
weights.wRR = wRR;
weights.wIR = wIR;
weights.wDR1 = wDR1;
weights.wDR2 = wDR2;
