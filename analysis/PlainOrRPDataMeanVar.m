function [RMean,RStd,N1,VMean,VStd,N2]=PlainOrRPDataMeanVar()
%DataRPSP(): 
%    Read random projected registation and verification data  
%    Normalize the data and move them in between 0-1
%    Calculate the means and variance(Std) of every features 
%    Return: both mean and variance of registation and verification data

addpath('../src/');
addpath('../sta/');
addpath('../data/');

%read registration and verification data
rRPData=readtable('data/randomRegData.csv');
vRPData= readtable('data/randomVerData.csv');

%read random projected registration and verification data
%rRPData=readtable('data/randomRegDataRP.csv');
%vRPData= readtable('data/randomVerDataRP.csv');

dataIndx=csvread('data/allUserIndxRP.csv');

totalUsers=195;
totalFeatures=45;
[Nr,Mr]=size(rRPData);
[Nv,Mv]=size(vRPData);

rRPData2=table2array(rRPData(1:Nr,2:totalFeatures+1));
vRPData2=table2array(vRPData(1:Nv,2:totalFeatures+1));
    
    
%calculate the mean and std of every feature
N1=zeros(1,totalUsers);
N2=zeros(1,totalUsers);
RMean=zeros(totalUsers,totalFeatures);
VMean=zeros(totalUsers,totalFeatures);
RStd=zeros(totalUsers,totalFeatures);
VStd=zeros(totalUsers,totalFeatures);

for uID=1:totalUsers
stIndx= dataIndx(1,uID)/2+1; 
endIndx=dataIndx(1,uID+1)/2;

%seperate a user's data
trDatat= rRPData2(stIndx:endIndx,1:totalFeatures);
tvDatat= vRPData2(stIndx:endIndx,1:totalFeatures);

for fi=1:totalFeatures
data1=trDatat(:,fi);
data2=tvDatat(:,fi);
[N1(uID),M1(uID)] = size(data1);
[N2(uID),M2(uID)] = size(data2);

RMean(uID,fi) =round(mean(data1),3); 
RStd(uID,fi)=round(std(data1),3);

VMean(uID,fi)=round(mean(data2),3);
VStd(uID,fi)=round(std(data2),3);
end
end
%fprintf('RMean Max:%f, RMean Min:%f, RStd Max:%f, RStd Min:%f.\n',max(max(RMean)),min(min(RMean)),max(max(RStd)),min(min(RStd)));
%fprintf('VMean Max:%f, VMean Min:%f, VStd Max:%f, VStd Min:%f.\n',max(max(VMean)),min(min(VMean)),max(max(VStd)),min(min(VStd)));
%for u=1:12
u=1;
v=RStd(u,:);
m=RMean(u,:);
plot(m,v,'o');
xlim([0,0.35]);
ylim([0,0.17]);
xlabel('Mean');
ylabel('Std');
hold on;
%end
end

