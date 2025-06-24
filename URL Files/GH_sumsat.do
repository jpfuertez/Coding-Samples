cd "/Users/maddisonerbabian/Google Drive/Thesis/Stata/Ghana"
*cd "/Users/maddisonerbabian/Google Drive/Thesis/Stata/Kenya"
capture log close
*log using GH_sumstat.log, replace
clear all

/*******************************************************************************
********************************************************************************

Date:				March 20, 2020	
Last Revised:		March 20, 2020



Datasets used:		-gh_compiled.dta


Output:				-GH_sumstat.log
					-GH_analysis.dta
					
					-edatt_birthyr.pdf
					-edatt_birthcohort.pdf
					-enroll_6_13.pdf
					-enroll_6_10.pdf
					-enroll_9_13.pdf
					-enroll_6_18.pdf
					-enroll_6_13_byyear.pdf
					-enroll_9_13_byyear.pdf
					-enroll_14_18_byyear.pdf
					
					-GH_sumstat.doc

********************************************************************************
*******************************************************************************/

use gh_compiled.dta, clear

* List numeric labels
numlabel _all, add

* Topcode distance to nearest college at 150 km
recode minwdist (150/1000=.)

// Clean variables
	// Move this to previous do file?
replace edattend=. if edattend==9
replace edlvl_attend=. if edlvl_attend==9
replace edlevel=. if edlevel==9
replace edyrs=. if edyrs ==99

	* Topcode years of educational attainment at Number of years alive - 3 years
	* since it is impossible to have gone to school for longer than your 
	* lifespan and extremely unlikely to have gone to school prior to age 4,
	* and any education attained prior to age 4 is not of interest here since I
	* am not studying early childhood education
	replace edyrs=age-3 if edyrs>=age-3
	recode edyrs (-3/0=0)
	
	
	
	* If years of educational attainment exceeds 26 years (implying 
	* approximately 10 years of grad school), set edyrs to missing because
	* survey respondents likely misunderstood the question
	replace edyrs=. if edyrs>26
	
	* Topcode years of educational attainment at 21 years of education 
	* (approximately 5 years of grad school)
	recode edyrs (21/26=21)
	tab edyrs, m
	

recode curedyrs (98/100=.)
recode curgrade (98/100=.)
recode curedlvl (8/10=.)
recode curinschool (9=.)
recode previnschool (9=.)
recode prevedlvl (9/10=.)
recode prevedyrs (98/100=.)


	* Topcode years of educational attainment at Number of years alive - 3 years
	* since it is impossible to have gone to school for longer than your 
	* lifespan and extremely unlikely to have gone to school prior to age 4,
	* and any education attained prior to age 4 is not of interest here since I
	* am not studying early childhood education
	replace curedyrs=age-3 if curedyrs>=age-3
	recode curedyrs (-3/0=0)
	
	replace prevedyrs=age-3 if prevedyrs>=age-3
	recode prevedyrs (-3/0=0)	

	
* Recode no response and "don't know" to missing
recode watertime (999=.)
recode watertime (998=.)

* Recode on premises as 0 min to water source
recode watertime (996=0)

* Topcode time to get to water source at 3 hours
recode watertime (180/1000=180)

* Label variables
la var edyrs "Educational Attainment in Years"
la var curedyrs "Educational Attainment in Years"
la var curinschool "Currently Attend School"
la var previnschool "Attended School Last Year"
la var curgrade "Current Grade Level"
la var urban "Urban"
la var male "Male"
la var age "Current Age"
la var weindex_quint "Wealth Index Quintile"
la var hhsize "De Jure Household Members"
la var kidsunder6 "Number of Kids in Household Age 5 or Under"
la var par_alive "Both Parents are Alive"
la var watertime "Time to Get to Water Source (min)"
la var bednet "Bednet"
la var elec "Electricity"
la var fridge "Refrigerator"
la var phone "Telephone"
la var radio "Radio"
la var bike "Bicycle"
la var motorcycle "Motorcycle or Scooter"
la var car "Car or Truck"
la var shoes "Shoes"
la var mult_clothes "2 or More Sets of Clothing"
la var birthcert "Birth Certificate"

