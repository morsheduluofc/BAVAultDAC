function [vault,xl]=chaffPoints(projpoints,poly,DEGREE,numChaffs,field,n1,mlockingSet,slockingSet)
%chaffPoints(): 
%    Input: locking set and their evaluation, polynomial, degree of the polynomial
%           number of chaff points, field size and size of input data
%    Randomly generate a chaff points in GF(2^16) and validate it     
%    Validation is based on statistical closenss and the constrain (y !=f(x))
%    Return: A vault with chaff points. A pairs are shuffled


%initialize set of chaff points to zeros
chaffs=gf(zeros(numChaffs,2),field);

%generate chaff points
counter=1;
while true
    rndPoint=gf(randi((2^field-1),1,2),field);
    %verify the constrains for chaff points
    decision=verifyConstrain(projpoints,poly,DEGREE,field,rndPoint,n1);
    if(decision) 
     chaffs(counter,:) = rndPoint; 
     counter=counter+1;
    end
    if (counter==numChaffs+1)
        break;
    end
end

  %===Begin Inverse transformation======
  %was range 0-65535 then become 0-1 then convert 0-65535
  %{
  rndPoint1=double(chaffs.x);
  rndPoint3=cdf('Normal',rndPoint1(:,1),mlockingSet,slockingSet);
  rndPoint4=uint16((((rndPoint3-0)*65535)/1)+0);
  chaffs=gf([rndPoint4,rndPoint1(:,2)],field);
  %}
  %===End Inverse transformation======
%show the locking set and chaff points in a graph

lockingSet= projpoints.x;
chaffSet=chaffs.x;
xl=lockingSet(:,1);
yl=lockingSet(:,2);
xc=chaffSet(:,1);
yc=chaffSet(:,2);
%{
plot(xl,yl,'o');
hold on;
plot(xc,yc,'.');
xlim([0,65535]);
ylim([0,65535]);
 %legend('legitimate points')
legend('legitimate points','chaff points')
%histfit(xl,10);
%xlim([0,65535]);
xlabel('Feature point x_i');
ylabel('Evaluation of feature points f(x_i)');
%xlabel('feature points x_i');
%ylabel('Frequency of x_i');
%[fi,xi]=ksdensity(xl);
%figure
%plot(xi,fi);
%plot(h);
%}
%sort points and merge chaffs with points
mtrx=[projpoints; chaffs ];
%vault = gf(mtrx.x,field);
vault = gf(sortrows(mtrx.x),field);
end