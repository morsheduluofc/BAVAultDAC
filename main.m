
%This program is for BA-Vault and perform the following funcanalities:
%1. RPNorDataMeanVar() read random projected data from files,normalize the data
%   and then calculate the means and variance(Std) of every features 
%2. StatisticalCloseness() measures the statistical closeness of registration 
%   and verification data. It verify that RP and data normalization does
%   not change the closeness of registration and verification data.
%3. MeanStdToFiled() concatinate the mean and variance and moved them to the
%   range [0-65500] and construct locking and unlocking set 

%InData=load('data/features.mat');

addpath('./src/');
addpath('./sta/');
addpath('./data/');

%Normalize data and calculate mean and variance
[RMean,RStd,N1,VMean,VStd,N2]=RPNorDataMeanVar();
[RMeanRemv,RStdRemv,N1Remv,VMeanRemv,VStdRemv,N2Remv]=RPNorDataMeanVarRemv();

%Measure the statistical closeness of registration and verification data
%[AllPValue]=StatisticalCloseness(RMean,RStd,N1,VMean,VStd,N2);

%Concatinate and moved mean and variance to the range [0-65500] to
%construct locking and unlocking set 
[lockingSet,unlockingSet]=MeanStdToFiled(RMean,RStd,VMean,VStd);

%AllUniformDist=zeros(1,5);
%=================For all Vlid Claim======================

for uID=1:10 %user ID
secret='MDMORSHEDULISLAMMDMORSHEDULISLAM'; %secret to hide
degree=length(secret)-1; %degree of the polynomial


%Lock the Vault
NumberOfChaff=180;
tic
vault=lockVault(secret,lockingSet(uID,:),NumberOfChaff,N1(1,uID));
toc
%[vault,fp]=lockVault(secret,lockingSet(uID,:),NumberOfChaff,N1(1,uID),mlockingSet(uID),slockingSet(uID));
%allFp(uID,:)=fp';
%disp(lockingSet(uID,:))



%Unlock the vault (both valid and invalid claim)
tic
recoverpoints=unlockVault(vault,unlockingSet(uID,:),degree,N1(1,uID),uID);
toc
%recoverpoints=unlockVault(vault,unlockingSet(uID,:),degree,N1(1,uID),mlockingSet(uID),slockingSet(uID));

%key2
%lockingSet(1,:)

trecoverdPoints=0;
for i=1:45
    for j=1:45
      if(recoverpoints(i,2)==lockingSet(uID,j))
      trecoverdPoints=trecoverdPoints+1;  
    end
    end
end
%fprintf('User Id: %d \n ',uID);
%fprintf('Recovered points: %d \n ',trecoverdPoints);
allrecoveredPoints(uID)=trecoverdPoints;
end
%allrecoveredPoints
%csvwrite('outputs/rPointsForTwoVSameX.csv',allrecoveredPoints);
%csvwrite('outputs/ValidRecoveredPointsTouch300.csv',allrecoveredPoints);
%csvwrite('outputs/featurePoints.csv',allFp);
%csvwrite('outputs/UniformityDAC.csv',AllUniformDist);


%{
%=================For all InVlid Claim======================
for uID=1:50 %user ID

for invClaim=1:1  
  invID = round((195-1).*rand(1,1) + 1); 
  while(uID==invID)
   invID = round((195-1).*rand(1,1) + 1); 
  end  
%fprintf('%d %d \n',uID,invID);

secret='MDMORSHEDULISLAMMDMORSHEDULISLAM'; %secret to hide
degree=length(secret)-1; %degree of the polynomial


%Lock the Vault
NumberOfChaff=150;
[count]=StatisticalClosenessInv(RMeanRemv,RStdRemv,N1Remv,uID,VMeanRemv,VStdRemv,N2Remv,invID);
vault=lockVault(secret,lockingSet(uID,:),NumberOfChaff,N1(1,uID));
%disp(lockingSet(uID,:))

%Unlock the vault invalid claim(same mean and std)
%recoverpoints=unlockVault(vault,unlockingSet(invID,:),degree,N1(1,invID),uID);
recoverpoints=unlockVault(vault,unlockingSet(invID,:),degree,N1(1,invID),uID);

%Unlock the vault invalid claim(different mean and std)
%mlockingSetI(uID)=mean(unlockingSet(invID,:));
%slockingSetI(uID)=std(unlockingSet(invID,:));
%Unlock the vault (both valid and invalid claim)
%recoverpoints=unlockVault(vault,unlockingSet(invID,:),degree,N1(1,invID),mlockingSetI(uID),slockingSetI(uID));

%key2
%lockingSet(1,:)

trecoverdPoints=0;
for i=1:45
    for j=1:45
    if(recoverpoints(i,2)==lockingSet(uID,j))
      trecoverdPoints=trecoverdPoints+1;  
    end
    end
end
%fprintf('Recovered points: %d \n ',trecoverdPoints);
%allrecoveredIPoints(uID,invClaim)=trecoverdPoints;
allrecoveredIPoints(uID,1)=count;
allrecoveredIPoints(uID,2)=trecoverdPoints;
end
end
%allrecoveredIPoints
%csvwrite('outputs/InValidRecoveredPointsTouch200.csv',allrecoveredIPoints)
csvwrite('outputs/ImpersonationDAC.csv',allrecoveredIPoints);

%}