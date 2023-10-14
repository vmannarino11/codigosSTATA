/*******************************************************************************
                   Problem set 6: Difference in differences 

                          Universidad de San Andrés
                              Economía Aplicada
*******************************************************************************/
 /*
Profesor: Martin Rossi
Tutores: Gastón García Zavaleta y Tomas Pachecho
Alumnos: Francisco Apezteguia, Mateo Fernandez, Valentin Mannarino y Juan Sebastián Navajas Jauregui

*/
/*******************************************************************************/
* 0) Set up environment
*==============================================================================*
* Install if it is necessary 

/*ssc install bacondecomp
ssc install eventdd
ssc install matsort
ssc install boottest
ssc install reghdfe    
ssc install ftools 
ssc install coefplot
ssc install csdid
ssc install drdid*/



clear all
global main "C:/Users/Usuario/OneDrive - Económicas - UBA/Valentin/Códigos/STATA/Cheng_Hoeskstra"
global input "$main/input"
global output "$main/output"
cd "$main"
use "$input/castle.dta",clear

* We create some variables that will be useful later and also change some labels.

gen northeast_y = northeast*year
gen south_y = south*year
gen midwest_y = midwest*year
gen west_y = west*year

label var l_burglary "Log (Burglary rate)"
label var post "Castle Doctrine Law"
label var l_robbery "Log (Robbery Rate)"
label var l_assault "Log (Aggravated Assault Rate)"
label var pre2_cdl "0 to 2 years before adoption of castle doctrine law"
*==============================================================================*
/* 1) Exercise 1
Replicate Table 4, keeping in mind that the results you obtain may not be exactly the same as those in the paper.

To replicate the table, we need to run each of the regressions that make it up. We will use the explanatory variable 'post' because it is a dummy variable, while the variable 'cdl' takes into account the year when the state entered treatment. This specification may pose some challenges in the Bacon decomposition (Cunningham, pp. 656).*/


*1 - First, we perform it for the "burglary" variable.
*A.1 -  We include only fixed effects by year and state, weighted regression.
reghdfe l_burglary post [aw = population], absorb (sid year) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_A.tex", dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, , Time-Varying Controls, -, Contemporaneous Crime Rates, - , State-Specific Linear Time Trends, -) append

 
*A.2 - We include fixed effects by year and state, along with fixed effects by region-year, weighted regression.
reghdfe l_burglary post [aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_A.tex", dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls,- , Contemporaneous Crime Rates,- , State-Specific Linear Time Trends,- ) append

*A.3 - We include fixed effects by year and state, fixed effects by region-year, and controls, weighted regression. 
reghdfe l_burglary post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44  [aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_A.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends,-) append

*A.4 - We include fixed effects by year and state, fixed effects by region-year, controls, and "pre2_cdl" as an explanatory variable, weighted regression. 
reghdfe l_burglary post pre2_cdl l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44  [aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_A.tex", keep(post pre2_cdl) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends, - ) append


*A.5 -  We include fixed effects by year and state, fixed effects by region-year, controls, time-varying controls, and contemporaneous crime rates, weighted regression.
reghdfe l_burglary post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 l_larceny l_motor [aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_A.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,Yes, State-Specific Linear Time Trends, - ) append


*A.6 - We include fixed effects by year and state, fixed effects by region-year, controls, time-varying controls, and state-specific linear time trends, weighted regression.
reghdfe l_burglary post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 trend_1-trend_51 [aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_A.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends, Yes ) append


*A.7 - We include only fixed effects by year and state, non-weighted regression.
reghdfe l_burglary post, absorb (sid year) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_A.tex", dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, -, Time-Varying Controls, -, Contemporaneous Crime Rates, - , State-Specific Linear Time Trends, -) append

 
*A.8 - We include fixed effects by year and state, fixed effects by region-year, non-weighted regression.
reghdfe l_burglary post, absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_A.tex", dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls,- , Contemporaneous Crime Rates,- , State-Specific Linear Time Trends,- ) append

*A.9 - We include fixed effects by year and state, fixed effects by region-year, controls, non-weighted regression.
reghdfe l_burglary post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 , absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_A.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,- , State-Specific Linear Time Trends,- ) append

*A.10 - We include fixed effects by year and state, fixed effects by region-year, controls, and "pre2_cdl" as an explanatory variable, non-weighted regression.
reghdfe l_burglary post pre2_cdl l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44, absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_A.tex", keep(post pre2_cdl) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends, - ) append


*A.11 - We include fixed effects by year and state, fixed effects by region-year, controls, time-varying controls, contemporaneous crime rates, and "pre2_cdl" as an explanatory variable, non-weighted regression.
reghdfe l_burglary post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 l_larceny l_motor , absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_A.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,Yes, State-Specific Linear Time Trends, - ) append


