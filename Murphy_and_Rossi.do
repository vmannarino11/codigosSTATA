/*******************************************************************************
                   Semana 5: Variables instrumentales 

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
global main "C:\Users\Usuario\OneDrive - Económicas - UBA\Valentin\Códigos\STATA\Limpiar_base"
global input "$main\input"
global output "$main\output"
cd "$main"

* 1) Exercise 1
*==============================================================================*
* Open the database
use "$input\poppy", clear

* Generate the variable Chinese presence -  "Chinese presence, a dummy variable that takes the value one if Chinese population in the municipality is greater than zero".
gen chinese_presence = (chinos1930hoy > 0)


* 2) Exercise 2
*==============================================================================*
* Labels 
label var cartel2005 "Cartel presence 2005"
label var cartel2010 "Cartel presence 2010"
label var chinese_presence "Chinese presence"
label var chinos1930hoy "Chinese population"
label var IM_2015  "Marginalization"
label var Impuestos_pc_mun "Per capita tax revenue"
label var n_index_p "Laakso and Taagepera index"
label var ANALF_2015 "Illiteracy"
label var SPRIM_2015 "Without primary"
label var OVSDE_2015 "Without toilet"
label var OVSEE_2015 "Without electricity"
label var OVSAE_2015 "Without water"
label var VHAC_2015 "Overcrowding"
label var PL5000_2015 "Small localities"
label var OVPT_2015 "Earthen floor"
label var dalemanes "German presence"
label var tempopium "Poppy suitability"
label var distancia_km "Distance to U.S. (km)"
label var distkmDF "Distance to Mexico City (km)"
label var mindistcosta "Min. distance to the coast (km)"
label var capestado "Head of state"
label var POB_TOT_2015 "Population in 2015 (in 000)"
label var superficie_km "Surface (000 km2)"
label var growthperc "Local population growth"
label var TempMed_Anual "Average temperature (Celsius)"
label var PrecipAnual_med "Average precipitation (mm)"
label var densidad "Density"
label var Del_RoboCasa2015 "Del_RoboCasa2015"
label var Del_RoboNegocio2015 "Del_RoboNegocio2015"
label var Del_RoboVehi2015 "Del_RoboVehi2015"
label var ejecuciones "Executions"
label var suitability "Suitability"
label var pob1930cabec "Population 1930"

* Descriptive statistics of the relevant variables
estpost summarize cartel2005 cartel2010 chinese_presence chinos1930hoy IM_2015 Impuestos_pc_mun n_index_p ANALF_2015 SPRIM_2015 OVSDE_2015 OVSEE_2015 OVSAE_2015 VHAC_2015 OVPT_2015 PL5000_2015 dalemanes tempopium distancia_km distkmDF mindistcosta capestado POB_TOT_2015 superficie_km growthperc TempMed_Anual PrecipAnual_med densidad Del_RoboCasa2015 Del_RoboNegocio2015 Del_RoboVehi2015 ejecuciones suitability pob1930cabec,d listwise
esttab using "$output/Table 1.tex", cells("mean sd min max") ///
collabels("Mean" "Standard Deviation" "Min" "Max") nomtitle nonumber replace label 

*Exclude if the state is the Federal District
drop if estado =="Distrito Federal"


* 3) Exercise 3
*==============================================================================*
* Regression with OLS Cartel presence 2010 - chinese_presence
* Without Controls  
reg cartel2010 chinese_presence i.id_estado, cluster(id_estado)
outreg2 using "$output/tabla5.tex", replace label keep (chinese_presence) addtext( State dummies, Yes, Controls, No, Clusters, `e(N_clust)') nocons
* With Controls: German presence, Poppy suitability, Average temperature, Average precipitation, Surface, Population in 1930, Distance to U.S., Distance to Mexico City, Min. distance to the coast, and Head of state.
reg cartel2010 chinese_presence i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado, cluster(id_estado)
outreg2 using "$output/tabla5.tex", append label keep (chinese_presence) addtext( State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons

* Regression with OLS Cartel presence 2005 - chinese_presence
* Without Controls  
reg cartel2005 chinese_presence i.id_estado, cluster(id_estado)
outreg2 using "$output/tabla5.tex", append label keep (chinese_presence) addtext( State dummies, Yes, Controls, No, Clusters, `e(N_clust)') nocons
* With Controls: German presence, Poppy suitability, Average temperature, Average precipitation, Surface, Population in 1930, Distance to U.S., Distance to Mexico City, Min. distance to the coast, and Head of state.
reg cartel2005 chinese_presence i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado, cluster(id_estado)
outreg2 using "$output/tabla5.tex", append label keep (chinese_presence) addtext( State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons tex


* 4) Exercise 4
*==============================================================================*
* Instrumenting the cartel presence variable in 2010 - Table 7
* Controls: German presence, Poppy suitability, Average temperature, Average precipitation, Surface, Population in 1930, Distance to U.S., Distance to Mexico City, Min. distance to the coast, and Head of state.
* First Stage to capture the F-test
* Without Controls and F-test 
reg cartel2010 chinese_presence i.id_estado, cluster(id_estado)
test chinese_presence=0
local F1 = round(r(F), 0.01)

* With Controls and F-test
reg cartel2010 chinese_presence i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado, cluster(id_estado)
test chinese_presence=0
local F2= round(r(F), 0.01)

* With Controls, F-test and excludes municipalities located more than 100 km from U.S. border
reg cartel2010 chinese_presence i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distkmDF mindistcosta capestado if distancia_km >=100, cluster(id_estado)
test chinese_presence=0
local F3= round(r(F), 0.01)

* With Controls, F-test and excludes municipalities located in the state of Sinaloa.
reg cartel2010 chinese_presence i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distkmDF mindistcosta capestado distancia_km if estado != "Sinaloa", cluster(id_estado)
test chinese_presence=0
local F4= round(r(F), 0.01)

* With Controls, F-test and further controls for Local population growth.
reg cartel2010 chinese_presence i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distkmDF mindistcosta capestado distancia_km growthperc, cluster(id_estado)
test chinese_presence=0
local F5= round(r(F), 0.01)

* 2SLS
* Without Controls 2SLS
ivregress 2sls IM_2015 i.id_estado (cartel2010 = chinese_presence), cluster(id_estado) 
outreg2 using "$output/tabla7.tex", replace label keep (cartel2010) addtext(F test , `F1', State dummies, Yes, Controls, No, Clusters, `e(N_clust)') nocons ctitle("Marginalization")

* With Controls 2SLS
ivregress 2sls IM_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado (cartel2010 = chinese_presence), cluster(id_estado)
outreg2 using "$output/tabla7.tex", append label keep (cartel2010) addtext(F test , `F2', State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons ctitle("Basic specification")
 
* With Controls 2SLS and excludes municipalities located more than 100 km from U.S.
ivregress 2sls IM_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distkmDF mindistcosta capestado (cartel2010 = chinese_presence) if distancia_km >= 100, cluster(id_estado)
outreg2 using "$output/tabla7.tex", append label keep (cartel2010) addtext(F test , `F3', State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons ctitle("Marginalization")
 
* With Controls 2SLS and excludes municipalities located in the state of Sinaloa.
ivregress 2sls IM_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distkmDF mindistcosta capestado distancia_km  (cartel2010 = chinese_presence) if estado != "Sinaloa", cluster(id_estado)
outreg2 using "$output/tabla7.tex", append label keep (cartel2010) addtext(F test , `F4', State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons ctitle("Marginalization")

* With Controls 2SLS and further controls for Local population growth.
ivregress 2sls IM_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distkmDF mindistcosta capestado distancia_km growthperc (cartel2010 = chinese_presence), cluster(id_estado)
outreg2 using "$output/tabla7.tex", append label keep (cartel2010) addtext(F test , `F5', State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons ctitle("Marginalization") tex

* Cartel presence and marginalization components - Table 8
* Controls: German presence, Poppy suitability, Average temperature, Average precipitation, Surface, Population in 1930, Distance to U.S., Distance to Mexico City, Min. distance to the coast, and Head of state.

* Iliteracy
ivregress 2sls ANALF_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado (cartel2010 = chinese_presence), cluster(id_estado)
outreg2 using "$output/tabla8.tex", replace label keep (cartel2010) addtext( State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons ctitle("Iliteracy")

* Without primary
ivregress 2sls SPRIM_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado (cartel2010 = chinese_presence), cluster(id_estado)
outreg2 using "$output/tabla8.tex", append label keep (cartel2010) addtext( State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons ctitle("Primary")

* Without toilet
ivregress 2sls OVSDE_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado (cartel2010 = chinese_presence), cluster(id_estado)
outreg2 using "$output/tabla8.tex", append label keep (cartel2010) addtext( State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons ctitle("Without toilet")

* Without electricity
ivregress 2sls OVSEE_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado (cartel2010 = chinese_presence), cluster(id_estado)
outreg2 using "$output/tabla8.tex", append label keep (cartel2010) addtext( State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons ctitle("Without electricity")

* Without water
ivregress 2sls OVSAE_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado (cartel2010 = chinese_presence), cluster(id_estado)
outreg2 using "$output/tabla8.tex", append label keep (cartel2010) addtext( State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons ctitle("Without water")

* Overcrowding
ivregress 2sls VHAC_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado (cartel2010 = chinese_presence), cluster(id_estado)
outreg2 using "$output/tabla8.tex", append label keep (cartel2010) addtext( State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons ctitle("Overcrowding")

* Earthen floor
ivregress 2sls OVPT_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado (cartel2010 = chinese_presence), cluster(id_estado)
outreg2 using "$output/tabla8.tex", append label keep (cartel2010) addtext( State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons ctitle("Earthen floor")

* Small localities
ivregress 2sls PL5000_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado (cartel2010 = chinese_presence), cluster(id_estado)
outreg2 using "$output/tabla8.tex", append label keep (cartel2010) addtext( State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons ctitle("Small localities")

* Low salary
ivregress 2sls PO2SM_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado (cartel2010 = chinese_presence), cluster(id_estado)
outreg2 using "$output/tabla8.tex", append label keep (cartel2010) addtext( State dummies, Yes, Controls, Yes, Clusters, `e(N_clust)') nocons ctitle("Low salary") tex

* 5) Exercise 5
*==============================================================================*
* Test the exogeneity of cartel presence
* With Controls 2SLS
ivregress 2sls IM_2015 i.id_estado dalemanes tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado (cartel2010 = chinese_presence), robust
est store iv
estat endogenous

* 6) Exercise 6
*==============================================================================*
* Basic specification and add the variable 'german presence' as an instrument
* Sargan 
/* The null hypothesis is that all moment conditions are valid. If the test is rejected, you cannot determine which the invalid moment conditions are. 
In this case you cannot reject the null hypothesis: the instruments are exogenous*/
ivregress 2sls IM_2015 i.id_estado tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado (cartel2010 = chinese_presence dalemanes), robust
estat overid

* J-test
/* The overidentifying restriction test statistic is J=mF. 
Under the null hypothesis that all instruments are exogenous, J is distributed Chi-Squared(m-r), where (m-r) is the number of instruments minus the number of endogenous variables */
ivreg2 IM_2015 i.id_estado tempopium TempMed_Anual PrecipAnual_med superficie_km pob1930cabec distancia_km distkmDF mindistcosta capestado (cartel2010 = chinese_presence dalemanes), robust





