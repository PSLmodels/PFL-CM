****************************
*** FMLA Survey Analysis ***
****************************
// Determine eligibility for paid leave, assuming FMLA eligibility rules
use fmla, clear
gen FMLAelig = 0
replace FMLAelig = 1 if (E11 == 1) & (E13 == 1) & (E14 == 1)
replace FMLAelig = 1 if (E11 == 1) & (E13 == 1) & inrange(E15_CAT_REV,5,8)
replace FMLAelig = 1 if inrange(E12,6,9) & (E13 == 1) & (E14 ==1)
replace FMLAelig = 1 if inrange(E12,6,9) & (E13 == 1) & inrange(E15_CAT_REV,5,8)

// Merge in policy parameters
gen mergeid = 1
merge m:1 mergeid using parameters, nogen

// Merge in assumption variables
merge m:1 mergeid using assumptions, nogen
drop mergeid


/* Duration Variables */

// Covert duration categorical results to continuous variable
gen durationlow=1 if A19_1_CAT==1
replace durationlow=2 if A19_1_CAT==2
replace durationlow=3 if A19_1_CAT==3
replace durationlow=4 if A19_1_CAT==4
replace durationlow=5 if A19_1_CAT==5
replace durationlow=6 if A19_1_CAT==6
replace durationlow=7 if A19_1_CAT==7
replace durationlow=8 if A19_1_CAT==8
replace durationlow=9 if A19_1_CAT==9
replace durationlow=10 if A19_1_CAT==10
replace durationlow=11.5 if A19_1_CAT==11
replace durationlow=13.5 if A19_1_CAT==12
replace durationlow=15 if A19_1_CAT==13
replace durationlow=17.5 if A19_1_CAT==14
replace durationlow=20 if A19_1_CAT==15
replace durationlow=22.5 if A19_1_CAT==16
replace durationlow=27 if A19_1_CAT==17
replace durationlow=30 if A19_1_CAT==18
replace durationlow=33 if A19_1_CAT==19
replace durationlow=38 if A19_1_CAT==20
replace durationlow=43 if A19_1_CAT==21
replace durationlow=48 if A19_1_CAT==22
replace durationlow=53 if A19_1_CAT==23
replace durationlow=58 if A19_1_CAT==24
replace durationlow=65.5 if A19_1_CAT==25
replace durationlow=80.5 if A19_1_CAT==26
replace durationlow=105.5 if A19_1_CAT==27
replace durationlow=121 if A19_1_CAT==28

// Adjust duration by doubling for those still on leave
gen durationhigh=durationlow
replace durationhigh=durationlow*2 if A3==1

// Limit duration based on maximum leave available
// durationhigh: duration of paid leave for those taking it immediately
// durationhigh2: duration for those going onto the program after 4 weeks
replace durationhigh = 0 if durationhigh<waiting_period & !missing(durationhigh)
replace durationhigh = durationhigh - waiting_period if durationhigh>=waiting_period & !missing(durationhigh)
replace durationhigh = maxduration_days if durationhigh>maxduration_days & !missing(durationhigh)

gen durationhigh2 = durationhigh
replace durationhigh2 = maxduration_days + 20 if durationhigh2>maxduration_days+20 & !missing(durationhigh2)


/* Workers who took medical, family, and parental, as defined under FMLA */

gen FMLAleavetaker=1 if A5_1_CAT>=1
replace FMLAleavetaker=0 if A5_1_CAT==.

//Those who took leave in past 18 months
gen leavetakeandneed=1 if LEAVE_CAT==1
replace leavetakeandneed=1 if LEAVE_CAT==4
replace leavetakeandneed=0 if LEAVE_CAT==2
replace leavetakeandneed=0 if LEAVE_CAT==3

//Those who took leave in past 12 months
gen leavetaker12=1 if A2==1
replace leavetaker12=0 if A2!=1


/* Reason for FMLA leave */

gen ownhealth1=1 if A5_1_CAT==1
replace ownhealth1=0 if A5_1_CAT!=1

gen childhealth1=1 if A5_1_CAT==11
replace childhealth1=0 if A5_1_CAT!=11

gen spousehealth1=1 if A5_1_CAT==12
replace spousehealth1=0 if A5_1_CAT!=12

