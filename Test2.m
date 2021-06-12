%{
Fqmin=0;
Fqmax=65635;
%lockingset = (Fqmax-Fqmin).*rand(45,1) + Fqmin;
mu1=(10-3).*rand(1,1) + 3;
sigma1=(8-4).*rand(1,1) + 4;
lockingset = normrnd(mu1,sigma1,[45,1]);
%mu=mean(lockingset);
%sigma=std(lockingset);
mu2=mu1+(10-6).*rand(1,1) + 6;
sigma2=sigma1+(2-0.5).*rand(1,1) + 0.5;
Chaff1 = normrnd(mu2,sigma2,[80,1]);
%chaff1=(Fqmax-Fqmin).*rand(45,1) + Fqmin;
LocChaff1=[lockingset; Chaff1];
mu3=mean(LocChaff1);
sigma3=std(LocChaff1);
VChaff1=cdf('Normal',Chaff1,mean(Chaff1),std(Chaff1));
VLocChaff1=cdf('Normal',LocChaff1,mu3,sigma3);
%VLocChaff1=(((VLocChaff1-0)*65535)/1)+0;
InvVLocChaff1=norminv(VLocChaff1,mu3,sigma3);

Chaff2=rand(80,1);
VLocChaff2=[VLocChaff1;Chaff2];
InvVLocChaff2=norminv(VLocChaff2,mu3,sigma3);
mu4=mean(InvVLocChaff2);
sigma4=std(InvVLocChaff2);

subplot(3,3,1)
hist(lockingset);
%xlim([0,65535]);
xlabel(['mu=',num2str(mu1),', sigma=',num2str(sigma1)])
title('Legitimate points set (A)')

subplot(3,3,2)
hist(Chaff1);
xlabel(['mu=',num2str(mu2),', sigma=',num2str(sigma2)])
%xlim([0,65535]);
title('Chaff points set (C1)')

subplot(3,3,3)
hist(LocChaff1);
xlabel(['mu=',num2str(mu3),', sigma=',num2str(sigma3)])
%xlim([0,65535]);
title('Set A and C1')

subplot(3,3,4)
hist(VLocChaff1);
xlim([0,1]);
title('Inverse transform of A and C1')

subplot(3,3,5)
hist(1);
xlim([0,1]);


subplot(3,3,6)
hist(InvVLocChaff1);
xlabel(['mu=',num2str(mu3),', sigma=',num2str(sigma3)])
%xlim([0,1]);
title('Recover set A and C1')



subplot(3,3,7)
hist(VLocChaff2);
xlim([0,1]);
title('Vault')

subplot(3,3,8)
hist(1);
xlim([0,1]);

subplot(3,3,9)
hist(InvVLocChaff2);
xlabel(['mu=',num2str(mu4),', sigma=',num2str(sigma4)])
%xlim([0,1]);
%title('Vault')
title('Recover set A and C1?')
%}
%BoxPlot for diffferent P value (valid and invalid claim)

totalValidFeatures05HM20=csvread('outputs\ValidRecoveredPointsTouch100.csv');

totalValidFeatures10HM20=csvread('outputs\ValidRecoveredPointsTouch150.csv');

totalValidFeatures15HM20=csvread('outputs\ValidRecoveredPointsTouch200.csv');

totalValidFeatures20HM20=csvread('outputs\ValidRecoveredPointsTouch250.csv');

totalValidFeatures25HM20=csvread('outputs\ValidRecoveredPointsTouch300.csv');

 

 

totalInvalidFeatures05HM20=csvread('outputs\InValidRecoveredPointsTouch100.csv');

totalInvalidFeatures10HM20=csvread('outputs\InValidRecoveredPointsTouch150.csv');

totalInvalidFeatures15HM20=csvread('outputs\InValidRecoveredPointsTouch200.csv');

totalInvalidFeatures20HM20=csvread('outputs\InValidRecoveredPointsTouch250.csv');

totalInvalidFeatures25HM20=csvread('outputs\InValidRecoveredPointsTouch300.csv');

 



allAcceptFP=[totalValidFeatures05HM20;totalValidFeatures10HM20;totalValidFeatures15HM20;totalValidFeatures20HM20;totalValidFeatures25HM20];

