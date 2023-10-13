/*******************************************************************************
                              Problem Set 2 

                          Universidad de San Andrés
                              Economía Aplicada
							       2023							           
*******************************************************************************/
 /*
Trabajo Práctico 2
Profesor: Martin Rossi
Tutores: Gastón García Zavaleta y Tomas Pachecho
Alumnos: Francisco Apezteguia, Mateo Fernandez, Valentin Mannarino y Juan Sebastián Navajas Jauregui

*/

* Source: https://www.aeaweb.org/articles?id=10.1257/app.20200204

*******************************************************************************/
* 0) Set up environment
*==============================================================================*
clear all
set more off
gl main "C:/Users/Usuario/OneDrive - Económicas - UBA/Valentin/Códigos/STATA/Attanasio et al"
gl input "$main/input"
gl output "$main/output"

* Open data set
use "$input/measures.dta", clear 

* Global with control variables
global covs_eva	"male i.eva_fu" 
global covs_ent	"male i.ent_fu"

* Adding labels
label var b_tot_cog1_st "Bayley: Cognitive"        
label var b_tot_lr1_st "Bayley: Receptive language"
label var b_tot_le1_st "Bayley: Expressive language"
label var b_tot_mf1_st "Bayley: Fine motor"
label var mac_words1_st "MacArthur: Words the chlid can say" 
label var mac_phrases1_st "MacArthur: Complex phrases the child can say"
label var bates_difficult1_st  "ICQ: Difficult (-)"        
label var bates_unsociable1_st  "ICQ: Unsociable (-) "
label var bates_unstoppable1_st  "ICQ: Unstoppable (-)"
label var roth_inhibit1_st  "ECBQ: Inhibitory control"
label var roth_attention1_st  "ECBQ: Attentional focusing"
label var fci_play_mat_type1_st  "FCI: Number of types of play materials"        
label var Npaintbooks1_st  "FCI: Number of coloring and drawing books"
label var Nthingsmove1_st  "FCI: Number of toys to learn movement"
label var Ntoysshape1_st  "FCI: Number of toys to learn shapes"
label var Ntoysbought1_st  "FCI: Number of shop-bought toys" 
label var fci_play_act1_st  "FCI: Number of types of play activities in last 3 days"   
label var home_stories1_st  "FCI: Number of times told a story to child in last 3 days"
label var home_read1_st  "FCI: Number of times read to child in last 3 days"
label var home_toys1_st  "FCI: Number of times played with toys in last 3 days"
label var home_name1_st  "FCI: Number of times named things to child in last 3 days" 

