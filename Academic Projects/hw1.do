clear all
set more off
capture log using "/Users/j.p./Downloads/ECON120B-SP23/hw1", text replace
*********************************************
*Econ 120B, SP23
*Source Code for HW1
*Name: John Fuertez
*Email: jfuertez@ucsd.edu
*PID: A16660875
*********************************************

capture cd "/Users/j.p./Downloads/ECON120B-SP23/hw1"

//Load the dataset murder_hw1.dta and save it as murder_hw1_replica.dta (option replace) below //
use "murder_hw1.dta"

save "murder_hw1_replica.dta", replace

//Load the dataset murder_hw1.dta and save it as murder_hw1_replica.dta (option replace) above //

describe

// Question 1 

scalar q1 = r(N)
display q1


// Question 2

scalar q2 = r(k)
display q2


// Question 3
// Multiple choice question answered on Canvas quiz //


// Question 4

sort mrdrte
list state

display round(mrdrte[51], 0.1)
display round(mrdrte[1],0.1)






scalar q4_min = round(mrdrte[1],0.1)
display q4_min
scalar q4_max = round(mrdrte[51], 0.1)
display q4_max


// Question 5

gsort -mrdrte
sort exec

list state mrdrte exec in 20


// Question 6
count if exec>10


scalar q6 = r(N)
display q6



// Question 7
summarize mrdrte,detail



// Question 8


scalar q8_a = r(p90)
display q8_a
scalar q8_b = r(p10)
display q8_b


// Question 9


scalar q9_mean = r(mean)
display q9_mean
scalar q9_sd = r(sd)
display q9_sd


// Question 10
summarize unem
generate dev_unem = unem-r(mean)
label variable dev_unem "Deviations of unemployment rate from its mean"
summarize dev_unem
sum(dev_unem)





scalar q10_max = r(max)
display q10_max
scalar q10_min = r(min)
display q10_min
scalar q10_sum = sum(dev_unem)
display q10_sum 


// Question 11
summarize mrdrte
generate dev_mrd = mrdrte-r(mean)
label variable dev_mrd "Deviations of murder rate from its mean"
summarize dev_mrd
total dev_mrd


scalar q11_max = r(max)
display q11_max
scalar q11_min = r(min)
display q11_min
scalar q11_sum = sum(dev_mrd)
display q11_sum 


// Question 12 
generate cross_product = dev_unem*dev_mrd
tabstat cross_product, statistics(sum) save
total cross_product


scalar q12 = 92.2
display q12


// Question 13
display q12/(_N-1)

scalar q13 = q12/(_N-1)
display q13


// Question 14
// Multiple choice question answered on Canvas quiz //


// Question 15
corr mrdrte unem

scalar q15 = r(rho)
display q15


// Question 16 
// Multiple choice question answered on Canvas quiz //


// Question 17


//Multiple choice question answered on Canvas quiz //



// Question 18
// Screenshot of the histogram uploaded to Canvas quiz


// Question 19
twoway (scatter mrdrte unem, mlabel(state) mlabsize(vsmall))



// Screenshot of the scatterplot uploaded to Canvas quiz


// Question 20 
// Screenshot of the scatterplot will provide the answer to be entered in Canvas quiz


// Question 21
summarize mrdrte, detail
list state if mrdrte>q21_upper
list state if mrdrte<q21_lower

scalar q21_upper = r(p75)+1.5*(r(p75)-r(p25))
display q21_upper
scalar q21_lower = r(p25)-1.5*(r(p75)-r(p25))
display q21_lower


//"Check all that apply" question answered on Canvas quiz //


// Question 22 
list state if mrdrte>q22_upper
list state if mrdrte<q22_lower

scalar q22_upper = r(mean)+3*r(sd) 
display q22_upper
scalar q22_lower = r(mean)-3*r(sd)
display q22_lower


//"Check all that apply" question answered on Canvas quiz //


// Question 23 
summarize cmrdrte
list state if cmrdrte == r(min)
list state if cmrdrte == r(max)

scalar q23_a = r(min)
display q23_a
scalar q23_b = r(max)
display q23_b


// Question 24 
generate unem06 = mrdrte-cmrdrte
label variable unem06 "annual unemployment rate in 2006"
summarize unem06

scalar q24 = r(mean)
display q24


scalar list

// Question 25
// Upload this do file


// Question 26
//Upload the log file



// Save your data "murder_hw1_replica.dta" (option replace) below//



// Save your data "murder_hw1_replica.dta" (option replace) above//


log close
