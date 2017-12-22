function value_based_task(nSimu,varyPara,varyPara_num,filename)

if ~isempty(varyPara) && ~isempty(varyPara_num)
    nPara = numel(varyPara_num);
else
    nPara = 1;
end

for iPara = 1:nPara
    disp(['iPara=',num2str(iPara)]);
    result_list = cell(1, nSimu);
    for iSimu = 1:nSimu
        disp(['iSimu=',num2str(iSimu)]);
        % set the initial parameters of model
        [modelPara, network, time] = Cat_setparameter();
     
        % change one parameter
        if ~isempty(varyPara) && ~isempty(varyPara_num)
            eval([varyPara,' = varyPara_num(iPara);']);
        end
        
        % set the connections
        weightSet = Cat_setconnection(network);
        % set the time
        timePara = Cat_settime(time);
        
        
        % training process
        [trainingResult,weightset,DM_resp,Output_resp,weightout] = ...
            Cat_training(modelPara, network, weightSet, timePara);
        
        result.trainingResult = trainingResult;
        result.modelPara = modelPara;
        result.network = network;
        result.timePara = timePara;
        result.weightset = weightset;
        result.weightout = weightout;
        result.dmresp =  DM_resp;
        result.opresp = Output_resp;
        result_list{1, iSimu} = result;
    end % end of nSimu
    
    % save the results
    save(filename{iPara},'result_list' ,'-v7.3');
end
