****************************
***     Check inputs     ***
****************************
// Check parameter inputs for unallowable values
use parameters, clear
assert maxduration_days >= 0
assert include_ownhealth==0 | include_ownhealth==1
assert include_childhealth==0 | include_childhealth==1
assert include_spousehealth==0 | include_spousehealth==1
assert include_parenthealth==0 | include_parenthealth==1
assert include_otherrelhealth==0 | include_otherrelhealth==1
assert include_military==0 | include_military==1
assert include_otherreason==0 | include_otherreason==1
assert include_newchild==0 | include_newchild==1
// Check parameter inputs for problematic values
if maxduration_days > 121 {
  noisily di as err "Warning: High value for maxduration_days"
}
if waiting_period > 20 {
  noisily di as err "Warning: High value for waiting_period"
}
if replacementrate < 0 {
  noisily di as err "Warning: Negative value for replacementrate"
}
if maxbenefit < 0 {
  noisily di as err "Warning: Negative value for maxbenefit"
}
if work_requirement < 0 {
  noisily di as err "Warning: Negative value for work requirement"
}
// Check assumption inputs for unallowable values
merge 1:1 mergeid using assumptions, nogen
assert overall_takeup >= 0
assert reduce_ownhealth >= 0
assert reduce_childhealth >= 0
assert reduce_spousehealth >= 0
assert reduce_parenthealth >= 0
assert reduce_otherrelhealth >= 0
assert reduce_military >= 0
assert reduce_otherreason >= 0
assert reduce_newchild >= 0
assert frac_fullpush >= 0
assert frac_partialpush >= 0
assert round(frac_fullpush + frac_partialpush, 0.0001) <= 1.0
assert delay_partialpush >= 0
// Check assumption inputs for problematic values
if overall_takeup > 1 {
  noisily di as err "Warning: High value for take-up rate"
}
save "intermediate_files/param_assum.dta", replace


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

// Merge in policy parameters and assumptions
gen mergeid = 1
merge m:1 mergeid using "intermediate_files/param_assum.dta", nogen
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
gen durationhigh2 = durationhigh
replace durationhigh2 = 0 if durationhigh2<waiting_period & !missing(durationhigh2)
replace durationhigh2 = durationhigh2 - waiting_period if durationhigh2>=waiting_period & !missing(durationhigh2)
replace durationhigh2 = maxduration_days if durationhigh2>maxduration_days & !missing(durationhigh2)

gen durationhigh3 = durationhigh
replace durationhigh3 = maxduration_days + delay_partialpush if durationhigh3>maxduration_days+delay_partialpus & !missing(durationhigh3)


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

gen leaveid = ownhealth1 + 2*childhealth1 + 3*spousehealth1 + 4*parenthealth1 + 5*otherrelhealth1 + 6*military1 + 7*otherreason1 + 8*newchild1

/* Workers paid by employer */

gen paid=1 if A45==1
replace paid=0 if A45==2


/*Workers who take at or below 4 weeks of leave*/
gen leavebelowdelay=1 if durationhigh<=delay_partialpush
replace leavebelowdelay=0 if durationhigh>delay_partialpush & durationhigh<=242

save "intermediate_files/fmla2.dta", replace


*************************
*** Save FMLA results ***
*************************

/* Save take-up shares */
// Condition: eligible and took leave

use "intermediate_files/fmla2.dta", clear
collapse ownhealth1 childhealth1 spousehealth1 parenthealth1 otherrelhealth1 military1 otherreason1 newchild1 if FMLAleavetaker==1 & FMLAelig==1 [aweight=weight], fast
xpose, clear varname
gen leaveid = .
replace leaveid = 1 if _varname=="ownhealth1"
replace leaveid = 2 if _varname=="childhealth1"
replace leaveid = 3 if _varname=="spousehealth1"
replace leaveid = 4 if _varname=="parenthealth1"
replace leaveid = 5 if _varname=="otherrelhealth1"
replace leaveid = 6 if _varname=="military1"
replace leaveid = 7 if _varname=="otherreason1"
replace leaveid = 8 if _varname=="newchild1"
drop _varname
rename v1 takeupshare
order leaveid takeupshare
save "intermediate_files/takeupshares.dta", replace

