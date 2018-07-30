# PFLCM
### This model was first developed by Ben Gitis of the American Action Forum.

## About PFLCM
PFLCM (short for Paid Family Leave Cost Model) is a model to evaluate the total cost of paid family and medical leave policy proposals. PFLCM uses the 2012 FMLA public use file to estimate take-up, leave duration and other information, which is then applied to the 2017 Current Population Survey to estimate the total cost of the policy.

## Disclaimer
This model is currently under development. The model components and the results may change as the model improves.

## Set-up Instructions
FMLA Public Use File
 - Download the Public Use File for Employees from the Department of Labor: https://www.dol.gov/whd/fmla/survey/
 - Extract the .dta version of the dataset and save it in this repository as `fmla.dta`.

CPS Public Use File
 - Download and extract the March 2017 CPS ASEC dataset here: http://www.nber.org/cps/cpsmar2017.zip
 - Save as a .dct file the March 2017 CPS data dictionary here: http://www.nber.org/data/progs/cps/cpsmar2017.dct
 - Read the CPS data into Stata using the following command:
   - `infile using "cpsmar2017.dct", using("asec2017_pubuse.dat")`
 - Once it has been converted, save the CPS dataset in this repository as `cpsmar2017.dta`.

## Citing PFLCM
PFLCM (Version 0.0.0)[Source code], https://github.com/open-source-economics/PFLCM.