la var collcount "Number of Colleges within 25 km of Community"
la var minwdist "Distance to Nearest College (km) Established 1996-2015"

* Lump "attended school at some time" in as "currently in school
gen enrolled = 0
replace enrolled = 1 if curinschool==1 | curinschool==2
la var enrolled "Enrolled in School"
	***** // Is this okay to do?
*********************************************************************

* Create binary variable for secondary school completion
gen sec_comp=0
replace sec_comp=1 if edlevel>=4 & edlevel!=.
la var sec_comp "Completed Secondary School"

* Create binary variable for secondary school attendance
gen sec_att=0
replace sec_att=1 if edlevel>=3 & edlevel!=.
la var sec_att "Attended Secondary School"

* Create binary variable for primary school attedance
gen prim_att=0
replace prim_att=1 if edlevel>=1 & edlevel!=.
la var prim_att "Attended Primary School"

* Create binary variable for primary school completion
gen prim_comp=0
replace prim_comp=1 if edlevel>=2 & edlevel!=.
la var prim_comp "Completed Primary School"




gen age_atest=age-collage
la var age_atest "Age in Year when College was Established"

drop if age_atest==.



* Create approximate birth year variable based on age & year surveyed
gen birthyr = year-age


/*
*** Control for UPE ***
gen upe=1 if birthyr>=1984
replace upe=0 if birthyr<1984
la var upe "Exposed to Universal Primary Education"
	
	// Not quite sure how to code/create the UPE variable...dummy? instrument?
	// index?
	// Policy exposure = 1 for those born in 1991 or after or 1984 or after?
		// Probably instrument for policy exposure based on age/birth year?

*/
		
* Create 5-yr birth cohorts
gen birthcohort = 5*floor(birthyr/5) if birthyr>0 & birthyr<.
label define BIRTHCOHORT 1900 "1900-1904" 1905 "1905-1919" 1920 "1920-1924" ///
	1925 "1925-1929" 1930 "1930-1934" 1935 "1935-1939" 1940 "1940-1944" ///
	1945 "1945-1949" 1950 "1950-1954" 1955 "1955-1959" 1960 "1960-1964" ///
	1965 "1965-1969" 1970 "1970-1974" 1975 "1975-1979" 1980 "1980-1984" ///
	1985 "1985-1989" 1990 "1990-1994" 1995 "1995-1999" 2000 "2000-2004" ///
	2005 "2005-2009" 2010 "2010-2014" 2015 "2015-2019"		
		
	
	
	
	
**************** DEFINE SAMPLES ********************


***** By Age at Year of College Establishment *****

* School age group in year of establishment (ages 6-18)
global sample_scage_atest "age_atest>=6 & age_atest<=18"

	// maybe I should redefine these age groups?
	
	
* Primary school age group in year of establishment (ages 6-13) ~ grade 1-7?
global sample_prim_atest "age_atest>=6 & age_atest<=13" 

* Primary school age POST-establishment (ages -2-5) 
	// Comparable in size to the 6-13 age group, but this age group does not 
	// begin school until after the college has opened
global sample_prim_post "age_atest>=-2 & age_atest<=5" 

* 18 or older in survey year
global sample18up "age>=18"


***** By Age in Survey Year *****

* School age group (ages 6-17)
global sample_scage "age>=6 & age<=17"

	// maybe I should redefine these age groups?
	
	
* Primary school age group (ages 6-13)
global sample_prim "age>=6 & age<=13" 

* 6-10 year olds
global sample_6_10 "age>=6 & age<=10"

* 9-13 year olds
global sample_9_13 "age>=9 & age<=13"

* 6 year olds
global sample_6 "age==6"

* 7 year olds
global sample_7 "age==7"

* 8 year olds 
global sample_8 "age==8"

* 9 year olds
global sample_9 "age==9"

* 10 year olds
global sample_10 "age==10"

* 11 year olds
global sample_11 "age==11"

* 12 year olds
global sample_12 "age==12"

* 13 year olds
global sample_13 "age==13"

* 14 year olds
global sample_14 "age==14"

* 15 year olds
global sample_15 "age==15"

* 16 year olds
global sample_16 "age==16"

* 17 year olds
global sample_17 "age==17"

* 18 year olds
global sample_18 "age==18"


