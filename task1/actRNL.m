function [action, pa, r_list,x_rec,v1,v2,pa_all] = actRNL(network,modelPara,weightSet, timePara, action_P,reward_P,x_rec)
global iSimu AR A Rand
dt = timePara.dt;
tau = timePara.tau;
dt_tau = dt/tau;
simutime_len = length(timePara.simuTime);

% initial the recurrent network
if modelPara.REinitial
    x_rec = network.x_ini*randn(network.nNeurons_rec, 1);
end
r_rec = activity2rate(x_rec);

% get the stimulus
input_F = zeros(network.nNeurons_input, simutime_len);
if modelPara.simutan
    if modelPara.withRF
        if reward_P % reward input
            input_F(3, timePara.Son:timePara.Soff) = 1;
        end
    end
else
    if modelPara.withRF && reward_P % reward input
        input_F(3, timePara.Ron:timePara.Roff) = 1;
    end
end
input_F(1, timePara.Son:timePara.Soff) = action_P(1);
input_F(2, timePara.Son:timePara.Soff) = action_P(2);
r_list = zeros(network.nNeurons_rec,length(timePara.simuTime));
pa_all = zeros(length(timePara.simuTime),1);
ti = 0;

for t = timePara.simuTime
    ti = ti + 1;
    % the responses of the recurrent
    x_rec = (1.0-dt_tau)*x_rec + weightSet.wRR*(r_rec*dt_tau) +...
        weightSet.wIR*(input_F(:,ti)*dt_tau) + network.noise_gain*randn(network.nNeurons_rec, 1).*dt_tau;
    r_rec = activity2rate(x_rec);
    r_list(:, ti) = r_rec;
    v1 = weightSet.wDR1'*r_rec;
    v2 = weightSet.wDR2'*r_rec;
    pa_all(ti) = 1./(1+exp(network.delta*(v2-v1)));
    
    % the decision time
    if t >= timePara.simuTime(timePara.dec) % time of make decision
        switch modelPara.blocking
            case 0
                v1 = weightSet.wDR1'*r_rec;
                v2 = weightSet.wDR2'*r_rec;
            case 1
                v1 = weightSet.wDR1'*(r_rec.*~Rand(iSimu,:)');
                v2 = weightSet.wDR2'*(r_rec.*~Rand(iSimu,:)');
            case 2
                v1 = weightSet.wDR1'*(r_rec.*~A(iSimu,:)');
                v2 = weightSet.wDR2'*(r_rec.*~A(iSimu,:)');
            case 3
                v1 = weightSet.wDR1'*(r_rec.*~AR(iSimu,:)');
                v2 = weightSet.wDR2'*(r_rec.*~AR(iSimu,:)');
        end
        %         v1 = weightSet.wDR1'*r_rec;
        %         v2 = weightSet.wDR2'*r_rec;
        pa = 1./(1+exp(network.delta*(v2-v1)));
        a = rand < pa;  %v1>v2;
        aind = 2-a;
        action = zeros(2,1);
        action(aind) = 1;
        break;
    end
end