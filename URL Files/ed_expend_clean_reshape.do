cd "/Users/j.p./Downloads/URL Files/data"
clear all

/*******************************************************************************
********************************************************************************

Author:				Maddison Erbabian

Date Begun:			November 15, 2023	
Last Revised:		January 19, 2024

This do file cleans country-year level education expenditure data from the World Bank EdStats database.  The input data is annual data for all countries and all levels of education over 2010-2022

Datasets used:		-11.22.23_edspending_data.csv
					-gdp_background_data_11.27.23.csv

Output:				
					-ed_expend_gdp_clean.dta
					-ed_expend_ratios_clean.dta
					-ed_expend_gdp_merged.dta
					-gdp_clean

********************************************************************************
*******************************************************************************/

********************************************************************************

***** Define globals *****

global edstatsdata "/Users/maddisonerbabian/Desktop/Research/Data/World Bank EdStats"

global cleanedexpend "$edstatsdata/11.22.23 Data Extract From Education Statistics Education Expenditure/Clean"

global data_other "$edstatsdata/11.27.23 Data Extracts from WB EdStats Ed Expenditures/"

global clean_other "$data_other/Clean"

global figures "$edstatsdata/Figures"


********************************************************************************

import delimited "11.22.23_edspending_data.csv", varnames(1) clear


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

* Drop irrelevant variables
drop if seriescode == "UIS.XSPENDP.1.FDPUB.FNBOOKS" | seriescode == "UIS.XSPENDP.23.FDPUB.FNBOOKS"

* Keep simplest government education expenditure variables 
* Keep per student and per capita spending measures

keep if seriescode == "UIS.XGDP.56.FSGOV" | seriescode == "UIS.X.US.5T8.FSGOV" | seriescode == "UIS.XGDP.1.FSGOV" | seriescode == "UIS.X.US.1.FSGOV" | seriescode == "UIS.XGDP.23.FSGOV" | seriescode == "UIS.X.US.2T3.FSGOV" | seriescode == "SE.XPD.TOTL.GB.ZS" | seriescode == "SE.XPD.TOTL.GD.ZS" | seriescode == "UIS.X.US.FSGOV" | seriescode == "UIS.XUNIT.GDPCAP.1.FSGOV" | seriescode == "UIS.XUNIT.PPPCONST.1.FSGOV" | seriescode == "UIS.XUNIT.GDPCAP.1.FSHH" | seriescode == "UIS.XUNIT.PPPCONST.1.FSHH" | seriescode == "UIS.XUNIT.PPPCONST.1.FSHH" |  seriescode == "UIS.XUNIT.GDPCAP.23.FSGOV" |  seriescode == "UIS.XUNIT.PPPCONST.23.FSGOV"	| seriescode == "UIS.XUNIT.GDPCAP.23.FSHH" | seriescode == "UIS.XUNIT.PPPCONST.23.FSHH" | seriescode == "UIS.XUNIT.GDPCAP.5T8.FSGOV" | seriescode == "UIS.XUNIT.PPPCONST.5T8.FSGOV" | seriescode == "UIS.XUNIT.GDPCAP.5T8.FSHH" | seriescode == "UIS.XUNIT.PPPCONST.5T8.FSHH"
	
	
* Keep per student and per capita spending measures
	