* 1) Regressions
*==============================================================================*
* We start by replicating the tables
* PANEL A (Child's cognitive skills at follow-up)

eststo clear
local bayley "b_tot_cog b_tot_lr b_tot_le b_tot_mf"
foreach y of local bayley{
cap drop V*
eststo: reg `y'1_st treat `y'0_st $covs_eva , cluster(cod_dane)		

} 

local macarthur "mac_words mac_phrases"
foreach y of local macarthur{
	cap drop V*
	eststo: reg `y'1_st treat mac_words0_st $covs_ent , cluster(cod_dane)
} 

esttab using "$output/TableA.txt", se replace label noobs ///
	keep(treat) ///
	cells(b(fmt(2) star) se(par fmt(2))) ///
	stats(N r2, fmt(0 2) labels("Number of Observations" "R-Squared")) 
	
* PANEL B (Child's socio-emotional skills at follow up) 

eststo clear
local bates "bates_difficult bates_unsociable bates_unstoppable" 
foreach y of local bates{
	cap drop V*
	eststo: reg `y'1_st treat `y'0_st $covs_ent, cl(cod_dane)
	
} 	

local roth "roth_inhibit roth_attention" 
foreach y of local roth{
	cap drop V*
	eststo: reg `y'1_st treat bates_difficult0_st $covs_ent , cluster(cod_dane)
	
} 
esttab using "$output/TableB.txt", se replace label noobs ///
	keep(treat) ///
	cells(b(fmt(2) star) se(par fmt(2))) ///
	stats(N r2, fmt(0 2) labels("Number of Observations" "R-Squared")) 
	
* PANEL C (Material investments)  

eststo clear 
local fcimat "fci_play_mat_type Npaintbooks Nthingsmove Ntoysshape Ntoysbought"
foreach y of local fcimat{
	cap drop V*
	eststo: reg `y'1_st treat fci_play_mat_type0_st $covs_ent , cluster(cod_dane)
	
} 
esttab using "$output/TableC.txt", se replace label noobs ///
	keep(treat) ///
	cells(b(fmt(2) star) se(par fmt(2))) ///
	stats(N r2, fmt(0 2) labels("Number of Observations" "R-Squared")) 
	
* PANEL D (Time investments)  

eststo clear 
local fcitime "fci_play_act home_stories home_read home_toys home_name"
foreach y of local fcitime{
	cap drop V*
	eststo: reg `y'1_st treat fci_play_act0_st $covs_ent , cluster(cod_dane)
	
} 
esttab using "$output/TableD.txt", se replace label noobs ///
	keep(treat) ///
	cells(b(fmt(2) star) se(par fmt(2))) ///
	stats(N r2, fmt(0 2) labels("Number of Observations" "R-Squared")) 

* In each panel, we work with corrections. They have a different number of hypotheses.
******************************************************************************* 
* PANEL A (Child's cognitive skills at follow up) 
******************************************************************************* 
* In this case, we have 6 hypotheses simultaneously.
scalar hyp = 6

* Define the significance level.
scalar signif = 0.05
scalar i = 1

* Create a matrix with 6 rows and 1 column (6 for the hypotheses).
mat p_values = J(6,1,.) 
eststo clear
local bayley "b_tot_cog b_tot_lr b_tot_le b_tot_mf"
foreach y of local bayley{
local append append 
if "`y'"=="b_tot_cog" local append replace 
	cap drop V*
	reg `y'1_st treat `y'0_st $covs_eva , cluster(cod_dane)
	eststo: test treat = 0
	estadd scalar p_value = r(p)
	estadd scalar Bon_p_value = min(1,r(p)*hyp)
	mat p_values[i,1]=r(p)
scalar i = i + 1
} 

local macarthur "mac_words mac_phrases"
foreach y of local macarthur{
	cap drop V*
	eststo: reg `y'1_st treat mac_words0_st $covs_ent , cluster(cod_dane)
	eststo: test treat = 0
	estadd scalar p_value = r(p)
	estadd scalar Bon_p_value = min(1,r(p)*hyp)
	mat p_values[i,1]=r(p)
scalar i = i + 1

	}
	
* Export the table with the p-value and the Bonferroni p-value.
esttab using "$output/Table 2A.txt", se replace label noobs ///
keep(treat, relax) ///
cells(b(fmt(2) star) se(par fmt(2))) ///
stats(p_value Bon_p_value blank N r2, fmt(2 2 0 2) labels("P-value" "Boferroni p-value" " " "Number of Observations" "R-Squared")) 
	
* Everything between preserve and restore does not affect the database. To work with the matrix.
preserve

* Clear and open the matrix as if it were a database.
clear 
svmat p_values

* Create a variable to know which each one belongs to.
gen var = _n

* Sort the p-values.
sort p_values1

* Generate the corrected alpha.
gen alpha_corr = signif/(hyp+1-_n)
gen significant = (p_values1<alpha_corr)

* Stop at the first one we find.
replace significant = 0 if significant[_n-1]==0
sort var

* Rename and save to perform Benjamini, Krieger, and Yekutieli.
rename p_values1 pval
rename var  outcome
save "$output/pvals_panel_A.dta", replace
restore

******************************************************************************* 
* PANEL B (Child's socio-emotional skills at follow up) 
******************************************************************************* 
* In this case, we have 5 hypotheses simultaneously.
scalar hyp = 5

* Define the significance level.
scalar signif = 0.05
scalar i = 1

* Create a matrix with 5 rows and 1 column (5 for the hypotheses).
mat p_values = J(5,1,.) 
eststo clear
local bates "bates_difficult bates_unsociable bates_unstoppable" 
foreach y of local bates{
	cap drop V*
	 eststo: reg `y'1_st treat `y'0_st $covs_ent, cl(cod_dane)
	 eststo: test treat = 0
	 estadd scalar p_value = r(p)
	estadd scalar Bon_p_value = min(1,r(p)*hyp)
	mat p_values[i,1]=r(p)
scalar i = i + 1
} 

local roth "roth_inhibit roth_attention" 
foreach y of local roth{
	cap drop V*
	eststo: reg `y'1_st treat bates_difficult0_st $covs_ent , cluster(cod_dane)
	eststo: test treat = 0
	estadd scalar p_value = r(p)
	estadd scalar Bon_p_value = min(1,r(p)*hyp)
	mat p_values[i,1]=r(p)
scalar i = i + 1
} 
esttab using "$output/Table 2B.txt", se replace label noobs ///
keep(treat, relax) ///
cells(b(fmt(2) star) se(par fmt(2))) ///
stats(p_value Bon_p_value blank N r2, fmt(2 2 0 2) labels("P-value" "Boferroni p-value" " " "Number of Observations" "R-Squared")) 
	
* Everything between preserve and restore does not affect the database. To work with the matrix.
preserve

* Clear and open the matrix as if it were a database.
clear 
svmat p_values

* Create a variable to know which each one belongs to.
gen var = _n

* Sort the p-values.
sort p_values1

* Generate the corrected alpha.
gen alpha_corr = signif/(hyp+1-_n)
gen significant = (p_values1<alpha_corr)

* Stop at the first one we find.
replace significant = 0 if significant[_n-1]==0
sort var

* Rename and save to perform Benjamini, Krieger, and Yekutieli.
rename p_values1 pval
rename var  outcome
save "$output/pvals_panel_B.dta", replace
restore

******************************************************************************* 
* PANEL C (Material investments)  
******************************************************************************* 
* In this case, we have 5 hypotheses simultaneously.
scalar hyp = 5

* Define the significance level.
scalar signif = 0.05
scalar i = 1

* Create a matrix with 5 rows and 1 column (5 for the hypotheses)
mat p_values = J(5,1,.) 
eststo clear
local fcimat "fci_play_mat_type Npaintbooks Nthingsmove Ntoysshape Ntoysbought"
foreach y of local fcimat{
	cap drop V*
    eststo: reg `y'1_st treat fci_play_mat_type0_st $covs_ent , cluster(cod_dane)
	eststo: test treat = 0
	estadd scalar p_value = r(p)
	estadd scalar Bon_p_value = min(1,r(p)*hyp)
	mat p_values[i,1]=r(p)
scalar i = i + 1
} 

esttab using "$output/Table 2C.txt", se replace label noobs ///
keep(treat, relax) ///
cells(b(fmt(2) star) se(par fmt(2))) ///
stats(p_value Bon_p_value blank N r2, fmt(2 2 0 2) labels("P-value" "Boferroni p-value" " " "Number of Observations" "R-Squared")) 
	
* Everything between preserve and restore does not affect the database. To work with the matrix.
preserve

* Clear and open the matrix as if it were a database.
clear 
svmat p_values

* Create a variable to know which each one belongs to.
gen var = _n

* Sort the p-values.
sort p_values1

* Generate the corrected alpha.
gen alpha_corr = signif/(hyp+1-_n)
gen significant = (p_values1<alpha_corr)

* Stop at the first one we find.
replace significant = 0 if significant[_n-1]==0
sort var

* Rename and save to perform Benjamini, Krieger, and Yekutieli.
rename p_values1 pval
rename var  outcome
save "$output/pvals_panel_C.dta", replace
restore

******************************************************************************* 
* PANEL D (Time investments)  
******************************************************************************* 
* In this case, we have 5 hypotheses simultaneously.
scalar hyp = 5

* Define the significance level. 
scalar signif = 0.05
scalar i = 1

* Create a matrix with 5 rows and 1 column (5 for the hypotheses).
mat p_values = J(5,1,.) 
eststo clear
local fcitime "fci_play_act home_stories home_read home_toys home_name"
foreach y of local fcitime{
	cap drop V*
	eststo: reg `y'1_st treat fci_play_act0_st $covs_ent , cluster(cod_dane)
	eststo: test treat = 0
	estadd scalar p_value = r(p)
	estadd scalar Bon_p_value = min(1,r(p)*hyp)
	mat p_values[i,1]=r(p)
scalar i = i + 1
} 

esttab using "$output/Table 2D.txt", se replace label noobs ///
keep(treat, relax) ///
cells(b(fmt(2) star) se(par fmt(2))) ///
stats(p_value Bon_p_value blank N r2, fmt(2 2 0 2) labels("P-value" "Boferroni p-value" " " "Number of Observations" "R-Squared")) 
	
* Everything between preserve and restore does not affect the database. To work with the matrix.
preserve

* Clear and open the matrix as if it were a database.
clear 
svmat p_values

* Create a variable to know which each one belongs to.
gen var = _n

* Sort the p-values.
sort p_values1

* Generate the corrected alpha.
gen alpha_corr = signif/(hyp+1-_n)
gen significant = (p_values1<alpha_corr)

* Stop at the first one we find.
replace significant = 0 if significant[_n-1]==0
sort var

* Rename and save to perform Benjamini, Krieger, and Yekutieli.
rename p_values1 pval
rename var  outcome
save "$output/pvals_panel_D.dta", replace
restore

* Use the code of Anderson´s 
local fcitime " A  B C D"
foreach y of local fcitime{
	di "$output/pvals_panel_`y'.dta"

*Ahora utilizamos el código de Michael Anderson's
preserve

use "$output/pvals_panel_`y'.dta", clear
version 10
set more off

* Collect the total number of p-values tested
quietly sum pval
local totalpvals = r(N)

* Sort the p-values in ascending order and generate a variable that codes each p-value's rank
quietly gen int original_sorting_order = _n
quietly sort pval
quietly gen int rank = _n if pval~=.

* Set the initial counter to 1 
local qval = 1

* Generate the variable that will contain the BKY (2006) sharpened q-values
gen bky06_qval = 1 if pval~=.

* Set up a loop that begins by checking which hypotheses are rejected at q = 1.000, then checks which hypotheses are rejected at q = 0.999, then checks which hypotheses are rejected at q = 0.998, etc.  The loop ends by checking which hypotheses are rejected at q = 0.001.

while `qval' > 0 {
	* First Stage
	* Generate the adjusted first stage q level we are testing: q' = q/1+q
	local qval_adj = `qval'/(1+`qval')
	* Generate value q'*r/M
	gen fdr_temp1 = `qval_adj'*rank/`totalpvals'
	* Generate binary variable checking condition p(r) <= q'*r/M
	gen reject_temp1 = (fdr_temp1>=pval) if pval~=.
	* Generate variable containing p-value ranks for all p-values that meet above condition
	gen reject_rank1 = reject_temp1*rank
	* Record the rank of the largest p-value that meets above condition
	egen total_rejected1 = max(reject_rank1)

	* Second Stage
	* Generate the second stage q level that accounts for hypotheses rejected in first stage: q_2st = q'*(M/m0)
	local qval_2st = `qval_adj'*(`totalpvals'/(`totalpvals'-total_rejected1[1]))
	* Generate value q_2st*r/M
	gen fdr_temp2 = `qval_2st'*rank/`totalpvals'
	* Generate binary variable checking condition p(r) <= q_2st*r/M
	gen reject_temp2 = (fdr_temp2>=pval) if pval~=.
	* Generate variable containing p-value ranks for all p-values that meet above condition
	gen reject_rank2 = reject_temp2*rank
	* Record the rank of the largest p-value that meets above condition
	egen total_rejected2 = max(reject_rank2)

	* A p-value has been rejected at level q if its rank is less than or equal to the rank of the max p-value that meets the above condition
	replace bky06_qval = `qval' if rank <= total_rejected2 & rank~=.
	* Reduce q by 0.001 and repeat loop
	drop fdr_temp* reject_temp* reject_rank* total_rejected*
	local qval = `qval' - .001
}
	

