# delimit ;
clear all;


*******************************************;
*potential outcomes model;
*******************************************;

*some parameters;
local sigma_u0 = 1;
local sigma_u1 = 1;
local sigma_uv = 1;
local corr_u01 = 0.5;
local corr_u0v = 0.3;
local corr_u1v = 0.7;
local alpha = 3;
local beta1 = 1;


**********************************************;
*Step 1: generate u0, u1, uv random variables;
**********************************************;

set seed 538;
matrix C = (1, `corr_u01', `corr_u0v' \ `corr_u01', 1, `corr_u1v' \ `corr_u0v', `corr_u1v', 1);
matrix sd = (`sigma_u0',`sigma_u1',`sigma_uv');
drawnorm U0 U1 UV, n(10000) corr(C) sds(sd);


**********************************************;
*Step 2: generate binary instrument;
**********************************************;

set seed 153;
gen temp = runiform();
gen Z = 1 if temp >= 0.5;
replace Z = 0 if temp < 0.5;



**********************************************;
*Step 3: generate remaining variables;
**********************************************;
gen Y0 = `beta1' + U0;
gen Y1 = `beta1' + `alpha' + U1;

*gen V = -1+2*Z + UV;
gen V = -1+3*Z + UV;

gen Delta = Y1 - Y0;
gen D = 1 if V >= 0;
replace D = 0 if V < 0;
gen Y = D*Y1 + (1-D)*Y0; 

**********************************************;
*Step 4: some estimators
**********************************************;
* ATE
mean Delta;
*ATET
mean Delta if D==1;
*ATEU
mean Delta if D==0;
*1) ols/naive;
regress Y D;
*gen beta_ols = _b[D];

*2) direct/reduced form/ITT;
regress Y Z;
*gen beta_direct = _b[Z];

*3) IV;
ivregress 2sls Y (D = Z);
gen beta_iv = _b[D];


*Step 5: define compliance groups for this Z
**********************************************;

*choice if Z = 0;
gen V_Z0 = -1+ 0 + UV; 
gen D_Z0 = 1 if V_Z0 >= 0;
replace D_Z0 = 0 if V_Z0 < 0; 

*choice if Z = 1;
gen V_Z1 = -1+3 + UV;
*gen V_Z1 = -1+2+ UV;
gen D_Z1 = 1 if V_Z1 >= 0;
replace D_Z1 = 0 if V_Z1 < 0;

*gen str6 = "comply" if D_Z1 == 1 & D_Z0 == 0;
count if D_Z1 == 1 & D_Z0 == 0;