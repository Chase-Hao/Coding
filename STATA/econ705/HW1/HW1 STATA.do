clear
*Step 1: set model parameters
**********************************************
local sigma_u0 = 1
local sigma_u1 = 1
local sigma_uv = 1
local corr_u01 = 0.5
local corr_u0v = 0.3
local corr_u1v = 0.7
local alpha = 1
local beta1 = 2
local muV = 1



set seed 202
matrix C = (1, `corr_u01', `corr_u0v' \ `corr_u01', 1, `corr_u1v' \ `corr_u0v', `corr_u1v', 1)
matrix sd = (`sigma_u0',`sigma_u1',`sigma_uv')
drawnorm U0 U1 UV, n(10000) corr(C) sds(sd)
*Step 2: generate V, Y0, Y1, Delta variables
**********************************************

gen V = `muV' + UV
gen Y0 = `beta1' + U0
gen Y1 = `beta1' + `alpha' + U1
gen Delta = Y1 - Y0

**********************************************
*Step 3: treatment assignment
**********************************************
*Distribution of treatment effects
*sum Delta, detail
*kdensity Delta
*kdensity Delta if D == 1
*kdensity Delta if D == 0

*Model 1: Treatment non-randomly assigned
gen D = 1 if V >= 0
replace D = 0 if V < 0
gen Y = D*Y1 + (1-D)*Y0

*ols ATE
regress Y D
mean Delta
*ATET 
mean Delta if D == 1
* Bias=Delta-alpha
*ATEU
mean Delta if D == 0


*Model 2: Treatment randomly assigned
set seed 151
gen coin = runiform()
gen D_rand = 1 if coin > 0.5
replace D_rand = 0 if coin <= 0.5
gen Y_rand = D_rand*Y1 + (1-D_rand)*Y0

*ols
regress Y_rand D_rand

*QTE
sum Y1 if D_rand == 1, detail 
*marginal distribution for treated
sum Y0 if D_rand == 0, detail 
*marginal distribution for untreated
sum Delta, detail 
*marginal distribution for the treatment effect