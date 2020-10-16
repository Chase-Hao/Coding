capture log close
log using panel.log, replace
clear all 
use nlsy_extract

describe
duplicates report id year
tab edu
label list edulabel

misstable sum
by id: egen totalIncome = total(income)
by id: egen startingAge = min(age)
sort id year
by id:gen startingIncome = income[1]
// _N= observation number of last observation
by id:gen endingIncome = income[_N]
gen eduForward = edu
by id: replace eduForward = eduForward[_n-1] if eduForward ==.
gsort id - year
gen eduBackward = edu
by id: replace eduBackward = eduBackward[_n-1] if eduBackward==.
sort id year

replace edu = eduForward if eduForward == eduBackward

browse id year edu*

by id:gen attendedSchool = (edu>edu[_n-1]) if edu<. & edu[_n-1]<.  
by id: gen grad = (edu==12 & edu[_n-1]<12)
by id: egen timeGrad = total(grad)

by id: egen neverFinished = min(edu<16 | edu<.)

by id: gen break = (edu>=13 & edu<16 & edu==edu[_n-1] &!neverFinished) ///
	if edu<. & edu[_n-1]<.
	
by id: gen tookBreak = max(break)
gen afterBreak =0
by id:replace afterBreak =(break[_n-1] == 1 | afterBreak[_n-1]==1)
by id: gen numBreaks= sum(break)

sort id grad
by id:gen ageAtGraduation =age[_N] if grad[_N]

gen toUse =1 if grad
by id:egen ageAtGraduation2 =mean(age*toUse) 

gsort id break -year
by id: gen ageAtFirstBreak = age[_N] if break[_N]==1
by id: gen incomeAtFirstBreak = income[_N] if break[_N]==1