/*******************************************************************************
                   Semana 6: Efectos fijos 

                          Universidad de San Andrés
                              Economía Aplicada
*******************************************************************************/
 /*
Trabajo Práctico 4
Profesor: Martin Rossi
Tutores: Gastón García Zavaleta y Tomas Pachecho
Alumnos: Francisco Apezteguia, Mateo Fernandez, Valentin Mannarino y Juan Sebastián Navajas Jauregui

*/
/*******************************************************************************/
* 0) Set up environment
*==============================================================================*
clear all
set more off
global main "C:\Users\Usuario\OneDrive - Económicas - UBA\Valentin\Códigos\STATA\Fixed Effects"
global input "$main\input"
global output "$main\output"
cd "$main"
use "$input/microcredit.dta",clear

* Rename the variable "year" to identify the referenced year
replace year=1998 if year==1
replace year=1991 if year==0


*==============================================================================*
/* 1) Exercise 1 
Estimate the base specification by OLS and present the results. What is the
identification assumption necessary for consistent estimation?*/


* Create the variable "logarithm of total expenditure" and rename our variables
gen l_exptot = log(exptot)
label var l_exptot "Log Expenditure"
label var dfmfd "Female participation"

* Next, run the simple regression
reg l_exptot dfmfd
outreg2 using "$output/reg_simple.tex", dec(6) label addtext(village fixed effects, No, Household fixed effects, No, Year fixed effects, No, Controls, No) replace


*==============================================================================*
* 2) Exercise 2

* First, include Household fixed effects. 
xtset	nh year
reghdfe l_exptot dfmfd, absorb(nh)
outreg2 using "$output/fe_house.tex", dec(3) addtext(Village fixed effects, No, Household fixed effects, Yes, Year fixed effects, No, Village X Year fixed effects, No, Household X Year fixed effects, No, Controls,  No) replace

* Next, include Year fixed effects. 
reghdfe l_exptot dfmfd, absorb(year)
outreg2 using "$output/fe_year.tex", dec(3) addtext(Village fixed effects, No, Household fixed effects, No, Year fixed effects, Yes, Village X Year fixed effects, No, Household X Year fixed effects, No, Controls,  No) replace

* Then, include Village fixed effects. 
reghdfe l_exptot dfmfd, absorb(village)
outreg2 using "$output/fe_village.tex", dec(3) addtext(Village fixed effects, Yes, Household fixed effects, No, Year fixed effects, No, Village X Year fixed effects, No, Household X Year fixed effects, No, Controls,  No) replace

* Then, include Village and household fixed effects. 
reghdfe l_exptot dfmfd, absorb(nh village)
outreg2 using "$output/fe_villagehouseh.tex",  dec(3) addtext(Village fixed effects, Yes, Household fixed effects, Yes, Year fixed effects, No, Village X Year fixed effects, No, Household X Year fixed effects, No, Controls,  No) replace

* Next, include Year and household fixed effects. 
reghdfe l_exptot dfmfd, absorb(year nh)
outreg2 using "$output/fe_yearhouseh.tex", dec(3) addtext(Village fixed effects, No, Household fixed effects, Yes, Year fixed effects, Yes, Village X Year fixed effects, No, Household X Year fixed effects, No, Controls,  No) replace

* Then, include Year and village fixed effects.
reghdfe l_exptot dfmfd, absorb(year village)
outreg2 using "$output/fe_yearvillage.tex", dec(3) addtext(Village fixed effects, Yes, Household fixed effects, No, Year fixed effects, Yes, Village X Year fixed effects, No, Household X Year fixed effects, No, Controls,  No) replace

* Next, include Village × year fixed effects. First, generate this variable. 
gen village_year = village*year
reghdfe l_exptot dfmfd, absorb(village_year)
outreg2 using "$output/fe_villageyear.tex", dec(3) addtext(Village fixed effects, No, Household fixed effects, No, Year fixed effects, No, Village X Year fixed effects, Yes, Household X Year fixed effects, No, Controls,  No) replace

* Finally, include Household × year fixed effects. First, generate this variable. Cannot be run due to multicollinearity.
gen nh_year = nh*year
reghdfe l_exptot dfmfd, absorb(nh_year)
outreg2 using "$output/fe_househyear.tex", dec(3) addtext(Village fixed effects, No, Household fixed effects, No, Year fixed effects, No, Village X Year fixed effects, No, Household X Year fixed effects, Yes, Controls,  No) replace

* Next, include Village × year fixed effects and household fixed effects.
reghdfe l_exptot dfmfd, absorb(village_year nh)
outreg2 using "$output/fe_villageyearhouseh.tex", dec(3) addtext(Village fixed effects, No, Household fixed effects, Yes, Year fixed effects, No, Village X Year fixed effects, Yes, Household X Year fixed effects, No, Controls,  No) replace