/* Save fraction paid */
// Condition: eligible & took given type of leave
use "intermediate_files/fmla2.dta", clear
collapse paid if FMLAelig==1 [aweight=weight], by(leaveid) fast
drop if leaveid==0
save "intermediate_files/fracpaid.dta", replace

/* Save fraction under 4 weeks and duration for those paid */
// Condition: eligible & took given type of leave & paid by employer
use "intermediate_files/fmla2.dta", clear
collapse leavebelowdelay durationhigh2 if FMLAelig==1 & paid==1 [aweight=weight], by(leaveid) fast
rename leavebelowdelay fracunderdelay
rename durationhigh2 dayspaid
drop if leaveid==0
save "intermediate_files/fracunderdelay_paid.dta", replace

/* Save duration for those unpaid */
// Condition: eligible & took given type of leave & unpaid
use "intermediate_files/fmla2.dta", clear
collapse durationhigh2 if FMLAelig==1 & paid==0 [aweight=weight], by(leaveid) fast
rename durationhigh daysunpaid
drop if leaveid==0
save "intermediate_files/daysunpaid.dta", replace


/* Save duration for those taking over 4 weeks */
// Condition: eligible & took given type of leave & paid by employer & took over 4 weeks
use "intermediate_files/fmla2.dta", clear
collapse durationhigh3 if FMLAelig==1 & paid==1 & leavebelowdelay==0 [aweight=weight], by(leaveid) fast
rename durationhigh3 daysover
drop if leaveid==0
save "intermediate_files/daysover.dta", replace


/* Merge FMLA results together */
use "intermediate_files/takeupshares.dta", clear
merge 1:1 leaveid using "intermediate_files/fracpaid.dta", nogen
merge 1:1 leaveid using "intermediate_files/fracunderdelay_paid.dta", nogen
merge 1:1 leaveid using "intermediate_files/daysunpaid.dta", nogen
merge 1:1 leaveid using "intermediate_files/daysover.dta", nogen
// Replace missing duration with zero
replace daysunpaid = 0 if daysunpaid==.
replace dayspaid = 0 if dayspaid==.
replace daysover = 0 if daysover==.

/* Merge in assumptions */
gen mergeid = 1
merge m:1 mergeid using "intermediate_files/param_assum", nogen
// Clean up assumptions structure
gen reduce = .
replace reduce = reduce_ownhealth if leaveid==1
replace reduce = reduce_childhealth if leaveid==2
replace reduce = reduce_spousehealth if leaveid==3
replace reduce = reduce_parenthealth if leaveid==4
replace reduce = reduce_otherrelhealth if leaveid==5
replace reduce = reduce_military if leaveid==6
replace reduce = reduce_otherreason if leaveid==7
replace reduce = reduce_newchild if leaveid==8
drop reduce_*

/* Calculate expected expected duration total*/
// Overall take-up rates
gen takeuprate = takeupshare * overall_takeup * reduce

// Expected duration for those not paid by employers
gen expdur_unpaid = takeuprate * (1 - paid) * daysunpaid

// Expected duration for those pushed onto the program
gen expdur_paid = takeuprate * paid * frac_fullpush * dayspaid

// Expected duration for those on the program after 4 weeks
if waiting_period <= delay_partialpush {
  gen daysover2 = daysover - delay_partialpush
}
else {
  gen daysover2 = daysover - waiting_period
}
gen expdur_over = takeuprate * paid * frac_partialpush * (1 - fracunderdelay) * daysover2

// Expected duration
gen expdur = expdur_unpaid + expdur_paid + expdur_over

/* Total up for included leave types */
gen includes = .
replace includes = include_ownhealth if leaveid==1
replace includes = include_childhealth if leaveid==2
replace includes = include_spousehealth if leaveid==3
replace includes = include_parenthealth if leaveid==4
replace includes = include_otherrelhealth if leaveid==5
replace includes = include_military if leaveid==6
replace includes = include_otherreason if leaveid==7
replace includes = include_newchild if leaveid==8
gen expdur2 = expdur * includes
collapse (mean) mergeid (sum) expdur2, fast
rename expdur2 leave_expdur
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
