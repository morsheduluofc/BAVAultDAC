
addpath('./src/');
addpath('./sta/');
addpath('./data/');

%Normalize data and calculate mean and variance
[RMean,RStd,n1,VMean,VStd,n2]=RPNorDataMeanVar();


%MatchingMeanVar(RMean,RStd,N1,VMean,VStd,N2);


%Measure the statistical closeness of registration and verification data
totalUsers=195;
totalFeatures=45;
AllPValue=zeros(totalUsers,totalFeatures);

for uID=1:totalUsers
 for aID=1:totalUsers  
  finalF=0;  
 for fi=1:totalFeatures
 RIndMean=RMean(uID,fi);
 RIndStd=RStd(uID,fi);
 VIndMean=RMean(aID,fi);
 VIndStd=RStd(aID,fi);
 N1=n1(uID);
 N2=n2(aID);

 if(RIndStd ~=0 ||VIndStd ~=0)
 
 %F-test (call the funcation vartest2U())
 [h3,p3,ci3,stat3]=vartest2U(power(RIndStd,2),N1-1,power(VIndStd,2),N2-1);
 %p3
 
 
 %t-test (all code here)
 %v = N1+N2-2;
 v1=((RIndStd^2)/N1+(VIndStd^2)/N2)^2;
 v2=((((RIndStd^2)/N1)^2)/(N1-1))+((((VIndStd^2)/N2)^2)/(N2-1));
 v=v1/v2;
 tval = (RIndMean-VIndMean) / (sqrt((RIndStd^2)/N1+(VIndStd^2)/N2));       % Calculate T-Statistic

 tdist2T = @(t,v) (1-betainc(v/(v+t^2),v/2,0.5));    % 2-tailed t-distribution
 tdist1T = @(t,v) 1-(1-tdist2T(t,v))/2;              % 1-tailed t-distribution

 tprob = 1-[tdist2T(tval,v)  tdist1T(tval,v)];
 p4=tprob(1);

 %combine both p-values
 inp1=[p3,p4];
 
 %Fisher's method to combine p-value
 final_p_value2 = fisher_pvalue_meta_analysis(inp1);
 %X=['Pvalue',num2str(fi),':  ',num2str(final_p_value2)];
 %disp(X);
 AllPValue(uID,fi)=round(final_p_value2,3);
 finalF=finalF+final_p_value2;
end 
 end
AllFFValue(uID,aID)=finalF;
end
end

csvwrite('outputs/ClosedProfile.csv',AllFFValue)

%Concatinate and moved mean and variance to the range [0-65500] to
%construct locking and unlocking set 
%[lockingSet,unlockingSet]=MeanStdToFiled(RMean,RStd,VMean,VStd);
%[lockingSet,unlockingSet,mlockingSet,slockingSet]=MeanStdToFiled(RMean,RStd,VMean,VStd);