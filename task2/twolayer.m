function twolayer(nSimu,varyPara,varyPara_num,filename)

nparas = cellfun(@length,varyPara_num);
nPara = nparas;
nPara(nparas==0) = 1;
result_list = cell(1,nSimu);

for iPara = 1:nPara(1)
for iPara2 = 1:nPara(2)
for iPara3 = 1:nPara(3)
    disp(['iPara:    ',num2str(iPara)]);
    for iSimu = 1:nSimu
        disp(['iSimu:    ',num2str(iSimu)]);
        
        % set the initial parameters of model
        [modelPara, network, time] = two_setparameter();
        % change the initial parameters of model
        if nparas(1)~=0
            eval([varyPara{1},' = varyPara_num{1}(iPara);'])
        end
        if nparas(2)~=0
            eval([varyPara{2},' = varyPara_num{2}(iPara2);'])
        end
        if nparas(3)~=0
            eval([varyPara{3},' = varyPara_num{3}(iPara3);'])
        end
        % set the connections
        weightSet = two_setconnection(network);
        % set the time
        timePara = two_settime(time);
        
        % training process
        [trainingResult, weightout, DM_resp, Rec_resp] = ...
            two_training(modelPara, network, weightSet, timePara);
        
        result.trainingResult = trainingResult;
        result.modelPara = modelPara;
        result.network = network;
        result.timePara = timePara;
        result.Rec_resp = Rec_resp;
        result.weightout = weightout;
        result.weightSet = weightSet;
        result.dmresp =  DM_resp;
        result_list{1, iSimu} = result;
        
    end % end of nSimu
    
    % save the results
    save(filename{iPara*iPara2*iPara3},'result_list' ,'-v7.3');
end
end
end
