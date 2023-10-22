/*******************************************************************************
                      Semana 8: Cluster robust inference

                          Universidad de San Andrés
                              Economía Aplicada
							       2022							           
*******************************************************************************/
 /*
Trabajo Práctico 7
Profesor: Martin Rossi
Tutores: Gastón García Zavaleta y Tomas Pachecho
Alumnos: Francisco Apezteguia, Mateo Fernandez, Valentin Mannarino y Juan Sebastián Navajas Jauregui

*/
* 0) Set up environment
*==============================================================================*
clear all
set more off
global main "C:/Users/Usuario/OneDrive - Económicas - UBA/Valentin/Maestria/Optativas/Tercer trimestre/Economía Aplicada/TPs/TP 7"
global input "$main\input"
global output "$main\output"
global programs "$main\programs"
cd "$main"

* Open the database
use "$input\base01", clear

* Define the groups
gen group = 1
replace group = 2 if pair == 2 | pair == 4
replace group = 3 if pair == 5 | pair == 8
replace group = 4 if pair == 7
replace group = 5 if pair == 9 | pair == 10
replace group = 6 if pair == 11
replace group = 7 if pair == 12 | pair == 13
replace group = 8 if pair == 14 | pair == 15
replace group = 9 if pair == 16 | pair == 17
replace group = 10 if pair == 18 | pair == 20
replace group = 11 if pair == 19

* Count the number of observations in each group
tab group

* Label 
label var zakaibag "High school matriculation certificate"


* 1) Robust SE
*==============================================================================*
xtreg zakaibag treated semarab semrel, fe i(group) robust

* We create the matrix to store the p value
mat p1 = 2*ttail(e(df_r), abs(_b[treated]/_se[treated]))
mat colnames p1= treated 

*==============================================================================*

* 2) Clustered SE
*==============================================================================*
xtreg zakaibag treated semarab semrel, fe i(group) cluster(group)

* Again, the matrix to store the p value
mat p2 = 2*ttail(e(df_r), abs(_b[treated]/_se[treated]))
mat colnames p2= treated 

*==============================================================================*

* 3) Wild-bootstrap 
*==============================================================================*
eststo clear
xtreg zakaibag treated semarab semrel, fe i(group) cluster(group)
eststo: boottest {treated}, boottype(wild) cluster(group) robust seed(123) nograph
mat p3 = (r(p))
mat colnames p3 = treated
estadd matrix p3
estadd matrix p1
estadd matrix p2

* Export the results
esttab using "$output/Table.txt", p se label replace ///
    keep(treated, relax) ///
    cells(b(fmt(3)) se(par fmt(2)) p1(par({ })) p2(par([ ])) p3(par({{ }}))) ///
    addnotes("Robust standard errors in parenthesis, robust p-value in braces, clusterd robust standard errors in brackets, and wild-bootstrapped p-values in double braces")
*==============================================================================*

* 4) ARTs
*==============================================================================*
* Load a user-defined ART program.
do "$programs\art.ado"
eststo clear

* Create a temporary storage environment to protect existing data and settings. Do not include fixed effects	
preserve
art zakaibag treated semarab semrel, cluster(group) m(regress) report(treated)
scalar p_1 = r(pvalue_joint)
restore
mat p4 = p_1
mat colnames p4 = treated
eststo: reg zakaibag treated semarab semrel , r cluster(group)
estadd matrix p4

* Export the results
esttab using "$output/ART SE.txt", label replace ///
    keep(treated, relax) ///
    cells(b(fmt(3) pvalue(p2) star)  se(par fmt(2)) p(par({ })) p4(par([ ] ))) ///
    addnotes("Roboust clustered standard errors in parenthesis, clustered roboust p-value in braces, ART-based p-values in brackets")

	
	
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
**Roboust SD
reg zakaibag treated semarab semrel i.group,  r
*** quiero guardar el p value en una matriz para despues ponerlo bajo el coef
mat p1 = 2*ttail(e(df_r), abs(_b[treated]/_se[treated]))
mat colnames p1= treated 

**Custered roboust SD
reg zakaibag treated semarab semrel i.group, r cluster(group)
*** idem
mat p2 = 2*ttail(e(df_r), abs(_b[treated]/_se[treated]))
mat colnames p2= treated 

**Preparo la tabla
eststo clear	


**Wild - Boostrap
reg zakaibag treated semarab semrel i.group, r 
eststo: boottest treated, boottype(wild) cluster(group) robust seed(123) nograph
mat p3 = (r(p))
mat colnames p3= treated 
estadd matrix p3
estadd matrix p1
estadd matrix p2

** Tabla casi lista, falta ponerle un nombre lindo a la Y
esttab using "$output/Table 1.tex", replace ///
keep(treated , relax) ///
cells(b(fmt(3)) se(par fmt(2)) p1(par({ })) p2(par([ ])) p3(par({{ }}))) ///
addnotes("Robust standard errors in parenthesis, robust p-value in braces, clusterd robust standard errors in brackets, and wild-bootstrapped p-values in double braces")






	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
