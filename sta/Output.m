rRPData=csvread('outputs/rPointsForVClaimInv.csv');
vRPData= csvread('outputs/rPointsForInvClaimInv.csv');
figure
boxplot([rRPData',vRPData],'Labels',{'Invalid claims','Valid claims'})
ylabel('recovered points');
ylim([0,45]);