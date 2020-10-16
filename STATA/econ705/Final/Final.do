# delimit ;
clear all;
use "/Users/Desktop/examdata.dta";

*a) OLS;
regress Y D;
gen ols_est = _b[D];

*b) IV;
ivregress 2sls Y (D = Z);
gen iv_est = _b[D];

*c) matching based on X and Z ;
forvalues x_val = 11(1)14 {;
forvalues z_val = 0(1)1 {;
regress Y D if X == `x_val' & Z == `z_val';
gen match_ATE`x_val'`z_val' = _b[D];
sum Y if X == `x_val' & Z == `z_val';
gen frac`x_val'`z_val' = r(N)/_N;
};
};
gen match_est = 
frac110*match_ATE110 + frac120*match_ATE120 + frac130*match_ATE130 + frac140*match_ATE140
+ frac111*match_ATE111 + frac121*match_ATE121 + frac131*match_ATE131+ frac141*match_ATE141;


*d) control function;

**Step 1: selection model;
probit D Z;
gen delta0_hat = _b[_cons];
gen delta1_hat = _b[Z];
gen Z_delta = delta0_hat + delta1_hat*Z;

**Step 2: control functions;
gen K1 = normalden(-Z_delta) / (1- normal(-Z_delta) );
regress Y K1 if D == 1;
gen cf1 = _b[_cons]  if D == 1;

gen K0 = -normalden(-Z_delta) / normal(-Z_delta);
regress Y K0 if D == 0;
gen cf0 = _b[_cons]  if D == 0;

sum cf1;
gen mean_cf1 = r(mean);
sum cf0;
gen mean_cf0 = r(mean);
gen cf_est = mean_cf1 - mean_cf0;
sum  ols_est iv_est match_est cf_est;