clear all
set more off
capture log using "/Users/j.p./Downloads/ECON120B-SP23/hw2_johnfuertez.log", text replace
*********************************************
*Econ 120B, SP23
*Source Code for HW2
*Name: John Fuertez
*Email: jfuertez@ucsd.edu
*PID: A16660875
*********************************************

capture cd "/Users/j.p./Downloads/ECON120B-SP23/hw2"

//Load the dataset cps04_SP23.dta and then save it as cps04_hw2_replica.dta (option replace) below //

use "CPS04_SP23.dta"
save "CPS04_hw2_replica.dta", replace

//Lets see what this dataset contains
describe

// Question 1 
regress ahe age, robust


scalar q1 = _b[_cons]
display q1


// Question 2

scalar q2 = _b[age]
display q2


// Question 3
display q1+56*q2

scalar q3 = q1+56*q2
display q3


// Question 4
// True of False question answered on Canvas



// Question 5

scalar q5a = e(r2)
display q5a
scalar q5b = e(rmse)
display q5b




// Question 6
regress ahe age if bachelor==0, robust

scalar q6a = _b[age]
display q6a
scalar q6b = _se[age]
display q6b



// Question 7
regress ahe age if bachelor==1, robust

scalar q7a = _b[age]
display q7a
scalar q7b = _se[age]
display q7b


// Question 8

scalar q8a = q7a-q6a
display q8a

scalar q8b = (q7b^2+q6b^2)^(1/2)
display q8b 

scalar q8c = q8a/q8b
display q8c

save "cps04_hw2replica.dta", replace 

scalar list

//Load the dataset BigMac_0722.dta and then save it as BigMac_hw2_replica.dta (option replace) below //

use "BigMac_0722.dta"
save "BigMac_hw2_replica.dta", replace

//Lets see what this dataset contains
describe


// Question 9

scalar Pus = 5.15
generate impxrate = local_price/Pus
label variable impxrate "Exchange rate implied by the Big Mac, units of local currency per USD"
list impxrate if country == "Mexico"

// Question 10
regress xrate impxrate, robust


scalar q10a = _b[_cons]/_se[_cons]
display q10a
scalar q10b =_b[impxrate]/_se[impxrate] 
display q10b

// Question 11
twoway scatter xrate impxrate ///
    || lfit xrate impxrate ///
    || lfit xrate impxrate, ///
    ytitle("Actual Exchange Rate") xtitle("Implied Exchange Rate") ///
    legend(order(1 "Fitted Line" 2 "45-degree Line")) ///
    name(hw2_q11, replace)

graph export "hw2_q11.png", replace


// Upload question 11 graph to Canvas 

// Question 12
generate valuation = (impxrate-xrate)*100/xrate
sort valuation
gsort -valuation

// Question 13
list valuation if country == "Brazil"


// Question 14
generate dollar_price = local_price/xrate
regress dollar_price gdppc, robust
twoway (scatter dollar_price gdppc, mlabel(country) mlabsize(tiny)) ///
       (lfit dollar_price gdppc), ///
       ytitle("Price Big Mac, in US dollars") ///
       xtitle("GDP per capita, in US dollars") ///
       title("Big Mac Prices versus GDP per person") ///
       name(hw2_q14, replace)

graph export "hw2_q14.png", replace

// Upload question 14 graph to Canvas 

// Question 15
regress dollar_price gdppc, robust
predict yhat
generate adj_valuation = ((dollar_price/Pus)/(yhat/(3.315837+.0000156*69231.4)) - 1)*100
gsort adj_valuation


// Question 16 
list adj_valuation if country == "Brazil"


// Question 17
generate uhat = dollar_price-yhat
list uhat if country=="Sweden"



// Question 18
summarize uhat, detail

scalar q18 = r(sum)
display q18



save "BigMac_hw2_replica.dta", replace

scalar list


//Load the dataset cps84.dta and then save it as cps84_hw2_replica.dta (option replace) below //
use "cps84.dta"

save "cps84_hw2_replica.dta", replace 


/*Lets see what this dataset contains.*/
describe


// Question 19
regress hwage ed, robust



scalar q19 = _b[ed]
display q19



// Question 20 
predict uhat, residuals
twoway (scatter uhat ed), yline(0)

graph export "hw2_q20.png", replace


// Upload question 20 graph to Canvas 

// Question 21
// Multiple dropdowns question answered on Canvas


// Question 22
bsample 850 
set seed 16660875
regress hwage ed, robust
summarize(hwage)

// 99% 2.58

scalar q22a = _b[ed]-2.58*_se[ed]
display q22a
scalar q22b = _b[ed]+2.58*_se[ed]
display q22b


// Question 23
// Numerical question answered directly on Canvas
display 400*0.01

save "cps84_hw2_replica.dta", replace


scalar list

// Question 24
// Upload this do file


// Question 25
//Upload the log file


log close
