cd "N:\Kallen\Gitis PFL model"

/* Define parameters */
use parameters, clear
replace maxduration_days = 40
replace replacementrate = 0.7
replace maxbenefit = 600
save parameters, replace

/* Determine which assumptions to use */
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


/* Run model */
quietly do "run_anyassumptions.do"
sum totalcost payrollcost
