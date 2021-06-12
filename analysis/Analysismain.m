addpath('./src/');
addpath('./sta/');
addpath('./outputs/');

%Normality Test
%[pValueR, pValueV]=NormalityTest();


%Plain or RP data and calculate mean and variance
%[RMean,RStd,N1,VMean,VStd,N2]=PlainOrRPDataMeanVar();


%Normalize RP data and calculate mean and variance
[RMean,RStd,N1,VMean,VStd,N2]=RPNorDataMeanVar();

%Feature analysis:(i) before turncate, (ii)after turncate
%(ii) after turncate and change range
%statisticalAnalysisValid(RMean,RStd,N1,VMean,VStd,N2)%for valid claim

%statisticalAnalysisInValid(RMean,RStd,N1,VMean,VStd,N2) %for invalid claim
%}


rRPData=csvread('rPointsForVClaimInv.csv');
vRPData= csvread('rPointsForInvClaimInv.csv');

figure
boxplot([rRPData,vRPData'],'Labels',{'Invalid claims','Valid claims'})
ylabel('recovered points');
ylim([0,45]);
%title('Compare Random Data from Different Distributions')