gen parenthealth1=1 if A5_1_CAT==13
replace parenthealth1=0 if A5_1_CAT!=13

gen otherrelhealth1=1 if A5_1_CAT==14
replace otherrelhealth1=0 if A5_1_CAT!=14

gen military1=1 if A5_1_CAT==17
replace military1=0 if A5_1_CAT!=17

gen otherreason1=1 if A5_1_CAT==20
replace otherreason1=0 if A5_1_CAT!=20

gen newchild1=1 if A5_1_CAT==21
replace newchild1=0 if A5_1_CAT!=21


/* Workers paid by employer */

gen paid=1 if A45==1
replace paid=0 if A45==2


/*Workers who take at or below 4 weeks of leave*/
gen fourweekshigh=1 if durationhigh<=20
replace fourweekshigh=0 if durationhigh>20 & durationhigh<=242

save "intermediate_files/fmla2.dta", replace


*************************
*** Save FMLA results ***
*************************

/* Save take-up shares */
// Condition: eligible and took leave
use "intermediate_files/fmla2.dta", clear
collapse ownhealth1 childhealth1 spousehealth1 parenthealth1 otherrelhealth1 military1 otherreason1 newchild1 if FMLAleavetaker==1 & FMLAelig==1 [aweight=weight]
gen mergeid = 1
save "intermediate_files/takeupshares.dta", replace

/* Save fraction paid */
// Condition: eligible & took given type of leave
use "intermediate_files/fmla2.dta", clear
collapse paid if ownhealth1==1 & FMLAelig==1 [aweight=weight]
rename paid ownhealth_fracpaid
gen mergeid = 1
save "intermediate_files/ownhealth_fracpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse paid if childhealth1==1 & FMLAelig==1 [aweight=weight]
rename paid childhealth_fracpaid
gen mergeid = 1
save "intermediate_files/childhealth_fracpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse paid if spousehealth1==1 & FMLAelig==1 [aweight=weight]
rename paid spousehealth_fracpaid
gen mergeid = 1
save "intermediate_files/spousehealth_fracpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse paid if parenthealth1==1 & FMLAelig==1 [aweight=weight]
rename paid parenthealth_fracpaid
gen mergeid = 1
save "intermediate_files/parenthealth_fracpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse paid if otherrelhealth1==1 & FMLAelig==1 [aweight=weight]
rename paid otherrelhealth_fracpaid
gen mergeid = 1
save "intermediate_files/otherrelhealth_fracpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse paid if military1==1 & FMLAelig==1 [aweight=weight]
rename paid military_fracpaid
gen mergeid = 1
save "intermediate_files/military_fracpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse paid if otherreason1==1 & FMLAelig==1 [aweight=weight]
rename paid otherreason_fracpaid
gen mergeid = 1
save "intermediate_files/otherreason_fracpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse paid if newchild1==1 & FMLAelig==1 [aweight=weight]
rename paid newchild_fracpaid
gen mergeid = 1
save "intermediate_files/newchild_fracpaid.dta", replace

use "intermediate_files/ownhealth_fracpaid.dta", clear
merge 1:1 mergeid using "intermediate_files/childhealth_fracpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/spousehealth_fracpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/parenthealth_fracpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/otherrelhealth_fracpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/military_fracpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/otherreason_fracpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/newchild_fracpaid.dta", nogen
save "intermediate_files/fracpaid.dta", replace