* Lowest Wealth Index Quintile
global sample_we1 "weindex_quint==1"

* Second lowest Wealth Index Quintile
global sample_we2 "weindex_quint==2"

* Middle Wealth Index Quintile
global sample_we3 "weindex_quint==3"

* Second Highest Wealth Index Quintile
global sample_we4 "weindex_quint==4"

* Highest Wealth Index Quintile
global sample_we5 "weindex_quint==5"

		
			
***** EXPLORATORY DESCRIPTIVE STATS *****

tab edlevel, m	
tab edlevel if $sample_scage==1, m

	
		


***** AVERAGE ENROLLMENT VARIABLES *****	
	
	
* Average Enrollment of 6-13 year olds
bysort year: egen enroll_6_13 = mean(enrolled) if $sample_prim==1
la var enroll_6_13 "Average Enrollment of 6-13 Year Olds"
tab enroll_6_13

* Average enrollment of 6-10 year olds
bysort year: egen enroll_6_10 = mean(enrolled) if $sample_6_10==1
la var enroll_6_10 "Average Enrollment of 6-10 Year Olds"
tab enroll_6_10

* Average enrollment of 9-13 year olds
bysort year: egen enroll_9_13 = mean(enrolled) if $sample_9_13==1
la var enroll_9_13 "Average Enrollment of 9-13 Year Olds"
tab enroll_9_13


	
* Average enrollment of 6 year olds
bysort year: egen enroll_6 = mean(enrolled) if $sample_6==1
la var enroll_6 "Enrollment of 6 Year Olds"
tab enroll_6

* Average enrollment of 7 year olds
bysort year: egen enroll_7 = mean(enrolled) if $sample_7==1
la var enroll_7 "Enrollment of 7 Year Olds"
tab enroll_7

* Average enrollment of 8 year olds
bysort year: egen enroll_8 = mean(enrolled) if $sample_8==1
la var enroll_8 "Enrollment of 8 Year Olds"
tab enroll_8
	
* Average enrollment of 9 year olds
bysort year: egen enroll_9 = mean(enrolled) if $sample_9==1
la var enroll_9 "Enrollment of 9 Year Olds"
tab enroll_9

* Average enrollment of 10 year olds
bysort year: egen enroll_10 = mean(enrolled) if $sample_10==1
la var enroll_10 "Enrollment of 10 Year Olds"
tab enroll_10

* Average enrollment of 11 year olds
bysort year: egen enroll_11 = mean(enrolled) if $sample_11==1
la var enroll_11 "Enrollment of 11 Year Olds"
tab enroll_11

* Average enrollment of 12 year olds
bysort year: egen enroll_12 = mean(enrolled) if $sample_12==1
la var enroll_12 "Enrollment of 12 Year Olds"
tab enroll_12

* Average enrollment of 13 year olds
bysort year: egen enroll_13 = mean(enrolled) if $sample_13==1
la var enroll_13 "Enrollment of 13 Year Olds"
tab enroll_13

* Average enrollment of 14 year olds
bysort year: egen enroll_14 = mean(enrolled) if $sample_14==1
la var enroll_14 "Enrollment of 14 Year Olds"
tab enroll_14

* Average enrollment of 15 year olds
bysort year: egen enroll_15 = mean(enrolled) if $sample_15==1
la var enroll_15 "Enrollment of 15 Year Olds"
tab enroll_15

* Average enrollment of 16 year olds
bysort year: egen enroll_16 = mean(enrolled) if $sample_16==1
la var enroll_16 "Enrollment of 16 Year Olds"
tab enroll_16

* Average enrollment of 17 year olds
bysort year: egen enroll_17 = mean(enrolled) if $sample_17==1
la var enroll_17 "Enrollment of 17 Year Olds"
tab enroll_17

* Average enrollment of 18 year olds
bysort year: egen enroll_18 = mean(enrolled) if $sample_18==1
la var enroll_18 "Enrollment of 18 Year Olds"
tab enroll_18



***** LINE GRAPHS *****

