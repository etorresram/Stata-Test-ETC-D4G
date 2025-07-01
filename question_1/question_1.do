* -------------------------------------------------------
* Subject: Online STATA Test, ETC (QUESTION 1)
* Author: Eric Torres
* System: macOS Sequoia 15.5
* STATA version: 14.0
* File: question_1.do
* Date: [Jun 30th 8:00am EST - Jul 1st 8:00am EST]
* -------------------------------------------------------

clear all  
set more off  
version 14.0
capture log close 

global root "/Users/etorresram/Documents"
global input "${root}/STATA_test/raw"
global output "${root}/STATA_test/output"
log using "${root}/STATA_test/question_1/question_1.log", replace text


///////////////////////////////////////////////////////////////////
///   QUESTION 1. Use of Brazil_2022.dta for poverty analysis.  ///
///////////////////////////////////////////////////////////////////

use "${input}/Brazil_2022.dta", clear


************************************************************************************************
// A. Explain how the $3.00/day international poverty line is derived in at most one paragraph.
************************************************************************************************

/* The $3.00/day international poverty line is derived from the update of the previous line of $2.15/day 
   incorporating the revised purchasing power parities (PPPs) from the International Comparison Program (ICP), 
   which moved from 2017 to 2021. This was done so that the new poverty estimates reflect the revisions 
   in national poverty lines due to better data, not just changes in prices. This new value is obtained computing 
   the median of national poverty lines in 23 low-income countries (selecting one per country, the one closest 
   to 2021), which, after being harmonized, were adjusted by PPP to ensure comparability across countries. */

   
************************************************************************************************
// B. Calculate the international poverty rate on the data you have been provided.
************************************************************************************************

*  Poverty lines
   scalar poverty_line1 = 3
   scalar poverty_line2 = 4.2
   scalar poverty_line3 = 8.3

*  Per capita daily welfare in 2021 PPP dollars
   gen welfare_pc_day_ppp = (welfare_hh / hsize / 365) / (cpi * ppp)
   label variable welfare_pc_day_ppp "Per capita daily welfare in 2021 PPP dollars"

*  Poverty variables

   gen poor1 = welfare_pc_day_ppp < poverty_line1
   label variable poor1 "Poverty rate $3.00/day (2021 PPP)"

   gen poor2 = welfare_pc_day_ppp < poverty_line2
   label variable poor2 "Poverty rate $4.20/day (2021 PPP)"
  
   gen poor3 = welfare_pc_day_ppp < poverty_line3
   label variable poor3 "Poverty rate $8.30/day (2021 PPP)"
   
   

*  Estimate poverty rate 
   mean poor1 [aw=weight]
   

   
************************************************************************************************
// C. Calculate the international poverty rate by gender and education level, illustrate the 
//    results in a graph, and comment on the results in at most one paragraph.
************************************************************************************************

   mean poor1 [aw=weight], over(male)
   mean poor1 [aw=weight], over(educat7)
   
   gen poor1_pct = poor1 * 100


* By Gender
    graph bar (mean) poor1_pct [aw=weight], over(male) ///
    ytitle("Poverty Rate (%)") title("Gender") ///
    blabel(bar, format(%4.1f) position(outside)) ///
    ylabel(0(2)10, format(%4.0f) angle(0)) /// 
    legend(off) name(g_gender, replace)

*  By educación
   gen tempvar1 = educat7
   graph bar (mean) poor1_pct [aw=weight], over(tempvar1, label(angle(0))) ytitle("") ///
   title("Level of education") blabel(bar, format(%4.1f) position(outside)) ///
    ylabel(0(2)10, format(%4.0f) angle(0)) ///
    note("1. No education" /// 
		"2. Primary incomplete" ///
		"3. Primary complete" ///
        "4. Secondary incomplete" ///
		"5. Secondary complete" ///
		"6. Higher (not university)" ///
        "7. University (complete or incomplete)", ///
        size(small) span pos(2) ring(0) width(60)) ///
    legend(off) ///
    name(g_edu, replace)
	drop tempvar1

