# Program Use Assumptions

## Headline take-up rate
`overall_takeup`
 - Definition: Probability of taking leave
 - Recommended value: 0.159
   - Source: Fraction of employees who took leave the last 12 months, among FMLA eligible and covered employees, from [Klerman, Daley and Pozniak, (2012)](https://www.dol.gov/asp/evaluation/fmla/FMLA-2012-Technical-Report.pdf).
 - Limitations:
   - Minimum: 0 (strict requirement)
   - Maximum: 1 (recommendation)
 - Note: A value greater than 1 should be interpreted as every eligible person taking paid leave at least once per year.

## Reduced take-up assumptions
These parameters reduce the take-up rates for different types of leave. The parametes apply to each type of leave:
 - `reduce_ownhealth`: own medical leave
 - `reduce_childhealth`: leave to care for an ill child
 - `reduce_spousehealth`: leave to care for an ill spouse
 - `reduce_parenthealth`: leave to care for an ill parent
 - `reduce_otherrelhealth`: leave to care for an ill relative, excluding child, spouse or parent
 - `reduce_military`: leave to address issues from the deployment of a military member
 - `reduce_newchild`: leave for the birth of a new child
 - `reduce_otherreason`: leave for other reasons

Recommended values: 
 - Full take-up: Every person who take leave and is eligible for the paid leave program uses it.
   - Values:
     - `reduce_ownhealth = 1`
     - `reduce_childhealth = 1`
     - `reduce_spousehealth = 1`
     - `reduce_parenthealth = 1`
     - `reduce_otherelhealth = 1`
     - `reduce_military = 1`
     - `reduce_otherreason = 1`
     - `reduce_newchild = 1`
 - Reduced take-up: Not all individuals who take leave and are eligible for the paid leave program use it, based on observed lower take-up rates in the state programs.
     - `reduce_ownhealth = 0.5`
     - `reduce_childhealth = 0.2`
     - `reduce_spousehealth = 0.2`
     - `reduce_parenthealth = 0.1`
     - `reduce_otherelhealth = 0.1`
     - `reduce_military = 0.9`
     - `reduce_otherreason = 0`
     - `reduce_newchild = 0.9`
For a description of these and a comparison, see Gitis, Glynn and Hayes (2018) (forthcoming).

Limitations: 
 - Minimum: 0 (strict requirement)
 - Maximum: 1 (recommendation)
Note: A value greater than 1 should be interpreted as fraudulent use of the program.

## Employer push assumptions
This parameter how employers respond to the creation of a paid leave program. 
 - Employer who do not pay their employees while on leave do not respond.
 - Some employers who provide paid leave would push their employees onto the government program immediately. If the employer offers a more generous benefit, the employer may top up the benefit.
 - Some employers who provide paid leave would continue to provide it for a short period before pushing employees onto the government program. We assume that this would occur after 4 weeks.

`frac_employerpush`
 - Defition: The proportion of employees who already receive pay while on leave that are immediately pushed onto the government program.
 - Note: The proportion that continues to receive pay from their employer but not the government program for the first 4 weeks is `1 - frac_employerpush`. 
 - Recommended values:
   - Full employer push: `frac_employerpush = 1`
   - Reduced employer push: `frac_employerpush = 0.4`
   - For a description of these and a comparison, see Gitis, Glynn and Hayes (2018) (forthcoming)
 - Limitations:
   - Minimum: 0 (strict requirement)
   - Maximum: 1 (strict requirement)
