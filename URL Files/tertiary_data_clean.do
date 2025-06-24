 
clear all
set more off
cd "/Users/j.p./Downloads/URL Files"

/*******************************************************************************
********************************************************************************

Author:				Jane Merkle

Date Begun:			January 22, 2024	
Last Revised:		January 30, 2024

This do file cleans and reshapes country-year level data from the World Bank EdStats database.  The input data is annual data for all countries and all levels of education over 2019-2022.

Datasets used:	
					-tertiaryed_data_11.27.23.csv

Output:				
					-clean_tertiary_data

********************************************************************************
*******************************************************************************/

********************************************************************************
***** Define globals **********

global edstatsdata "/Users/janemerkle/Desktop/URL/World Bank EdStats"

// global cleanedexpend "$edstatsdata/11.22.23 Data Extract From Education Statistics Education Expenditure/Clean"

// global data_other "$edstatsdata/11.27.23 Data Extracts from WB EdStats Ed Expenditures/"

// global clean_other "$data_other/Clean"

// global figures "$edstatsdata/Figures"

// global work "/Users/maddisonerbabian/Desktop/Research/Code/Edu Expenditures/Work 12.29.23"


********************************************************************************

***** Tertiary Education Dataset *****

********************************************************************************

import delimited "/Users/j.p./Downloads/URL Files/tertiaryed_data_11.27.23.csv", varnames(1) clear

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
keep if seriescode == "SE.TER.ENRL" | seriescode == "SE.TER.ENRL.FE" | seriescode == "UIS.E.58.M" | seriescode == "UIS.GAR.5T8" | seriescode == "SE.TER.ENRR" | seriescode == "SE.TER.CMPL.ZS" | seriescode == "UIS.MSEP.56" | seriescode == "UIS.MSEP.56.F" | seriescode == "UIS.MSEP.56.M" | seriescode == "UIS.MENF.56" | seriescode == "UIS.MENFR.56" | seriescode == "UIS.OMR.56" | seriescode == "SE.TER.PRIV.ZS" |  seriescode == "UIS.FOSGP.5T8.F500600700" |  seriescode == "UIS.FOSGP.5T8.FNON500600700" | seriescode == "UIS.FOSGP.5T8.F400" |  seriescode == "UIS.FOSGP.5T8.F600" | seriescode == "SE.TER.GRAD.ED.ZS" | seriescode == "SE.TER.GRAD.EN.ZS" | seriescode == "SE.TER.GRAD.HL.ZS" | seriescode == "SE.TER.GRAD.SC.ZS" | seriescode == "UIS.MS.56.T" | seriescode == "UIS.MS.56.M" | seriescode == "UIS.MS.56.F" | seriescode == "UIS.OE.56.40510" 

****************************************************************************

* Enrollment & Attendance vars	
gen var = "TE_both" if seriescode == "SE.TER.ENRL"
	replace var = "TE_both" if seriescode == "SE.TER.ENRL"
	// enrollment in tertiary ed, all programmes, both sexes (#)
	replace var = "TE_f" if seriescode == "SE.TER.ENRL.FE"
	// enrollment in tertiary ed, all programmes, female (#)
	replace var = "TE_m" if seriescode == "UIS.E.58.M"
	// enrollment in tertiary ed, all programmes, male (#)
	replace var = "AR_TE_both" if seriescode == "UIS.GAR.5T8"
	// gross attendance ratio for tertiary ed, both sexes (%)
	replace var = "ER_TE_both" if seriescode == "SE.TER.ENRR"
	// gross enrollment ratio for tertiary ed, both sexes (%)
	replace var = "AE_TE" if seriescode == "SE.TER.PRIV.ZS"
	// 	%age of enrollment in tertiary ed in private institutions (%)
	
