# Set-up Instructions
This file explains how to download and set up the necessary datasets to run PFLCM.

## FMLA Public Use File
 - Download the Public Use File for Employees from the Department of Labor: https://www.dol.gov/whd/fmla/survey/
 - Extract the .dta version of the dataset and save it in this repository as `fmla.dta`.

## CPS Public Use File
 - Download and extract the March 2017 CPS ASEC dataset here: http://www.nber.org/cps/cpsmar2017.zip
 - Save as a .dct file the March 2017 CPS data dictionary here: http://www.nber.org/data/progs/cps/cpsmar2017.dct
 - Read the CPS data into Stata using the following command:
     `infile using "cpsmar2017.dct", using("asec2017_pubuse.dat")`
 - Once it has been converted, save the CPS dataset in this repository as `cpsmar2017.dta`.
