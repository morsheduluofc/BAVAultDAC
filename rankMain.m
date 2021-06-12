
%This program is for BA-Vault and perform the following funcanalities:
%1. RPNorDataMeanVar() read random projected data from files,normalize the data
%   and then calculate the means and variance(Std) of every features 
%2. StatisticalCloseness() measures the statistical closeness of registration 
%   and verification data. It verify that RP and data normalization does
%   not change the closeness of registration and verification data.
%3. MeanStdToFiled() concatinate the mean and variance and moved them to the
%   range [0-65500] and construct locking and unlocking set 

addpath('./src/');
addpath('./sta/');
addpath('./data/');

%Normalize data and calculate mean and variance
[RMean,RStd,N1,VMean,VStd,N2]=RPNorDataMeanVar();


%Measure the statistical closeness of registration and verification data
[AllPValue]=StatisticalCloseness(RMean,RStd,N1,VMean,VStd,N2);

%Concatinate and moved mean and variance to the range [0-65500] to
%construct locking and unlocking set 
[lockingSet,unlockingSet]=MeanStdToFiled(RMean,RStd,VMean,VStd);

%range=RangeofFDist(lockingSet);

%=================For all Vlid Claim======================

for uID=1:1%user ID
secret='MDMORSHEDULISLAMMDMORSHEDULISLAM'; %secret to hide
degree=length(secret)-1; %degree of the polynomial

%VMean(uID,:)
%VStd(uID,:)
%unlockingSet(uID,:)

%Lock the Vault
NumberOfChaff=180;
vault=lockVault(secret,lockingSet(uID,:),NumberOfChaff,N1(1,uID));
%[vault,fp]=lockVault(secret,lockingSet(uID,:),NumberOfChaff,N1(1,uID),mlockingSet(uID),slockingSet(uID));
%allFp(uID,:)=fp';
%disp(lockingSet(uID,:))



%Unlock the vault (both valid and invalid claim)
noOfSolution=5;
recoverpoints=rankUnlockVault(vault,unlockingSet(uID,:),degree,N1(1,uID),uID,noOfSolution);
%recoverpoints=unlockVault(vault,unlockingSet(uID,:),degree,N1(1,uID),mlockingSet(uID),slockingSet(uID));

%key2
%lockingSet(1,:)



for solution=1:noOfSolution
trecoverdPoints=0;
for i=1:45
    for j=1:45
    if(recoverpoints(45*(solution-1)+i,2)==lockingSet(uID,j))
     %if(recoverpoints(i,2)==lockingSet(uID,j))
      trecoverdPoints=trecoverdPoints+1;  
    end
    end
end
allrecoveredPoints(uID,solution)=trecoverdPoints;
end

allrecoveredPoints

index=1;
recoverpointsStatus=zeros(45*solution,1);
for solution=1:noOfSolution
trecoverdPoints=0;
for i=1:45
    for j=1:45
    if(recoverpoints(45*(solution-1)+i,2)==lockingSet(uID,j))
        actualRecoveredPoints(uID,index)=lockingSet(uID,j);
        recoverpointsStatus(45*(solution-1)+i,1)=1;
        index=index+1;
    end
    end
end
allrecoveredPoints(uID,solution)=numel(unique(actualRecoveredPoints(uID,:))>0);
end
recoverpoints=[recoverpoints,recoverpointsStatus];

a=recoverpoints(:,:)';
a=a(2,:)+","+a(3,:);
xx = unique(a);       % temp vector of vals
x = sort(a);          % sorted input aligns with temp (lowest to highest)
t = zeros(size(xx)); % vector for freqs
[m,n]=size(xx);
xxx = zeros(2,n);
%st = zeros(size(xx));
% frequency for each value
for i = 1:length(xx)
    t(i) = sum(x == xx(i));
    xxx(:,i)=split(xx(i),',');
    st(i)=recoverpoints(find(recoverpoints(:,2)==xxx(1,i) & recoverpoints(:,3)==xxx(2,i),1),4);
    %st(i)=recoverpoints(find(recoverpoints(:,2)==xx(i),1),4);
end

answer=[xxx(1,:);xxx(2,:);st;t]';
sortrows(answer,-4);

%{
a=recoverpoints(:,2)';
xx = unique(a);       % temp vector of vals
x = sort(a);          % sorted input aligns with temp (lowest to highest)
t = zeros(size(xx)); % vector for freqs
st = zeros(size(xx));
% frequency for each value
for i = 1:length(xx)
    t(i) = sum(x == xx(i));
    st(i)=recoverpoints(find(recoverpoints(:,2)==xx(i),1),4);
end
answer=[xx;t;st]';
sortrows(answer,-2)
%}
end
%csvwrite('outputs/rPointsForVClaimInv.csv',allrecoveredPoints);
%csvwrite('outputs/featurePoints.csv',allFp);
%}