gen var = "terexp_per" if seriescode == "UIS.XGDP.56.FSGOV"
	// gov expenditure on tertiary education as % of GDP 
	
	replace var = "terexp_usd" if seriescode == "UIS.X.US.5T8.FSGOV"
	// gov expenditure on tertiary education in US$ (millions)	
	// Total general (local, regional and central) government expenditure on tertiary education (current, capital, and transfers) in millions US$ (nominal value). It includes expenditure funded by transfers from international sources to government. Total government expenditure for a given level of education (e.g. primary, secondary, or all levels combined) in national currency is converted to US$. Limitations: In some instances data on total government expenditure on education refers only to the Ministry of Education, excluding other ministries which may also spend a part of their budget on educational activities. For more information, consult the UNESCO Institute of Statistics website: http://www.uis.unesco.org/Education/
	
	replace var = "primexp_per" if seriescode == "UIS.XGDP.1.FSGOV"
	replace var = "primexp_usd" if seriescode == "UIS.X.US.1.FSGOV"
	
	replace var = "secondexp_per" if seriescode == "UIS.XGDP.23.FSGOV"
	replace var = "secondexp_usd" if seriescode == "UIS.X.US.2T3.FSGOV"
	
	replace var = "all_edexp_pergovexp" if seriescode=="SE.XPD.TOTL.GB.ZS"
	
	replace var = "gov_edexp_per" if seriescode=="SE.XPD.TOTL.GD.ZS"
	replace var = "gov_edexp_usd" if seriescode=="UIS.X.US.FSGOV"	
	
	replace var = "gov_perprim_gdppc" if seriescode=="UIS.XUNIT.GDPCAP.1.FSGOV"	
	// initial gov funding per primary student, as %age of GDP pc
	replace var = "gov_perprim_ppp" if seriescode=="UIS.XUNIT.PPPCONST.1.FSGOV"	
	// initial gov funding per primary student, constant PPP$
	// Total general (local, regional and central, current and capital) initial government funding of education per student, which includes transfers paid (such as scholarships to students), but excludes transfers received, in this case international transfers to government for education (when foreign donors provide education sector budget support or other support integrated in the government budget). Calculation Method: Total general (local, regional and central) government expenditure (current and capital) on a given level of education (primary, secondary, etc) minus international transfers to government for education, divided by the number of student enrolled at that level of education. This is then expressed at constant purchasing power parity (constant PPP$). Limitations: In some instances data on total government expenditure on education refers only to the Ministry of Education, excluding other ministries which may also spend a part of their budget on educational activities. There are also cases where it may not be possible to separate international transfers to government from general government expenditure on education, in which cases they have not been subtracted in the formula. For more information, consult the UNESCO Institute of Statistics website: http://www.uis.unesco.org/Education/
	
	replace var = "hh_perprim_gdppc" if seriescode=="UIS.XUNIT.GDPCAP.1.FSHH"
	// initial HH funding per primary student as a %age of GDP pc
	replace var = "hh_perprim_ppp" if seriescode=="UIS.XUNIT.PPPCONST.1.FSHH"
	// initial HH funding per primary student, constant PPP$
	
	replace var = "gov_persec_gdppc" if seriescode=="UIS.XUNIT.GDPCAP.23.FSGOV"	
	// initial gov funding per secondary student, as %age of GDP pc
	replace var = "gov_persec_ppp" if seriescode=="UIS.XUNIT.PPPCONST.23.FSGOV"	
	// initial gov funding per secondary student, constant PPP$
	
	replace var = "hh_persec_gdppc" if seriescode=="UIS.XUNIT.GDPCAP.23.FSHH"
	// initial HH funding per secondary student as a %age of GDP pc
	replace var = "hh_persec_ppp" if seriescode=="UIS.XUNIT.PPPCONST.23.FSHH"
	// initial HH funding per secondary student, constant PPP$
	
	replace var = "gov_perter_gdppc" if seriescode=="UIS.XUNIT.GDPCAP.5T8.FSGOV"	
	// initial gov funding per tertiary student, as %age of GDP pc
	replace var = "gov_perter_ppp" if seriescode=="UIS.XUNIT.PPPCONST.5T8.FSGOV"	
	// initial gov funding per tertiary student, constant PPP$
	// 	Total general (local, regional and central, current and capital) initial government funding of education per student, which includes transfers paid (such as scholarships to students), but excludes transfers received, in this case international transfers to government for education (when foreign donors provide education sector budget support or other support integrated in the government budget). Calculation Method: Total general (local, regional and central) government expenditure (current and capital) on a given level of education (primary, secondary, etc) minus international transfers to government for education, divided by the number of student enrolled at that level of education. This is then expressed at constant purchasing power parity (constant PPP$). Limitations: In some instances data on total government expenditure on education refers only to the Ministry of Education, excluding other ministries which may also spend a part of their budget on educational activities. There are also cases where it may not be possible to separate international transfers to government from general government expenditure on education, in which cases they have not been subtracted in the formula. For more information, consult the UNESCO Institute of Statistics website: http://www.uis.unesco.org/Education/
	
	replace var = "hh_perter_gdppc" if seriescode=="UIS.XUNIT.GDPCAP.5T8.FSHH"
	// initial HH funding per tertiary student as a %age of GDP pc
	replace var = "hh_perter_ppp" if seriescode=="UIS.XUNIT.PPPCONST.5T8.FSHH"
	// initial HH funding per tertiary student, constant PPP$
	// Total payments of households (pupils, students and their families) for educational institutions (such as for tuition fees, exam and registration fees, contribution to Parent-Teacher associations or other school funds, and fees for canteen, boarding and transport) and purchases outside of educational institutions (such as for uniforms, textbooks, teaching materials, or private classes). 'Initial funding' means that government transfers to households, such as scholarships and other financial aid for education, are subtracted from what is spent by households. Note that in some countries for some education levels, the value of this indicator may be 0, since on average households may be receiving as much, or more, in financial aid from the government than what they are spending on education. Calculation: Total payments of households (pupils, students and their families) for educational institutions (such as for tuition fees, exam and registration fees, contribution to Parent-Teacher associations or other school funds, and fees for canteen, boarding and transport), plus purchases outside of educational institutions (such as for uniforms, textbooks, teaching materials, or private classes), minus government education transfers to households (such as scholarships or other education-specific financial aid). Limitations: Indicators for household expenditure on education should be interpreted with caution since data comes from household surveys which may not all follow the same definitions and concepts. These types of surveys are also not carried out in all countries with regularity, and for some categories (such as pupils in pre-primary education), the sample sizes may be low. In some cases where data on government transfers to households (scholarships and other financial aid) was not available, they could not be subtracted from amounts paid by households. For more information, consult the UNESCO Institute of Statistics website: http://www.uis.unesco.org/Education/
	
	