/*	
	* Average educational attainment (in single yrs) for each birth year
	bysort birthyr: egen ed_18up_birthyr = mean(edyrs) if $sample18up==1
	
* Line graph of edu attainment around entryyr
graph twoway (line ed_18up_birthyr birthyr)  if $sample18up==1, ylabel(, format(%9.1f) angle(horizontal)) ///
	ytitle("Average Educational Attainment (yrs)") xline(0, lcolor(red)) ///
	xtitle("Birth Year") ///
	title("Average Educational Attainment by Birth Year, Ghana")
graph export edatt_birthyr_gh.pdf, replace
*/

	* Average educational attainment (in single yrs) for each birth cohort
	bysort birthcohort: egen ed_18up_birthcohort = mean(edyrs) if $sample18up==1	

* Line graph of edu attainment around entryyr
graph twoway (line ed_18up_birthcohort birthcohort)  if $sample18up==1, ylabel(, format(%9.1f) angle(horizontal)) ///
	ytitle("Average Educational Attainment (yrs)") ///
	xtitle("Birth Cohort") ///
	title("Average Educational Attainment by Birth Cohort, Ghana") ///
	graphregion(color(white))
graph export edatt_birthcohort_gh.pdf, replace	
	


/*
* Line graph of edu enrollment around entryyr
graph twoway (line enroll_6_13 year), ylabel(, format(%9.1f) angle(horizontal)) ///
	ytitle("Average School Enrollment") ///
	xtitle("Year") ///
	title("Average School Enrollment of 6-13 Year Olds, Ghana")
graph export enroll_6_13_gh.pdf, replace		


* Line graph of edu enrollment around entryyr
graph twoway (line enroll_6_10 year), ylabel(, format(%9.1f) angle(horizontal)) ///
	ytitle("Average School Enrollment") ///
	xtitle("Year") ///
	title("Average School Enrollment of 6-10 Year Olds, Ghana")
graph export enroll_6_10_gh.pdf, replace		


* Line graph of edu attainment around entryyr
graph twoway (line enroll_9_13 year), ylabel(, format(%9.1f) angle(horizontal)) ///
	ytitle("Average School Enrollment") ///
	xtitle("Year") ///
	title("Average School Enrollment of 9-13 Year Olds, Ghana")
graph export enroll_9_13_gh.pdf, replace


* Line graph of edu attainment around entryyr -- 6-18 by year
graph twoway (line enroll_6 year) (line enroll_7 year) (line enroll_8 year) ///
	(line enroll_9 year) (line enroll_10 year) (line enroll_11 year) ///
	(line enroll_12 year) (line enroll_13 year) (line enroll_14 year) ///
	(line enroll_15 year) (line enroll_16 year) (line enroll_17 year) ///
	(line enroll_18 year), ylabel(, format(%9.1f) angle(horizontal)) ///
	ytitle("Average School Enrollment") ///
	xtitle("Year") ///
	title("Average School Enrollment of 6-18 Year Olds, Ghana")
graph export enroll_6_18_gh.pdf, replace		

*/	
* Line graph of edu attainment around entryyr -- 6-13 by year
graph twoway (line enroll_6 year) (line enroll_7 year) (line enroll_8 year) ///
	(line enroll_9 year) (line enroll_10 year) (line enroll_11 year) ///
	(line enroll_12 year) (line enroll_13 year), ylabel(, format(%9.1f) angle(horizontal)) ///
	ytitle("Average School Enrollment") ///
	xtitle("Year") ///
	title("Average School Enrollment of 6-13 Year Olds, Ghana") ///
	graphregion(color(white))
graph export enroll_6_13_byyear_gh.pdf, replace	

/*
* Line graph of edu attainment around entryyr -- 9-13 by year
graph twoway (line enroll_9 year) (line enroll_10 year) (line enroll_11 year) ///
	(line enroll_12 year) (line enroll_13 year) (line enroll_9_13 year), ///
	ylabel(, format(%9.1f) angle(horizontal)) ///
	ytitle("Average School Enrollment") ///
	xtitle("Year") ///
	title("Average School Enrollment of 9-13 Year Olds, Ghana")
graph export enroll_9_13_byyear_gh.pdf, replace	


* Line graph of edu attainment around entryyr -- 14-18 by year
graph twoway (line enroll_14 year) ///
	(line enroll_15 year) (line enroll_16 year) (line enroll_17 year) ///
	(line enroll_18 year), ylabel(, format(%9.1f) angle(horizontal)) ///
	ytitle("Average School Enrollment") ///
	xtitle("Year") ///
	title("Average School Enrollment of 14-18 Year Olds, Ghana")
graph export enroll_14_18_byyear_gh.pdf, replace	
	

			

	
*/	
	