* Graduation vars	
	replace var = "GR_TE_both" if seriescode == "SE.TER.CMPL.ZS"
	// gross graduation ratio from first degree programmes (ISCED 6 and 7) in tertiary ed, both sexes (%)
	replace var = "GTE_both" if seriescode == "SE.TER.GRAD.ED.ZS"
	// Percentage of graduates from tertiary education graduating from Education programmes, both sexes(%)
	replace var = "GTE_emc_both" if seriescode == "SE.TER.GRAD.EN.ZS"
	// Percentage of graduates from tertiary education graduating from Engineering, Manufacturing and 	Construction programmes, both sexes (%)
	replace var = "GTE_hw_both" if seriescode == "SE.TER.GRAD.HL.ZS"
	// Percentage of graduates from tertiary education graduating from Health and Welfare programmes, both sexes (%)
	replace var = "GTE_sms_both" if seriescode == "SE.TER.GRAD.SC.ZS"
	// Percentage of graduates from tertiary education graduating from Natural Sciences, Mathematics and Statistics programmes, both sexes (%)

	
* Grads by Major vars
	replace var = "AG_STEM_both" if seriescode == "UIS.FOSGP.5T8.F500600700"
	// %age of grads in STEM, both sexes (%)
	replace var = "AG_not_STEM_both" if seriescode == "UIS.FOSGP.5T8.FNON500600700"
	// %age of grads not in STEM, both sexes (%)
	replace var = "AG_bizlawadmn_both" if seriescode == "UIS.FOSGP.5T8.F400"
	// %age of grads in business, law, and admin, both sexes (%)
	replace var = "AG_IT_both" if seriescode == "UIS.FOSGP.5T8.F600"
	// %age of grads in IT, both sexes (%)


* Migration vars
	replace var = "IMR_both" if seriescode == "UIS.MSEP.56"
	// inbound mobility rate, both sexes (%)
	replace var = "IMR_f" if seriescode == "UIS.MSEP.56.F"
	// inbound mobility rate, female (%)
	replace var = "IMR_m" if seriescode == "UIS.MSEP.56.M"
	// inbound mobility rate, male (%)
	replace var = "F_IntM_both" if seriescode == "UIS.MENF.56"
	// Net flow of internationally mobile students (inbound - outbound), both sexes (number)
	replace var = "FR_IntM_both" if seriescode == "UIS.MENFR.56"
	// Net flow ratio of internationally mobile students (inbound - outbound), both sexes (%)
	replace var = "OMR_both" if seriescode == "UIS.OMR.56"
	// Outbound mobility ratio, all regions, both sexes (%)
	replace var = "Tot_IM_both" if seriescode == "UIS.MS.56.T"
	// Total inbound internationally mobile students, both sexes (number)
	replace var = "Tot_IM_m" if seriescode == "UIS.MS.56.M"
	// Total inbound internationally mobile students, male (number)
	replace var = "Tot_IM_f" if seriescode == "UIS.MS.56.F"
	// Total inbound internationally mobile students, female (number)
	replace var = "OM_TE_st_ab_both" if seriescode == "UIS.OE.56.40510"
	// Total outbound internationally mobile tertiary students studying abroad, all countries, both sexes (number)
	
* Miscellaneous vars !!!!!!
	// replace var = "" if seriescode == ""
	// 
	
* Drop years with all missing observations
*drop 

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

* Reshape long so that year becomes a variable and we end up with country-year pairs for each observation !!!!!
reshape long TE_both TE_f TE_m AR_TE_both ER_TE_both AE_TE GR_TE_both GTE_both GTE_emc_both GTE_hw_both GTE_sms_both AG_STEM_both AG_not_STEM_both AG_bizlawadmn_both AG_IT_both IMR_both IMR_f IMR_m F_IntM_both FR_IntM_both OMR_both Tot_IM_both Tot_IM_m Tot_IM_f OM_TE_st_ab_both, i(countryid) j(year)
*******************************************************************