* Drop years with all missing observations
drop yr2022 yr2021 yr2020

* Temporarily drop seriescode and seriesname
drop seriescode seriesname

drop countrycode 

sort countryid countryname var

* Bring key variables to front of dataset
order countryid countryname var

* Reshape long to wide for variables
reshape wide yr*, i(countryid) j(var) string

foreach year of numlist 1995(1)2019 {
	
	rename yr`year'*    *yr`year'
}

foreach year of numlist 1995(1)2019 {
	
	rename    *yr`year'  *`year'
}


// reshape long terexp_per, i(countryid) j(year) 

reshape long terexp_per terexp_usd primexp_per  primexp_usd secondexp_per secondexp_usd all_edexp_pergovexp gov_edexp_per  gov_edexp_usd gov_perprim_gdppc gov_perprim_ppp hh_perprim_gdppc hh_perprim_ppp gov_persec_gdppc gov_persec_ppp hh_persec_gdppc hh_persec_ppp gov_perter_gdppc gov_perter_ppp hh_perter_gdppc hh_perter_ppp, i(countryid) j(year)



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


		//  12 American Samoa
		//  32 Brunei Darussalam


		//  50 Caribbean small states
		//  57 Dijibouti 
		//  58 Dominica

		//  79 Faroe Islands
		//  80 Micronesia, Fed Sts.
		// 097 High income
		// 100 Heavily indebted poor countries
		// 104 IBRD only

		// 109 Isle of Man

		// 124 Kyrgyz Republic
		// 131 Lao PDR
		// 137 Least Developed Countries
		// 138 Low Income
		// 141 Lower middle income
		// 144 Late-demographic dividend
		// 158 Middle Income
		// 193 Pre-demographic dividend
		// 194 Puerto Rico
		// 211 Solomon Islands
		// 217 SSA Excluding High Income
		// 219 SSA
		// 255 St. Vincent & the Grenadines
		// 257 British Virgin Islands 
		// 258 US Virgin Islands
		// 261 World


********************************************************************************

***** Calculate spending ratios *****

*** Aggregate Spending Ratios, USD ***
gen ter_prim = terexp_usd/primexp_usd
	la var ter_prim "Tertiary-Primary Aggregate Spending Ratio"
