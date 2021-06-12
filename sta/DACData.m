
%{
%-----------------------------------------------------------------
% Analysis all DAC data based on SRRP, RPSR and mean and variance
% First set of (3) tests is for valid claim. 
% Second set of (3) test is for invlaid claim.
% Considering 2/3 decimal place precision
%----------------------------------------------------------------
rSRData=readtable('data/randomRegDataSRRP.csv');
vSRData= readtable('data/randomVerDataSRRP.csv');
rData=readtable('data/randomRegDataRP.csv');
vData= readtable('data/randomVerDataRP.csv');
dataIndx=csvread('data/allUserIndxRP.csv');



%----Start All valid claims-------
%statistical test for  SRRP data
%finaPValueSR=StatisticalClosenessSRRP(rSRData,vSRData,dataIndx);

%statical test for RPSR data 
%finaPValue=StatisticalClosenessRPSR(rData,vData,dataIndx);

%statical test for RPSR data. Only Mean and Variance of data 
%finaPValueMV=StatisticallyClosenessMV(rData,vData,dataIndx);
%----End All valid claims-------


%----Start All invalid claims-------
%statistical test for  SRRP data
%finaPValueSRInvalid=StatisticalClosenessSRRPInvalid(rSRData,vSRData,dataIndx);

%statical test for RPSR data 
%finaPValue=StatisticalClosenessRPSRInvalid(rData,vData,dataIndx);

%statical test for RPSR data. Only Mean and Variance of data 
%finaPValueMV=StatisticallyClosenessMVInvalid(rData,vData,dataIndx);

%----End All invalid claims-------


%finaPValueSR-finaPValue
%{
for i=1:195
for j=2:46    
%allMean(i,j-1)=mean(rSRData(dataIndx(i)/2+1:dataIndx(i+1)/2,j));
[h,p] = ttest(table2array(rData(dataIndx(i)/2+1:dataIndx(i+1)/2,j)),table2array(vData(dataIndx(i)/2+1:dataIndx(i+1)/2,j)));
TTest(i,j-1)=p;
%allVer(i,j-1)=var(rSRData(dataIndx(i)/2+1:dataIndx(i+1)/2,j));
end
end
%}

%{
for i=1:195
    minData=mean(allMean(i,:));
    maxData=max(allMean(i,:));
    Mrange(i)=maxData-minData;
    
    minData=mean(allVer(i,:));
    maxData=max(allVer(i,:));
    Vrange(i)=maxData-minData;
    
end
max(Mrange)
max(Vrange)
%}
%max(max(allMean))
%min(min(allMean))
%max(max(allVer))
%min(min(allVer))

function final_p_value =StatisticalClosenessSRRP(rData1,vData1,dataIndx1)
for i=1:195
for j=2:46    
[ht,pt] = ttest2(table2array(rData1(dataIndx1(i)/2+1:dataIndx1(i+1)/2,j)),table2array(vData1(dataIndx1(i)/2+1:dataIndx1(i+1)/2,j)));
ptValue(i,j-1)=pt;

[hf,pf] = vartest2(table2array(rData1(dataIndx1(i)/2+1:dataIndx1(i+1)/2,j)),table2array(vData1(dataIndx1(i)/2+1:dataIndx1(i+1)/2,j)));
pfValue(i,j-1)=pf;

%final_p_value(i,j-1) = pt;
if( fisher_pvalue_meta_analysis([pt,pf])<0.05)
    final_p_value(i,j-1) =0.0;
else
   final_p_value(i,j-1)=fisher_pvalue_meta_analysis([pt,pf]); 
end
end
end
end


function final_p_value =StatisticalClosenessRPSR(rData1,vData1,dataIndx1)

for j=2:46
    minimum(j-1)=min(table2array(rData1(:,j)));
    maximum(j-1)=max(table2array(rData1(:,j)));
end

for j=2:46
    rDataR(:,j)=(table2array(rData1(:,j))-minimum(j-1))/(maximum(j-1)-minimum(j-1));
    vDataR(:,j)=(table2array(vData1(:,j))-minimum(j-1))/(maximum(j-1)-minimum(j-1));
end

rDataR(:,j)=round(rDataR(:,j),3);
vDataR(:,j)=round(vDataR(:,j),3);

%SaprDataR(:,j)=round(rDataR(:,j),3);
%SampvDataR(:,j)=round(vDataR(:,j),3);

for i=1:195
for j=2:46    
[ht,pt] = ttest2(rDataR(dataIndx1(i)/2+1:dataIndx1(i+1)/2,j),vDataR(dataIndx1(i)/2+1:dataIndx1(i+1)/2,j));
ptValue(i,j-1)=pt;

[hf,pf] = vartest2(rDataR(dataIndx1(i)/2+1:dataIndx1(i+1)/2,j),vDataR(dataIndx1(i)/2+1:dataIndx1(i+1)/2,j));
pfValue(i,j-1)=pf;

%final_p_value(i,j-1) = pt;
if( fisher_pvalue_meta_analysis([pt,pf])<0.05)
    final_p_value(i,j-1) =0.0;
else
   final_p_value(i,j-1)=fisher_pvalue_meta_analysis([pt,pf]); 
end
end
end
end


function final_p_value=StatisticallyClosenessMV(rData1,vData1,dataIndx1)

for ui=1:195
stIndx= dataIndx1(1,ui)/2+1; 
endIndx=dataIndx1(1,ui+1)/2;

rDatat=rData1(stIndx:endIndx,2:46);
vDatat=vData1(stIndx:endIndx,2:46);


for fi=1:45
%load 'examgrades.mat'
%data1=cellfun(@str2num,table2array(rData(:,fi)));
%data2=cellfun(@str2num,table2array(vData(:,fi)));
data1=table2array(rDatat(:,fi));
data2=table2array(vDatat(:,fi));
[N1,M1] = size(data1);
[N2,M2] = size(data2);

Amean =mean(data1); 
Asd=std(data1);
%Asd=Asd*Asd;
Bmean=round(mean(data2),2);
Bsd=round(std(data2),2);
%Bsd=Bsd*Bsd;
%AllRMean(ui,fi)=Amean;
%AllRVer(ui,fi)=Asd;
%AllRMean(ui,fi)=Bmean;
%AllRVer(ui,fi)=Bsd;
%normality test
%[h,p]=kstest(data1);
%fprintf('%d ',h)

if(Asd ~=0 ||Bsd ~=0)
%%Manually test F-test
[h3,p3,ci3,stat3]=vartest2U(power(Asd,2),N1-1,power(Bsd,2),N2-1);
%p3
%Manually test t-test


%v = N1+N2-2;
v1=((Asd^2)/N1+(Bsd^2)/N2)^2;
v2=((((Asd^2)/N1)^2)/(N1-1))+((((Bsd^2)/N2)^2)/(N2-1));
v=v1/v2;
tval = (Amean-Bmean) / (sqrt((Asd^2)/N1+(Bsd^2)/N2));       % Calculate T-Statistic

tdist2T = @(t,v) (1-betainc(v/(v+t^2),v/2,0.5));    % 2-tailed t-distribution
tdist1T = @(t,v) 1-(1-tdist2T(t,v))/2;              % 1-tailed t-distribution

tprob = 1-[tdist2T(tval,v)  tdist1T(tval,v)];
p4=tprob(1);

inp1=[p3,p4];
%Fisher's method to combine p-value
final_p_value2 = fisher_pvalue_meta_analysis(inp1);
%X=['Pvalue',num2str(fi),':  ',num2str(final_p_value2)];
%disp(X);
final_p_value(ui,fi)=round(final_p_value2,2);
end %end if
%if final_p_value2>0.25
%fprintf('%f ',final_p_value2)
%else
% fprintf('0 ')   
%end
end
%fprintf('\n');
%scatter(AllRMean(ui,:),AllRVer(ui,:));
%hold on
end
%final_p_value=0;
end

function final_p_value =StatisticalClosenessSRRPInvalid(rData1,vData1,dataIndx1)
for i=1:195
for invalid=1:5    
r = round((195-1).*rand(1000,1) + 1); 
if(r~=i)
for j=2:46    
[ht,pt] = ttest2(table2array(rData1(dataIndx1(i)/2+1:dataIndx1(i+1)/2,j)),table2array(vData1(dataIndx1(r)/2+1:dataIndx1(r+1)/2,j)));
ptValue(i,j-1)=pt;

[hf,pf] = vartest2(table2array(rData1(dataIndx1(i)/2+1:dataIndx1(i+1)/2,j)),table2array(vData1(dataIndx1(r)/2+1:dataIndx1(r+1)/2,j)));
pfValue(i,j-1)=pf;

%final_p_value(i,j-1) = pt;
if( fisher_pvalue_meta_analysis([pt,pf])<0.05)
    final_p_value(i,j-1) =0.0;
else
   final_p_value(i,j-1)=fisher_pvalue_meta_analysis([pt,pf]); 
end
end
end
end
end
end

function final_p_value =StatisticalClosenessRPSRInvalid(rData1,vData1,dataIndx1)

for j=2:46
    minimum(j-1)=min(table2array(rData1(:,j)));
    maximum(j-1)=max(table2array(rData1(:,j)));
end

for j=2:46
    rDataR(:,j)=(table2array(rData1(:,j))-minimum(j-1))/(maximum(j-1)-minimum(j-1));
    vDataR(:,j)=(table2array(vData1(:,j))-minimum(j-1))/(maximum(j-1)-minimum(j-1));
end

rDataR(:,j)=round(rDataR(:,j),3);
vDataR(:,j)=round(vDataR(:,j),3);

%SaprDataR(:,j)=round(rDataR(:,j),3);
%SampvDataR(:,j)=round(vDataR(:,j),3);

for i=1:195
for invalid=1:5    
r = round((195-1).*rand(1000,1) + 1); 
if(r~=i)
for j=2:46    
[ht,pt] = ttest2(rDataR(dataIndx1(i)/2+1:dataIndx1(i+1)/2,j),vDataR(dataIndx1(r)/2+1:dataIndx1(r+1)/2,j));
ptValue(i,j-1)=pt;

[hf,pf] = vartest2(rDataR(dataIndx1(i)/2+1:dataIndx1(i+1)/2,j),vDataR(dataIndx1(r)/2+1:dataIndx1(r+1)/2,j));
pfValue(i,j-1)=pf;

%final_p_value(i,j-1) = pt;
if( fisher_pvalue_meta_analysis([pt,pf])<0.05)
    final_p_value(i,j-1) =0.0;
else
   final_p_value(i,j-1)=fisher_pvalue_meta_analysis([pt,pf]); 
end
end
end
end
end
end


function final_p_value=StatisticallyClosenessMVInvalid(rData1,vData1,dataIndx1)

for ui=1:195
stIndx= dataIndx1(1,ui)/2+1; 
endIndx=dataIndx1(1,ui+1)/2;
rDatat=rData1(stIndx:endIndx,2:46);

for invalid=1:5    
r = round((195-1).*rand(1000,1) + 1); 
if(r~=ui)
stIndxr= dataIndx1(1,r)/2+1; 
endIndxr=dataIndx1(1,r+1)/2;
vDatat=vData1(stIndxr:endIndxr,2:46);

for fi=1:45
%load 'examgrades.mat'
%data1=cellfun(@str2num,table2array(rData(:,fi)));
%data2=cellfun(@str2num,table2array(vData(:,fi)));
data1=table2array(rDatat(:,fi));
data2=table2array(vDatat(:,fi));
[N1,M1] = size(data1);
[N2,M2] = size(data2);

Amean =mean(data1); 
Asd=std(data1);
%Asd=Asd*Asd;
Bmean=round(mean(data2),2);
Bsd=round(std(data2),2);
%Bsd=Bsd*Bsd;
%AllRMean(ui,fi)=Amean;
%AllRVer(ui,fi)=Asd;
%AllRMean(ui,fi)=Bmean;
%AllRVer(ui,fi)=Bsd;
%normality test
%[h,p]=kstest(data1);
%fprintf('%d ',h)

if(Asd ~=0 ||Bsd ~=0)
%%Manually test F-test
[h3,p3,ci3,stat3]=vartest2U(power(Asd,2),N1-1,power(Bsd,2),N2-1);
%p3
%Manually test t-test


%v = N1+N2-2;
v1=((Asd^2)/N1+(Bsd^2)/N2)^2;
v2=((((Asd^2)/N1)^2)/(N1-1))+((((Bsd^2)/N2)^2)/(N2-1));
v=v1/v2;
tval = (Amean-Bmean) / (sqrt((Asd^2)/N1+(Bsd^2)/N2));       % Calculate T-Statistic

tdist2T = @(t,v) (1-betainc(v/(v+t^2),v/2,0.5));    % 2-tailed t-distribution
tdist1T = @(t,v) 1-(1-tdist2T(t,v))/2;              % 1-tailed t-distribution

tprob = 1-[tdist2T(tval,v)  tdist1T(tval,v)];
p4=tprob(1);

inp1=[p3,p4];
%Fisher's method to combine p-value
final_p_value2 = fisher_pvalue_meta_analysis(inp1);
%X=['Pvalue',num2str(fi),':  ',num2str(final_p_value2)];
%disp(X);
final_p_value(ui,fi)=round(final_p_value2,2);
end %end if
%if final_p_value2>0.25
%fprintf('%f ',final_p_value2)
%else
% fprintf('0 ')   
%end
end
%fprintf('\n');
%scatter(AllRMean(ui,:),AllRVer(ui,:));
%hold on
end
end
end
%final_p_value=0;
end
%}