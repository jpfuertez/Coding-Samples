* load data to see which type of merge
use opioids_2016.dta, clear

use urate_2016.dta, clear

* merge  m:1 data on county
merge 1:1 fips_county using urate_2016.dta, keep(3) nogen

*Histogram of urate_2016
hist urate, frac ///
	title("Histogram of Unemployment Rate") ///
	xtitle("Unemployment Rates") ///
	ytitle("Fraction of Observations")
   
gr export histogram_urate.png, replace

*Histogram of prescrip_rate
hist prescrip_rate, frac ///
	title("Histogram of Prescription Rates") ///
	xtitle("Prescription Rates") ///
	ytitle("Fraction of Observations")
	
gr export histogram_prescription.png, replace

*Scatter plot
twoway scatter prescrip_rate urate, msymbol(circle_hollow) ///
	title("Scatter Plot of Prescription and Unemployment Rates") ///
	xtitle("Unemployment Rate") ///
	ytitle("Prescription Rate")

gr export scatter_prescripurate.png, replace

*at least one opioid prescription
 count if prescrip_rate>=100 & prescrip_rate<=470.3
*divide by 100 to get individual since it is per 100
 
*average size of labor force
destring labor_force, replace ignore("chars" [, aschars])

sum labor_force

*Estimating linear regression
reg prescrip_rate urate

*creating binary variables per region
gen west = 1 if state==("CA")|state==("OR")|state==("WA")| ///
	state==("ID")|state== ("NV")|state==("UT")| ///
	state==("AZ")|state==("MT")|state==("WY")| ///
	state==("CO")|state==("NM")
	
gen mid_west = 1 if state==("ND")|state==("SD")|state==("NE")| ///
	state==("KS")|state== ("MN")|state==("IA")| ///
	state==("MO")|state==("WI")|state==("IL")| ///
	state==("MI")|state==("IN")|state==("OH")

gen north_east = 1 if state==("NY")|state==("PA")|state==("NJ")| ///
	state==("CT")|state== ("RI")|state==("MA")| ///
	state==("NH")|state==("VT")|state==("ME")
	
gen south = 1 if state==("TX")|state==("OK")|state==("AR")| ///
	state==("LA")|state== ("MS")|state==("AL")| ///
	state==("KY")|state==("TN")|state==("DE")| ///
	state==("MD")|state==("WV")|state==("VA")| ///
	state==("NC")|state==("SC")|state==("GA")| state==("FL")

*regression per region 
reg prescrip_rate urate if west==1
est store reg_west

reg prescrip_rate urate if south==1
est store reg_south

reg prescrip_rate urate if mid_west==1
est store reg_mid_west

reg prescrip_rate urate if north_east==1
est store reg_north_east

*outreg2 command
ssc install outreg2

outreg2 [reg_west reg_south reg_mid_west reg_north_east] ///
	using reg_table.doc, word replace ///
	title("Regression Table by Region")




