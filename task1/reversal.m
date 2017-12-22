function reversal(nSimu,varyPara,varyPara_num,filename)

global iSimu
nparas = cellfun(@length,varyPara_num);
nPara = nparas;
nPara(nparas==0) = 1;

for iPara = 1:nPara(1)
for iPara2 = 1:nPara(2)
for iPara3 = 1:nPara(3)
    result_list = cell(1, nSimu);
    disp(['iPara:  ',num2str(iPara)]);
    for iSimu = 1:nSimu
        disp(['iSimu:  ',num2str(iSimu)]);
        
        % set the initial parameters of model
        [modelPara, network, time] = setparameter();
        % change one parameter
        if nparas(1)~=0
            eval([varyPara{1},' = varyPara_num{1}(iPara);'])
        end
        if nparas(2)~=0
            eval([varyPara{2},' = varyPara_num{2}(iPara2);'])
        end
        if nparas(3)~=0
            eval([varyPara{3},' = varyPara_num{3}(iPara3);'])
        end
        % set the time
        timePara = settime(time,modelPara);
        % set the connections
        if modelPara.blocking~=0
            weightSet = neuron_blocking;
            get_selNeuron;
        else
            weightSet = setconnection(network);
        end
        
        % training process
        [trainingResult, rateRec, weightout,pa_alltrial] = training(modelPara,...
            network, weightSet, timePara);
        
        result.trainingResult = trainingResult;
        result.modelPara = modelPara;
        result.network = network;
        result.timePara = timePara;
        result.rateRec = rateRec;
        result.weightout = weightout;
        result.weightSet = weightSet;
        result.pa = pa_alltrial;
        result_list{1, iSimu} = result;
    end % end of nSimu
    
    % save the results
    save(filename{iPara*iPara2*iPara3},'result_list' ,'-v7.3');
end
end
end