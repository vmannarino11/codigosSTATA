clear all 

global main "C:/Users/Usuario/OneDrive - Económicas - UBA/Valentin/Códigos/STATA/tax_multiplier"
global input "$main/input"
global output "$main/output"

import excel "$input/data.xlsx", sheet("IMP") firstrow clear

tsset tiempo

gen ddgsinint_lag1 = L1.ddgsinint
gen ddgsinint_lag2 = L2.ddgsinint
gen ddgsinint_lag3 = L3.ddgsinint

gen ddpbi_lag1 = L1.ddpbi
gen ddpbi_lag2 = L2.ddpbi
gen ddpbi_lag3 = L3.ddpbi

* Simple regression: public spending
eststo clear
eststo: reg ddpbi ddgsinint
esttab , se r2 starlevels(* 0.10 ** 0.05 *** 0.01) 
esttab using "$output/tabla1.tex", replace label 

* Regression with controls
eststo: reg ddpbi ddgsinint cris diacp dcpriv ddedtot ddgsinint_lag1 ddgsinint_lag2 ddgsinint_lag3
esttab , se r2 starlevels(* 0.10 ** 0.05 *** 0.01) 
esttab using "$output/tabla1.tex", append label 

* Simple regression: deficit
eststo: reg ddpbi drprim
esttab , se r2 starlevels(* 0.10 ** 0.05 *** 0.01) 
esttab using "$output/tabla1.tex", append label 

* Regression with controls: deficit
eststo: reg ddpbi drprim cris diacp dcpriv ddedtot
esttab , se r2 starlevels(* 0.10 ** 0.05 *** 0.01) 
esttab using "$output/tabla1.tex", append label 

* Simple regression: inflation tax
gen deficit_neto = dsen + drprim
eststo: reg ddpbi deficit_neto 
esttab , se r2 starlevels(* 0.10 ** 0.05 *** 0.01) 
esttab using "$output/tabla1.tex", append label 

* Regression with controls: inflation tax
eststo: reg ddpbi deficit_neto cris diacp dcpriv ddedtot
esttab , se r2 starlevels(* 0.10 ** 0.05 *** 0.01) 
esttab using "$output/tabla1.tex", append label 
