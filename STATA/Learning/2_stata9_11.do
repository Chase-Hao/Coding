// egen meanx = function  like mean(x)
// gen or replace x = some math
capture log close 
log using first_step.log, replace
clear all

// use 2000_acs_sample.dta
// describe

// label list 
// duplicates report serial pernum

// list if _n==5
// list if pernum==1 & serial==242
// //for observation 5
// display us2000c_age[5]

// use atus
// list if caseid==20170101170012
// save mynewdate, replace 
// log close
// file system
/* absolute address
relative address 
..\data\tt.dta
running C:\ss.do*/

// drop year dataum
// drop if gp==3 | gq==4

// householdIncome household_income
// rename oldname new name 
// rename us2000c_* *
// rename educ edu
// rename racel race
// rename serial household
// rename perum person
destring income, gen(income2) force
tab income if income2==.