gen ter_sec = terexp_usd/secondexp_usd
	la var ter_sec "Tertiary-Secondary Aggregate Spending Ratio"	
gen ter_govtotaled = terexp_usd/gov_edexp_usd
	la var ter_govtotaled "Share of Government Expenditure on Tertiary Education"

*** Per Student Spending Ratios, PPP ***
gen ter_prim_perstudent = gov_perter_ppp/gov_perprim_ppp
	la var ter_prim_perstudent "Tertiary-Primary Per Student Gov. Spending Ratio"
gen ter_sec_perstudent = gov_perter_ppp/gov_persec_ppp
	la var ter_sec_perstudent "Tertiary-Secondary Per Student Gov. Spending Ratio"
gen ter_sec_prim_perstudent = gov_perter_ppp/gov_persec_ppp/gov_perprim_ppp
	la var ter_sec_prim_perstudent "Tertiary-Secondary-Primary Per Student Gov. Spending Ratio"
gen sec_prim_perstudent = gov_persec_ppp/gov_perprim_ppp
	la var ter_sec_perstudent "Secondary-Primary Per Student Gov. Spending Ratio"


	// These are my variables of interest that I want to plot against GDP/income level, development level, etc. to get my figures of interest to establish my fact that is related to Nancy Birdsall's (1996) work
gen ter_prim_hh = hh_perter_ppp/hh_perprim_ppp
	la var ter_prim_hh "Tertiary-Primary Per Student HH Spending Ratio"
gen ter_sec_hh = hh_perter_ppp/hh_persec_ppp
	la var ter_sec_hh "Tertiary-Secondary Per Student HH Spending Ratio"
* Reorganize dataset
order countryid countryname year country_yr_id  ter_prim_perstudent ter_sec_perstudent

* Save dataset with education level spending ratios
preserve

	keep countryid countryname year country_yr_id ter_prim_perstudent ter_sec_perstudent ter_prim ter_sec ter_govtotaled ter_prim_hh ter_sec_hh

	save "ed_expend_ratios_clean.dta", replace
	
restore


********************************************************************************
********************************************************************************

***** GDP and Background Dataset *****

********************************************************************************

import delimited "gdp_background_data_11.27.23.csv", varnames(1) clear


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
	
* Keep simplest variables

keep if seriescode == "NY.GDP.PCAP.KD" | seriescode == "NY.GDP.PCAP.CD" | seriescode == "NY.GDP.PCAP.PP.KD" | seriescode == "NY.GDP.PCAP.PP.CD" |  seriescode == "NY.GNP.MKTP.CD" | seriescode == "NY.GNP.PCAP.PP.CD" | seriescode == "NY.GNP.MKTP.PP.CD" 
	
gen var = "gdppc_cons" if seriescode == "NY.GDP.PCAP.KD"
	// GDP pc, constant 2005 USD
	replace var = "gdppc_curr" if seriescode == "NY.GDP.PCAP.CD"
	// GDP pc, current USD
	
	replace var = "gdppc_ppp_cons" if seriescode == "NY.GDP.PCAP.PP.KD"
	// GDP pc, PPP, constant 2011 international $
	
	replace var = "gdppc_ppp_curr" if seriescode == "NY.GDP.PCAP.PP.CD"
	// GDP pc, PPP, current international $
	
	replace var = "gni_curr" if seriescode == "NY.GNP.MKTP.CD"
	// GNI, current USD
	
	replace var = "gni_pc_ppp" if seriescode == "NY.GNP.PCAP.PP.CD"
	// GNI pc, PPP, current international $
	replace var = "gni_ppp" if seriescode == "NY.GNP.MKTP.PP.CD"
	// GNI, PPP, current international $
	
	
* Drop years with all missing observations
drop yr2022 yr2021 yr2020 yr2019

* Temporarily drop seriescode and seriesname
drop seriescode seriesname

drop countrycode 

sort countryid countryname var

* Bring key variables to front of dataset
order countryid countryname var

* Reshape long to wide for variables
reshape wide yr*, i(countryid) j(var) string

