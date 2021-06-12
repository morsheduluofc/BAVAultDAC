function range=RangeofFDist(data)
[m,n]=size(data);
for i=1:m
    minD=min(data(i,:));
    maxD=max(data(i,:));
    range(i)=maxD-minD;
end

end