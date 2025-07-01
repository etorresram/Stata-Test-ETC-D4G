* -------------------------------------------------------
* Subject: Online STATA Test, ETC (QUESTION 2)
* Author: Eric Torres
* System: macOS Sequoia 15.5
* STATA version: 14.0
* File: question_2.do
* Date: [Jun 30th 8:00am EST - Jul 1st 8:00am EST]
* -------------------------------------------------------

clear all  
set more off  
version 14.0
capture log close 

global root "/Users/etorresram/Documents"
global input "${root}/STATA_test/raw"
global output "${root}/STATA_test/output"
log using "${root}/STATA_test/question_2/question_2.log", replace text



///////////////////////////////////////////////////////////////////
///     QUESTION 2. Efficient coding with Sim_sample.zip.       ///
///////////////////////////////////////////////////////////////////


******************************************************************************************************
// A. Efficiently compute a set of poverty rates and the Gini coefficient at two levels (national and 
//    states) for all simulated samples.
******************************************************************************************************

timer clear 1
timer on 1

cd "${root}/STATA_test"
cap program drop new_poverty
cap program drop new_gini


forvalues i = 1/1000 {
    
    quietly use "${input}/temp3/sim_sample`i'.dta", clear
	
  // Poverty rate program: new_poverty.ado
  
  *  new_poverty: income(varname) 
  *               weight(varname) 
  *			      line(put the number here) if not stated default=3 
  *			      state(varname) 
  *			      rural(varname)
  
     new_poverty, income (welfppp) weight(wgt) line(3.0)
	 new_poverty, income (welfppp) weight(wgt) line(3.0) state(state)
  
  
  // Gini coefficient program: new_gini.ado 
  
  *  new_gini:    income(varname) 
  *               weight(varname) 
  *               state(varname) 
  *               rural(varname)
  
     new_gini, income (welfppp) weight(wgt)
	 new_gini, income (welfppp) weight(wgt) state(state)
}

timer off 1
timer list

log close



























