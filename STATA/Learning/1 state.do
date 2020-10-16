capture log close
log using first.log, replace

clear all
sysuse auto

//1. list cars

// by rep78, sort: ///
// 	list make

// save autoV2, replace
// log close

// 2. sum mpg
//
// tab rep78
//
// tab rep78 foreign
//
// tab rep78, missing
//
// tab rep78 foreign, row col cell
//
// tab rep78 foreign, chi2
 
gen price2019 = price*4
sum price price2019
replace price = price*4.03
// gen rep3 = 1 if rep78 <3 
// replace rep3 = 2 if rep78==3
// replace rep3 = 3 if rep78>3 & rep78<.

// gen rep3 =1 if rep78 <3
// replace rep3 =2 if rep78==3
// replace rep3 =3 if rep78==4
// replace rep3 =4 if rep78==5

gen rep4 =1 if rep78<3
replace rep4 = rep78-1 if rep78>=3 & rep78<.

recode rep78 (1 2 = 1) (3 =2) (4 5 =3), gen(rep3b)


gen lowMPG = (mpg<20) if mpg<.
gen company = word(make,1)

bysort company: egen meanP =mean(price)

label variable foreign "car origin "

label define replable ///
1 "bad"
2 "avg"
3 "good" ///

label values rep3 replabel

tab rep3

recode rep78 ///
(1 2 =1 "Bad")///
(3 =2 "Bad")///
(4 5 = 3 "Bad")///