***** DESCRIPTIVE STATS TABLES *****	

	
***** DESCRIPTIVE STATS TABLES *****	

*** FOR GEORGETOWN CONFERENCE SUBMISSION ***

* Descriptive Statistics - Ages 6-13 *
tabstat enrolled previnschool curgrade curedyrs minwdist collcount age age_atest prim_att urban male ///
	hhsize kidsunder6 bike motorcycle car watertime bednet elec fridge phone ///
	radio if $sample_prim==1, ///
	stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample1
mat sumstat1 = des_sample1'
frmttable using GH_Georgetown_sumstat.doc, replace statmat(sumstat1) store(t1) varlabels ///
	title("Descriptive Statistics, Children ages 6-13, Ghana") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  This sample is restricted to school age children between 6 and 13 years old.  Data are from the 1993-2014 waves of the Demographic and Health Survey (DHS) conducted by USAID.  College data are obtained from Ghana's National Accreditation Board.  Geographic data of colleges are obtained from Google Maps.")	posttext(" " \ " " \ " ")


* Descriptive Statistics - Enrollment *
tabstat enroll_6 enroll_7 enroll_8 enroll_9 enroll_10 enroll_11 enroll_12 ///
	enroll_13 enroll_14 enroll_15 enroll_16 enroll_17 enroll_18 enroll_6_13 ///
	enroll_6_10 enroll_9_13 if year>1999, stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample1
mat sumstat1 = des_sample1'
frmttable using GH_Georgetown_enrollmenttable.doc, replace statmat(sumstat1) store(t1) varlabels ///
	title("Average School Enrollment by Age, Ghana") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  Data are from the 2003-2014 waves of the Demographic and Health Survey (DHS) conducted by USAID.")	posttext(" " \ " " \ " ")	
	