/* Save fraction under 4 weeks and duration for those paid */
// Condition: eligible & took given type of leave & paid by employer
use "intermediate_files/fmla2.dta", clear
collapse fourweekshigh durationhigh if ownhealth1==1 & FMLAelig==1 & paid==1 [aweight=weight]
rename fourweekshigh ownhealth_fracunder4
rename durationhigh ownhealth_dayspaid
gen mergeid = 1
save "intermediate_files/ownhealth_fracunder4_paid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse fourweekshigh durationhigh if childhealth1==1 & FMLAelig==1 & paid==1 [aweight=weight]
rename fourweekshigh childhealth_fracunder4
rename durationhigh childhealth_dayspaid
gen mergeid = 1
save "intermediate_files/childhealth_fracunder4_paid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse fourweekshigh durationhigh if spousehealth1==1 & FMLAelig==1 & paid==1 [aweight=weight]
rename fourweekshigh spousehealth_fracunder4
rename durationhigh spousehealth_dayspaid
gen mergeid = 1
save "intermediate_files/spousehealth_fracunder4_paid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse fourweekshigh durationhigh if parenthealth1==1 & FMLAelig==1 & paid==1 [aweight=weight]
rename fourweekshigh parenthealth_fracunder4
rename durationhigh parenthealth_dayspaid
gen mergeid = 1
save "intermediate_files/parenthealth_fracunder4_paid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse fourweekshigh durationhigh if otherrelhealth1==1 & FMLAelig==1 & paid==1 [aweight=weight]
rename fourweekshigh otherrelhealth_fracunder4
rename durationhigh otherrelhealth_dayspaid
gen mergeid = 1
save "intermediate_files/otherrelhealth_fracunder4_paid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse fourweekshigh durationhigh if military1==1 & FMLAelig==1 & paid==1 [aweight=weight]
rename fourweekshigh military_fracunder4
rename durationhigh military_dayspaid
gen mergeid = 1
save "intermediate_files/military_fracunder4_paid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse fourweekshigh durationhigh if otherreason1==1 & FMLAelig==1 & paid==1 [aweight=weight]
rename fourweekshigh otherreason_fracunder4
rename durationhigh otherreason_dayspaid
gen mergeid = 1
save "intermediate_files/otherreason_fracunder4_paid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse fourweekshigh durationhigh if newchild1==1 & FMLAelig==1 & paid==1 [aweight=weight]
rename fourweekshigh newchild_fracunder4
rename durationhigh newchild_dayspaid
gen mergeid = 1
save "intermediate_files/newchild_fracunder4_paid.dta", replace

use "intermediate_files/ownhealth_fracunder4_paid.dta", clear
merge 1:1 mergeid using "intermediate_files/childhealth_fracunder4_paid.dta", nogen
merge 1:1 mergeid using "intermediate_files/spousehealth_fracunder4_paid.dta", nogen
merge 1:1 mergeid using "intermediate_files/parenthealth_fracunder4_paid.dta", nogen
merge 1:1 mergeid using "intermediate_files/otherrelhealth_fracunder4_paid.dta", nogen
merge 1:1 mergeid using "intermediate_files/military_fracunder4_paid.dta", nogen
merge 1:1 mergeid using "intermediate_files/otherreason_fracunder4_paid.dta", nogen
merge 1:1 mergeid using "intermediate_files/newchild_fracunder4_paid.dta", nogen
save "intermediate_files/fracunder4_paid.dta", replace

/* Save duration for those unpaid */
// Condition: eligible & took given type of leave & unpaid
use "intermediate_files/fmla2.dta", clear
collapse durationhigh if ownhealth1==1 & FMLAelig==1 & paid==0 [aweight=weight]
rename durationhigh ownhealth_daysunpaid
gen mergeid = 1
save "intermediate_files/ownhealth_daysunpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse durationhigh if childhealth1==1 & FMLAelig==1 & paid==0 [aweight=weight]
rename durationhigh childhealth_daysunpaid
gen mergeid = 1
save "intermediate_files/childhealth_daysunpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse durationhigh if spousehealth1==1 & FMLAelig==1 & paid==0 [aweight=weight]
rename durationhigh spousehealth_daysunpaid
gen mergeid = 1
save "intermediate_files/spousehealth_daysunpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse durationhigh if parenthealth1==1 & FMLAelig==1 & paid==0 [aweight=weight]
rename durationhigh parenthealth_daysunpaid
gen mergeid = 1
save "intermediate_files/parenthealth_daysunpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse durationhigh if otherrelhealth1==1 & FMLAelig==1 & paid==0 [aweight=weight]
rename durationhigh otherrelhealth_daysunpaid
gen mergeid = 1
save "intermediate_files/otherrelhealth_daysunpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse durationhigh if military1==1 & FMLAelig==1 & paid==0 [aweight=weight]
rename durationhigh military_daysunpaid
gen mergeid = 1
save "intermediate_files/military_daysunpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
//No observations, set duration to zero
**collapse durationhigh if otherreason1==1 & FMLAelig==1 & paid==0 [aweight=weight]
**rename durationhigh otherreason_daysunpaid
gen otherreason_daysunpaid = 0
collapse otherreason_daysunpaid
gen mergeid = 1
save "intermediate_files/otherreason_daysunpaid.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse durationhigh if newchild1==1 & FMLAelig==1 & paid==0 [aweight=weight]
rename durationhigh newchild_daysunpaid
gen mergeid = 1
save "intermediate_files/newchild_daysunpaid.dta", replace

