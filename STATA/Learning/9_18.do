capture log close 
log using transform.log, replace
clear all

// sysuse auto
/*
gen weightCost = 1.5*weight
gen shipCost = 0.25*weight if foreign
gen qualityCost = 100 if rep78 == 5
egen totalCost = rowtotal(weightCost+ shipCost + qualityCost)
*/
// gen weightCost = 1.5*weight
// gen shipCost = 0.25*weight if foreign
// replace shipCost = 0 if shipCost==.
// gen qualityCost = 100 if rep78 == 5
// replace qualityCost = 0 if qualityCost ==.
// gen totalCost =weight + shipCost +qualityCost

// gen weightCost = 1.5*weight
// gen shipCost = cond(foreign, .25*weight,0)
// gen qualityCost = cond(rep78==5, 100, 0)

// gen weightCost = 1.5*weight
// gen shipCost = 0.25*weight*foreign
// gen qualityCost = 100 * (rep==5)

// gen profit = price -///
// 	(1.5*weight + 0.25*weight*foreign + 100*(rep78==5))
//	
// gen cost =1.5*weight
// replace cost = cost + 0.25*weight if foreign
// replace cost = cost + 100 if rep78==5
//
// gen CAR = weight*mpg/1000
// replace CAR =cond(weight>2800&foreign==1, CAR-price/1200, CAR-price/1000)
// replace CAR= CAR +10 if rep78>3
// replace CAR =. if rep78==.
// replace CAR= cond(CAR==.,0, CAR)
//
// use 2000_acs_cleaned
// by household: egen houseIncome =total(income)
// // by household: egen incomePerPerson =mean(income)
//
// by household: egen incomePerPerson =total(income/_N)
//
// by household: gen householdSize = income/_N
//
// by household: egen householdChildrenIncome =/// egen dont count missing
// 	total(income) if age<18
// gen toUse =1 if age<18
// by household: egen householdChildrenIncome =///
// 	total(income*toUse)
//	
// drop toUse
// gen toUse =1 if age<18
// by household: egen meanAdultAge =///
// 	mean(age*toUse)
//
// gen child =(age<18)
// by household: egen numChildren = total(child)
// by household: egen propChildren =mean(child)
// by household: egen hasChildren = max(child)
// by household: egen allChildren = min(child)
//
// gen grad = (edu>=12 & edu<.)
// by household: egen numGrads = total(grad)
// by household: egen propGrads = mean(grad)
// by household: egen hasGrad =max(grad)
//
// gen toUse =1 if age>=18
// by household: egen allGrads= min(grad*toUse)
//			
		
use 2000_acs_wide

egen householdIncome = rowtotal(income*)

gen child1 = age1<18
