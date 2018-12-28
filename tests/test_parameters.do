cd ..

/*
This file tests the effects of changing the parameter 
values. It begins with a base case and tests the 
results when each parameter deviates from the 
base case. 
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
save "tests/test_output/test_params_output.dta", replace
}

/* Test maxduration_days */
quietly {
use parameters, clear
replace maxduration_days = 80
save parameters, replace
do "run_anyassumptions.do"
gen testid = "maxduration_days"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test replacementrate */
quietly {
use parameters, clear
replace maxduration_days = 40
replace replacementrate = 0.9
save parameters, replace
do "run_anyassumptions.do"
gen testid = "replacementrate"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test maxbenefit */
quietly {
use parameters, clear
replace replacementrate = 0.7
replace maxbenefit = 1000
save parameters, replace
do "run_anyassumptions.do"
gen testid = "maxbenefit"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test minbenefit */
quietly {
use parameters, clear
replace maxbenefit = 600
replace minbenefit = 300
save parameters, replace
do "run_anyassumptions.do"
gen testid = "minbenefit"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test phase-out */
quietly {
use parameters, clear
replace minbenefit = 0
replace benefit_phaseout_thd = 2000
replace benefit_phaseout_rt = 0.2
save parameters, replace
do "run_anyassumptions.do"
gen testid = "phase_out"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test waiting_period */
quietly {
use parameters, clear
replace benefit_phaseout_thd = 9e99
replace benefit_phaseout_rt = 0
replace waiting_period = 5
save parameters, replace
do "run_anyassumptions.do"
gen testid = "waiting_period"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test work_requirement */
quietly {
use parameters, clear
replace waiting_period = 0
replace work_requirement = 1000
save parameters, replace
do "run_anyassumptions.do"
gen testid = "work_requirement"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test include_ownhealth */
quietly {
use parameters, clear
replace work_requirement = 0
replace include_ownhealth = 0
save parameters, replace
do "run_anyassumptions.do"
gen testid = "include_ownhealth"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test include_childhealth */
quietly {
use parameters, clear
replace include_ownhealth = 1
replace include_childhealth = 0
save parameters, replace
do "run_anyassumptions.do"
gen testid = "include_childhealth"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test include_spousehealth */
quietly {
use parameters, clear
replace include_childhealth = 1
replace include_spousehealth = 0
save parameters, replace
do "run_anyassumptions.do"
gen testid = "include_spousehealth"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test include_parenthealth */
quietly {
use parameters, clear
replace include_spousehealth = 1
replace include_parenthealth = 0
save parameters, replace
do "run_anyassumptions.do"
gen testid = "include_parenthealth"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test include_otherrealhealth */
quietly {
use parameters, clear
replace include_parenthealth = 1
replace include_otherrelhealth = 0
save parameters, replace
do "run_anyassumptions.do"
gen testid = "include_otherrelhealth"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test include_military */
quietly {
use parameters, clear
replace include_otherrelhealth = 1
replace include_military = 0
save parameters, replace
do "run_anyassumptions.do"
gen testid = "include_military"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test include_otherreason */
quietly {
use parameters, clear
replace include_military = 1
replace include_otherreason = 0
save parameters, replace
do "run_anyassumptions.do"
gen testid = "include_otherreason"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* Test include_newchild */
quietly {
use parameters, clear
replace include_otherreason = 1
replace include_newchild = 0
save parameters, replace
do "run_anyassumptions.do"
gen testid = "include_newchild"
merge 1:1 testid using "tests/test_output/test_params_output.dta", nogen
save "tests/test_output/test_params_output.dta", replace
}

/* ONLY USE TO OVERWRITE RESULTS
// Export results to CSV file
use "tests/test_output/test_params_output.dta", clear
gen expectedbenefit_res = round(expectedbenefit, 0.01)
gen totalcost_res = round(totalcost / 10^9, 0.01)
gen payrollcost_res = round(payrollcost * 100, 0.01)
drop expectedbenefit totalcost payrollcost
export delimited expectedbenefit_res totalcost_res payrollcost_res testid using "tests/test_output/testresults_parameters.csv", replace
*/

/* Check that all tests pass or which fail */
quietly {
import delimited "tests/test_output/testresults_parameters.csv", clear
merge 1:1 testid using "tests/test_output/test_params_output.dta"
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

