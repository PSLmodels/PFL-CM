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
replace frac_employerpush = 1.0
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
save "tests/test_output/test_assum_basecase_output.dta", replace
}

/* Test overall_takeup */
quietly {
use assumptions, clear
replace overall_takeup = 0.2
save assumptions, replace
do "run_anyassumptions.do"
gen pass_takeup_expben = (abs(expectedbenefit - 393.8793) < 0.01)
gen pass_takeup_total = (abs(totalcost/10^9 - 62.730408) < 0.01)
gen pass_takeup_payroll = (abs(payrollcost*100 - 0.72588287) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_assum_takeup_output.dta", replace
}

/* Test reduce_ownhealth */
quietly {
use assumptions, clear
replace overall_takeup = 0.159
replace reduce_ownhealth = 0.5
save assumptions, replace
do "run_anyassumptions.do"
gen pass_redmedical_expben = (abs(expectedbenefit - 220.1012 ) < 0.01)
gen pass_redmedical_total = (abs(totalcost/10^9 - 35.053978) < 0.01)
gen pass_redmedical_payroll = (abs(payrollcost*100 - .40562595) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_assum_redmedical_output.dta", replace
}

/* Test reduce_childhealth */
quietly {
use assumptions, clear
replace reduce_ownhealth = 1.0
replace reduce_childhealth = 0.2
save assumptions, replace
do "run_anyassumptions.do"
gen pass_redchildh_expben = (abs(expectedbenefit - 307.3982  ) < 0.01)
gen pass_redchildh_total = (abs(totalcost/10^9 - 48.957166) < 0.01)
gen pass_redchildh_payroll = (abs(payrollcost*100 - .56650625) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_assum_redchildh_output.dta", replace
}

/* Test reduce_spousehealth */
quietly {
use assumptions, clear
replace reduce_childhealth = 1.0
replace reduce_spousehealth = 0.2
save assumptions, replace
do "run_anyassumptions.do"
gen pass_redspouse_expben = (abs(expectedbenefit - 301.0782) < 0.01)
gen pass_redspouse_total = (abs(totalcost/10^9 - 47.950623) < 0.01)
gen pass_redspouse_payroll = (abs(payrollcost*100 - .55485908) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_assum_redspouse_output.dta", replace
}

/* Test reduce_parenthealth */
quietly {
use assumptions, clear
replace reduce_spousehealth = 1.0
replace reduce_parenthealth = 0.1
save assumptions, replace
do "run_anyassumptions.do"
gen pass_redparent_expben = (abs(expectedbenefit - 298.7396) < 0.01)
gen pass_redparent_total = (abs(totalcost/10^9 - 47.578178) < 0.01)
gen pass_redparent_payroll = (abs(payrollcost*100 - .55054934) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_assum_redparent_output.dta", replace
}

/* Test reduce_otherrelhealth */
quietly {
use assumptions, clear
replace reduce_parenthealth = 1.0
replace reduce_otherrelhealth = 0.1
save assumptions, replace
do "run_anyassumptions.do"
gen pass_redotherrel_expben = (abs(expectedbenefit - 309.5474) < 0.01)
gen pass_redotherrel_total = (abs(totalcost/10^9 - 49.29946) < 0.01)
gen pass_redotherrel_payroll = (abs(payrollcost*100 - .57046711) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_assum_redotherrel_output.dta", replace
}

/* Test reduce_military */
quietly {
use assumptions, clear
replace reduce_otherrelhealth = 1.0
replace reduce_military = 0.9
save assumptions, replace
do "run_anyassumptions.do"
gen pass_redmilitary_expben = (abs(expectedbenefit - 312.691) < 0.01)
gen pass_redmilitary_total = (abs(totalcost/10^9 - 49.80011) < 0.01)
gen pass_redmilitary_payroll = (abs(payrollcost*100 - .57626031) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_assum_redmilitary_output.dta", replace
}

/* Test reduce_otherreason */
quietly {
use assumptions, clear
replace reduce_military = 1.0
replace reduce_otherreason = 0.0
save assumptions, replace
do "run_anyassumptions.do"
gen pass_redother_expben = (abs(expectedbenefit - 312.1819) < 0.01)
gen pass_redother_total = (abs(totalcost/10^9 - 49.719038) < 0.01)
gen pass_redother_payroll = (abs(payrollcost*100 - .57532224) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_assum_redother_output.dta", replace
}

/* Test reduce_newchild */
quietly {
use assumptions, clear
replace reduce_otherreason = 1.0
replace reduce_newchild = 0.9
save assumptions, replace
do "run_anyassumptions.do"
gen pass_rednewchild_expben = (abs(expectedbenefit - 305.1873) < 0.01)
gen pass_rednewchild_total = (abs(totalcost/10^9 - 48.605061) < 0.01)
gen pass_rednewchild_payroll = (abs(payrollcost*100 - .5624319) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_assum_rednewchild_output.dta", replace
}

/* Test frac_employerpush */
quietly {
use assumptions, clear
replace reduce_newchild = 1.0
replace frac_employerpush = 0.4
save assumptions, replace
do "run_anyassumptions.do"
gen pass_emppush_expben = (abs(expectedbenefit - 247.8717) < 0.01)
gen pass_emppush_total = (abs(totalcost/10^9 - 39.476793) < 0.01)
gen pass_emppush_payroll = (abs(payrollcost*100 - .45680446) < 0.01)
drop expectedbenefit totalcost payrollcost
gen mergeid = 1
save "tests/test_output/test_assum_emppush_output.dta", replace
}

/* Check that all tests pass, or which fail */
quietly{
use "tests/test_output/test_assum_basecase_output.dta", clear
gen pass_basecase = pass_basecase_expben * pass_basecase_total * pass_basecase_payroll
if pass_basecase==1 {
noisily di "Base case passes"
}
else {
noisily di "Base case fails"
noisily sum pass_basecase_expben pass_basecase_total pass_basecase_payroll
}
merge 1:1 mergeid using "tests/test_output/test_assum_takeup_output.dta", nogen norep
gen pass_takeup = pass_takeup_expben * pass_takeup_total * pass_takeup_payroll
if pass_takeup == 1 {
noisily di "Overall take-up assumption passes"
}
else {
noisily di "Overall take-up assumption fails"
noisily sum pass_takeup_expben pass_takeup_total pass_takeup_payroll
}
merge 1:1 mergeid using "tests/test_output/test_assum_redmedical_output.dta", nogen norep
gen pass_redmedical = pass_redmedical_expben * pass_redmedical_total * pass_redmedical_payroll
if pass_redmedical == 1 {
noisily di "Reduce take-up for ownhealth assumption passes"
}
else {
noisily di "Reduce take-up for ownhealth assumption fails"
noisily sum pass_redmedical_expben pass_redmedical_total pass_redmedical_payroll
}
merge 1:1 mergeid using "tests/test_output/test_assum_redchildh_output.dta", nogen norep
gen pass_redchildh = pass_redchildh_expben * pass_redchildh_total * pass_redchildh_payroll
if pass_redchildh == 1 {
noisily di "Reduce take-up for child health assumption passes"
}
else {
noisily di "Reduce take-up for child health assumption fails"
noisily sum pass_redchildh_expben pass_redchildh_total pass_redchildh_payroll
}
merge 1:1 mergeid using "tests/test_output/test_assum_redspouse_output.dta", nogen norep
gen pass_redspouse = pass_redspouse_expben * pass_redspouse_total * pass_redspouse_payroll
if pass_redspouse == 1 {
noisily di "Reduce take-up for spouse health assumption passes"
}
else {
noisily di "Reduce take-up for spouse health assumption fails"
noisily sum pass_redspouse_expben pass_redspouse_total pass_redspouse_payroll
}
merge 1:1 mergeid using "tests/test_output/test_assum_redparent_output.dta", nogen norep
gen pass_redparent = pass_redparent_expben * pass_redparent_total * pass_redparent_payroll
if pass_redparent == 1 {
noisily di "Reduce take-up for parent health assumption passes"
}
else {
noisily di "Reduce take-up for parent health assumption fails"
noisily sum pass_redparent_expben pass_redparent_total pass_redparent_payroll
}
merge 1:1 mergeid using "tests/test_output/test_assum_redotherrel_output.dta", nogen norep
gen pass_redotherrel = pass_redotherrel_expben * pass_redotherrel_total * pass_redotherrel_payroll
if pass_redotherrel == 1 {
noisily di "Reduce take-up for other relative health assumption passes"
}
else {
noisily di "Reduce take-up for other relative health assumption fails"
noisily sum pass_redotherrel_expben pass_redotherrel_total pass_redotherrel_payroll
}
merge 1:1 mergeid using "tests/test_output/test_assum_redmilitary_output.dta", nogen norep
gen pass_redmilitary = pass_redmilitary_expben * pass_redmilitary_total * pass_redmilitary_payroll
if pass_redmilitary == 1 {
noisily di "Reduce take-up for military assumption passes"
}
else {
noisily di "Reduce take-up for military assumption fails"
noisily sum pass_redmilitary_expben pass_redmilitary_total pass_redmilitary_payroll
}
merge 1:1 mergeid using "tests/test_output/test_assum_redother_output.dta", nogen norep
gen pass_redother = pass_redother_expben * pass_redother_total * pass_redother_payroll
if pass_redother == 1 {
noisily di "Reduce take-up for other reason assumption passes"
}
else {
noisily di "Reduce take-up for other reason assumption fails"
noisily sum pass_redother_expben pass_redother_total pass_redother_payroll
}
merge 1:1 mergeid using "tests/test_output/test_assum_rednewchild_output.dta", nogen norep
gen pass_rednewchild = pass_rednewchild_expben * pass_rednewchild_total * pass_rednewchild_payroll
if pass_rednewchild == 1 {
noisily di "Reduce take-up for new child assumption passes"
}
else {
noisily di "Reduce take-up for new child assumption fails"
noisily sum pass_rednewchild_expben pass_rednewchild_total pass_rednewchild_payroll
}
merge 1:1 mergeid using "tests/test_output/test_assum_emppush_output.dta", nogen norep
gen pass_emppush = pass_emppush_expben * pass_emppush_total * pass_emppush_payroll
if pass_emppush == 1 {
noisily di "Reduced employer push assumption passes"
}
else {
noisily di "Reduced employer push assumption fails"
noisily sum pass_emppush_expben pass_emppush_total pass_emppush_payroll
}
}

