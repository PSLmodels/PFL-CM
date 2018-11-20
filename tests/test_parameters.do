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
gen pass_basecase_expben = (abs(expectedbenefit - 313.13403) < 0.01)
gen pass_basecase_total = (abs(totalcost/10^9 - 49.870676) < 0.01)
gen pass_basecase_payroll = (abs(payrollcost*100 - 0.5770769) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_basecase_output.dta", replace
}

/* Test maxduration_days */
quietly {
use parameters, clear
replace maxduration_days = 80
save parameters, replace
do "run_anyassumptions.do"
gen pass_duration_expben = (abs(expectedbenefit - 411.77203) < 0.01)
gen pass_duration_total = (abs(totalcost/10^9 - 65.580061) < 0.01)
gen pass_duration_payroll = (abs(payrollcost*100 - 0.75885751) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_duration_output.dta", replace
}

/* Test replacementrate */
quietly {
use parameters, clear
replace maxduration_days = 40
replace replacementrate = 0.9
save parameters, replace
do "run_anyassumptions.do"
gen pass_replacement_expben = (abs(expectedbenefit - 341.86853) < 0.01)
gen pass_replacement_total = (abs(totalcost/10^9 - 54.447018) < 0.01)
gen pass_replacement_payroll = (abs(payrollcost*100 - 0.6300319) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_replacement_output.dta", replace
}

/* Test maxbenefit */
quietly {
use parameters, clear
replace replacementrate = 0.7
replace maxbenefit = 1000
save parameters, replace
quietly do "run_anyassumptions.do"
gen pass_maxben_expben = (abs(expectedbenefit - 399.59793) < 0.01)
gen pass_maxben_total = (abs(totalcost/10^9 - 63.641178) < 0.01)
gen pass_maxben_payroll = (abs(payrollcost*100 - 0.73642181) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_maxben_output.dta", replace
}

/* Test waiting_period */
quietly {
use parameters, clear
replace maxbenefit = 600
replace waiting_period = 5
save parameters, replace
quietly do "run_anyassumptions.do"
gen pass_waiting_expben = (abs(expectedbenefit - 264.39389) < 0.01)
gen pass_waiting_total = (abs(totalcost/10^9 - 42.10817) < 0.01)
gen pass_waiting_payroll = (abs(payrollcost*100 - 0.48725335) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_waiting_output.dta", replace
}

/* Test work_requirement */
quietly {
use parameters, clear
replace waiting_period = 0
replace work_requirement = 1000
save parameters, replace
quietly do "run_anyassumptions.do"
gen pass_workhrs_expben = (abs(expectedbenefit - 297.452) < 0.01)
gen pass_workhrs_total = (abs(totalcost/10^9 - 47.373103) < 0.01)
gen pass_workhrs_payroll = (abs(payrollcost*100 - .54817633) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_workhrs_output.dta", replace
}

/* Test include_ownhealth */
quietly {
use parameters, clear
replace work_requirement = 0
replace include_ownhealth = 0
save parameters, replace
quietly do "run_anyassumptions.do"
gen pass_ownhealth_expben = (abs(expectedbenefit - 127.06824) < 0.01)
gen pass_ownhealth_total = (abs(totalcost/10^9 - 20.237271) < 0.01)
gen pass_ownhealth_payroll = (abs(payrollcost*100 - .23417494) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_ownhealth_output.dta", replace
}

/* Test include_childhealth */
quietly {
use parameters, clear
replace include_ownhealth = 1
replace include_childhealth = 0
save parameters, replace
quietly do "run_anyassumptions.do"
gen pass_childhealth_expben = (abs(expectedbenefit - 305.9642) < 0.01)
gen pass_childhealth_total = (abs(totalcost/10^9 - 48.728785) < 0.01)
gen pass_childhealth_payroll = (abs(payrollcost*100 - .56386353) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_childhealth_output.dta", replace
}

/* Test include_spousehealth */
quietly {
use parameters, clear
replace include_childhealth = 1
replace include_spousehealth = 0
save parameters, replace
quietly do "run_anyassumptions.do"
gen pass_spousehealth_expben = (abs(expectedbenefit - 298.06427) < 0.01)
gen pass_spousehealth_total = (abs(totalcost/10^9 - 47.470617) < 0.01)
gen pass_spousehealth_payroll = (abs(payrollcost*100 - .54930467) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_spousehealth_output.dta", replace
}

/* Test include_parenthealth */
quietly {
use parameters, clear
replace include_spousehealth = 1
replace include_parenthealth = 0
save parameters, replace
quietly do "run_anyassumptions.do"
gen pass_parenthealth_expben = (abs(expectedbenefit - 297.14026) < 0.01)
gen pass_parenthealth_total = (abs(totalcost/10^9 - 47.323455) < 0.01)
gen pass_parenthealth_payroll = (abs(payrollcost*100 - .54760179) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_parenthealth_output.dta", replace
}

/* Test include_otherrealhealth */
quietly {
use parameters, clear
replace include_parenthealth = 1
replace include_otherrelhealth = 0
save parameters, replace
quietly do "run_anyassumptions.do"
gen pass_otherrel_expben = (abs(expectedbenefit - 309.1489) < 0.01)
gen pass_otherrel_total = (abs(totalcost/10^9 - 49.235988) < 0.01)
gen pass_otherrel_payroll = (abs(payrollcost*100 - .56973263) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_otherrel_output.dta", replace
}

/* Test include_military */
quietly {
use parameters, clear
replace include_otherrelhealth = 1
replace include_military = 0
save parameters, replace
quietly do "run_anyassumptions.do"
gen pass_military_expben = (abs(expectedbenefit - 308.70319) < 0.01)
gen pass_military_total = (abs(totalcost/10^9 - 49.165005) < 0.01)
gen pass_military_payroll = (abs(payrollcost*100 - .56891125) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_military_output.dta", replace
}

/* Test include_otherreason */
quietly {
use parameters, clear
replace include_military = 1
replace include_otherreason = 0
save parameters, replace
quietly do "run_anyassumptions.do"
gen pass_other_expben = (abs(expectedbenefit - 312.18195) < 0.01)
gen pass_other_total = (abs(totalcost/10^9 - 49.719038) < 0.01)
gen pass_other_payroll = (abs(payrollcost*100 - .57532224) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_other_output.dta", replace
}

/* Test include_newchild */
quietly {
use parameters, clear
replace include_otherreason = 1
replace include_newchild = 0
save parameters, replace
quietly do "run_anyassumptions.do"
gen pass_newchild_expben = (abs(expectedbenefit - 233.6673) < 0.01)
gen pass_newchild_total = (abs(totalcost/10^9 - 37.21456) < 0.01)
gen pass_newchild_payroll = (abs(payrollcost*100 - .43062707) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_params_newchild_output.dta", replace
}

/* Check that all tests pass, or which fail */
quietly{
use "tests/test_output/test_params_basecase_output.dta", clear
gen pass_basecase = pass_basecase_expben * pass_basecase_total * pass_basecase_payroll
if pass_basecase==1 {
noisily di "Base case passes"
}
else {
noisily di "Base case fails"
noisily sum pass_basecase_expben pass_basecase_total pass_basecase_payroll
}
merge 1:1 mergeid using "tests/test_output/test_params_duration_output.dta", nogen norep
gen pass_duration = pass_duration_expben * pass_duration_total * pass_duration_payroll
if pass_duration == 1 {
noisily di "Duration parameter passes"
}
else {
noisily di "Duration parameter fails"
noisily sum pass_duration_expben pass_duration_total pass_duration_payroll
}
merge 1:1 mergeid using "tests/test_output/test_params_replacement_output.dta", nogen norep
gen pass_replacement = pass_replacement_expben * pass_replacement_total * pass_replacement_payroll
if pass_replacement == 1 {
noisily di "Replacement rate parameter passes"
}
else {
noisily di "Replacement rate parameter fails"
noisily sum pass_replacement_expben pass_replacement_total pass_replacement_payroll
}
merge 1:1 mergeid using "tests/test_output/test_params_maxben_output.dta", nogen norep
gen pass_maxben = pass_maxben_expben * pass_maxben_total * pass_maxben_payroll
if pass_maxben == 1 {
noisily di "Maximum benefit parameter passes"
}
else {
noisily di "Maximum benefit parameter fails"
noisily sum pass_maxben_expben pass_maxben_total pass_maxben_payroll
}
merge 1:1 mergeid using "tests/test_output/test_params_waiting_output.dta", nogen norep
gen pass_waiting = pass_waiting_expben * pass_waiting_total * pass_waiting_payroll
if pass_waiting == 1 {
noisily di "Waiting period parameter passes"
}
else {
noisily di "Waiting period parameter fails"
noisily sum pass_waiting_expben pass_waiting_total pass_waiting_payroll
}
merge 1:1 mergeid using "tests/test_output/test_params_workhrs_output.dta", nogen norep
gen pass_workhrs = pass_workhrs_expben * pass_workhrs_total * pass_workhrs_payroll
if pass_workhrs == 1 {
noisily di "Work hours requirement parameter passes"
}
else {
noisily di "Work hours requirement parameter fails"
noisily sum pass_workhrs_expben pass_workhrs_total pass_workhrs_payroll
}
merge 1:1 mergeid using "tests/test_output/test_params_ownhealth_output.dta", nogen norep
gen pass_ownhealth = pass_ownhealth_expben * pass_ownhealth_total * pass_ownhealth_payroll
if pass_ownhealth == 1 {
noisily di "Include ownh health parameter passes"
}
else {
noisily di "Include own health parameter fails"
noisily sum pass_ownhealth_expben pass_ownhealth_total pass_ownhealth_payroll
}
merge 1:1 mergeid using "tests/test_output/test_params_childhealth_output.dta", nogen norep
gen pass_childhealth = pass_childhealth_expben * pass_childhealth_total * pass_childhealth_payroll
if pass_childhealth == 1 {
noisily di "Include child health parameter passes"
}
else {
noisily di "Include child health parameter fails"
noisily sum pass_childhealth_expben pass_childhealth_total pass_childhealth_payroll
}
merge 1:1 mergeid using "tests/test_output/test_params_spousehealth_output.dta", nogen norep
gen pass_spousehealth = pass_spousehealth_expben * pass_spousehealth_total * pass_spousehealth_payroll
if pass_spousehealth == 1 {
noisily di "Include spouse health parameter passes"
}
else {
noisily di "Include spouse health parameter fails"
noisily sum pass_spousehealth_expben pass_spousehealth_total pass_spousehealth_payroll
}
merge 1:1 mergeid using "tests/test_output/test_params_parenthealth_output.dta", nogen norep
gen pass_parenthealth = pass_parenthealth_expben * pass_parenthealth_total * pass_parenthealth_payroll
if pass_parenthealth == 1 {
noisily di "Include parent health parameter passes"
}
else {
noisily di "Include parent health parameter fails"
noisily sum pass_parenthealth_expben pass_parenthealth_total pass_parenthealth_payroll
}
merge 1:1 mergeid using "tests/test_output/test_params_otherrel_output.dta", nogen norep
gen pass_otherrel = pass_otherrel_expben * pass_otherrel_total * pass_otherrel_payroll
if pass_otherrel == 1 {
noisily di "Include other relative health parameter passes"
}
else {
noisily di "Include other relative health parameter fails"
noisily sum pass_otherrel_expben pass_otherrel_total pass_otherrel_payroll
}
merge 1:1 mergeid using "tests/test_output/test_params_military_output.dta", nogen norep
gen pass_military = pass_military_expben * pass_military_total * pass_military_payroll
if pass_military == 1 {
noisily di "Include military parameter passes"
}
else {
noisily di "Include military parameter fails"
noisily sum pass_military_expben pass_military_total pass_military_payroll
}
merge 1:1 mergeid using "tests/test_output/test_params_other_output.dta", nogen norep
gen pass_other = pass_other_expben * pass_other_total * pass_other_payroll
if pass_other == 1 {
noisily di "Include other reason parameter passes"
}
else {
noisily di "Include other reason parameter fails"
noisily sum pass_other_expben pass_other_total pass_other_payroll
}
merge 1:1 mergeid using "tests/test_output/test_params_newchild_output.dta", nogen norep
gen pass_newchild = pass_newchild_expben * pass_newchild_total * pass_newchild_payroll
if pass_newchild == 1 {
noisily di "Include new child parameter passes"
}
else {
noisily di "Include new child parameter fails"
noisily sum pass_newchild_expben pass_newchild_total pass_newchild_payroll
}
}