use "intermediate_files/ownhealth_daysunpaid.dta", clear
merge 1:1 mergeid using "intermediate_files/childhealth_daysunpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/spousehealth_daysunpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/parenthealth_daysunpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/otherrelhealth_daysunpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/military_daysunpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/otherreason_daysunpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/newchild_daysunpaid.dta", nogen
save "intermediate_files/daysunpaid.dta", replace


/* Save duration for those taking over 4 weeks */
// Condition: eligible & took given type of leave & paid by employer & took over 4 weeks
use "intermediate_files/fmla2.dta", clear
collapse durationhigh2 if ownhealth1==1 & FMLAelig==1 & paid==1 & fourweekshigh==0 [aweight=weight]
rename durationhigh2 ownhealth_daysover
gen mergeid = 1
save "intermediate_files/ownhealth_daysover.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse durationhigh2 if childhealth1==1 & FMLAelig==1 & paid==1 & fourweekshigh==0 [aweight=weight]
rename durationhigh2 childhealth_daysover
gen mergeid = 1
save "intermediate_files/childhealth_daysover.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse durationhigh2 if spousehealth1==1 & FMLAelig==1 & paid==1 & fourweekshigh==0 [aweight=weight]
rename durationhigh2 spousehealth_daysover
gen mergeid = 1
save "intermediate_files/spousehealth_daysover.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse durationhigh2 if parenthealth1==1 & FMLAelig==1 & paid==1 & fourweekshigh==0 [aweight=weight]
rename durationhigh2 parenthealth_daysover
gen mergeid = 1
save "intermediate_files/parenthealth_daysover.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse durationhigh2 if otherrelhealth1==1 & FMLAelig==1 & paid==1 & fourweekshigh==0 [aweight=weight]
rename durationhigh2 otherrelhealth_daysover
gen mergeid = 1
save "intermediate_files/otherrelhealth_daysover.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse durationhigh2 if military1==1 & FMLAelig==1 & paid==1 & fourweekshigh==0 [aweight=weight]
rename durationhigh2 military_daysover
gen mergeid = 1
save "intermediate_files/military_daysover.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse durationhigh2 if otherreason1==1 & FMLAelig==1 & paid==1 & fourweekshigh==0 [aweight=weight]
rename durationhigh2 otherreason_daysover
gen mergeid = 1
save "intermediate_files/otherreason_daysover.dta", replace

use "intermediate_files/fmla2.dta", clear
collapse durationhigh2 if newchild1==1 & FMLAelig==1 & paid==1 & fourweekshigh==0 [aweight=weight]
rename durationhigh2 newchild_daysover
gen mergeid = 1
save "intermediate_files/newchild_daysover.dta", replace

use "intermediate_files/ownhealth_daysover.dta", clear
merge 1:1 mergeid using "intermediate_files/childhealth_daysover.dta", nogen
merge 1:1 mergeid using "intermediate_files/spousehealth_daysover.dta", nogen
merge 1:1 mergeid using "intermediate_files/parenthealth_daysover.dta", nogen
merge 1:1 mergeid using "intermediate_files/otherrelhealth_daysover.dta", nogen
merge 1:1 mergeid using "intermediate_files/military_daysover.dta", nogen
merge 1:1 mergeid using "intermediate_files/otherreason_daysover.dta", nogen
merge 1:1 mergeid using "intermediate_files/newchild_daysover.dta", nogen
save "intermediate_files/daysover.dta", replace


/* Merge FMLA results together */
use "intermediate_files/takeupshares.dta", clear
merge 1:1 mergeid using "intermediate_files/fracpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/fracunder4_paid.dta", nogen
merge 1:1 mergeid using "intermediate_files/daysunpaid.dta", nogen
merge 1:1 mergeid using "intermediate_files/daysover.dta", nogen
merge 1:1 mergeid using assumptions, nogen