allInvAcceptFP=[totalInvalidFeatures05HM20';totalInvalidFeatures10HM20';totalInvalidFeatures15HM20';totalInvalidFeatures20HM20';totalInvalidFeatures25HM20'];

%allInv=[totalValidFeatures05HM20;totalInvalidFeatures05HM20;totalValidFeatures10HM20;totalInvalidFeatures10HM20;totalValidFeatures15HM20;totalInvalidFeatures15HM20; totalValidFeatures20HM20;totalInvalidFeatures20HM20;totalValidFeatures25HM20;totalInvalidFeatures25HM20];
X=[100 150 200 250 300];
%aX=['0.05'; '0.05'; '0.10'; '0.10'; '0.15'; '0.15'; '0.20'; '0.20'; '0.25'; '0.25'];
%boxplot(allInv');

%set(gca,'xticklabel',aX);

boxplot(allAcceptFP',X);
hold on;
boxplot(allInvAcceptFP',X);

%xticks([-3*pi -2*pi -pi 0 pi 2*pi 3*pi])
%xticklabels({'-3\pi','-2\pi','-\pi','0','\pi','2\pi','3\pi'})
%xticks([0.1 0.2 0.3 0.4 0.5]);

ylim([0,45]);

xlabel('Total chaff points');

ylabel('Total recovered legitimate points');

%{
%FAR and FRR calculation
threshold=31;
FR=0;
[m1,n1]=size(allAcceptFP);
for i=1:m1
    for j=1:n1
    if (allAcceptFP(i,j)<threshold+1)
        FR=FR+1;
    end
    end
end
FRR=(FR/(n1*m1))*100

FA=0;
[m2,n2]=size(allInvAcceptFP);
for i=1:m2
    for j=1:n2
    if (allInvAcceptFP(i,j)>=threshold+1)
        FA=FA+1;
    end
    end
end
FAR=(FA/n2*m2)*100
%}
%{
meanStart=10;
meanEnd=88;
stdStart=2;
stdEnd=18;
count=1;
sum=0;
while (stdStart<stdEnd) 
    meanStart=11;
   %M=round((meanEnd-meanStart)/(stdStart*1.97*0.158));
   while(meanStart<=meanEnd)
   meanStart=meanStart +(stdStart*1.97*0.158) 
   
   %sum=sum+M;
   %disp(M);
   count=count+1;
   end
   stdStart=stdStart*sqrt(1.55);
   %count=count+1;
end
%}
%{
%DAC
meanStart=0.108;
meanEnd=0.875;
stdStart=0.001;
stdEnd=0.098;
count=0;
count2=0;
sum=0;
while (stdStart<stdEnd) 
    meanStart=0.108;
   M=round((meanEnd-meanStart)/(stdStart*1.97*0.158))
   while(meanStart<=meanEnd)
   meanStart=meanStart +(stdStart*1.97*0.158); 
   
   %sum=sum+M;
   %disp(M);
   count=count+1;
   end
   std111=stdStart;
   do=true;
   while(do)
   stdStart=stdStart*sqrt(1.54);
   do=((stdStart-std111)<0.001);
   end
   stdStart;
   count2=count2+1;
   %count=count+1;
end
%}

%{
%Touchalytics
meanStart=0.230;
meanEnd=0.820;
stdStart=0.001;
stdEnd=0.052;
count=0;
count2=0;
sum=0;
while (stdStart<stdEnd) 
   meanStart=0.230;
   M=round((meanEnd-meanStart)/(stdStart*1.97*0.158))
   while(meanStart<=meanEnd)
   meanStart=meanStart +(stdStart*1.97*0.081); 
   
   %sum=sum+M;
   %disp(M);
   count=count+1;
   end
   std111=stdStart;
   do=true;
   while(do)
   stdStart=stdStart*sqrt(1.21);
   do=((stdStart-std111)<0.001);
   end
   stdStart;
   count2=count2+1;
   %count=count+1;
end
%}
%{
x=0.11;
count=1;
while (x<=0.87)
    disp(x);
    x=x+0.015;
    count=count+1;
end
%}