*  Combining both
    graph combine g_gender g_edu, ///
    title("International poverty rate by groups") ///
    col(2)
	
	
/*  The poverty rate in Brazil reached 4.47% in 2022. Although this overall poverty figure is important, 
it is even more relevant to understand how it is distributed among different socioeconomic groups, 
such as gender and education level. Regarding the first, no gap is identified that significantly favors 
both men or women; certainly, this gap could change if we analyze both groups in different contexts, 
whether geographically or socioculturally. Furthermore, the differences in poverty rates by educational 
level are at first glance noticeable, showing an inverse relationship between educational level and poverty rates. 
The gap of 1.8 percentage points between the group with completed primary education and those with incomplete 
secondary education stands out. Although this is certainly possible, it could also be related to the fact that 
this database is a sample of the real database, given that the number of observations in the group with completed 
primary education is the lowest of all categories and could be underrepresented. */	



************************************************************************************************
// D. Write code that produces a table for excel showing poverty rates by gender and education 
//    level at varying poverty lines.
************************************************************************************************

// Excel sheet for poverty rates by gender

putexcel set "${output}/poverty_by_group.xlsx", sheet("Gender") replace

* Header
putexcel A1=("Gender") B1=("Poverty Rate ($3/day)") C1=("Poverty Rate ($4.2/day)") D1=("Poverty Rate ($8.3/day)")


// Excel table for poverty rates by gender
forvalues i = 0/1 {
    local label : label (male) `i'
    local row = `i' + 2

    tabstat poor1 if male == `i' [aw=weight], save
    putexcel A`row'=("`label'") B`row'=matrix(r(StatTotal))

    tabstat poor2 if male == `i' [aw=weight], save
    putexcel C`row'=matrix(r(StatTotal))

    tabstat poor3 if male == `i' [aw=weight], save
    putexcel D`row'=matrix(r(StatTotal))

}



// Excel table for poverty rates by level of education

putexcel set "${output}/poverty_by_group.xlsx", sheet("Level of education") modify

* Header
putexcel A1=("Education Level") B1=("Poverty Rate ($3/day)") C1=("Poverty Rate ($4.2/day)") D1=("Poverty Rate ($8.3/day)") 

* Values
forvalues i = 1/7 {
    local label : label (educat7) `i'
	local row = `i' + 1
	
    tabstat poor1 if educat7 == `i' [aw=weight], save
    putexcel A`row'=("`label'") B`row'=matrix(r(StatTotal))
	
	tabstat poor2 if educat7 == `i' [aw=weight], save
    putexcel C`row'=matrix(r(StatTotal))

    tabstat poor3 if educat7 == `i' [aw=weight], save
    putexcel D`row'=matrix(r(StatTotal))
}



***************************************************************************************************
// E. Calculate the prosperity gap on the data and comment on the results in at most one paragraph.
***************************************************************************************************

scalar prosperity_line = 25

* Gap for those below the threshold
gen prosperity_gap = prosperity_line - welfare_pc_day_ppp if welfare_pc_day_ppp < prosperity_line
replace prosperity_gap = 0 if missing(prosperity_gap)

* Now as percentage of the threshold
gen prosperity_gap_pct = 100 * prosperity_gap / prosperity_line if prosperity_gap > 0
replace prosperity_gap_pct = 0 if missing(prosperity_gap_pct)

* average prosperity gap (in dollars and as a %)
mean prosperity_gap [aw=weight] if prosperity_gap > 0
mean prosperity_gap_pct [aw=weight] if prosperity_gap_pct > 0


/* According to the results obtained from this sample, on average, Brazilians living below the prosperity 
   threshold have a daily deficit of $13.25 (PPP 2021), which is equivalent to 53% of the prosperity threshold. 
   In other words, they only reach 47% of the income level required to live prosperously. */	





log close










