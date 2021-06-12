

function [RMean,RStd,N1,VMean,VStd,N2]=RPDataMeanVar()
%DataRPSP(): 
%    Read random projected registation and verification data  
%    Normalize the data and move them in between 0-1
%    Calculate the means and variance(Std) of every features 
%    Return: both mean and variance of registation and verification data

%read random projected registration and verification data
rRPData=readtable('data/randomRegDataRP.csv');
vRPData= readtable('data/randomVerDataRP.csv');
dataIndx=csvread('data/allUserIndxRP.csv');


%calculate min and max valur of every features
minValue=zeros();
for j=2:46
    minValue(j-1)=min(table2array(rRPData(:,j)));
    maxValue(j-1)=max(table2array(rRPData(:,j)));
end

for j=2:46
    rDataR(:,j)=(table2array(rRPData(:,j))-minValue(j-1))/(maxValue(j-1)-minValue(j-1));
    vDataR(:,j)=(table2array(vRPData(:,j))-minValue(j-1))/(maxValue(j-1)-minValue(j-1));
end

rDataR(:,j)=round(rDataR(:,j),3);
vDataR(:,j)=round(vDataR(:,j),3);

for uID=1:195
stIndx= dataIndx(1,uID)/2+1; 
endIndx=dataIndx(1,uID+1)/2;

rDatat=rDataR(stIndx:endIndx,2:46);
vDatat=vDataR(stIndx:endIndx,2:46);

for fi=1:45
    
data1=rDatat(:,fi);
data2=vDatat(:,fi);
[N1(uID),M1(uID)] = size(data1);
[N2(uID),M2(uID)] = size(data2);

RMean(uID,fi) =round(mean(data1),3); 
RStd(uID,fi)=round(std(data1),3);

VMean(uID,fi)=round(mean(data2),3);
VStd(uID,fi)=round(std(data2),3);
end
end
fprintf('RMean Max:%f, RMean Min:%f, RStd Max:%f, RStd Min:%f.\n',max(max(RMean)),min(min(RMean)),max(max(RStd)),min(min(RStd)));
fprintf('VMean Max:%f, VMean Min:%f, VStd Max:%f, VStd Min:%f.\n',max(max(VMean)),min(min(VMean)),max(max(VStd)),min(min(VStd)));

end
