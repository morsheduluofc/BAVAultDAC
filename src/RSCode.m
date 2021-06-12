function Ply = RSCode(secret,field,degree)
% GENPOLY() takes a secret (ASCII) and a specified finite field,
% generating a polynomial from the secret by using segments of
% the secret as coefficients.
% PARAMETERS:
%	secret ---
%   field --- exponent of field degree, i.e. GF(2^field)
%   degree --- degree of polynomial

% define tolerance for adequate length-checks
tolerance = 1;

% ==== Run reed-solomon encoder on secret =====
secretmsg = gf(double(secret),field); % e.g. gf(key,16)

%Ply=msgKey;
%check to see if degree is large enough:
if ((degree + 1 - length(secretmsg)) < tolerance)
	error('Degree and key length mismatched');
else
	Ply = rsenc(secretmsg,(degree+1),length(secretmsg));
end
%length(Ply)
%P = rsenc(msgKey,(degree+1),length(msgKey));
end

