%show the locking set and chaff points in a graph
lockingSet= projpoints.x;
chaffSet=chaffs.x;
xl=lockingSet(:,1);
yl=lockingSet(:,2);
xc=chaffSet(:,1);
yc=chaffSet(:,2);

 plot(xl,yl,'o');
 hold on;
 plot(xc,yc,'.');
 xlim([0,65535]);
 ylim([0,65535]);
 %legend('legitimate points')
legend('legitimate points','chaff points')
%histfit(xl,10);
%xlim([0,65535]);
%xlabel('x_i');
%ylabel('f(x_i)');
%xlabel('feature points x_i');
%ylabel('Frequency of x_i');
%[fi,xi]=ksdensity(xl);
%figure
%plot(xi,fi);
%plot(h);
%sort points and merge chaffs with points
mtrx=[ projpoints; chaffs ];
%vault = gf(mtrx.x,field);
vault = gf(sortrows(mtrx.x),field);