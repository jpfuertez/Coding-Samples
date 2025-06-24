clear all
set more off
capture log using "/Users/j.p./Downloads/ECON120B-SP23/hw3/hw3_johnfuertez.log", text replace
*********************************************
*Econ 120B, SP23
*Source Code for HW3
*Name: John Fuertez
*Email: jfuertez122@gmail.com
*PID: A16660875
*********************************************

capture cd "/Users/j.p./Downloads/ECON120B-SP23/hw3"

//Load the dataset MLB1.dta and then save it as MLB1_replica.dta (option replace) below //

use "MLB1.dta"
save "MLB1_replica.dta", replace

//Lets see what this dataset contains
describe

// Question 1 
// MC question answered on Canvas
regress salary years gamesyr frstbase scndbase thrdbase shrtstop catcher outfield, robust


// Question 2
regress salary years gamesyr frstbase thrdbase shrtstop catcher outfield, robust

scalar q2 = _b[catcher]
display q2


// Question 3
display _b[thrdbase] - _b[shrtstop]

scalar q3 = _b[thrdbase] - _b[shrtstop]
display q3


// Question 4
test shrtstop=thrdbase

scalar q4 = r(F)
display q4



// Question 5
display _b[_cons]+_b[years]*12+_b[gamesyr]*132+_b[outfield]

scalar q5 = _b[_cons]+_b[years]*12+_b[gamesyr]*132+_b[outfield]

display q5



// Question 6
display 4333333-q5

scalar q6 = 4333333-q5
display q6



// Question 7
regress lsalary years gamesyr bavg hrunsyr rbisyr, robust 
correlate rbisyr hrunsyr
display _b[hrunsyr]/_se[hrunsyr]

scalar q7 = r(rho)
display q7

// Question 8
regress lsalary years gamesyr bavg hrunsyr, robust
display _b[hrunsyr]/_se[hrunsyr]

// Question 9
regress lsalary years gamesyr bavg hrunsyr runsyr fldperc sbasesyr, robust
display _b[runsyr]/_se[runsyr]
display _b[fldperc]/_se[fldperc]
display _b[sbasesyr]/_se[sbasesyr]

// Question 10


// Question 11
test bavg fldperc sbasesyr

scalar q11 = r(F)
display q11

// Question 12
regress lsalary years gamesyr bavg hrunsyr rbisyr runsyr fldperc allstar black hispan, robust 
test black hispan

scalar q12 = r(F)
display q12



// Question 13
regress lsalary years gamesyr bavg hrunsyr rbisyr runsyr fldperc allstar black hispan blckpb hispph, robust 
test black hispan blckpb hispph
display _b[black]+20*_b[blckpb]


// Question 14
display _b[hispan]/_b[hispph]

scalar q14 = -1*_b[hispan]/_b[hispph]
display q14

save "MLB1_replica.dta", replace


scalar list

// Question 15
// Upload this do file


// Question 16
//Upload the log file


log close
