function statisticalAnalysisValid(RMean,RStd,N1,VMean,VStd,N2)

addpath('./src/');
addpath('./sta/');

%{
%============Before turncate==================
%Measure the statistical closeness of registration and verification data
max(max(RStd));
min(min(RStd));

max(max(VStd));
min(min(VStd));

%[AllPValue]=StatisticalCloseness(RMean,RStd,N1,VMean,VStd,N2);
%[AllPValue]=StatisticalClosenessAllPossible(RMean,RStd,N1,VMean,VStd,N2);

[rows,cols]=size(AllPValue);
counter=0;
for i=1:rows
    for j=1:cols
        if(AllPValue(i,j)>0.05)
            counter=counter+1;
        end
    end
end
bftpercentage= ((counter)/(rows*cols))*100;
fprintf('Percentage of features that pass the statistical test before turncate %f\n',bftpercentage);
%============End Before turncate==================
%}

%{
%============After turncate==================
%Measure the statistical closeness of registration and verification data

%percentage of Std that are lower than 0.1 (both registration and verification)
[rows,cols]=size(RStd);
counter=0;
for i=1:rows
    for j=1:cols
        if(RStd(i,j)<0.1)
            counter=counter+1;
        end
    end
end
%((counter)/(rows*cols))*100

[rows,cols]=size(VStd);
counter=0;
for i=1:rows
    for j=1:cols
        if(VStd(i,j)<0.1)
            counter=counter+1;
        end
    end
end
%((counter)/(rows*cols))*100

%Turncate the data
RMean=round(RMean,3);
VMean=round(VMean,3);
RStd=RStd*1000;
VStd=VStd*1000;
RStd=mod(RStd,100)/1000.0;
VStd=mod(VStd,100)/1000.0;



%Statistical test
[AllPValue]=StatisticalCloseness(RMean,RStd,N1,VMean,VStd,N2);

[rows,cols]=size(AllPValue);
counter=0;
for i=1:rows
    for j=1:cols
        if(AllPValue(i,j)>0.05)
            counter=counter+1;
        end
    end
end
bftpercentage= ((counter)/(rows*cols))*100;
fprintf('Percentage of features that pass the statistical testafter turncate %f\n',bftpercentage);
%============End turncate==================
%}


%============Turncate and Moved Range==================
%Turncate the data
%move all data three decimal place left (example: 0.876 -> 876.0)
%fprintf('%f  %f\n',RMean(101,11),RStd(101,11));
RMean=round(RMean,3);
VMean=round(VMean,3);
RStd=RStd*1000;
VStd=VStd*1000;
RStd=mod(RStd,100)/1000.0;
VStd=mod(VStd,100)/1000.0;

RMean=RMean*1000;
RStd=RStd*1000;
VMean=VMean*1000;
VStd=VStd*1000;
%fprintf('%f  %f\n',RMean(101,1),RStd(101,11));

%concatinate mean and std (example: (876.0. 75.0) -> 87600+75 -> 876175)
totalUsers=195;
totalFeatures=45;

for i=1:totalUsers
for j=1:totalFeatures
if(RStd(i,j)<100)
 lockingSet(i,j)=100*RMean(i,j)+RStd(i,j);
else
 lockingSet(i,j)=100*RMean(i,j)+mod(RStd(i,j),100);
end
if (VStd(i,j)<100)
unlockingSet(i,j)=100*VMean(i,j)+VStd(i,j);
else
unlockingSet(i,j)=100*VMean(i,j)+mod(VStd(i,j),100);
end
end
end
%fprintf('%f \n',lockingSet(101,11));

%moved range to [15000,80500]
for uID=1:totalUsers
 for j=1:totalFeatures
     if(lockingSet(uID,j)<15000)
         lockingSet(uID,j)=15000;
     end
     if(unlockingSet(uID,j)<15000)
         unlockingSet(uID,j)=15000;
     end
     
     if(lockingSet(uID,j)>80500)
         lockingSet(uID,j)=80500;
     end
     if(unlockingSet(uID,j)>80500)
         unlockingSet(uID,j)=80500;
     end
end
end

%moved range to [0,65500]
for uID=1:totalUsers
 for j=1:totalFeatures
     lockingSet(uID,j)=lockingSet(uID,j)-15000;
     unlockingSet(uID,j)=unlockingSet(uID,j)-15000;
end
end


%seperate the data
for i=1:totalUsers
 for j=1:totalFeatures
RMean(i,j)=round(double(idivide(lockingSet(i,j),int32(100)))/1000.0,3);
VMean(i,j)=round(double(idivide(unlockingSet(i,j),int32(100)))/1000.0,3);

RStd(i,j)=mod(lockingSet(i,j),100)/1000.0;
VStd(i,j)=mod(unlockingSet(i,j),100)/1000.0;
%fprintf('%f  %f\n',RMean(i,j),RStd(i,j));
 end
end 
%Statistical test
%[AllPValue]=StatisticalCloseness(RMean,RStd,N1,VMean,VStd,N1);
[AllPValue]=StatisticalClosenessAllPossible(RMean,RStd,N1,VMean,VStd,N2);

[rows,cols]=size(AllPValue);
counter=0;
for i=1:rows
    for j=1:cols
        if(AllPValue(i,j)>0.05)
            counter=counter+1;
        end
    end
end
bftpercentage= ((counter)/(rows*cols))*100;
fprintf('Percentage of features that pass the statistical test after turncate and range change %f\n',bftpercentage);
%============End =Turncate and Moved Range==================

end