quietly sort original_sorting_order
pause off
set more on

display "Code has completed."
display "Benjamini Krieger Yekutieli (2006) sharpened q-vals are in variable 'bky06_qval'"
display	"Sorting order is the same as the original vector of p-values"

keep outcome pval bky06_qval
save "$output/sharpenedqvals_`y'.dta", nolabel replace

restore
}

********************************************************************************
* PANEL A 
* Generate matrices with corrected p-values
mat  corr_h = [0.008, 0.01, 0.05, 0.0167, 0.013, 0.025]
mat  corr_bky = [0.001, 0.018, 0.508, 0.29, 0.29, 0.338  ]
* Rerun regressions to add them
scalar i = 1
eststo clear
local bayley "b_tot_cog b_tot_lr b_tot_le b_tot_mf"
foreach y of local bayley{
local append append 
if "`y'"=="b_tot_cog" local append replace 
	cap drop V*
	reg `y'1_st treat `y'0_st $covs_eva , cluster(cod_dane)
	eststo: test treat = 0
	estadd scalar p_value = r(p)
	estadd scalar Bon_p_value = min(1,r(p)*hyp)
	estadd scalar corr_h = corr_h[1,i]
	estadd scalar corr_bky = corr_bky[1,i]
scalar i = i + 1
} 

