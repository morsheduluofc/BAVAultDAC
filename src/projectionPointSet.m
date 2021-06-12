function values=projectionPointSet(points,Ply,field)

% initialize output to matrix of zeros in GF(2^field):
values = gf(zeros(length(points),1),field);

%define the polynomial degree
degree=length(Ply)-1;

%generate a square matrix [1 X X^2 X^3 ... X^N]
X = genPolyMatrix(points,degree,field);

% compute polynomial evaluations: return [1 X X^2 X^3 ... X^N] * P' ~ (M x 1)
for i=1:length(points)
    values(i)=X(i,:)*Ply';
end

end