foreach year of numlist 1995(1)2018 {
	
	rename yr`year'*    *yr`year'
}

foreach year of numlist 1995(1)2018 {
	
	rename    *yr`year'  *`year'
}

* Reshape long so that year becomes a variable and we end up with country-year pairs for each observation 
reshape long gdppc_cons gdppc_curr gdppc_ppp_cons gdppc_ppp_curr gni_curr gni_pc_ppp gni_ppp, i(countryid) j(year)


* Label variables
la var gdppc_cons "GDP per capita, constant 2005 USD"
la var gdppc_curr "GDP pc, current USD"
la var gdppc_ppp_cons "GDP pc, PPP, constant 2011 international $"
la var gdppc_ppp_curr "GDP pc, PPP, current international $"
la var gni_curr "GNI, current USD"
la var gni_pc_ppp "GNI pc, PPP, current international $"
la var gni_ppp "GNI, PPP, current international $"

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


* Save dataset with education level spending ratios
save "gdp_clean.dta", replace
	

********************************************************************************

			***** MERGE *****

********************************************************************************

use "ed_expend_ratios_clean.dta", clear

* Merge clean education expenditure ratios data and clean gdp data
merge 1:1 countryname year using "gdp_clean.dta"

* Save merged data 
save "ed_expend_gdp_merged.dta", replace

********************************************************************************

			***** Create Figures *****

********************************************************************************

tab year if ter_prim_perstudent !=.
	// No obs. in 1996, very few in 2019, we have 65+ obs. for 2009-2015 
	
tab year if ter_sec_perstudent !=.
	// No obs. in 1996, very few in 2019, we have 60+ obs. for 2009-2015

* Drop outliers for now
drop if ter_prim_perstudent>100	
	// Outliers with tertiary-primary per student spending ratio > 100 are Malawi (1999-2001, 2010-2011) and Rwanda (2000)

	
*** Focus on one year for now: 2010 ***	

	
* Calculate descriptive statistics
sum ter_prim_perstudent if year==2010 & ter_prim_perstudent != ., d
	// 10th %ile: 0.8, 25th %ile: 1.1, median:  1.7, 75th %ile: 3.7, 90th %ile: 19.5
	
sum ter_sec_perstudent if year==2010 & ter_prim_perstudent != ., d
	// 10th %ile: 0.8, 25th %ile: 1.0, median:  1.3, 75th %ile: 2.6, 90th %ile: 6.3

	
* Graphs with GDP PC, current USD
graph twoway scatter ter_prim_perstudent gdppc_curr if year==2010 & ter_prim_perstudent != .
	// L-shape with most observations clustered around 1-3.7	

graph twoway scatter ter_sec_perstudent gdppc_curr if year==2010 & ter_prim_perstudent != .
	// L-shape with most observations clustered around 1-2.6
	
* Create log income variables
gen log_gni = log(gni_curr)
	la var log_gni "Log GNI"
gen log_gdp_pc = log(gdppc_curr)
	la var log_gdp_pc "Log GDP per capita"
	
* Graphs with log GNI
graph twoway scatter ter_prim_perstudent log_gni if year==2010 & ter_prim_perstudent != .
	// Still an L-shape, but the countries that have a ratio of tertiary-primary per student government sepnding ratio >= 4, are in the lower half of log GNI	

graph twoway scatter ter_sec_perstudent log_gni if year==2010 & ter_prim_perstudent != .
	// L-shape with most observations clustered <= 4, the countries with ratios >= 4 tend to be in the lower half of log GNI, but there are not too many here

	
	
// Preferred Graphs?

kdensity log_gdp_pc