%=================For all InVlid Claim======================
%{
for uID=1:5 %user ID

for invClaim=1:1  
  invID = round((195-1).*rand(1,1) + 1); 
  while(uID==invID)
   invID = round((195-1).*rand(1,1) + 1); 
  end  
%fprintf('%d %d \n',uID,invID);

secret='MDMORSHEDULISLAMMDMORSHEDULISLAM'; %secret to hide
degree=length(secret)-1; %degree of the polynomial


%Lock the Vault
NumberOfChaff=180;
vault=lockVault(secret,lockingSet(uID,:),NumberOfChaff,N1(1,uID));
%disp(lockingSet(uID,:))

%Unlock the vault invalid claim(same mean and std)
%recoverpoints=unlockVault(vault,unlockingSet(invID,:),degree,N1(1,invID),uID);
noOfSolution=5;
recoverpoints=rankUnlockVault(vault,unlockingSet(invID,:),degree,N1(1,invID),uID,noOfSolution);

%Unlock the vault invalid claim(different mean and std)
%mlockingSetI(uID)=mean(unlockingSet(invID,:));
%slockingSetI(uID)=std(unlockingSet(invID,:));
%Unlock the vault (both valid and invalid claim)
%recoverpoints=unlockVault(vault,unlockingSet(invID,:),degree,N1(1,invID),mlockingSetI(uID),slockingSetI(uID));

%key2
%lockingSet(1,:)


for solution=1:noOfSolution
trecoverdPoints=0;
for i=1:45
    for j=1:45
    if(recoverpoints(45*(solution-1)+i,2)==lockingSet(uID,j))
     %if(recoverpoints(i,2)==lockingSet(uID,j))
      trecoverdPoints=trecoverdPoints+1;  
    end
    end
end
%fprintf('Recovered points: %d \n ',trecoverdPoints);

%allrecoveredPoints(uID)=trecoverdPoints;
allrecoveredPoints(uID,solution)=trecoverdPoints;
end
end
%allrecoveredPoints

%{
index=1;
for solution=1:noOfSolution
for i=1:45
    for j=1:45
    if(recoverpoints(45*(solution-1)+i,2)==lockingSet(uID,j))
        actualRecoveredPoints(uID,index)=lockingSet(uID,j);
        index=index+1;
    end
    end
end
allrecoveredPoints(uID,solution)=numel(unique(actualRecoveredPoints(uID,:))>0);
end
end
%}

end
allrecoveredPoints

%csvwrite('outputs/rPointsForInvClaimInv.csv',allrecoveredPoints)
%}

%{
%=================Attacker drop that are not close======================

for uID=1:1 %user ID

for invClaim=1:1  
  invID = round((195-1).*rand(1,1) + 1); 
  while(uID==invID)
   invID = round((195-1).*rand(1,1) + 1); 
  end  
%fprintf('%d %d \n',uID,invID);

secret='MDMORSHEDULISLAMMDMORSHEDULISLAM'; %secret to hide
degree=length(secret)-1; %degree of the polynomial


%Lock the Vault
NumberOfChaff=180;
vault=lockVault(secret,lockingSet(uID,:),NumberOfChaff,N1(1,uID));
%disp(lockingSet(uID,:))

noOfSolution=5;
recoverpoints=rankUnlockVault(vault,unlockingSet(invID,:),degree,N1(1,invID),uID,noOfSolution);


for solution=1:noOfSolution
trecoverdPoints=0;
for i=1:45
    for j=1:45
    if(recoverpoints(45*(solution-1)+i,2)==lockingSet(uID,j))
     %if(recoverpoints(i,2)==lockingSet(uID,j))
      trecoverdPoints=trecoverdPoints+1;  
    end
    end
end
allrecoveredPoints(uID,solution)=trecoverdPoints;
end

allrecoveredPoints

index=1;
recoverpointsStatus=zeros(45*solution,1);
for solution=1:noOfSolution
trecoverdPoints=0;
for i=1:45
    for j=1:45
    if(recoverpoints(45*(solution-1)+i,2)==lockingSet(uID,j))
        actualRecoveredPoints(uID,index)=lockingSet(uID,j);
        recoverpointsStatus(45*(solution-1)+i,1)=1;
        index=index+1;
    end
    end
end
allrecoveredPoints(uID,solution)=numel(unique(actualRecoveredPoints(uID,:))>0);
end
end

recoverpoints=[recoverpoints,recoverpointsStatus];
a=recoverpoints(:,:)';
a=a(2,:)+","+a(3,:);
xx = unique(a);       % temp vector of vals
x = sort(a);          % sorted input aligns with temp (lowest to highest)
t = zeros(size(xx)); % vector for freqs
[m,n]=size(xx);
xxx = zeros(2,n);
%st = zeros(size(xx));
% frequency for each value
for i = 1:length(xx)
    t(i) = sum(x == xx(i));
    xxx(:,i)=split(xx(i),',');
    st(i)=recoverpoints(find(recoverpoints(:,2)==xxx(1,i) & recoverpoints(:,3)==xxx(2,i),1),4);
    %st(i)=recoverpoints(find(recoverpoints(:,2)==xx(i),1),4);
end

answer=[xxx(1,:);xxx(2,:);st;t]';
sortrows(answer,-3)

%{
a=recoverpoints(:,2)';
xx = unique(a);       % temp vector of vals
x = sort(a);          % sorted input aligns with temp (lowest to highest)
t = zeros(size(xx)); % vector for freqs
st = zeros(size(xx));
% frequency for each value
for i = 1:length(xx)
    t(i) = sum(x == xx(i));
    st(i)=recoverpoints(find(recoverpoints(:,2)==xx(i),1),4);
end
answer=[xx;t;st]';
sortrows(answer,-2)
%numel(xx)
%}
end
%allrecoveredPoints
%csvwrite('outputs/rPointsForInvClaimInv.csv',allrecoveredPoints)
%}