function nllk = cost_fit_frsed(input_sA, input_sB, input_R ,para)

% this is the error function to fit both the model-free and model-based RL
% model to the data file generated from the 1-stage probabilistic learning
% experiment.
%
% The free parameters are:
%   lr_free: learning rate in model_free                  para(1)
%   lr_based: learning rate in model-based                 para(2)
%   lambda:                    para(3)
%   weight: weight of model-based learning          para(4)
%   beta: contronl the trade-off between exploration and exploitation   para(5)
%   p: perseveration term para(6)

lr_free = para(1);
lr_based = para(2);
lambda = para(3);
weight = para(4);
beta = 2;
p = para(5);
nllk = 0;
Q_A1_free = 0;Q_A2_free = 0;
Q_B1_free = 0;Q_B2_free = 0;
Q_B1_based = 0;Q_B2_based = 0;
numTrial = length(input_sA);
for numT = 2:numTrial-1;
    %% model free
    Q_B1_free = Q_B1_free + lr_free*input_sB(numT)*(input_R(numT)-Q_B1_free);
    Q_B2_free = Q_B2_free + (1-input_sB(numT))*lr_free*(input_R(numT)-Q_B2_free);
    
    Q_A1_free = Q_A1_free + input_sB(numT)*input_sA(numT)*lr_free*lambda*(Q_B1_free-Q_A1_free) +... %% if A1B1
        (1-input_sB(numT))*input_sA(numT)*lr_free*lambda*(Q_B2_free-Q_A1_free); %%if A1B2
    Q_A2_free = Q_A2_free + input_sB(numT)*(1-input_sA(numT))*lr_free*lambda*(Q_B1_free-Q_A2_free) + ... %% if A2B1
        (1-input_sB(numT))*(1-input_sA(numT))*lr_free*lambda*(Q_B2_free-Q_A2_free);  %% if A2B2
    %% model based
    Q_B1_based = Q_B1_based + input_sB(numT)*lr_based*(input_R(numT)-Q_B1_based);
    Q_B2_based = Q_B2_based + (1 - input_sB(numT))*lr_based*(input_R(numT)-Q_B2_based);
    
    Q_A1_based = 0.8*Q_B1_based + 0.2*Q_B2_based;
    Q_A2_based = 0.8*Q_B2_based + 0.2*Q_B1_based;
    %% weighted sum
    Q_A1 = (1-weight)*Q_A1_free + weight*Q_A1_based;
    Q_A2 = (1-weight)*Q_A2_free + weight*Q_A2_based;
    
    pref = exp(beta*(Q_A1+p*input_sA(numT-1)))...
        /(exp(beta*(Q_A1+p*input_sA(numT-1)))+exp(beta*(Q_A2+p*(1-input_sA(numT-1)))));
    %% maximize the posterior probability
    nllk = nllk - input_sA(numT+1)*log(pref)-(1-input_sA(numT+1))*log(1-pref);
end
