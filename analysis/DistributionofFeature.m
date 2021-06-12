FPoints=readtable('outputs/featurePoints.csv');

%{
figure
for i=1:12
    points=table2array(FPoints(i,:));
    %[fi,xi,bw]=ksdensity(points,'Bandwidth',6553.5);
    [fi,xi,bw]=ksdensity(points);
    plot(xi,fi);
    xlim([0,65535]);
    bw
    hold on;
end
xlabel('Feature points x_i');
ylabel('Frequency of x_i');
title('Different bandwidth');
%}
%[fi,xi]=ksdensity(FPoints(:,1));
%plot(xi,fi);

points=table2array(FPoints(12,:));
Ctrs = [1637.5:3275:63862.5];
%Xcts = hist(points, Ctrs);
%figure(1)
%bar(Ctrs, Xcts)
%xlim([0, 65500]);
%ylim([0,12]);


figure
range=[0:1:65500];
for i=1:12
    points=table2array(FPoints(i,:));
    [fi,xi,bw]=ksdensity(points,range,'Bandwidth',3275);
    plot(xi,fi);
    xlim([0,65535]);
    %ylim([0,12]);
    hold on;
end


xlabel('Feature points x_i');
ylabel('Density of x_i');
%title('Different bandwidth');
