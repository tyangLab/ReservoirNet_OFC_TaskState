function F = figure4d(filename)

%% analysis all the result in the folder
load(filename);
fname = filename(1:end-4);
data = result_list;
clear result_list
type = data{1,1}.trainingResult(:,8);
nNeurons = data{1, 1}.network.nNeurons_rec;
n_timepoint = length(data{1, 1}.timePara.simuTime);
stimuli_on = data{1, 1}.timePara.Aonset;
X = zeros(nNeurons,n_timepoint*8);
%%
for i= 1:8
    Response = squeeze(mean(data{1,1}.Rec_resp(type==i,:,:),1));
    X(:,1+n_timepoint*(i-1):n_timepoint*i) = Response;
end
%Normalization
X = X-ones(size(X,1),1)*mean(X);

% Calculate the eigenvalues and eigenvectors of the new covariance matrix.
covarianceMatrix = X*X'/size(X,2);

% E principal component transformation (orthogonal)
% D variances of the principal components
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

F = figure('name',[fname,'-PCA']);
hold on
map = distinguishable_colors(8);
for ii=1:8
    curr_resp = squeeze(mean(data{1,1}.Rec_resp(type==ii,:,:),1));
    curr_coord = E(1:3,:) * curr_resp(:,stimuli_on-1:end);
    curve{ii} = plot3(curr_coord(1,:),curr_coord(2,:),curr_coord(3,:),...
        'LineWidth',2,'Color',map(ii,:));
end
curr_resp = squeeze(mean(data{1,1}.Rec_resp,1));
curr_coord = E(1:3,:)*curr_resp(:,1:stimuli_on);
plot3(curr_coord(1,:),curr_coord(2,:),curr_coord(3,:),'b','LineWidth',4)
view([90 30 30]);
set (gcf,'Position',[0,0,1500,750]);
hold off
var = sum(d(end-2:end))./sum(d);
xlabel(strcat('variance:',num2str(var)));
legend([curve{:}],'A1B1RW','A1B1NW','A1B2RW','A1B2NW','A2B1RW','A2B1NW',...
    'A2B2RW','A2B2NW');