local macarthur "mac_words mac_phrases"
foreach y of local macarthur{
	cap drop V*
	eststo: reg `y'1_st treat mac_words0_st $covs_ent , cluster(cod_dane)
	estadd scalar p_value = r(p)
	estadd scalar Bon_p_value = min(1,r(p)*hyp)
	estadd scalar corr_h = corr_h[1,i]
	estadd scalar corr_bky = corr_bky[1,i]
scalar i = i + 1

	}
* Export the table with p-value and Bonferroni p-value
esttab using "$output/TableCorr2A.txt", se replace label noobs ///
keep(treat, relax) ///
cells(b(fmt(2) star) se(par fmt(2))) ///
stats(p_value Bon_p_value corr_h  corr_bky blank N r2, fmt(2 2 0 2) labels("P-value" "Boferroni p-value" "Holm Alpha" "BKY p-value" " " "Number of Observations" "R-Squared")) 

* PANEL B 
* Generate matrices with corrected p-values
mat  corr_h = [0.01, 0.0167, 0.025, 0.05, 0.0125] 
mat  corr_bky = [0.517, 0.744, 0.744, 1, 0.517  ]

* Rerun regressions to add them
scalar i = 1
eststo clear
local bates "bates_difficult bates_unsociable bates_unstoppable" 
foreach y of local bates{
	cap drop V*
	reg `y'1_st treat `y'0_st $covs_ent, cl(cod_dane)
	eststo: test treat = 0
	estadd scalar p_value = r(p)
	estadd scalar Bon_p_value = min(1,r(p)*hyp)
	estadd scalar corr_h = corr_h[1,i]
	estadd scalar corr_bky = corr_bky[1,i]
scalar i = i + 1
} 

