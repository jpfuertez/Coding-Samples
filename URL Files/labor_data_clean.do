***** Labor Data ***************************************************************
********************************************************************************
clear all
set more off
cd "/Users/j.p./Downloads/URL Files"

*********************************************************************************
* Author: Jane Merkle
* Date begun: Feb 4, 2024
* Last modified: Feb 4, 2024

* This do file cleans country level labor data from the World Bank EdStats Database.

* Datasets used: labor_data_11.27.23.csv
* Output: 

********************************************************************************

import delimited "/Users/j.p./Downloads/URL Files/labor_data_11.27.23.csv", varnames(1) clear

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

* Labor force education level variables
gen var = "LF_advanced_ed" if seriescode == "SL.TLF.ADVN.ZS"
	replace var = "LF_advanced_ed" if seriescode == "SL.TLF.ADVN.ZS"
	// Labor force with advanced education (% of total labor force)
	replace var = "LF_advanced_ed_f" if seriescode == "SL.TLF.ADVN.FE.ZS"
	// Labor force with advanced education, female (% of female labor force)
	replace var = "LF_advanced_ed_m" if seriescode == "SL.TLF.ADVN.MA.ZS"
	// Labor force with advanced education, male (% of male labor force)
	replace var = "LF_basic_ed" if seriescode == "SL.TLF.BASC.ZS"
	// Labor force with basic education (% of total labor force)
	replace var = "LF_basic_ed_f" if seriescode == "SL.TLF.BASC.FE.ZS"
	// Labor force with basic education, female (% of female labor force)
	replace var = "LF_basic_ed_m" if seriescode == "SL.TLF.BASC.MA.ZS"
	// Labor force with basic education, male (% of male labor force)
	replace var = "LF_intermediate_ed" if seriescode == "SL.TLF.INTM.ZS"
	// Labor force with intermediate education (% of total labor force )
	replace var = "LF_intermediate_ed_f" if seriescode == "SL.TLF.INTM.FE.ZS"
	// Labor force with intermediate education, female (% of female labor force)
	replace var = "LF_intermediate_ed_m" if seriescode == "SL.TLF.INTM.MA.ZS"
	// Labor force with intermediate education, male (% of male labor force)
	
* Labor force 
	replace var = "LF_f" if seriescode == "SL.TLF.TOTL.FE.ZS"
	// Labor force, female (% of total labor force)
	replace var = "LF_total" if seriescode == "SL.TLF.TOTL.IN"
	// Labor force, total
	
* Unemployment + not enrolled in education variables
	replace var = "youth_neet_f" if seriescode == "SL.UEM.NEET.FE.ZS"
	// Share of youth not in education, employment, or training, female (% of female youth population)
	replace var = "youth_neet_m" if seriescode == "SL.UEM.NEET.MA.ZS"
	// Share of youth not in education, employment, or training, male (% of male youth population)
	replace var = "youth_neet" if seriescode == "SL.UEM.NEET.ZS"
	// Share of youth not in education, employment, or training, total (% of youth population)
	replace var = "unemployment_f" if seriescode == "SL.UEM.TOTL.FE.ZS"
	// Unemployment, female (% of female labor force)
	replace var = "unemployment_m" if seriescode == "SL.UEM.TOTL.MA.ZS"
	// Unemployment, male (% of male labor force)
	replace var = "unemployment" if seriescode == "SL.UEM.TOTL.ZS"
	// Unemployment, total (% of total labor force)
	
* Drop years with all missing observations
*drop yr2022 yr2021 yr2020	
	
* Temporarily drop seriescode and seriesname
drop seriescode seriesname

drop countrycode 

sort countryid countryname var

* Bring key variables to front of dataset
order countryid countryname var

* Reshape long to wide for variables  ***** !!!!
reshape wide yr*, i(countryid) j(var) string

 foreach year of numlist 1995(1)2022 {
	
	rename yr`year'*    *yr`year'
}

foreach year of numlist 1995(1)2022 {
	
	rename    *yr`year'  *`year'
}

* Reshape long so that year becomes a variable and we end up with country-year pairs for each observation 
reshape long LF_advanced_ed LF_advanced_ed_f LF_advanced_ed_m LF_intermediate_ed LF_intermediate_ed_f LF_intermediate_ed_m LF_basic_ed LF_basic_ed_f LF_basic_ed_m LF_f LF_total youth_neet youth_neet_f youth_neet_m unemployment unemployment_f unemployment_m, i(countryid) j(year)

* label variables
la var LF_advanced_ed "% labor force, advanced education"
la var LF_advanced_ed_f "% labor force, advanced education, female"
la var LF_advanced_ed_m "% labor force, advanced education, male"
la var LF_intermediate_ed "% labor force, intermediate education"
la var LF_intermediate_ed_f "% labor force, intermediate education, female"
la var LF_intermediate_ed_m "% labor force, intermediate education, male"
la var LF_basic_ed "% labor force, basic education"
la var LF_basic_ed_f "% labor force, basic education, female"
la var LF_basic_ed_m "% labor force, basic education, male"
la var LF_f "female labor force"
la var LF_total "total labor force"
la var youth_neet "youth not employed or enrolled"
la var youth_neet_f "youth not employed or enrolled, female"
la var youth_neet_m "youth not employed or enrolled, male"
la var unemployment "unemployment"
la var unemployment_f "female unemployment"
la var unemployment_m "male unemployment"
	
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

********************************************************************************
save "clean_labor_data", replace
********************************************************************************
********************************************************************************
** MERGE **
use "/Users/janemerkle/Desktop/URL W24/ed_expend_gdp_tertiary_data_merged.dta"
drop _merge
merge 1:1 countryname year using "/Users/janemerkle/Desktop/URL W24/clean_labor_data.dta"
	// says variable _merge alr defined... ik i have to drop but how
	
save "ed_expend_gdp_tertiary_labor_data_merged.dta", replace 
	
use "/Users/janemerkle/Desktop/URL W24/ed_expend_gdp_tertiary_labor_data_merged.dta" 	
drop _merge
merge 1:1 countryname year using "/Users/janemerkle/Desktop/URL W24/population_clean.dta"
	
save "ed_expend_gdp_tertiary_labor_pop_data_merged", replace
	
	
	
	
	
	
	
	
	
	


	  