* Label variables
la var TE_both "tertiary enrollment, both"
la var TE_f "tertiary enrollment, female"
la var TE_m "tertiary enrollment, male"
la var AR_TE_both "tertiary attendance ratio, both"
la var ER_TE_both "tertiary enrollment ratio, both"
la var AE_TE "tertiary enrollment age, private"
la var GR_TE_both "tertiary grad ratio, 1st degree, both"
la var GTE_both "% tertiary grads, education, both"
la var GTE_emc_both "% tertiary grads, manufacturing, construction, engineering, both"
la var GTE_hw_both "% tertiary grads, health + welfare, both"
la var GTE_sms_both "% tertiary grads, sciences, maths, stats, both"
la var AG_STEM_both "grad age, STEM, both"
la var AG_not_STEM_both "grad age, not STEM, both"
la var AG_bizlawadmn_both "grad age, business, law, admin, both"
la var AG_IT_both "grad age, IT, both"
la var IMR_both "inbound mobility rate, both"
la var IMR_f "inbound mobility rate, female"
la var IMR_m "inbound mobility rate, male"
la var F_IntM_both "flow of internationally mobile students, both sexes"
la var FR_IntM_both "flow ratio of internationally mobile students, both"
la var OMR_both "outbound mobility ratio, both"
la var Tot_IM_both "total inbound internationally mobile students, both"
la var Tot_IM_m "total inbound internationally mobile students, male"
la var Tot_IM_f "total inbound internationally mobile students, female"
la var OM_TE_st_ab_both "Total outbound internationally mobile tertiary students studying abroad, all countries, both"


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
// drop columns with no observations
// yr2021GTE_both, yr2021AE_TE, yr2021AE_TE, yr2020AG_IT_both, yr2021AG_IT_both, yr2022AG_IT_both, yr2020AG_STEM_both,  yr2021AG_STEM_both,  yr2022AG_STEM_both, yr2021AG_bizlawadmn_both, yr2022AG_bizlawadmn_both,  yr2021AG_not_STEM,  yr2022AG_not_STEM, yr2020AR_TE_both, yr2021AR_TE_both, yr2022AR_TE_both, yr2021ER_TE_both, yr2022ER_TE_both, yr2019FR_IntM_both, yr2020FR_IntM_both, yr2021FR_IntM_both, yr2022FR_IntM_both, yr2019F_IntM_both, yr2019F_IntM_both, yr2020F_IntM_both, yr2021F_IntM_both, yr2022F_IntM_both, yr2020GR_TE_both, yr2021GR_TE_both, yr2022GR_TE_both, yr2020GTE_both, yr2021GTE_both, yr2022GTE_both, yr2020GTE_emc_both, yr2021GTE_emc_both, tab yr2022GTE_emc_both, yr2021GTE_hw_both, yr2022GTE_hw_both, yr2020GTE_sms_both, yr2021GTE_sms_both, yr2022GTE_sms_both, yr2021IMR_both, yr2022IMR_both, yr2021IMR_f, yr2022IMR_f, yr2021IMR_m, yr2022IMR_m, OMR_both (2019-22), OM_TE_st_ab_both (2019-22), yr2021TE_both, yr2022TE_both, yr2021TE_f, yr2022TE_f, yr2021TE_m, yr2022TE_m, yr2021Tot_IM_both, yr2022Tot_IM_both, yr2021Tot_IM_f, yr2022Tot_IM_f, yr2021Tot_IM_m, yr2022Tot_IM_m


* Save dataset with education level spending ratios
save "clean_tertiary_data", replace 

********************************************************************************
********************************************************************************
** MERGE **
use "/Users/janemerkle/Desktop/URL W24/World Bank EdStats/ed_expend_gdp_merged.dta"
merge 1:1 countryname year using "/Users/janemerkle/Desktop/URL W24/clean_tertiary_data.dta"

save "ed_expend_gdp_tertiary_data_merged.dta", replace 






