*A.12 - We include fixed effects by year and state, fixed effects by region-year, controls, time-varying controls, and state-specific linear time trends, non-weighted regression.
reghdfe l_burglary post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 trend_1-trend_51, absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_A.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends, Yes ) append

*2 - Second, we perform it for the "robbery" variable
*B.1 - We include only fixed effects by year and state, weighted regression.
reghdfe l_robbery post [aw = population], absorb (sid year) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_B.tex", dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, -, Time-Varying Controls, -, Contemporaneous Crime Rates, - , State-Specific Linear Time Trends, -) append

*B.2 - We include fixed effects by year and state, along with fixed effects by region-year, weighted regression.
reghdfe l_robbery post [aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_B.tex", dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls,- , Contemporaneous Crime Rates,- , State-Specific Linear Time Trends,- ) append

*B.3 - We include fixed effects by year and state, fixed effects by region-year, and controls, weighted regression. 
reghdfe l_robbery post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44  [aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_B.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends,-) append

*B.4 - We include fixed effects by year and state, fixed effects by region-year, controls, and "pre2_cdl" as an explanatory variable, weighted regression.
reghdfe l_robbery post pre2_cdl l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44  [aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_B.tex", keep(post pre2_cdl) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends, - ) append


*B.5 - We include fixed effects by year and state, fixed effects by region-year, controls, time-varying controls, and contemporaneous crime rates, weighted regression. 
reghdfe l_robbery post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 l_larceny l_motor [aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_B.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,Yes, State-Specific Linear Time Trends, - ) append

*B.6 - We include fixed effects by year and state, fixed effects by region-year, controls, time-varying controls, and state-specific linear time trends, weighted regression. 
reghdfe l_robbery post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 trend_1-trend_51[aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_B.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends, Yes ) append


*B.7 -  We include only fixed effects by year and state, non-weighted regression.
reghdfe l_robbery post, absorb (sid year) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_B.tex", dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, -, Time-Varying Controls, -, Contemporaneous Crime Rates, - , State-Specific Linear Time Trends, -) append

 
*B.8 - We include fixed effects by year and state, fixed effects by region-year, non-weighted regression.
reghdfe l_robbery post, absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_B.tex", dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls,- , Contemporaneous Crime Rates,- , State-Specific Linear Time Trends,- ) append

*B.9 - We include fixed effects by year and state, fixed effects by region-year, controls, non-weighted regression.
reghdfe l_robbery post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 , absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_B.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,- , State-Specific Linear Time Trends,- ) append

*B.10 - We include fixed effects by year and state, fixed effects by region-year, controls, and "pre2_cdl" as an explanatory variable, non-weighted regression.
reghdfe l_robbery post pre2_cdl l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44, absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_B.tex", keep(post pre2_cdl) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends, - ) append

*B.11 - We include fixed effects by year and state, fixed effects by region-year, controls, time-varying controls, contemporaneous crime rates, and "pre2_cdl" as an explanatory variable, non-weighted regression.
reghdfe l_robbery post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 l_larceny l_motor , absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_B.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,Yes, State-Specific Linear Time Trends, - ) append

*B.12 - We include fixed effects by year and state, fixed effects by region-year, controls, time-varying controls, and state-specific linear time trends, non-weighted regression.
reghdfe l_robbery post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 trend_1-trend_51, absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_B.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends, Yes ) append


*3 - Finally, we perform it for the "assault" variable.
*C.1 - We include only fixed effects by year and state, weighted regression.
reghdfe l_assault post [aw = population], absorb (sid year) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_C.tex", dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, -, Time-Varying Controls, -, Contemporaneous Crime Rates, - , State-Specific Linear Time Trends, -) append