/* Calculate expected expected duration total*/
// Overall take-up rates
gen ownhealth_rate = ownhealth1 * overall_takeup * reduce_ownhealth
gen childhealth_rate = childhealth1 * overall_takeup * reduce_childhealth
gen spousehealth_rate = spousehealth1 * overall_takeup * reduce_spousehealth
gen parenthealth_rate = parenthealth1 * overall_takeup * reduce_parenthealth
gen otherrelhealth_rate = otherrelhealth1 * overall_takeup * reduce_otherrelhealth
gen military_rate = military1 * overall_takeup * reduce_military
gen otherreason_rate = otherreason1 * overall_takeup * reduce_otherreason
gen newchild_rate = newchild1 * overall_takeup * reduce_newchild

// Expected duration for those not paid by employers
gen ownhealth_expdur_unpaid = ownhealth_rate * (1 - ownhealth_fracpaid) * ownhealth_daysunpaid
gen childhealth_expdur_unpaid = childhealth_rate * (1 - childhealth_fracpaid) * childhealth_daysunpaid
gen spousehealth_expdur_unpaid = spousehealth_rate * (1 - spousehealth_fracpaid) * spousehealth_daysunpaid
gen parenthealth_expdur_unpaid = parenthealth_rate * (1 - parenthealth_fracpaid) * parenthealth_daysunpaid
gen otherrelhealth_expdur_unpaid = otherrelhealth_rate * (1 - otherrelhealth_fracpaid) * otherrelhealth_daysunpaid
gen military_expdur_unpaid = military_rate * (1 - military_fracpaid) * military_daysunpaid
gen otherreason_expdur_unpaid = otherreason_rate * (1 - otherreason_fracpaid) * otherreason_daysunpaid
gen newchild_expdur_unpaid = newchild_rate * (1 - newchild_fracpaid) * newchild_daysunpaid

// Expected duration for those pushed onto the program
gen ownhealth_expdur_paid = ownhealth_rate * frac_employerpush * ownhealth_fracpaid * ownhealth_dayspaid
gen childhealth_expdur_paid = childhealth_rate * frac_employerpush * childhealth_fracpaid * childhealth_dayspaid
gen spousehealth_expdur_paid = spousehealth_rate * frac_employerpush * spousehealth_fracpaid * spousehealth_dayspaid
gen parenthealth_expdur_paid = parenthealth_rate * frac_employerpush * parenthealth_fracpaid * parenthealth_dayspaid
gen otherrelhealth_expdur_paid = otherrelhealth_rate * frac_employerpush * otherrelhealth_fracpaid * otherrelhealth_dayspaid
gen military_expdur_paid = military_rate * frac_employerpush * military_fracpaid * military_dayspaid
gen otherreason_expdur_paid = otherreason_rate * frac_employerpush * otherreason_fracpaid * otherreason_dayspaid
gen newchild_expdur_paid = newchild_rate * frac_employerpush * newchild_fracpaid * newchild_dayspaid

// Expected duration for those on the program after 4 weeks
gen ownhealth_expdur_over = ownhealth_rate * (1 - frac_employerpush) * ownhealth_fracpaid * (ownhealth_daysover - 20) * (1 - ownhealth_fracunder4)
gen childhealth_expdur_over = childhealth_rate * (1 - frac_employerpush) * childhealth_fracpaid * (childhealth_daysover - 20) * (1 - childhealth_fracunder4)
gen spousehealth_expdur_over = spousehealth_rate * (1 - frac_employerpush) * spousehealth_fracpaid * (spousehealth_daysover - 20) * (1 - spousehealth_fracunder4)
gen parenthealth_expdur_over = parenthealth_rate * (1 - frac_employerpush) * parenthealth_fracpaid * (parenthealth_daysover - 20) * (1 - parenthealth_fracunder4)
gen otherrelhealth_expdur_over = otherrelhealth_rate * (1 - frac_employerpush) * otherrelhealth_fracpaid * (otherrelhealth_daysover - 20) * (1 - otherrelhealth_fracunder4)
gen military_expdur_over = military_rate * (1 - frac_employerpush) * military_fracpaid * (military_daysover - 20) * (1 - military_fracunder4)
gen otherreason_expdur_over = otherreason_rate * (1 - frac_employerpush) * otherreason_fracpaid * (otherreason_daysover - 20) * (1 - otherreason_fracunder4)
gen newchild_expdur_over = newchild_rate * (1 - frac_employerpush) * newchild_fracpaid * (newchild_daysover - 20) * (1 - newchild_fracunder4)

