/*******************************************************************************
                        Semana 9: Control sintético
					  
                          Universidad de San Andrés
                              Economía Aplicada
							       2022							           
*******************************************************************************/
 /*
Trabajo Práctico 8
Profesor: Martin Rossi
Tutores: Gastón García Zavaleta y Tomas Pachecho
Alumnos: Francisco Apezteguia, Mateo Fernandez, Valentin Mannarino y Juan Sebastián Navajas Jauregui

*/
* 0) Set up environment
*==============================================================================*
clear all
set more off
global main "C:/Users/Usuario/OneDrive - Económicas - UBA/Valentin/Maestria/Optativas/Tercer trimestre/Economía Aplicada/TPs/TP 8"
global input "$main\input"
global output "$main\output"
global programs "$main\programs"
cd "$main"

* Open the database
import delimited "$input\df.csv", encoding (UTF-8) clear

*Labels  
label var homiciderates "Homicide Rates"
label var year "Year"

* Work with a panel
tsset code year 

* Install synth
*ssc install synth
*ssc install grstyle
*ssc install palettes
*ssc install colrspace


* 1) Figure
*==============================================================================*
* Figure 1: Homicide rates per 100,000 population: São Paulo and Brazil (excluding the state of São Paulo).
	
* First we create the variable homice-rate without Sao Pablo (35) and for SP
clonevar hom_br = homiciderates
replace hom_br = . if code == 35
	
clonevar hom_sp = homiciderates
replace hom_sp = . if code != 35

* Generate the average for all state except SP. 
bysort year : egen prom_br = mean(hom_br)

* Save in .dta
save "input\df.dta", replace

* Generate the graph
set scheme s2mono
grstyle init
grstyle set horizontal
graph set window fontface "Palatino Linotype"
grstyle color background white
grstyle color heading black

