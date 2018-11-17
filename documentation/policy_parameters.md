# Policy parameters

## Leave duration parameters
`maxduration_days`
 - Definition: Maximum duration of days receiving paid leave benefits, annual basis
 - Limitations:
   - Minimum: parameter value should be nonnegative (strict requirement)
   - Maximum: parameter value should not exceed 121 days (recommendation)

`waiting_period`
 - Definition: Days between leave needed when leave is eligible for paid leave benefits
 - Limitations:
   - Minimum: parameter value should be nonnegative (recommendation)
   - Maximum: parameter value should not exceed 20 days (recommendation)
 - Note: A negative value should be interpreted as allowing leave before the life event occurs.

## Payment parameters
`replacementrate`
 - Definition: Proportion of usual wages paid during leave, weekly basis while on program
 - Limitations:
   - Minimum: parameter value should be nonnegative (recommendation)
 - Note: A negative value should be interpreted as a surtax on lost income. 

`maxbenefit`
 - Definition: Maximum weekly benefit amount
 - Limitations:
   - Mimumum: parameter value should be nonnegative (recommendation)
 - Note: A negative value should be interpreted as a minimum surtax on lost income.

## Eligibility requirements
`work_requirement`
 - Definition: Minimum total hours worked (annual basis) to be eligible for paid leave benefits
 - Limitations:
   - Minimum: parameter value should not be negative (recommendation)

## Types of leave included
`include_ownhealth`
 - Definition: Whether paid leave program includes own medical leave (1 for yes, 0 for no)
 - Limitations: possible values of 0 or 1 (strict requirement)

`include_childhealth`
 - Definition: Whether paid leave program includes leave to care for one's ill child (1 for yes, 0 for no)
 - Limitations: possible values of 0 or 1 (strict requirement)

`include_spousehealth`
 - Definition: Whether paid leave program includes leave to care for one's ill spouse (1 for yes, 0 for no)
 - Limitations: possible values of 0 or 1 (strict requirement)

`include_parenthealth`
 - Definition: Whether paid leave program includes leave to care for one's ill parent (1 for yes, 0 for no)
 - Limitations: possible values of 0 or 1 (strict requirement)

`include_otherrelhealth`
 - Definition: Whether paid leave program includes leave to care for a relative besides child, spouse or parent (1 for yes, 0 for no)
 - Limitations: possible values of 0 or 1 (strict requirement)

`include_military`
 - Definition: Whether paid leave program includes leave to address issues from deployment of a military member (1 for yes, 0 for no)
 - Limitations: possible values of 0 or 1 (strict requirement)

`include_otherreason`
 - Definition: Whether paid leave program includes leave for other reasons (1 for yes, 0 for no)
 - Limitations: possible values of 0 or 1 (strict requirement)

`include_newchild`
 - Definition: Whether paid leave program includes parental leave (1 for yes, 0 for no)
 - Limitations: possible values of 0 or 1 (strict requirement)