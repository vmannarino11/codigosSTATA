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
use "$input/data.dta",clear


* PUNTO 2
* A)
/* Clean the dataset - We start by generating variables and converting them to numeric using encode 
*/


foreach var of varlist sex belief obese{
    encode `var', gen(sec`var') 
    replace sec`var' =. if `var' == "."
    drop `var'
    rename sec`var' `var'
}
* Now we create the male variable where 1= male and 2 = female
gen male =.
replace male = 1  if sex == 2
replace male = 0  if sex == 1

* Since 'obese' takes values 3 and 2, and we want it to be 1 and 0
replace obese=obese-2

* Now we remove values with .a, .b, .c, .d
foreach v of varlist econrk powrnk  resprk highsc hattac hosl3m hattac alclmo cmedin wtchng{
replace `v' = "" if `v'==".a" | `v'==".b" | `v'==".c" | `v'==".d"
}

* Convert values in letters to numbers
foreach v of varlist econrk powrnk resprk hattac satlif satecc  wtchng evalhl  geo operat {
replace `v'="0" if `v'=="cero"
replace `v'="1" if `v'=="one"
replace `v'="2" if `v'=="two"
replace `v'="3" if `v'=="three"
replace `v'="4" if `v'=="four"
replace `v'="5" if `v'=="five"
replace `v'="6" if `v'=="six"
replace `v'="7" if `v'=="seven"
replace `v'="8" if `v'=="eight"
replace `v'="9" if `v'=="nine"
destring `v', replace force 
}

* Now we want 'smokes' to be equal to 1 
replace smokes = "1"  if smokes == "Smokes"

* Now convert binary variables to numeric 
foreach var of varlist hprblm hosl3m hattac alclmo hhpres cmedin operat highsc smokes ortho monage waistc tincm_r{
	destring `var', replace dpcomma force 
}

* Work with the 'hipsiz' variable
gen new_hipsiz = real(regexs(1)) if regexm(hipsiz, "([0-9.]+)")
replace new_hipsiz = . if missing(new_hipsiz)
drop hipsiz
rename new_hipsiz hipsiz

* Work with the 'totexpr' variable
gen new_totexpr = real(regexs(1)) if regexm(totexpr, "([0-9.]+)")
replace new_totexpr = . if missing(new_totexpr)
drop totexpr
rename new_totexpr totexpr

* Now see if the 'work' and 'marsta' variables can be combined into a single quantitative variable
gen new_work = .
replace new_work = 0 if work0 == "1"
replace new_work = 1 if work1 == "1"
replace new_work = 2 if work2 == "1"
drop work0 work1 work2
rename new_work work
gen new_marsta = .
replace new_marsta = 1 if marsta1 == "1"
replace new_marsta = 2 if marsta2 == "1"
replace new_marsta = 3 if marsta3 == "1"
replace new_marsta = 4 if marsta4 == "1"
drop marsta1 marsta2 marsta3 marsta4
rename new_marsta marsta
replace marsta = 0 if marsta == .
br
* We have completed the data cleaning :)
*B)
* To check for missing values
* Install the 'mdesc' package
ssc install mdesc

* Check for missing values
mdesc

* Variables with more than 5% missing are totexpr, obese, tincm_r, htself, monage
* C)
* General summarize
summarize

* We found that the 'tincm_r' variable has a minimum of -183.4
replace tincm_r = . if tincm_r <0

* We found that the 'totexpr' variable has a minimum of *******
replace totexpr = . if totexpr <0

*  Now, for a more detailed analysis, we use 'codebook' since it comes with labels
codebook 
codebook 

* We can check if there are places where expenses (exp) exceed income (inc) 
count if totexpr > tincm_r 

* Set missing values for those cases
replace tincm_r = . if totexpr > tincm_r
replace totexpr = . if totexpr > tincm_r

*D)
* Sort the columns
order id site sex totexpr

* Sort the rows by observation with the lowest value
-gsort totexpr

*E) 
* First, we will convert the age, which is in months, to years
gen age = monage / 12

* We will label the variables
label var age "Edad"
label var male "Género"
label var satlif "Satisfación con la vida"
label var  hipsiz "Circunferencia de la cadera"
label var totexpr "Gasto real"

estpost tabstat age male satlif hipsiz totexpr, listwise ///
stats (mean sd min max) columns (statistics)
esttab using "$main/table1.rtf", cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") ///
label replace collabels("Mean" "SD" "Min" "Max")

*F)
* Hip Circumference Distribution
twoway (kdensity hipsiz if sex == 1, mcolor(green%90)) (kdensity hipsiz if sex == 2, mcolor(red%90)), ///
    legend(order(1 "Mujeres" 2 "Hombres")) ///
    xtitle("Circunferencia de caderas") ytitle("Densidad") ///
    title("Distribución de circunferencia de caderas por género")
graph export "$main/graf1.png"

* Mean test
ttest hipsiz, by(male)
estpost ttest hipsiz, by(male)
esttab using "$main/table2.rtf"