local roth "roth_inhibit roth_attention" 
foreach y of local roth{
	cap drop V*
    reg `y'1_st treat bates_difficult0_st $covs_ent , cluster(cod_dane)
	eststo: test treat = 0
	estadd scalar p_value = r(p)
	estadd scalar Bon_p_value = min(1,r(p)*hyp)
	estadd scalar corr_h = corr_h[1,i]
	estadd scalar corr_bky = corr_bky[1,i]
scalar i = i + 1
} 

* Export the table with p-value and Bonferroni p-value
esttab using "$output/TableCorr2B.txt", se replace label noobs ///
keep(treat, relax) ///
cells(b(fmt(2) star) se(par fmt(2))) ///
stats(p_value Bon_p_value corr_h  corr_bky blank N r2, fmt(2 2 0 2) labels("P-value" "Boferroni p-value" "Holm Alpha" "BKY p-value" " " "Number of Observations" "R-Squared")) 

* PANEL C 
* Generate matrices with corrected p-values 
mat  corr_h = [0.015, 0.0167, 0.025, 0.01, 0.05] 
mat  corr_bky = [0.002, 0.029, 0.293, 0.001, 0.429  ]

* Rerun regressions to add them
scalar i = 1
eststo clear
local fcimat "fci_play_mat_type Npaintbooks Nthingsmove Ntoysshape Ntoysbought"
foreach y of local fcimat{
	cap drop V*
    eststo: reg `y'1_st treat fci_play_mat_type0_st $covs_ent , cluster(cod_dane)
	eststo: test treat = 0
	estadd scalar p_value = r(p)
	estadd scalar Bon_p_value = min(1,r(p)*hyp)
	mat p_values[i,1]=r(p)
scalar i = i + 1
} 

* Export the table with p-value and Bonferroni p-value
esttab using "$output/TableCorr2C.txt", se replace label noobs ///
keep(treat, relax) ///
cells(b(fmt(2) star) se(par fmt(2))) ///
stats(p_value Bon_p_value corr_h  corr_bky blank N r2, fmt(2 2 0 2) labels("P-value" "Boferroni p-value" "Holm Alpha" "BKY p-value" " " "Number of Observations" "R-Squared")) 

* PANEL D 
* Generate matrices with corrected p-values 
mat  corr_h = [0.013, 0.05, 0.01, 0.017, 0.025]
mat  corr_bky = [0.001, 0.005, 0.001, 0.003, 0.003  ]

* Rerun regressions to add them
scalar i = 1
eststo clear
local fcitime "fci_play_act home_stories home_read home_toys home_name"
foreach y of local fcitime{
	cap drop V*
	eststo: reg `y'1_st treat fci_play_act0_st $covs_ent , cluster(cod_dane)
	eststo: test treat = 0
	estadd scalar p_value = r(p)
	estadd scalar Bon_p_value = min(1,r(p)*hyp)
	mat p_values[i,1]=r(p)
scalar i = i + 1
} 

* Export the table with p-value and Bonferroni p-value
esttab using "$output/TableCorr2CD.txt", se replace label noobs ///
keep(treat, relax) ///
cells(b(fmt(2) star) se(par fmt(2))) ///
stats(p_value Bon_p_value corr_h  corr_bky blank N r2, fmt(2 2 0 2) labels("P-value" "Boferroni p-value" "Holm Alpha" "BKY p-value" " " "Number of Observations" "R-Squared")) 


