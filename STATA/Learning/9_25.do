capture log close
log using restructure.log, replace
clear all
// use 2000_acs_cleaned
// use nlsy_extract
//
// duplicates report household person
//
// describe
//
// by household: egen householdIncome = total(income)
//
// // reshape wide age race maritalStatus edu income female hispanic, ///
// // 	i(household) j(person)
//	
// reshape wide age race maritalStatus edu income female hispanic, ///
// 	i(household) j(person)
//	
// duplicates report household

// reshape wide  edu income age, i(id) j(year)

// drop person age race maritalStatus edu income female hispanic
// by household: keep if _n==1

// collapse ///
// (first) householdIncome ///
// (mean) proportionFemale =female///
// (count) householdSize =person///
// , by(household)
// collapse (first) yearOfBirth (mean)income (max) edu ///
// , by(id)

//?????????????????????????????????????????????????????????????????????????????
//combining dataset
use 2000_acs_part1
append using 2000_acs_part2
// clear
// use 2000_acs_demographics
// merge 1:1 household person using 2000_acs_ses
// clear
// use 2000_acs_race
// describe
// use 2000_acs_education
// describe
// clear
// use 2000_acs_adults
// describe
// clear
// use 2000_acs_children
// describe
// clear
// use 2000_acs_children
// append using 2000_acs_adults
// clear
// use nlsy1980
// gen year = 1980
// save nlsy1980_append, replace

clear
use nlsy1979
gen year = 1979
append using nlsy1980_append
sort id yearOfBirth

clear 
use nlsy1980_append
sort id year

clear 
use nlsy1980
rename edu-age =1980
save nlsy1980_merge

clear
use nlsy1979
rename edu-age =1979

merge 1:1 id using nlsy1980_merge

clear 
use 2000_acs_cleaned
merge m:1 household using 2000_acs_households

clear
use fredcpi
gen year= year(daten)
rename CPIAUCSL cpi
drop date*

merge 1:m year using nlsy_extract, keep(match)

gen year2000 = 1 if year==2000
egen cpi2000 =mean(cpi*year2000) 

gen inc2000 = income * cpi2000/cpi

bysort year: sum inc*


