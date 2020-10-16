# delimit ;
clear all;
use "C:\Users\haoch\OneDrive - UW-Madison\2nd Semester\705Mat\HW3\ps3data.dta";

summarize;

regress Y D;

*overlapping support?;
bysort X Z: sum D;
gen treat = D;
gen untreat = 1-D;


*matching estimator;

gen total=_N;
forvalues X_val = 1(1)3 {;
forvalues Z_val = 0(1)1 {;
regress Y D if X == `X_val' &  Z== `Z_val';
gen ATE`X_val'`Z_val' = _b[D];
count if X==`X_val'& Z==`Z_val';
gen num`X_val'`Z_val' = r(N);
gen P`X_val'`Z_val' = num`X_val'`Z_val'/total;
};
};

gen ATE_match = P11*ATE11 + P10*ATE10 +P21*ATE21+ P20*ATE20+P31*ATE31+P31*ATE30;

*2) Step 1: selection model;
probit D Z X;
gen delta0_hat = _b[_cons];
gen delta1_hat = _b[Z];
gen delta2_hat = _b[X];
gen Z_delta = delta0_hat + delta1_hat*Z + delta2_hat*X;


*3) Step 2: control functions;
gen K1 = normalden(-Z_delta) / (1- normal(-Z_delta) );
regress Y K1 if D == 1;
gen cf1 = _b[_cons];

gen K0 = -normalden(-Z_delta) / normal(-Z_delta);
regress Y K0 if D == 0;
gen cf0 = _b[_cons];

gen Two =cf1 -cf0;

