clear all

/*Author:				J.P. Fuertez

Date Begun:			January 29, 2024	
Last Revised:		February 12, 2024

This do file cleans and reshapes country-year level data from the World Bank EdStats database.  The input data is annual data for all countries and all levels of education over 2010-2022.

Datasets used:		-pop_data_11.27.23.csv

Output:				
					-ed_expend_XXXXXX_clean.dta
*/




cd "/Users/j.p./Downloads/URL Files/data"


***** Population Dataset *****

********************************************************************************

import delimited "pop_data_11.27.23.csv", varnames(1) clear


* Recode all ".." entries to missing
forvalues i=1995/2022 {
	
	replace yr`i' = "."  if yr`i'== ".."
	destring yr`i', replace
}

sort countrycode
by countrycode: gen newid = 1 if _n==1
replace newid = sum(newid)
replace newid = . if missing(countrycode)
egen countryid = group(countrycode), label

drop if countryid == .

gen newid_str = "00" + string(newid) if newid < 10
	replace newid_str = "0" + string(newid) if newid >= 10 & newid < 100 
	replace newid_str = string(newid) if newid >= 100

order countrycode seriesname seriescode 
sort countrycode seriesname seriescode
	
********************************************************************************
	
* Keep simplest variables
keep if seriescode == "SP.POP.GROW" | seriescode == "UIS.SAP.CE" | seriescode == "UIS.SAP.CE.F" | seriescode == "UIS.SAP.CE.M" | seriescode == "UIS.SAP.1.G1"| seriescode == "UIS.SAP.23.GPV.G1" | seriescode == "UIS.SAP.23.GPV.G1.F" | seriescode == "UIS.SAP.23.GPV.G1.M" | seriescode == "SP.POP.TOTL.FE.IN" | seriescode == "SP.POP.TOTL.MA.IN" | seriescode == "SP.POP.TOTL" | seriescode == "SP.PRM.TOTL.IN" | seriescode == "SP.PRM.TOTL.FE.IN" | seriescode == "SP.PRM.TOTL.MA.IN" |  seriescode == "SP.SEC.TOTL.IN" |  seriescode == "SP.SEC.TOTL.FE.IN" | seriescode == "SP.SEC.TOTL.MA.IN" |  seriescode == "SP.TER.TOTL.IN" | seriescode == "SP.TER.TOTL.FE.IN" | seriescode == "SP.TER.TOTL.MA.IN" 

* Population growth and Populatio of Particular School Age	
gen var = "population_growth" if seriescode == "SP.POP.GROW"
	// Population of compulsory school age, both sexes (number)
	replace var = "cmplsryage_both" if seriescode == "UIS.SAP.CE"
	// Population of compulsory school age, female (number)
	replace var = "cmplsryage_f" if seriescode == "UIS.SAP.CE.F"
	// Population of compulsory school age, male (number)
	replace var = "cmplsryage_m" if seriescode == "UIS.SAP.CE.M"
	// Population of the official entrance age to primary education, both sexes (number)
	replace var = "primaryage_both" if seriescode == "UIS.SAP.1.G1"
	// Population of the official entrance age to secondary general education, both sexes (number)
	replace var = "secondaryage_both" if seriescode == "UIS.SAP.23.GPV.G1"
	// Population of the official entrance age to secondary general education, female (number)
	replace var = "secondaryage_f" if seriescode == "UIS.SAP.23.GPV.G1.F"
	// Population of the official entrance age to secondary general education, male (number)
	replace var = "secondaryage_m" if seriescode == "UIS.SAP.23.GPV.G1.M"

* Population by Gender
	// Total population
	replace var = "totalpop" if seriescode == "SP.POP.TOTL"
	//Population, female
	replace var = "popfemale" if seriescode == "SP.POP.TOTL.FE.IN"
	//Population, male
	replace var = "popmale" if seriescode == "SP.POP.TOTL.MA.IN"
	
* School Age Population by Level
	//School age population, primary education, both sexes (number)
	replace var = "spprimary_both" if seriescode == "SP.PRM.TOTL.IN"
	//School age population, primary education, female (number)
	replace var = "spprimary_f" if seriescode == "SP.PRM.TOTL.FE.IN"
	//School age population, primary education, male (number)
	replace var = "spprimary_m" if seriescode == "SP.PRM.TOTL.MA.IN"
	//School age population, secondary education, both sexes (number)
	replace var = "spsecond_both" if seriescode == "SP.SEC.TOTL.IN"
	//School age population, secondary education, female (number)
	replace var = "spsecond_f" if seriescode == "SP.SEC.TOTL.FE.IN"
	//School age population, secondary education, male (number)
	replace var = "spsecond_m" if seriescode == "SP.SEC.TOTL.MA.IN"
	//School age population, tertiary education, both sexes (number)
	replace var = "sptert_both" if seriescode == "SP.TER.TOTL.IN"
	//School age population, tertiary education, female (number)
	replace var = "sptert_f" if seriescode == "SP.TER.TOTL.FE.IN"
	//School age population, tertiary education, male (number)
	replace var = "sptert_m" if seriescode == "SP.TER.TOTL.MA.IN"

* Drop years with all missing observations
drop yr2021 yr2022

* Temporarily drop seriescode and seriesname
drop seriescode seriesname

drop countrycode 

sort countryid countryname var

* Bring key variables to front of dataset
order countryid countryname var

* Reshape long to wide for variables
reshape wide yr*, i(countryid) j(var) string

foreach year of numlist 1995(1)2020 {
	
	rename yr`year'*    *yr`year'
}

