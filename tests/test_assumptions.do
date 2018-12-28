cd ..

/*
This file tests the effects of changing the assumptions.
It begins with a base case and tests the results when 
each assumption value deviates from the base case. 
*/
quietly{
/* Define parameters for base case */
use parameters, clear
replace maxduration_days = 40
replace replacementrate = 0.7
replace maxbenefit = 600
replace minbenefit = 0
replace benefit_phaseout_thd = 9e99
replace benefit_phaseout_rt = 0
replace waiting_period = 0
replace work_requirement = 0
replace include_ownhealth = 1
replace include_childhealth = 1
replace include_spousehealth = 1
replace include_parenthealth = 1
replace include_otherrelhealth = 1
replace include_military = 1
replace include_otherreason = 1
replace include_newchild = 1
save parameters, replace


/* Determine assumptions for all tests */
use assumptions, clear
replace overall_takeup = 0.159
replace reduce_ownhealth = 1.0
replace reduce_childhealth = 1.0
replace reduce_spousehealth = 1.0
replace reduce_parenthealth = 1.0
replace reduce_otherrelhealth = 1.0
replace reduce_military = 1.0
replace reduce_otherreason = 1.0
replace reduce_newchild = 1.0
replace frac_fullpush = 1.0
replace frac_partialpush = 0.0
replace delay_partialpush = 20
save assumptions, replace
}

/* Test base case*/
quietly {
do "run_anyassumptions.do"
gen testid = "base_case"
save "tests/test_output/test_assum_output.dta", replace
}

/* Test overall_takeup */
quietly {
use assumptions, clear
replace overall_takeup = 0.2
save assumptions, replace
do "run_anyassumptions.do"
gen testid = "overall_takeup"
merge 1:1 testid using "tests/test_output/test_assum_output.dta", nogen
save "tests/test_output/test_assum_output.dta", replace
}

/* Test reduce_ownhealth */
quietly {
use assumptions, clear
replace overall_takeup = 0.159
replace reduce_ownhealth = 0.5
save assumptions, replace
do "run_anyassumptions.do"
gen testid = "reduce_ownhealth"
merge 1:1 testid using "tests/test_output/test_assum_output.dta", nogen
save "tests/test_output/test_assum_output.dta", replace
}

/* Test reduce_childhealth */
quietly {
use assumptions, clear
replace reduce_ownhealth = 1.0
replace reduce_childhealth = 0.2
save assumptions, replace
do "run_anyassumptions.do"
gen testid = "reduce_childhealth"
merge 1:1 testid using "tests/test_output/test_assum_output.dta", nogen
save "tests/test_output/test_assum_output.dta", replace
}

/* Test reduce_spousehealth */
quietly {
use assumptions, clear
replace reduce_childhealth = 1.0
replace reduce_spousehealth = 0.2
save assumptions, replace
do "run_anyassumptions.do"
gen testid = "reduce_spousehealth"
merge 1:1 testid using "tests/test_output/test_assum_output.dta", nogen
save "tests/test_output/test_assum_output.dta", replace
}

/* Test reduce_parenthealth */
quietly {
use assumptions, clear
replace reduce_spousehealth = 1.0
replace reduce_parenthealth = 0.1
save assumptions, replace
do "run_anyassumptions.do"
gen testid = "reduce_parenthealth"
merge 1:1 testid using "tests/test_output/test_assum_output.dta", nogen
save "tests/test_output/test_assum_output.dta", replace
}

/* Test reduce_otherrelhealth */
quietly {
use assumptions, clear
replace reduce_parenthealth = 1.0
replace reduce_otherrelhealth = 0.1
save assumptions, replace
do "run_anyassumptions.do"
gen testid = "reduce_otherrelhealth"
merge 1:1 testid using "tests/test_output/test_assum_output.dta", nogen
save "tests/test_output/test_assum_output.dta", replace
}

/* Test reduce_military */
quietly {
use assumptions, clear
replace reduce_otherrelhealth = 1.0
replace reduce_military = 0.9
save assumptions, replace
do "run_anyassumptions.do"
gen testid = "reduce_military"
merge 1:1 testid using "tests/test_output/test_assum_output.dta", nogen
save "tests/test_output/test_assum_output.dta", replace
}

/* Test reduce_otherreason */
quietly {
use assumptions, clear
replace reduce_military = 1.0
replace reduce_otherreason = 0.0
save assumptions, replace
do "run_anyassumptions.do"
gen testid = "reduce_otherreason"
merge 1:1 testid using "tests/test_output/test_assum_output.dta", nogen
save "tests/test_output/test_assum_output.dta", replace
}

/* Test reduce_newchild */
quietly {
use assumptions, clear
replace reduce_otherreason = 1.0
replace reduce_newchild = 0.9
save assumptions, replace
do "run_anyassumptions.do"
gen testid = "reduce_newchild"
merge 1:1 testid using "tests/test_output/test_assum_output.dta", nogen
save "tests/test_output/test_assum_output.dta", replace
}

/* Test frac_fullpush and frac_partialpush */
quietly {
use assumptions, clear
replace reduce_newchild = 1.0
replace frac_fullpush = 0.4
replace frac_partialpush = 0.6
save assumptions, replace
do "run_anyassumptions.do"
gen testid = "push"
merge 1:1 testid using "tests/test_output/test_assum_output.dta", nogen
save "tests/test_output/test_assum_output.dta", replace
}

/* Test delay_partialpush */
quietly {
use assumptions, clear
replace delay_partialpush = 25
save assumptions, replace
do "run_anyassumptions.do"
gen testid = "delay_partialpush"
merge 1:1 testid using "tests/test_output/test_assum_output.dta", nogen
save "tests/test_output/test_assum_output.dta", replace
}

/* ONLY USE TO OVERWRITE RESULTS
// Export results to CSV file
use "tests/test_output/test_assum_output.dta", clear
gen expectedbenefit_res = round(expectedbenefit, 0.01)
gen totalcost_res = round(totalcost / 10^9, 0.01)
gen payrollcost_res = round(payrollcost * 100, 0.01)
drop expectedbenefit totalcost payrollcost
export delimited expectedbenefit_res totalcost_res payrollcost_res testid using "tests/test_output/testresults_assumptions.csv", replace
di "Test assumptions results saved"
*/

/* Check that all tests pass or which fail */
quietly {
import delimited "tests/test_output/testresults_assumptions.csv", clear
merge 1:1 testid using "tests/test_output/test_assum_output.dta"
replace expectedbenefit = round(expectedbenefit, 0.01)
replace totalcost = round(totalcost / 10^9, 0.01)
replace payrollcost = round(payrollcost * 100, 0.01)
gen pass_expben = (expectedbenefit==expectedbenefit_res)
gen pass_total = (totalcost==totalcost_res)
gen pass_payroll = (payrollcost==payrollcost_res)
gen pass_test = pass_expben * pass_total * pass_payroll
gen test_message = ""
replace test_message = testid + ": " + "PASS" if pass_test==1
replace test_message = testid + ": " + "FAIL" if pass_test==0
noisily list test_message
}
