function F = figureS1(filename)
load(filename);
data = result_list;
clear result_list
%% get the neuron type
[~, ~, Max] = figure2c(filename);
%%
time.input_on = data{1}.timePara.Son;
time.decision = data{1}.timePara.dec;
type = sum(data{1,1}.trainingResult(:,[1 3])*diag([1 2]),2)+1;% 1:AN 2:BN 3:AR 4:BR
X=[];
nNeurons = data{1,1}.network.nNeurons_rec;
time_leng = length(data{1,1}.timePara.simuTime);
for i= 1:4
    Response = nanmean(data{1,1}.rateRec(type==i,:,:),1);
    X = [X squeeze(Response)];
end
%Normalization
X = X-ones(size(X,1),1)*mean(X);

% Calculate the eigenvalues and eigenvectors of the new covariance matrix.
covarianceMatrix = X*X'/size(X,2);
[E, D] = eig(covarianceMatrix); % eigenvectors as column

% Sort the eigenvalues  and recompute matrices
[~,order] = sort(diag(-D));
E = E(:,order);
Y = E'*X;%Y the project matrix of the input data X without whiting

d = diag(D);
dsqrtinv = real(d.^(-0.5));
Dsqrtinv = diag(dsqrtinv(order));
D = diag(d(order));
V = Dsqrtinv*E';% V swhitening matrix
E = E';
%%
F = figure('name','pca');
hold on
colormap = distinguishable_colors(8);
for ntype = 1:2
    if ntype==1
        neuron_order =  Max.AR;
    elseif ntype==2
        neuron_order =  Max.BR;
    end
    for ii=1:4
        curr_resp = reshape(mean(data{1,1}.rateRec(type==ii,neuron_order,:),...
            1),sum(neuron_order),time.decision);
        curr_coord = E(1:3,neuron_order) * curr_resp;
        plot3(curr_coord(1,:),curr_coord(2,:),curr_coord(3,:),...
            'Color',colormap(ii*ntype,:),'LineWidth',2);
    end
end
legend('AR-AN','AR-BN','AR-AR','AR-BR','BR-AN','BR-BN','BR-AR','BR-BR');
view([90 30 30]);
hold off
var = sum(d(end-2:end))./sum(d);
xlabel(strcat('PC1  variance:',num2str(var)));
ylabel('PC2');zlabel('PC3');