/*


* Table 1: Descriptive Statistics - Ages 18+ *
tabstat edyrs minwdist age age_atest prim_att prim_comp sec_att sec_comp urban male ///
	hhsize kidsunder6 bike motorcycle car watertime bednet elec fridge phone ///
	radio if $sample18up==1, ///
	stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample
mat sumstat = des_sample'
frmttable using KE_sumstat.doc, replace statmat(sumstat) store(t1) varlabels ///
	title("Table 1: Descriptive Statistics of People Ages 18+, Kenya") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  This sample is restricted to people ages 18 and older.  Data are from the 1993-2014 waves of the Demographic and Health Survey (DHS) conducted by USAID.  College data are obtained from Ghana's National Accreditation Board.  Geographic data of colleges are obtained from Google Maps.")	posttext(" " \ " " \ " ")


* Table 2: Descriptive Statistics - Ages 6-13 IN entryyr *
tabstat enrolled previnschool curgrade curedyrs minwdist age age_atest prim_att prim_comp sec_att sec_comp urban male ///
	hhsize kidsunder6 bike motorcycle car watertime bednet elec fridge phone ///
	radio if $sample_prim_atest==1, ///
	stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample2
mat sumstat2 = des_sample2'
frmttable using GH_sumstat.doc, addtable statmat(sumstat2) store(t2) varlabels ///
	title("Table 2: Descriptive Statistics, Ages 6-13 in College Establishment Year, Ghana") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  This sample is restricted to people between age 6 and age 13 in the year of establishment of the nearest college.  Data are from the 1993-2014 waves of the Demographic and Health Survey (DHS) conducted by USAID.  College data are obtained from Ghana's National Accreditation Board.  Geographic data of colleges are obtained from Google Maps.")	posttext(" " \ " " \ " ")



* Table 3: Descriptive Statistics - Begin primary school AFTER entryyr *
tabstat enrolled previnschool curgrade curedyrs minwdist age age_atest prim_att prim_comp sec_att sec_comp urban male ///
	hhsize kidsunder6 bike motorcycle car watertime bednet elec fridge phone ///
	radio if $sample_prim_post==1, ///
	stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample3
mat sumstat3 = des_sample3'
frmttable using GH_sumstat.doc, addtable statmat(sumstat3) store(t3) varlabels ///
	title("Table 3: Descriptive Statistics, Children who Begin Primary School After College Establishment Year, Ghana") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  This sample is restricted to people an eight-year age cohort that begins primary school directly after the year of establishment of the nearest college.  Data are from the 2003-2014 waves of the Demographic and Health Survey (DHS) conducted by USAID.  College data are obtained from Ghana's National Accreditation Board.  Geographic data of colleges are obtained from Google Maps.")	posttext(" " \ " " \ " ")





* Table 4: Descriptive Statistics - Enrollment *
tabstat enroll_6 enroll_7 enroll_8 enroll_9 enroll_10 enroll_11 enroll_12 ///
	enroll_13 enroll_14 enroll_15 enroll_16 enroll_17 enroll_18 enroll_6_13 ///
	enroll_6_10 enroll_9_13, stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample4
mat sumstat4 = des_sample4'
frmttable using GH_sumstat.doc, addtable statmat(sumstat4) store(t4) varlabels ///
	title("Table 4: Average School Enrollment by Age, Ghana") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  Data are from the 1993-2014 waves of the Demographic and Health Survey (DHS) conducted by USAID.")	posttext(" " \ " " \ " ")
	
	
	
** Enrollment by Year **
	
* Table 5: Descriptive Statistics - Enrollment in 2003 *
tabstat enroll_6 enroll_7 enroll_8 enroll_9 enroll_10 enroll_11 enroll_12 ///
	enroll_13 enroll_14 enroll_15 enroll_16 enroll_17 enroll_18 enroll_6_13 ///
	enroll_6_10 enroll_9_13 if year==2003, stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample5
mat sumstat5 = des_sample5'
frmttable using GH_sumstat.doc, addtable statmat(sumstat5) store(t5) varlabels ///
	title("Table 5: Average School Enrollment by Age, Ghana, 2003") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  Data are from the 2003 wave of the Demographic and Health Survey (DHS) conducted by USAID.")	posttext(" " \ " " \ " ")
	

* Table 6: Descriptive Statistics - Enrollment in 2008*
tabstat enroll_6 enroll_7 enroll_8 enroll_9 enroll_10 enroll_11 enroll_12 ///
	enroll_13 enroll_14 enroll_15 enroll_16 enroll_17 enroll_18 enroll_6_13 ///
	enroll_6_10 enroll_9_13 if year==2008, stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample6
mat sumstat6 = des_sample6'
frmttable using GH_sumstat.doc, addtable statmat(sumstat6) store(t6) varlabels ///
	title("Table 6: Average School Enrollment by Age, Ghana, 2008") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  Data are from the 2008 wave of the Demographic and Health Survey (DHS) conducted by USAID.")	posttext(" " \ " " \ " ")
	

* Table 7: Descriptive Statistics - Enrollment in 2011*
tabstat enroll_6 enroll_7 enroll_8 enroll_9 enroll_10 enroll_11 enroll_12 ///
	enroll_13 enroll_14 enroll_15 enroll_16 enroll_17 enroll_18 enroll_6_13 ///
	enroll_6_10 enroll_9_13 if year==2014, stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample7
mat sumstat7 = des_sample7'
frmttable using GH_sumstat.doc, addtable statmat(sumstat7) store(t7) varlabels ///
	title("Table 7: Average School Enrollment by Age, Ghana, 2014") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  Data are from the 2014 wave of the Demographic and Health Survey (DHS) conducted by USAID.")	posttext(" " \ " " \ " ")
	
	
	
	
** Enrollment by Wealth Index Quintiles **

* Table 8: Descriptive Statistics - Enrollment in Quintile 1 (lowest)*
tabstat enroll_6 enroll_7 enroll_8 enroll_9 enroll_10 enroll_11 enroll_12 ///
	enroll_13 enroll_14 enroll_15 enroll_16 enroll_17 enroll_18 enroll_6_13 ///
	enroll_6_10 enroll_9_13 if $sample_we1==1, stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample8
mat sumstat8 = des_sample8'
frmttable using GH_sumstat.doc, addtable statmat(sumstat8) store(t8) varlabels ///
	title("Table 8: Average School Enrollment in Lowest Wealth Index Quintile, Ghana") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  This sample is restricted to children from the lowest wealth index quintile.  Data are from the 1993-2014 waves of the Demographic and Health Survey (DHS) conducted by USAID.")	posttext(" " \ " " \ " ")
	

* Table 9: Descriptive Statistics - Enrollment in Quintile 2 (second lowest)*
tabstat enroll_6 enroll_7 enroll_8 enroll_9 enroll_10 enroll_11 enroll_12 ///
	enroll_13 enroll_14 enroll_15 enroll_16 enroll_17 enroll_18 enroll_6_13 ///
	enroll_6_10 enroll_9_13 if $sample_we2==1, stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample9
mat sumstat9 = des_sample9'
frmttable using GH_sumstat.doc, addtable statmat(sumstat9) store(t9) varlabels ///
	title("Table 9: Average School Enrollment in Wealth Index Quintile 2, Ghana") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  This sample is restricted to children from the second lowest wealth index quintile.  Data are from the 1993-2014 waves of the Demographic and Health Survey (DHS) conducted by USAID.")	posttext(" " \ " " \ " ")
	

* Table 10: Descriptive Statistics - Enrollment in Quintile 3 (middle)*
tabstat enroll_6 enroll_7 enroll_8 enroll_9 enroll_10 enroll_11 enroll_12 ///
	enroll_13 enroll_14 enroll_15 enroll_16 enroll_17 enroll_18 enroll_6_13 ///
	enroll_6_10 enroll_9_13 if $sample_we3==1, stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample10
mat sumstat10 = des_sample10'
frmttable using GH_sumstat.doc, addtable statmat(sumstat10) store(t10) varlabels ///
	title("Table 10: Average School Enrollment in Middle Wealth Index Quintile, Ghana") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  This sample is restricted to children from the middle wealth index quintile.  Data are from the 1993-2014 waves of the Demographic and Health Survey (DHS) conducted by USAID.")	posttext(" " \ " " \ " ")
					

* Table 11: Descriptive Statistics - Enrollment in Quintile 4 (second highest)*
tabstat enroll_6 enroll_7 enroll_8 enroll_9 enroll_10 enroll_11 enroll_12 ///
	enroll_13 enroll_14 enroll_15 enroll_16 enroll_17 enroll_18 enroll_6_13 ///
	enroll_6_10 enroll_9_13 if $sample_we4==1, stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample11
mat sumstat11 = des_sample11'
frmttable using GH_sumstat.doc, addtable statmat(sumstat11) store(t11) varlabels ///
	title("Table 11: Average School Enrollment in Wealth Index Quintile 4, Ghana") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  This sample is restricted to children from the second highest wealth index quintile.  Data are from the 1993-2014 waves of the Demographic and Health Survey (DHS) conducted by USAID.")	posttext(" " \ " " \ " ")
		

* Table 12: Descriptive Statistics - Enrollment in Quintile 5 (highest)*
tabstat enroll_6 enroll_7 enroll_8 enroll_9 enroll_10 enroll_11 enroll_12 ///
	enroll_13 enroll_14 enroll_15 enroll_16 enroll_17 enroll_18 enroll_6_13 ///
	enroll_6_10 enroll_9_13 if $sample_we5==1, stat(mean sd N) save f(%20.0gc)
tabstatmat des_sample12
mat sumstat12 = des_sample12'
frmttable using GH_sumstat.doc, addtable statmat(sumstat12) store(t12) varlabels ///
	title("Table 12: Average School Enrollment in Highest Wealth Index Quintile, Ghana") ///
	ctitles(" " "Mean" "SD" "N") coljust(l{c}) nocenter hlstyle(dsd) ///
	note("Notes:  This sample is restricted to children from the highest wealth index quintile.  Data are from the 1993-2014 waves of the Demographic and Health Survey (DHS) conducted by USAID.")	posttext(" " \ " " \ " ")

*/	
		
		
save GH_analysis.dta, replace		



		
////////////////////////////////////////////////////////////////////////////////

								***** MAPS *****
		
////////////////////////////////////////////////////////////////////////////////





	
	
		
		
*log close
