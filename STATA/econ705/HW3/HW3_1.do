# delimit ;
clear all;

set obs 10000;

*X distribution;
set seed 317;
gen temp = runiform();
gen X = 1 if temp <= 1/3;
replace X = 2 if temp > 1/3 & temp <= 2/3;
replace X = 3 if temp > 2/3 & temp <= 1; 

*potential outcomes;
set seed 318;
gen chi0 = runiform();
set seed 319;
gen chi1 = runiform();
gen Y0 = 0*X -1*X^2 + chi0;
gen Y1 = -10 + 0*X +2*X^2 + chi1;
gen Delta = Y1 - Y0;

*choice;
set seed 320;
gen UV = runiform();
*replace UV = UV - 0.5;
replace UV =chi1-0.5;
gen V = -0.2 + 0.1*X + UV;

gen D = 1 if V >= 0;
replace D = 0 if V < 0;

*observed outcome;
gen Y = D*Y1 + (1-D)*Y0;


*overlapping support?;
bysort X: sum D;
gen treat = D;
gen untreat = 1-D;
graph bar treat untreat, over(X) legend( label(1 "Treated") label(2 "Untreated") );

*naive estimator;
regress Y D;

*matching estimator;
forvalues X_val = 1(1)3 {;
regress Y D if X == `X_val';
gen ATE`X_val' = _b[D];
};


*overall ate estimate (each X value is equal proportion in sample);
gen ATE_match = 1/3*(ATE1 + ATE2 + ATE3);


