/*******************************************************************************
                          Universidad de San Andrés
                              Economía Aplicada
							       2023						           
*******************************************************************************/
/*******************************************************************************
Trabajo Práctico 1
Profesor: Martin Rossi
Tutores: Gastón García Zavaleta y Tomas Pachecho
Alumnos: Francisco Apezteguia, Mateo Fernandez, Valentin Mannarino y Juan Sebastián Navajas Jauregui
*******************************************************************************/*/
/*******************************************************************************/
* 0) Set up environment
*==============================================================================*
clear all
set more off
global main "C:\Users\Usuario\OneDrive - Económicas - UBA\Valentin\Códigos\STATA\Limpiar_base"
global input "$main\input"
global output "$main\output"
cd "$main"


* 1) Ejercicio 1
*==============================================================================*

*ssc install estout
*ssc install texsave
**** INCISO 1 ****

* List of sample sizes
local obslist "100 150 300"

* Initialize a counter to save regression
local counter = 10

* Loop over different sample sizes
foreach obs in `obslist' {
    * Clear the dataset
    clear
    
    * Set the number of observations
    set obs `obs'
    set seed 1233
    
    * Generate variables
    gen intelligence=int(invnormal(uniform())*20+100)
    gen education=int(intelligence/10+invnormal(uniform())*1)
    corr education intelligence
    
    gen a=int(invnormal(uniform())*3+10)
    gen b=int(invnormal(uniform())*1+5)
    gen u=int(invnormal(uniform())*1+7)
    
    * Data generating process
    gen wage=3*intelligence+a+2*b+u
    
    * Regression
    reg wage intelligence a b
    predict y_hat_`counter' 
    
    * Save results
    est store ols`counter'
    
    * Increment the counter
    local counter = `counter' + 1
}

* 
* Create an exportable table with standard errors

esttab ols* using "results.tex", cell(se) nonumber replace

**** INCISO 2 ****
clear

* List of sample sizes
local varlist "1 5 10"

* Initialize a counter to save regressions
local counter = 10

* Loop over different sample sizes
foreach var in `varlist' {
    * Clear the dataset
    clear
    
    * Set the number of observations
    set obs 100
    set seed 1233
    
    * Generate variables
    gen intelligence=int(invnormal(uniform())*20+100)
    gen education=int(intelligence/10+invnormal(uniform())*1)
    corr education intelligence
    
    gen a=int(invnormal(uniform())*3+10)
    gen b=int(invnormal(uniform())*1+5)
    gen u=int(invnormal(uniform())*`var'+7)
    
    * Data generating process
    gen wage=3*intelligence+a+2*b+u
    
    * Regression
    reg wage intelligence a b
    predict y_hat_`counter' 
    
    * Save results
    est store ols`counter'
    
    * Increment the counter
    local counter = `counter' + 1
}

* Create an exportable table with standard errors

esttab ols* using "results2.tex", cell(se) nonumber replace

**** INCISO 3 ****
clear

* List of sample sizes
local varlist "20 30 40"

* Initialize a counter to save regressions
local counter = 10

* Loop over different sample sizes
foreach var in `varlist' {
    * Clear the dataset
    clear
    
    * Set the number of observations
    set obs 100
    set seed 1233
    
    * Generate variables
    gen intelligence=int(invnormal(uniform())*`var'+100)
    gen education=int(intelligence/10+invnormal(uniform())*1)
    corr education intelligence
    
    gen a=int(invnormal(uniform())*3+10)
    gen b=int(invnormal(uniform())*1+5)
    gen u=int(invnormal(uniform())*1+7)
    
    * Data generating process
    gen wage=3*intelligence+a+2*b+u
    
    * Regression
    reg wage intelligence a b
    predict y_hat_`counter' 
    
    * Save results
    est store ols`counter'
    
    * Increment the counter
    local counter = `counter' + 1
}

* Create an exportable table with standard errors.
esttab ols* using "results3.tex", cell(se) nonumber replace

**** INCISO 4 y 5****
clear
set obs 100
set seed 1233
gen intelligence=int(invnormal(uniform())*20+100)

gen a=int(invnormal(uniform())*3+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)

* Data generating process
gen wage=3*intelligence+a+2*b+u

* Two different regressions
reg wage intelligence a b
predict res, residuals
sum res

estpost summarize res
esttab using results4.tex, replace

**** INCISO 6****
clear
set obs 100
set seed 1233
gen a=int(invnormal(uniform())*20+100)
gen b=int(invnormal(uniform())*3+10)

* gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=a+2*b+u
reg wage  a b
predict y_hat_1
est store ols11
clear
set obs 100
set seed 1233
gen a=int(invnormal(uniform())*20+100)
gen b=int(a/10+invnormal(uniform())*1)
gen u=int(invnormal(uniform())*1+7)
corr a b
gen wage=a+2*b+u
reg wage a b
predict y_hat_2
est store ols12

esttab ols11 ols12, se cells("se")

**** INCISO 7****

clear
set obs 100
set seed 1233
gen a=int(invnormal(uniform())*20+100)
gen b=int(invnormal(uniform())*3+10)
gen u=int(invnormal(uniform())*1+7)
gen e=50
gen wage=a+2*b+u
reg wage  a b
predict y_hat_3
est store ols13
clear
set obs 100
set seed 1233
gen a=int(invnormal(uniform())*20+100)
gen b=int(invnormal(uniform())*3+10)
gen u=int(invnormal(uniform())*1+7)
gen e=50
gen wage=a+2*(b+e)+u
reg wage  a b
predict y_hat_1
est store ols11
clear
set obs 100
set seed 1233
gen a=int(invnormal(uniform())*20+100)
gen b=int(invnormal(uniform())*3+10)
gen u=int(invnormal(uniform())*1+7)
gen e=int(invnormal(uniform())*1+7)
gen wage=a+2*(b+e)+u
reg wage  a b
predict y_hat_2
est store ols12
clear

* Using the commands suest and esttab we can compare the results of the two ols exercise
esttab ols13 ols11 ols12

**** INCISO 8****
clear
set obs 100
set seed 1233
gen a=int(invnormal(uniform())*20+100)
gen b=int(invnormal(uniform())*3+10)
gen u=int(invnormal(uniform())*1+7)
gen e=50
gen wage=a+2*b+u
reg wage  a b
predict y_hat_3
est store ols13
clear
set obs 100
set seed 1233
gen a=int(invnormal(uniform())*20+100)
gen b=int(invnormal(uniform())*3+10)
gen u=int(invnormal(uniform())*1+7)
gen e=50
gen wage=a+2*b+u+e
reg wage  a b
predict y_hat_1
est store ols11
clear
set obs 100
set seed 1233
gen a=int(invnormal(uniform())*20+100)
gen b=int(invnormal(uniform())*3+10)
gen u=int(invnormal(uniform())*1+7)
gen e=int(invnormal(uniform())*1+7)
gen wage=a+2*b+u+e
reg wage  a b
predict y_hat_2
est store ols12
clear

* Using the commands suest and esttab we can compare the results of the two ols exercise
esttab ols13 ols11 ols12





