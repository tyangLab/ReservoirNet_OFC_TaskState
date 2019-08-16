function get_selNeuron

global AR A Rand target_file
if exist([target_file(1:end-4),'_Max.mat'],'file')
    load([target_file(1:end-4),'_Max.mat']);
else
    [~,Max] = figure2c(target_file);
end
    
AR = zeros(size([Max.AR]));
A = zeros(size([Max.A]));
Rand = zeros(size([Max.A]));
for i = 1:size([Max.AR],1)
    temp = find(Max.AR(i,:)==1);
    a = randperm(sum(Max.AR(i,:)));
    temp(a(51:end)) = [];
    AR(i,temp)=1;
    
    temp2 = find(Max.A(i,:)==1);
    aa = randperm(sum(Max.A(i,:)));
    temp2(aa(51:end)) = [];
    A(i,temp2)=1;
    
    aaa = randperm(500);
    Rand(aaa(1:50))=1;    
end



