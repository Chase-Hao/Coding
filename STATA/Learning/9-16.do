
capture log close 
log using first_step.log, replace
clear all

use 2000_acs_sample.dta
rename us2000c_* *
rename inctot income
destring income, replace force
destring age, replace force
destring hispan, replace

// destring income, gen(income2) force
// tab income if income2==.
// destring income, force replace
// assert person==real(pnum)
// drop pnum
rename educ edu
rename race1 race
rename serial household
rename pernum person

destring edu, replace force
// gen hisp = (hispan>1)
// tab hispan hisp, miss
// label variable female "Person is female"
// describe female
// label define marlabel
// 	1 "now married"
// 	2 "widowed"
// 	3 "divorced"
// 	4 "separated"
// 	5 "never married"
//	
// label values maritalStatus marlabel
// tab maritalStatus
// tab maritalStatus, nolabel
// sum age if income==.
// // hist age
// hist age, discrete freq
// tab hispan if race==8 
// graph bar, over(edu)

replace edu = . if edu ==0
tab income if income<0
replace income = . if income <0
