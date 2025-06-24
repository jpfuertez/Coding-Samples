cd "/Users/j.p./Downloads/URL Files/data"
clear all

/*******************************************************************************
********************************************************************************

Author:				J.P. Fuertez

Date:				February 26, 2024
Last Revised:		

Datasets used:		-edex_gdp_labor_tertiary_pop_data_merged.dta

*******************************************************************************/
use "edex_gdp_labor_tertiary_pop_data_merged.dta"

* Figure for Government Spending on tertiaty education and tertiary enrollment 
graph twoway scatter ter_govtotaled TE_both if TE_both <= 10000000, ///
			title("Government Education Expenditure on Teriary Education vs. Tertiary Enrollment", size(medium)) ///
			graphregion(color(white)) msymbol(circle_hollow) ///
			ytitle("Share of Government Expenditure on Tertiary Education") ///
			xtitle("Total Tertiary Enrollment for Both Genders ", size(medium)) ytitle(,size(small))

			*Potential skew since countries with large enrollment have larger populations

*Variable for ratio of tertiary enrollment and tertiary populations !!!!BETTER GRAPH!!!!
g tertenrollperpop = TE_both/sptert_both

la var tertenrollperpop "Ratio of tertiary enrollment and tertiary age population"

graph twoway scatter ter_govtotaled tertenrollperpop || lfit ter_govtotaled tertenrollperpop, ///
			title("Government Education Expenditure on Tertiary Education" "and Ratio of Tertiary Enrollment", size(medium)) ///
			graphregion(color(white)) msymbol(circle_hollow) ///
			ytitle("Share of Government Expenditure on Tertiary Education") ///
			xtitle("Tertiary Enrollment for Both Genders over Tertiary School Age Population", size(medium)) ytitle(,size(small))
			
			
g tertenrollperpop = TE_both/sptert_both
			
**** interesting vars: ter_prim_perstudent –> tertiary-primary per student gov. spending ratio, ter_sec_perstudent –> secondary-primary per student gov. spending ratio, ter_prim –> tertiary-primary agg spending ratio, ter_sec –> tertiary-secondary agg spending ratio, ter_govtotaled –> share of gov't exp[enditure on tertiary education, LF_advanced_ed –> % labor force, advanced ed (also gender diffs are potentially interesting), unemployment, youth_neet –> youth not in ed or employed, AR_TE_both –> tertiary attendence ratio, both, ER_TE_both –> tertiary enrollment ratio, both, tertenrollperpop –> tertiary enrollment to pop ratio *******

*graph twoway scatter tertenrollperpop ter_govtotaled if countryid == 30 || lfit tertenrollperpop ter_govtotaled, legend(off) mlabel(countryname) msymbol(circle_hollow) title("Government Education Expenditure on Tertiary Education" "and Ratio of Tertiary Enrollment for Brazil", size(medium)) graphregion(color(white))  ytitle("Tertiary Enrollment per School Age Population", size(small)) xtitle("Share of Gov't Expenditure on Tertiary Education", size(medium))

graph twoway scatter tertenrollperpop ter_govtotaled if countryid == 30, legend(off) mlabel(countryname) msymbol(circle_hollow) title("Government Education Expenditure on Tertiary Education" "and Ratio of Tertiary Enrollment for Brazil", size(medium)) graphregion(color(white))  ytitle("Tertiary Enrollment per School Age Population", size(small)) xtitle("Share of Gov't Expenditure on Tertiary Education", size(medium)) || lfit tertenrollperpop ter_govtotaled



graph twoway scatter ter_govtotaled TE_both if TE_both <= 10000000, ///
			title("Government Education Expenditure on Teriary Education vs. Tertiary Enrollment", size(medium)) ///
			graphregion(color(white)) msymbol(circle_hollow) ///
			ytitle("Share of Government Expenditure on Tertiary Education") ///
			xtitle("Total Tertiary Enrollment for Both Genders ", size(medium)) ytitle(,size(small))
			
			
			
sum ter_prim_perstudent ter_sec_perstudent ter_prim ter_sec ter_govtotaled ter_prim_hh ter_sec_hh

sum gdppc_cons gdppc_curr gdppc_ppp_cons gdppc_ppp_curr gni_curr gni_pc_ppp gni_ppp log_gni log_gdp_pc LF_intermediate_ed LF_intermediate_ed_f LF_intermediate_ed_m LF_total

sum LF_advanced_ed LF_advanced_ed_f LF_advanced_ed_m LF_basic_ed LF_basic_ed_f LF_basic_ed_m LF_f LF_intermediate_ed LF_intermediate_ed_f LF_intermediate_ed_m LF_total

sum unemployment unemployment_f unemployment_m youth_neet youth_neet_f youth_neet_m

sum AE_TE AG_IT_both AG_STEM_both AG_bizlawadmn_both AG_not_STEM_both AR_TE_both ER_TE_both

sum cmplsryage_both cmplsryage_f cmplsryage_m popfemale popmale population_growth primaryage_both secondaryage_both secondaryage_f secondaryage_m spprimary_both spprimary_f spprimary_m spsecond_both spsecond_f spsecond_m sptert_both sptert_f sptert_m totalpop
