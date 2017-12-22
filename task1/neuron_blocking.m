function weightSet = neuron_blocking

global target_file iSimu
pre_data = load(target_file);
weightSet = pre_data.result_list{1, iSimu}.weightSet;
weightSet.wDR1 = pre_data.result_list{1, iSimu}.weightout{1,1}(end,:)';
weightSet.wDR2 = pre_data.result_list{1, iSimu}.weightout{1,2}(end,:)';
