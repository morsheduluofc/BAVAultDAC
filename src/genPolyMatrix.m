function mtrx=genPolyMatrix(points,degree,field)

%generate dimensional parameter
M=length(points);
N=degree;

% generate square matrix [X X^2 X^3 ... X^N]:
X=gf(zeros(M,N),field);

for i=1:degree
    initialvaule=gf(ones(M,1),field);
    for j=1:i
      initialvaule=initialvaule.*points;  
    end
    X(:,i)=initialvaule;
end

%return a matrix
mtrx=[gf(ones(M,1),field) X];
end