// Expected duration
gen ownhealth_expdur = ownhealth_expdur_unpaid + ownhealth_expdur_paid + ownhealth_expdur_over
gen childhealth_expdur = childhealth_expdur_unpaid + childhealth_expdur_paid + childhealth_expdur_over
gen spousehealth_expdur = spousehealth_expdur_unpaid + spousehealth_expdur_paid + spousehealth_expdur_over
gen parenthealth_expdur = parenthealth_expdur_unpaid + parenthealth_expdur_paid + parenthealth_expdur_over
gen otherrelhealth_expdur = otherrelhealth_expdur_unpaid + otherrelhealth_expdur_paid + otherrelhealth_expdur_over
gen military_expdur = military_expdur_unpaid + military_expdur_paid + military_expdur_over
gen otherreason_expdur = otherreason_expdur_unpaid + otherreason_expdur_paid + otherreason_expdur_over
gen newchild_expdur = newchild_expdur_unpaid + newchild_expdur_paid + newchild_expdur_over

save "intermediate_files/fmla_results.dta", replace


************************************
*** CPS Wage and Worker Analysis ***
************************************

use cpsmar2017, clear

// Employment status identifier
gen employed=1 if a_wkstat>=2 & a_wkstat<=5
replace employed=0 if a_wkstat<=1
replace employed=0 if a_wkstat>=6

// Calculate weekly wage
gen weeklywage=wsal_val/wkswork if employed==1
replace weeklywage=. if weeklywage<=0

// Calculate hours worked
gen totalhours = wkswork * hrswk

// Merge in policy parameters
gen mergeid = 1
merge m:1 mergeid using parameters
drop _merge

// Merge in results of FMLA analysis
merge m:1 mergeid using "intermediate_files/fmla_results.dta"
drop mergeid _merge

// Calculate expected total leave taken
replace ownhealth_expdur = ownhealth_expdur * include_ownhealth
replace childhealth_expdur = childhealth_expdur * include_childhealth
replace spousehealth_expdur = spousehealth_expdur * include_spousehealth
replace parenthealth_expdur = parenthealth_expdur * include_parenthealth
replace otherrelhealth_expdur = otherrelhealth_expdur * include_otherrelhealth
replace military_expdur = military_expdur * include_military
replace otherreason_expdur = otherreason_expdur * include_otherreason
replace newchild_expdur = newchild_expdur * include_newchild

gen leave_expdur = ownhealth_expdur + childhealth_expdur + spousehealth_expdur + parenthealth_expdur + otherrelhealth_expdur + military_expdur + otherreason_expdur + newchild_expdur

// Exclude those who do not meet the required hours worked
replace leave_expdur = 0 if totalhours < work_requirement

// Calculate benefit
gen leave_expweeks = leave_expdur / 5
gen weeklybenefit = min(replacementrate * weeklywage, maxbenefit) if !missing(weeklywage)

/* Produce final estimates */
// Total expected benefit per person
gen leave_total = leave_expweeks * weeklybenefit
// Extrapolate to entire employed population for total cost
egen benefit_total = total(leave_total * marsupwt) if !missing(weeklywage)
egen employed_total = total(marsupwt) if employed==1
egen used_total = total(marsupwt) if !missing(weeklywage)
gen totalcost = benefit_total / used_total * employed_total
**gen totalcost = leave_total * 151436000
// Cost as a percent of payroll
egen wage_total = total(wsal_val * marsupwt) if !missing(leave_total)
gen payrollcost = benefit_total / wage_total
gen expectedbenefit = leave_total if !missing(weeklywage)

collapse expectedbenefit totalcost payrollcost [aweight=marsupwt]
sum expectedbenefit totalcost payrollcost