line hom_sp prom_br year, lpattern(solid dash) tline(1999, lcolor(black) lpattern(shortdash)) ytitle("Homicide Rates") xtitle("Year") yscale(range(0 60)) ylabel(#7) ttext(50 1995 "Policy change") legend( label (1 "Sao Paulo") label (2 "Brazil (average)") ring(0) bplacement(swest) cols(1))

graph export "$output/1.png", replace

* Figure 2: Trends in homicide rates: São Paulo versus synthetic São Paulo	
synth homiciderates stategdpcapita stategdpgrowthpercent populationprojectionln yearsschoolingimp homiciderates giniimp, trunit(35) trperiod(1999) fig nested 

graph export "$output/2.png", replace	

* Figure 3: Homicide rates gap between São Paulo and synthetic São Paulo.
synth homiciderates stategdpcapita stategdpgrowthpercent populationprojectionln yearsschoolingimp homiciderates(1990(1)1998) giniimp(1990(1)1998), trunit(35) trperiod(1999) xperiod(1990(1)1998) nested keep(resout1) fig

preserve
use "resout1.dta", replace
matrix gaps = e(Y_treated) - e(Y_synthetic)	
matrix Y_treated=e(Y_treated)
matrix Y_synthetic=e(Y_synthetic)	
keep _time
svmat gaps
svmat Y_treated
svmat Y_synthetic
	
twoway (line gaps _time), xline(1999, lpattern(shortdash)) yline(0, lpattern(dash)) ytitle("Gap in  Homicide Rates") xtitle("Year") yscale(range(-30 30)) ylabel(#7) ttext(20 1995 "Policy change")	

graph export "$output/3.png", replace

* Figure 4: Placebo policy implementation in 1994: São Paulo versus synthetic São Paulo In time
use "$input\df.dta", clear
tsset code year

synth homiciderates stategdpcapita stategdpgrowthpercent populationprojectionln yearsschoolingimp homiciderates giniimp, trunit(35) trperiod(1995) resultsperiod(1990(1)1998) nested 

matrix gaps = e(Y_treated) - e(Y_synthetic)	
matrix Y_treated=e(Y_treated)
matrix Y_synthetic=e(Y_synthetic)	
keep year
svmat gaps
svmat Y_treated
svmat Y_synthetic

set scheme s2mono
grstyle init
grstyle set horizontal
graph set window fontface "Palatino Linotype"
grstyle color background white
grstyle color heading black

twoway (line Y_treated year if year < 1999, lcolor(black)) (line Y_synthetic year if year < 1999, lcolor(black) lpattern(dash)), xline(1995, lpattern(shortdash) lcolor(gray)) ytitle("Homicide Rates") xtitle("Year") ysc(r(0 50)) ylabel(0 10 20 30 40 50) ttext(40 1993 "Placebo Policy change")	 legend(label(1 "Sao Paulo") label(2 "Synthetic Sao Paulo")ring(0) bplacement(swest) cols(1))

graph export "$output/4.png", replace


* Figure 5: Leave-one-out distribution of the synthetic control for São Paulo.
use "$input\df.dta", clear
*destring proportionextremepoverty, replace
*rename proportionextremepoverty propextremepov
tsset code year 

tempname resmat
        local i 35
        qui synth homiciderates stategdpcapita stategdpgrowthpercent populationprojectionln yearsschoolingimp homiciderates(1990(1)1998) giniimp(1990(1)1998) , trunit(`i') trperiod(1999) nested xperiod(1990(1)1998) keep(loo-resout`i', replace)	
		
		forvalues j=11/53 {
		if `j'==35{ 
		continue
		}
		use "$input\df.dta", clear
		*destring proportionextremepoverty, replace
*rename proportionextremepoverty propextremepov
		tsset code year 
		drop if code==`j'
        qui synth homiciderates stategdpcapita stategdpgrowthpercent populationprojectionln yearsschoolingimp homiciderates(1990(1)1998) giniimp(1990(1)1998), trunit(35) trperiod(1999) nested xperiod(1990(1)1998) keep(loo-resout`j', replace)	
        }
		

forvalues i = 11/53 { 
use "loo-resout`i'.dta", clear
ren _Y_synthetic _Y_synthetic_`i'
ren _Y_treated _Y_treated_`i'
gen _Y_gap_`i'=_Y_treated_`i'-_Y_synthetic_`i'
save "loo-resout`i'.dta", replace
}

use "loo-resout11.dta", clear
forvalues i = 12/53 {
merge 1:1 _Co_Number _time using "loo-resout`i'.dta", nogen
}


twoway (line _Y_synthetic_14 _time, lcolor(gs14)) (line _Y_synthetic_32 _time, lcolor(gs14)) (line _Y_synthetic_42 _time, lcolor(gs14)) (line _Y_synthetic_50 _time, lcolor(gs14)) (line _Y_synthetic_53 _time, lcolor(gs14)) (line _Y_treated_35 _time, lcolor(black) lwidth(thick)) (line _Y_synthetic_35 _time, lcolor(black) lpattern(dash)), xscale (range(1990 1998)) yscale (range(0 50)) xline(1999, lcolor (black) lpattern (dot)) xtitle("Year") ytitle("Homice Rate") ysc(r(0 50)) ylabel(0 10 20 30 40 50) ttext(45 1995 "Policy change") legend (order(1 "Sao Paulo" 2 "Synthetic Sao Pablo" 3 "Synthetic Sao Pablo (leave-one out)")ring(0) bplacement(swest) cols (1)) 

graph export "$output/5.png", replace

* Figure 6: Permutation test: Homicide rate gaps in São Paulo and twenty-six control states
use "$input\df.dta", clear
tsset code year

tempname resmat
        local i 35
        qui synth homiciderates stategdpcapita stategdpgrowthpercent populationprojectionln yearsschoolingimp homiciderates(1990(1)1998) giniimp(1990(1)1998), trunit(`i') trperiod(1999) nested xperiod(1990(1)1998) keep(resout`i', replace)	 
        matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`i'"'"'
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")
		
		drop if code==35
		
        forvalues i = 11/53 {
		if (`i'==35 |`i'==18 | `i'==19 | `i'==20 | `i'==30 | `i'==34 | `i'==36 | `i'== 37 | `i'==38 | `i'==39 | `i'==40 | `i'==44 | `i'==45 | `i'==46 | `i'==47 | `i'==48 | `i'==49) { 
		continue
		}
        qui synth homiciderates stategdpcapita stategdpgrowthpercent populationprojectionln yearsschoolingimp homiciderates(1990(1)1998) giniimp(1990(1)1998), trunit(`i') trperiod(1999) xperiod(1990(1)1998) nested keep(resout`i', replace)		
        matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`i'"'"'
        }
		
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
        matlist `resmat' , row("Treated Unit")
			
forvalues i = 11/53 {
if (`i'==18 | `i'==19 | `i'==20 | `i'==30 | `i'==34 | `i'==36 | `i'== 37 | `i'==38 | `i'==39 | `i'==40 | `i'==44 | `i'==45 | `i'==46 | `i'==47 | `i'==48 | `i'==49) { 
		continue
		}
use "resout`i'.dta", clear
ren _Y_synthetic _Y_synthetic_`i'
ren _Y_treated _Y_treated_`i'
gen _Y_gap_`i'=_Y_treated_`i'-_Y_synthetic_`i'
save "resout`i'.dta", replace
}

use "resout11.dta", clear
forvalues i = 12/53 {
if (`i'==18 | `i'==19 | `i'==20 | `i'==30 | `i'==34 | `i'==36 | `i'== 37 | `i'==38 | `i'==39 | `i'==40 | `i'==44 | `i'==45 | `i'==46 | `i'==47 | `i'==48 | `i'==49) { 
		continue
		}
merge 1:1 _Co_Number _time using "resout`i'.dta", nogen
}

twoway (line _Y_gap_11 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_12 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_13 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_14 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_15 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_16 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_17 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_21 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_22 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_23 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_24 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_25 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_26 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_27 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_28 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_29 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_31 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_32 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_33 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_41 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_42 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_43 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_50 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_51 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_52 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_53 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_35 _time, lcolor(black) lwidth(thick) lpattern(solid)), xscale (range(1990 1998)) yscale (range(0 50)) xline(1999, lcolor (black) lpattern (dot)) xtitle("Year") ytitle("Homice Rate") ysc(r(0 50)) ylabel(0 10 20 30 40 50) ttext(30 1997 "Policy change") legend (order(1 "Sao Paulo" 2 "Control States")ring(0) bplacement(swest) cols (1)) 

graph export "$output/6.png", replace


* Figure 7: Permutation test: Homicide rate gaps in São Paulo and selected control states
/* It uses a stricter threshold for the simulated synthetic controls. The graph features cases in which the mean squared prediction error, a measure of goodness-of-fit, is no higher than twice that of São Paulo. That is, only placebos that have good synthetic matches were selected for the analysis */
* Root Mean Squared Prediction Error (RMSPE)
*  1.669045 - RMSPE so 2,7857
/*Treated Unit |     RMSPE 
-------------+-----------
          35 |  1.669045 
          11 |  7.231113 
          12 |   3.55609 
          13 |  .9994324 
          14 |  6.729529 
          15 |  .9875896 
          16 |  11.09317 
          17 |  1.505844 
          21 |  1.388704 
          22 |  3.201157 
          23 |  .9501709 
          24 |  .8929107 
          25 |  1.507458 
          26 |  3.504915 
          27 |  4.154632 
          28 |   7.29874 
          29 |  2.727769 
          31 |  .3640564 
          32 |  3.021388 
          33 |  11.67074 
          41 |  .8158313 
          42 |  .3828398 
          43 |  2.099757 
          50 |  4.131034 
          51 |  4.424652 
          52 |  2.536674 
          53 |   1.70997 
*/

* 13-15-17-21-23-24-25-29-31-41-42-43-52-53

twoway (line _Y_gap_13 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_15 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_17 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_21 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_23 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_24 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_25 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_29 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_31 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_41 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_42 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_43 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_52 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_53 _time, lcolor(gray) lpattern(solid) lwidth(thin)) (line _Y_gap_35 _time, lcolor(black) lwidth(thick) lpattern(solid)), xscale (range(1990 2009)) xline(1998, lcolor (black) lpattern (dot)) yline(0, lcolor (black)) xtitle("Year") ytitle("Gap in Homicide Rates") ttext(25 1995 "Policy change") legend (order(1 "Sao Paulo" 2 "Control States (MSPE Less Than Two Times" "That of Sao Paulo")ring(0) bplacement(swest) cols (1))

graph export "$output/7.png", replace


















