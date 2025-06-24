cd "/Users/j.p./Downloads/URL Files/data"
clear all

/*******************************************************************************
********************************************************************************

Author:				J.P. Fuertez

Date:				February 26, 2024
Last Revised:		

This do file cleans country-year level education expenditure data from the World Bank EdStats database.  The input data is annual data for all countries and all levels of education over 2010-2022

Datasets used:		-/Users/j.p./Downloads/URL Files/data/edex_gdp_labor_tertiary_pop_data_merged.dta
					-

Output:				
					-

********************************************************************************
*******************************************************************************/

********************************************************************************

***** Define globals *****

global edstatsdata "/Users/maddisonerbabian/Desktop/Research/Data/World Bank EdStats"

global cleanedexpend "$edstatsdata/11.22.23 Data Extract From Education Statistics Education Expenditure/Clean"

global data_other "$edstatsdata/11.27.23 Data Extracts from WB EdStats Ed Expenditures/"

global clean_other "$data_other/Clean"

global figures "$edstatsdata/Figures"

if ter_govtotaled & TE_both <= 10000000
********************************************************************************

use "edex_gdp_labor_tertiary_pop_data_merged.dta", clear


* Figure for Government Spending on tertiaty education and tertiary enrollment
graph twoway scatter ter_govtotaled TE_both if TE_both <= 10000000, ///
			title("Government Education Expenditure on Teriary Education vs. Tertiary Enrollment", size(medium)) ///
			graphregion(color(white)) msymbol(circle_hollow) ///
			ytitle("Share of Government Expenditure on Tertiary Education") ///
			xtitle("Total Tertiary Enrollment for Both Genders ", size(medium)) ytitle(,size(small))

			*Potential skew since countries with large enrollment have larger populations*


* Figure for tertiary-primary spending ratio globally with log gdp pc

preserve
	keep if year>=2007 & year<=2017
	drop if ter_prim_perstudent == .
	
	collapse (mean) ter_prim_perstudent log_gdp_pc, by(countryid countryname)
	
	* Label variables
	la var log_gdp_pc "Log GDP per capita"
	la var ter_prim_perstudent "Tertiary-Primary Per Student Gov. Spending Ratio"

	graph twoway scatter ter_prim_perstudent log_gdp_pc, ///
			title("Tertiary-Primary Education Gov. Expenditure Ratios" "by National Per Capita Income, 2007-2017") ///
			graphregion(color(white))
	graph export "$figures/ter-prim_ps_spendingratios_bylogGDPpc_pooled_2007_2017.png", replace

restore 

exit
preserve
	collapse (mean) ter_prim_perstudent ter_sec_perstudent log_gdp_pc gni_curr ter_prim_hh ter_sec_hh, by(countryid countryname yrgrp)
	sort yrgrp countryname
	sort yrgrp log_gdp_pc
	
	* Label variables
	la var log_gdp_pc "Log GDP per capita"
	la var gni_curr "GNI, current USD"
	la var ter_prim_perstudent "Tertiary-Primary Per Student Gov. Spending Ratio"
	la var ter_sec_perstudent "Tertiary-Secondary Per Student Gov. Spending Ratio"
	
	* Store yrgrp values in local to be used in figure-making loop
	levelsof yrgrp, local(levels)

	* Grouped Years scatterplots of tertiary-primary expenditure ratio
	foreach i of local levels {

	local label : label (yrgrp) `i'

	* Graphs with log GDP PC
	quietly graph twoway scatter ter_prim_perstudent log_gdp_pc if yrgrp==`i' & ter_prim_perstudent != ., ///
			title("Tertiary-Primary Education Gov. Expenditure Ratios" "by Income, `label'") ///
			name(scatter_terprimgrp_`i', replace) ///
			graphregion(color(white)) mlabel(countryname)
	graph export "$figures/Year Groups/ter-prim_ps_spendingratios_bylogGDPpc_`label'.png", replace
			//

	quietly graph twoway scatter ter_sec_perstudent log_gdp_pc if yrgrp==`i' & ter_sec_perstudent != ., ///
			title("Tertiary-Secondary Education Gov. Expenditure Ratios" "by Income, `label'") ///
			name(scatter_tersecgrp_`i', replace) ///
			graphregion(color(white)) mlabel(countryname)
	graph export "$figures/Year Groups/ter-sec_ps_spendingratios_bylogGDPpc_`label'.png", replace
			// 
	}
	
	* Grouped Years HH scatterplots of tertiary-primary expenditure ratio
	foreach i of local levels {

	local label : label (yrgrp) `i'

	* Graphs with log GDP PC
	quietly graph twoway scatter ter_prim_hh log_gdp_pc if yrgrp==`i' & ter_prim_perstudent != ., ///
			title("Tertiary-Primary Education HH Expenditure Ratios" "by Income, `label'") ///
			name(scatter_terprimgrp_`i', replace) ///
			graphregion(color(white)) mlabel(countryname)
	graph export "$figures/Year Groups/HHter-prim_ps_spendingratios_bylogGDPpc_`label'.png", replace
			//

	quietly graph twoway scatter ter_sec_hh log_gdp_pc if yrgrp==`i' & ter_sec_perstudent != ., ///
			title("Tertiary-Secondary Education HH Expenditure Ratios" "by Income, `label'") ///
			name(scatter_tersecgrp_`i', replace) ///
			graphregion(color(white)) mlabel(countryname)
	graph export "$figures/Year Groups/HHter-sec_ps_spendingratios_bylogGDPpc_`label'.png", replace
			// 
	}	

restore



exit




* Time Lapse Scatterplot of Year Group Figures

graph combine scatter_terprimgrp_*, col(1) name(timelapse_terprim_grp)


exit
foreach i of local levels {
	
}		
	
	
* binscatter y: spending ratio x: loggdp absorb: year FE		
	
	
	