foreach year of numlist 1995(1)2020 {
	
	rename    *yr`year'  *`year'
}


* Reshape long so that year becomes a variable and we end up with country-year pairs for each observation 
reshape long population_growth cmplsryage_both cmplsryage_f cmplsryage_m primaryage_both secondaryage_both secondaryage_f secondaryage_m totalpop popfemale popmale spprimary_both spprimary_f spprimary_m spsecond_both spsecond_f spsecond_m sptert_both sptert_f sptert_m, i(countryid) j(year)


* Label variables
la var population_growth "Population growth (annual %)"
la var cmplsryage_both "Population of compulsory school age, both sexes (number)"
la var cmplsryage_f "Population of compulsory school age, female (number)"
la var cmplsryage_m "Population of compulsory school age, male (number)"
la var primaryage_both "Population of the official entrance age to primary education, both sexes (number)"
la var secondaryage_both "Population of the official entrance age to secondary general education, both sexes (number)"
la var secondaryage_f "Population of the official entrance age to secondary general education, female (number)"
la var secondaryage_m "Population of the official entrance age to secondary general education, male (number)"
la var totalpop "Population, total"
la var popfemale "Population, female"
la var popmale "Population, male"
la var spprimary_both "School age population, primary education, both sexes (number)"
la var spprimary_f "School age population, primary education, female (number)"
la var spprimary_m "School age population, primary education, male (number)"
la var spsecond_both "School age population, secondary education, both sexes (number)"
la var spsecond_f "School age population, secondary education, female (number)"
la var spsecond_m "School age population, secondary education, male (number)"
la var sptert_both "School age population, tertiary education, both sexes (number)"
la var sptert_f "School age population, tertiary education, female (number)"
la var sptert_m "School age population, tertiary education, male (number)"

* Create unique country-yr ID                                 
gen countryyr_id_str = "1" + newid_str + string(year)

drop newid newid_str

encode countryyr_id_str, gen(country_yr_id) 

drop countryyr_id_str

********************************************************************************

* Drop regions and organize dataset 

order countryid countryname year country_yr_id

numlabel, add 

* Drop regions

drop if inlist(countryid, 2, 4, 8, 12, 32, 37, 50, 57, 58, 62, 63, 64, 65, 66, 69, 74, 75, 79, 80, 96, 99, 103, 104, 105, 106, 108, 109, 111, 113, 123, 129, 130, 136, 137, 140, 143, 154, 157, 162, 171, 182, 184, 192, 193, 198, 199, 205, 216, 218, 219, 220, 221, 228, 231, 232, 237, 239, 241, 242, 250, 254, 256, 257, 260)

*Drop missing columns


********************************************************************************


* Save dataset with education level spending ratios
save "population_clean.dta", replace
	

********************************************************************************

			***** MERGE *****
			
use "ed_expend_gdp_clean.dta", clear 
drop _merge

merge 1:1 countryname year using "clean_labor_data.dta"

save "ed_expend_gdp_labor_data_merged.dta", replace 

use "ed_expend_gdp_labor_data_merged.dta", clear
drop _merge

merge 1:1 countryname year using "clean_tertiary_data.dta"

save "ed_expend_gdp_labor_tertiary_data_merged.dta", replace 

use "ed_expend_gdp_labor_tertiary_data_merged.dta", clear 
drop _merge

merge 1:1 countryname year using "population_clean.dta"
drop _merge

save "edex_gdp_labor_tertiary_pop_data_merged.dta", replace 
********************************************************************************