*C.2 - We include fixed effects by year and state, along with fixed effects by region-year, weighted regression.
reghdfe l_assault post [aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_C.tex", dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls,- , Contemporaneous Crime Rates,- , State-Specific Linear Time Trends,- ) append

*C.3 - We include fixed effects by year and state, fixed effects by region-year, and controls, weighted regression.
reghdfe l_assault post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44  [aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_C.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends,-) append

*C.4 - We include fixed effects by year and state, fixed effects by region-year, controls, and "pre2_cdl" as an explanatory variable, weighted regression.
reghdfe l_assault post pre2_cdl l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44  [aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_C.tex", keep(post pre2_cdl) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends, - ) append


*C.5 - We include fixed effects by year and state, fixed effects by region-year, controls, time-varying controls, and contemporaneous crime rates, weighted regression. 
reghdfe l_assault post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 l_larceny l_motor [aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_C.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,Yes, State-Specific Linear Time Trends, - ) append


*C.6 - We include fixed effects by year and state, fixed effects by region-year, controls, time-varying controls, and state-specific linear time trends, weighted regression. 
reghdfe l_assault post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 trend_1-trend_51[aw = population], absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_C.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends, Yes ) append


*C.7 -  We include only fixed effects by year and state, non-weighted regression.
reghdfe l_assault post, absorb (sid year) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_C.tex", dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, -, Time-Varying Controls, -, Contemporaneous Crime Rates, - , State-Specific Linear Time Trends, -) append

 
*C.8 - We include fixed effects by year and state, fixed effects by region-year, non-weighted regression.
reghdfe l_assault post, absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_C.tex", dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls,- , Contemporaneous Crime Rates,- , State-Specific Linear Time Trends,- ) append

*C.9 - We include fixed effects by year and state, fixed effects by region-year, controls, non-weighted regression.
reghdfe l_assault post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 , absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_C.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,- , State-Specific Linear Time Trends,- ) append

*C.10 - We include fixed effects by year and state, fixed effects by region-year, controls, and "pre2_cdl" as an explanatory variable, non-weighted regression.
reghdfe l_assault post pre2_cdl l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44, absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_C.tex", keep(post pre2_cdl) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends, - ) append


*C.11 - We include fixed effects by year and state, fixed effects by region-year, controls, time-varying controls, contemporaneous crime rates, and "pre2_cdl" as an explanatory variable, non-weighted regression.
reghdfe l_assault post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 l_larceny l_motor , absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_C.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,Yes, State-Specific Linear Time Trends, - ) append

*C.12 - We include fixed effects by year and state, fixed effects by region-year, controls, time-varying controls, and state-specific linear time trends, non-weighted regression.
reghdfe l_assault post l_police l_prisoner l_exp_pubwelfare l_exp_subsidy l_income poverty unemployrt l_lagprisoner blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 trend_1-trend_51, absorb (sid year west_y midwest_y south_y northeast_y) cluster ("sid") nocon
outreg2 using "$output/ejercicio_1_C.tex", keep(post) dec(4) label nonot addtext(State and Year Fixed Effects, Yes, Region-by-Year Fixed Effects, Yes, Time-Varying Controls, Yes, Contemporaneous Crime Rates,-, State-Specific Linear Time Trends, Yes ) append

*==============================================================================*
* 2) Exercise 2
*==============================================================================*

* Column 1 of Panel C -  Table 4. Callaway and Sant´Anna´s (2020)
* Ensure 'effyear' has no missing values; replace any with zeros if necessary.
replace effyear = 0 if effyear == .
encode state, generate(state_num)

* CS
csdid l_assault post, ivar(state_num) time(year) gvar(effyear) method(reg) notyet [aweight=popwt] fe vce(cluster sid)

* Pre - trend. P-value: 0.0000
estat pretrend 

* Average ATT
estat simple

* Dynamic effects by groups
csdid l_assault post, ivar(state_num) time(year) gvar(effyear) method(reg) notyet [aweight=popwt] fe vce(cluster sid) 
csdid_plot, group(2005) name(m1,replace) title("Group 2005")
csdid_plot, group(2006) name(m2,replace) title("Group 2006")
csdid_plot, group(2007) name(m3,replace) title("Group 2007")
csdid_plot, group(2008) name(m4,replace) title("Group 2008")
graph combine m1 m2 m3 m4, xcommon scale(0.8)

* Event study plot
estat event
csdid_plot


*==============================================================================*
* 3) Exercise 3
*==============================================================================*


net install ddtiming, from(https://tgoldring.com/code)

** Bacon Decomposition
xtreg l_burglary post i.year, fe robust

encode state, generate(state_num)

ddtiming l_burglary post, i(state_num) t(year) ddline(lwidth(thick)) ///
ylabel(-.10(0.05).15) legend(order(3 4 1 2)) savegraph(nfd.jpg) ///
savedata(nfd) replace




