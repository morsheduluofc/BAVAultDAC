function recoveredValidData = unlockVault(vault,unlockingSet,DEGREE,n1)
% unlockVault()
%      Input: a vault, unlocking set, degree of the polynomial and size of input data
%      It compare all points of unlocking set with the points of vault and
%      gets a matrix of p-value. Transform the matrix to square matrix.
%      Apply the Hungarian method to get the optimal solution
%      Return:a pair of recovered points and their evaluation 
%

% add path to src folder:
addpath('./src/');
addpath('./sta/');
addpath('./data/');

%initialized row and columns
rows=length(vault);
cols=length(unlockingSet);

% work over GF(2^16):
FIELD = 16;
%unlocking set to GF(2^16)
unlockingSetF=gf(unlockingSet,FIELD);

% size of vault and unlocking set
vaultLength = length(vault);
numPts = length(unlockingSetF);

% initialize the coefficient in GF
coeffs = gf(zeros(1,(DEGREE+1)),FIELD);
%{
 %===Begin Inverse transformation======
 %was range 0-65535 then become 0-1 then convert 0-65535
 vp=double(vault.x);
 vpoint=(((vp(:,1)-1)*1)/65535)+0;
 vpoint=uint16(norminv(vpoint,mlockingSet,slockingSet));
 %vpoint=uint16((((vpoint-0)*65534)/1)+1);
 Fvpoint=gf(vpoint,16);
 allPValues=Matching1(Fvpoint,unlockingSetF,n1);

 
%===End Inverse transformation======
%}

allPValues=Matching1(vault(:,1),unlockingSetF,n1);

%Matching2: it used the HUNGARIAN method to get optimal solution
[costMatrix,totalCost]=Matching2(-allPValues);

%fprintf('Total cost: %f.\n',-totalCost);


% based on cost matrix seperate the recovered pair and their p-value
for i=1:rows
optimalP(i)=  allPValues(costMatrix(i),i);
optimalXValueF=vault(costMatrix(i),1);
optimalYValueF=vault(costMatrix(i),2);
optimalXValue(i)=double(optimalXValueF.x);
optimalYValue(i)=double(optimalYValueF.x);
%recoveredData=[FinalPvalues(costMatrix(i),i) vault(costMatrix(i),1) vault(costMatrix(i),2)]
end

%combine p-vaule and recovered vault pair togather
recoveredData=[optimalP' optimalXValue' optimalYValue' ];

%return the triple based on the size of unlocking set  
recoveredValidData=recoveredData(1:cols,:);

%{
%-------------RS-decoding part----------------
DEGREE=35;
testSet = recoveredValidData(1:cols,2:3);
% try running on points of vaultSorted:
polyCoeffs = decodePolynomial(testSet,FIELD,DEGREE);

if (checkPoly(testSet,polyCoeffs,field))
  coeffs = polyCoeffs;
end
%-------------End RS-decoding part--------------
%}
end