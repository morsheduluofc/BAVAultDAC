function gftoDoubleMeanVariance(projpoints)

ddata=double(projpoints.x)
for i=1:length(ddata)
    mean(i)=round(double(idivide(ddata(i,1),int32(100)))/1000.0,3)
    var(i)=mod(ddata(i,1),100)/1000.0
end
 %AllData=[lmean,cver]
end