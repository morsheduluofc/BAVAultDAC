function coeffs = decodePolynomial(points,field,degree)
% DECODEPOLYNOMIAL() implements the matrix inversion algorithm
% to decode a degree-d polynomial from a set { (x,y) } of d+1
% coordinates over a field with degree specified by `field`.
% Returns a row vector of d+1 values over the field, representing a
% polynomial.
% TEST:
%	ply = gf([ 1 1 2 3 5 ],16);
%	X = gf([ 3 4 5 6 7 ]',16);
%	Y = evaluate(X,ply,16);
%	M = [ X Y ];
%	decodePolynomial(M,16,4);
%	ans =
%	GF(2^16) array. Primitive Polynomial = D^16+D^12+D^3+D+1 (decimal 69643)
%	Array elements = 
%   1   1   2   3   5


% add parent folder to path to use genPolyMatrix():
addpath('../');

% ===== 1. Form square matrix over GF composed of powers of points =====

% extract dimensions of points:
numPts = size(points,1);

% check to make sure degree & number of points match:
if (numPts <(degree+1))
	error('Error! Points and degree do not match.');
end

% create matrix of monomial terms [ 1 X X^2 ... X^degree ]:
gfMatrix = genPolyMatrix(points(:,1),degree,field);

% ===== 2. Invert matrix to get coefficients =====

% compute matrix inverse M^-1
gfInverse = inv(gfMatrix);

% ===== 3. Return coefficients of polynomial =====

% return coefficients as transpose of M^-1 * Y
%coeffs = (gfInverse \ points(:,2))';
coeffs = (gfInverse * points(:,2))';

end

% ================================================================

%gfMatrix = gf(zeros(numPts,(degree+1)),field);

% set first column to 1's:
%gfMatrix(:,1) = gf(ones(numPts,1),field);

% set coefficients to x^n for n = 1...degree -- CHECK THIS LOOP
%for idx=1:degree
%	monomialN = points(:,1);
	%monomialN = gf(ones(numPts,1),field);
%	for jdx=2:idx
%		monomialN = monomialN .* points(:,1);
%	end
%	gfMatrix(:,(idx+1)) = monomialN;
%end