/* Yearly scatterplots of tertiary-primary expenditure ratio
foreach year of numlist 1998(1)2017 {

	* Graphs with log GDP PC
	graph twoway scatter ter_prim_perstudent log_gdp_pc if year==`year' & ter_prim_perstudent != ., ///
		title("Tertiary-Primary Education Spending Ratios by Income, `year'") ///
		graphregion(color(white))
	graph export "$figures/Yearly/ter-prim_ps_spendingratios_bylogGDPpc_`year'.pdf", replace
		// Notes on 2010: L-shape with most observations clustered around 1-3.7, all tertiary-primary spending ratios above this are from countries in the lowest 1/3 of log GDP pc, and most countries in the lowest 1/3 of log GDP pc have higher spending ratios	
		
		// Notes on 2010:  It appears that countries converge to a lower ratio as log GDP pc rises

	graph twoway scatter ter_sec_perstudent log_gdp_pc if year==`year' & ter_sec_perstudent != ., ///
		title("Tertiary-Secondary Education Spending Ratios by Income, `year'") ///
		graphregion(color(white))
	graph export "$figures/Yearly/ter-sec_ps_spendingratios_bylogGDPpc_`year'.pdf", replace
		// Notes on 2010:  L-shape with most observations clustered around 1-2.6, all tertiary-primary spending ratios above this are from countries in the lowest 1/2 of log GDP pc, and most countries in the lowest 1/3 of log GDP pc have higher spending ratios	
		
		// Notes on 2010:  It appears that countries converge to a lower ratio as log GDP pc rises
}	

////// FINISH 	

* Time Lapse Scatterplot

forvalues t = 1998/2017 {
	
}	
*/
	
/////////

	unique countryid if ter_prim_perstudent != . & year == 2017	

	unique countryid if ter_prim_perstudent != . & year == 2018	
	
	sort year
	
	// distinct or isid are alternative similar commands

	
* Calculate average expenditure ratio over 5 years to increase sample size since many countries do not have observations in every year

gen yrgrp = 0 if year<2000
	replace yrgrp = 1 if year>=2000 & year<2005 
	replace yrgrp = 2 if year>=2005 & year<2010
	replace yrgrp = 3 if year>=2010 & year<2015
	replace yrgrp = 4 if year>=2015
label define YRGRP 0 "1995-1999" 1 "2000-2004" 2 "2005-2009" 3 "2010-2014" 4 "2015-2018"
label values yrgrp  YRGRP

unique countryid yrgrp if yrgrp==0
unique countryid yrgrp if yrgrp==1
unique countryid yrgrp if yrgrp==2
unique countryid yrgrp if yrgrp==3
unique countryid yrgrp if yrgrp==4
	
egen ter_prim_yrgrp = mean(ter_prim_perstudent), by(countryid yrgrp)
egen log_gdp_pc_yrgrp = mean(gdppc_curr), by(countryid yrgrp)


	
* Store yrgrp values in local to be used in figure-making loop
/*
levelsof yrgrp, local(levels)
foreach i of local levels {
	local label : label (yrgrp) `i'
	display "`label'"
}	
*/

/* Store yrgrp values in local to be used in figure-making loop
levelsof yrgrp, local(levels)

* Grouped Years scatterplots of tertiary-primary expenditure ratio
foreach i of local levels {

	local label : label (yrgrp) `i'

	* Graphs with log GDP PC
	quietly graph twoway scatter ter_prim_perstudent log_gdp_pc if yrgrp==`i' & ter_prim_perstudent != ., ///
		title("Tertiary-Primary Education Expenditure Ratios" "by Income, `label'") ///
		name(scatter_terprimgrp_`i', replace) ///
		graphregion(color(white))
	graph export "$figures/Year Groups/ter-prim_ps_spendingratios_bylogGDPpc_`label'.pdf", replace
		//

	quietly graph twoway scatter ter_sec_perstudent log_gdp_pc if yrgrp==`i' & ter_sec_perstudent != ., ///
		title("Tertiary-Secondary Education Expenditure Ratios" "by Income, `label'") ///
		name(scatter_tersecgrp_`i', replace) ///
		graphregion(color(white))
	graph export "$figures/Year Groups/ter-sec_ps_spendingratios_bylogGDPpc_`label'.pdf", replace
		// 
}

*/


order countryid countryname year ter_prim_perstudent ter_sec_perstudent gdppc_curr log_gdp_pc gni_curr ter_prim ter_sec


* Save combined data 
save "ed_expend_gdp_clean.dta", replace


	
	
	
	
	