/*******************************************************************************
                          Universidad de Buenos Aires
                              Econometría
*******************************************************************************/
 /*
Profesor: Gabriel Montes Rojas
Alumnos: Franco Linardi, Valentin Mannarino y Juan Sebastián Navajas Jauregui
Date: 10/10/2022
*/
/*******************************************************************************/
* 0) Set up environment
*==============================================================================*
clear all
set more off
global main "C:\Users\Usuario\OneDrive - Económicas - UBA\Valentin\Códigos\STATA\EPH"
global input "$main\input"
global output "$main\output"
cd "$main"

/*******************************************************************************/
* EPH
*==============================================================================*

* Open the database
import excel "$input\ephcombinado.xlsx" , sheet("ephcombinado") firstrow case (lower)

* Identification
lab var codusu "Codigo para distinguir VIVIENDAS"
lab var ano4 "Ano de relevamiento"
lab var trimestre "Ventana de observacion"
lab var region "Codigo de region"
lab def catregion 1 "Gran Buenos Aires"
lab def catregion 40 "Noroeste", add
lab def catregion 41 "Nordeste", add
lab def catregion 42 "Cuyo", add
lab def catregion 43 "Pampeana", add
lab def catregion 44 "Patagonica", add
lab val region catregion
lab var aglomerado "Codigo de Aglomerado"
lab def cataglomerado 2 "Gran La Plata"
lab def cataglomerado 3 "Bahia Blanca - Cerri", add
lab def cataglomerado 4 "Gran Rosario", add
lab def cataglomerado 5 "Gran Santa Fe", add
lab def cataglomerado 6 "Gran Parana", add
lab def cataglomerado 7 "Posadas", add
lab def cataglomerado 8 "Gran Resistencia", add
lab def cataglomerado 9 "Cdro. Rivadavia - R.Tilly", add
lab def cataglomerado 10 "Gran Mendoza", add
lab def cataglomerado 12 "Corrientes", add
lab def cataglomerado 13 "Gran Cordoba", add
lab def cataglomerado 14 "Concordia", add
lab def cataglomerado 15 "Formosa", add
lab def cataglomerado 17 "Neuquen y Plottier", add
lab def cataglomerado 18 "S.del Estero - La Banda", add
lab def cataglomerado 19 "Jujuy - Palpala", add
lab def cataglomerado 20 "Rio Gallegos", add
lab def cataglomerado 22 "Gran Catamarca", add
lab def cataglomerado 23 "Salta", add
lab def cataglomerado 25 "La Rioja", add
lab def cataglomerado 26 "San Luis - El Chorrillo", add
lab def cataglomerado 27 "Gran San Juan", add
lab def cataglomerado 29 "Gran Tucuman - T. Viejo", add
lab def cataglomerado 30 "Santa Rosa - Toay", add
lab def cataglomerado 31 "Ushuaia - Rio Grande", add
lab def cataglomerado 32 "Ciudad de Bs As", add
lab def cataglomerado 33 "Partidos del GBA", add
lab def cataglomerado 34 "Mar del Plata - Batan", add
lab def cataglomerado 36 "Rio Cuarto", add
lab def cataglomerado 38 "San Nicolas ñ Villa Constitucion", add
lab def cataglomerado 91 "Rawson y Trelew", add
lab def cataglomerado 93 "Viedma y Carmen de Patagones", add
lab val aglomerado cataglomerado
lab var pondera "Ponderacion"
lab var ch03 "Relacion de parentesco"
lab def catch03 1 "Jefe/a"
lab def catch03 2 "Conyuge/Pareja",add
lab def catch03 3 "Hijo/Hijastro/a",add
lab def catch03 4 "Yerno/Nuera",add
lab def catch03 5 "Nieto/a",add
lab def catch03 6 "Madre/Padre",add
lab def catch03 7 "Suegro/a",add
lab def catch03 8 "Hermano/a",add
lab def catch03 9 "Otros Familiares",add
lab def catch03 10 "No Familiares",add
lab val ch03 catch03
lab var ch04 "Sexo"
lab def catch04 1 "Varon"
lab def catch04 2 "Mujer", add
lab val ch04 catch04
lab var ch05 "Fecha de nacimiento"
lab var ch06 "Años cumplidos"
lab var ch07 "Actualmente esta...(Estado civil)"
lab def catch07 1 "Unido"
lab def catch07 2 "Casado", add
lab def catch07 3 "Separado/a o divorciado/a", add
lab def catch07 4 "Viudo/a", add
lab def catch07 5 "Soltero/a", add
lab def catch07 9 "Ns./Nr.", add
lab val ch07 catch07
lab var ch10 "Asiste o asistio a algun establecimiento educativo?(colegio, escuela, universidad)"
lab def catch10 1 "Si, asiste"
lab def catch10 2 "No asiste, pero asistio", add
lab def catch10 3 "Nunca asistio", add
lab def catch10 9 "Ns./Nr.", add
lab val ch10 catch10
lab var ch11 "Ese establecimiento es..."
lab def catch11 1 "Publico"
lab def catch11 2 "Privado", add
lab def catch11 9 "Ns./Nr.", add
lab val ch11 catch11
lab var ch12 "Cual es el nivel mas alto que cursa o curso?"
lab def catch12 1 "Jardin/ Preescolar"
lab def catch12 2 "Primario", add
lab def catch12 3 "EGB", add
lab def catch12 4 "Secundario", add
lab def catch12 5 "Polimodal", add
lab def catch12 6 "Terciario", add
lab def catch12 7 "Universitario", add
lab def catch12 8 "Posgrado Univ.", add
lab def catch12 9 "Educacion especial (discapacitado)", add
lab def catch12 99 "Ns./Nr.", add
lab val ch12 catch12
lab var ch13 "Finalizo ese nivel?"
lab def catsn9 1 "Si"
lab def catsn9 2 "No", add
lab def catsn9 9 "Ns./Nr.", add
lab val ch13 catsn9
lab var nivel_ed "Nivel educativo"
lab def catned 1 "Primaria Incompleta(incluye educacion especial)"
lab def catned 2 "Primaria Completa", add
lab def catned 3 "Secundaria Incompleta", add
lab def catned 4 "Secundaria Completa", add
lab def catned 5 "Superior Universitaria Incompleta", add
lab def catned 6 "Superior Universitaria Completa", add
lab def catned 7 "Sin instruccion", add
lab def catned 9 "Ns./ Nr.", add
lab val nivel_ed catned
lab var estado "Condicion de actividad"
lab def catestado 0 "Entrevista individual no realizada (no respuesta al Cuestionario Individual)"
lab def catestado 1 "Ocupado", add
lab def catestado 2 "Desocupado", add
lab def catestado 3 "Inactivo", add
lab def catestado 4 "Menor de 10 aÒos", add
lab val estado catestado
lab var cat_ocup "Categoria ocupacional"
lab def catcatocup 1 "Patron"
lab def catcatocup 2 "Cuenta propia", add
lab def catcatocup 3 "Obrero o empleado", add
lab def catcatocup 4 "Trabajador familiar sin remuneracion", add
lab def catcatocup 9 "Ns./Nr.", add
lab val cat_ocup catcatocup
lab var cat_inac "Categoria de inactividad"
lab def catcatinac 1 "Jubilado/ Pensionado"
lab def catcatinac 2 "Rentista", add
lab def catcatinac 3 "Estudiante", add
lab def catcatinac 4 "Ama de casa", add	
lab def catcatinac 5 "Menor de 6 anos", add
lab def catcatinac 6 "Discapacitado", add
lab def catcatinac 7 "Otros", add
lab val cat_inac catcatinac

* Start analyzing the data

/*******************************************************************************/
* 1) Section 1
*==============================================================================*

* According to the instructions we are left with certain data
* We keep the data of individuals between 25 and 65 years old
keep if ch06>=25 & ch06<=65

* We keep the data of the individuals belonging to the Autonomous City of Buenos Aires
keep if aglomerado==32

* We keep the data of the individuals who are heads of household
keep if ch03==1

* We keep the data of the individual heads of household
keep if cat_ocup==3

* We are left with individuals who have salaries greater than 0
keep if p21>1
                                                                   
* We see a summary of this to see the average in 2021 and 2022														   
summ p21 [w=pondiio] if ano4==2021															   
summ p21 [w=pondiio] if ano4==2022

* We now see the average monthly salary for men and women for 2021 and 2022
bysort ch04: sum p21 [w=pondiio] if	ano4==2021														   
bysort ch04: sum p21 [w=pondiio] if	ano4==2022

* We generate different age ranges to observe salaries
gen rango=1 if ch06>=25 & ch06<35
replace rango=2 if ch06>=35 & ch06<45
replace rango=3 if ch06>=45 & ch06<55
replace rango=4 if ch06>=55 & ch06<=65

* We put different labels
label var rango "edad"
lab def rlab 1 "25-35"
lab def rlab 2 "35-45", add
lab def rlab 3 "45-55", add
lab def rlab 4 "55-65", add
lab val rango rlab

* We observe the average monthly salary of the sample for each age range in 2021 and 2022
table rango [w=pondiio] if ano4==2021 , c (mean p21)		
table rango [w=pondiio] if ano4==2022 , c (mean p21)		

* To observe the same but in a table for 2021 and 2022
bysort rango: sum p21 [w=pondiio] if ano4==2021
bysort rango: sum p21 [w=pondiio] if ano4==2022
                                                                     
/* We chose to use the education variable as a qualitative variable, with pc = completed primary school; si = incomplete secondary school; sc = completed secondary school;
                                                                                 ui = incomplete university; uc = complete university*/
gen pc=1 if nivel_ed==2
replace pc=0 if pc==.
gen si=1 if nivel_ed==3
replace si=0 if si==.
gen sc=1 if nivel_ed==4
replace sc=0 if sc==.
gen ui=1 if nivel_ed==5
replace ui=0 if ui==.
gen uc=1 if nivel_ed==6
replace uc=0 if uc==.

* We generate the gender dummy variable
gen fem=1 if ch04==2
replace fem=0 if fem==.

* The age variable appears as a squared power and assuming that it is continuous
gen ch062=ch06^2

* We use the marital status variable as a dummy represented ep = united and married
gen ep=1 if ch07==1 | ch07==2
replace ep=0 if ep==.

* We run a regression for wage earners to see how education affects wages, keeping gender, marital status, and age constant for the year 2021 and 2022.
reg p21 pc si sc ui uc fem ch06 ch062 ep if ano4==2021
reg p21 pc si sc ui uc fem ch06 ch062 ep if ano4==2022

* We generate a variable logarithm of income
gen lp21=ln(p21) if p21>0
replace lp21=0 if lp21==.

* We run the regression but now with salary as a logarithm variable for the year 2021 and 2022
reg lp21 pc si sc ui uc fem ch06 ch062 ep if ano4==2021
reg lp21 pc si sc ui uc fem ch06 ch062 ep if ano4==2022

* We generate the interactions that consist of the multiplication of the female dummy and each educational level
gen fpc=fem*pc
gen fsi=fem*si
gen fsc=fem*sc
gen fui=fem*ui
gen fuc=fem*uc

* We run the regression for the year 2021 and 2022
reg lp21 pc si sc ui uc fem fpc fsi fsc fui fuc ch06 ch062 ep if ano4==2021
reg lp21 pc si sc ui uc fem fpc fsi fsc fui fuc ch06 ch062 ep if ano4==2022

* We observe the sample according to educational level, separating by sex for the year 2021 and 2022
table nivel_ed ch04 if ano4==2021
table nivel_ed ch04 if ano4==2022

* We create a table to observe the average income according to educational level and sex for the year 2021 and 2022
table nivel_ed ch04 if ano4==2021 , c (mean p21)
table nivel_ed ch04 if ano4==2022 , c (mean p21)

* We run a registry of income, educational level, sex, age, ageˆ2 and marital status for the year 2021 of the first quarter
reg p21 pc si sc ui uc fem ch06 ch062 ep if ano4==2021

* estimated salary
predict sestimado

* We created a table to observe the estimated average salary with completed university education and married, for both sexes for the year 2021 of the first quarter.
table ch04 if ano4==2021 & nivel_ed==6 & ch07==2 , c (mean sestimado)

* We create the same table but now for all possible cases of age between 25-65 for the year 2021 of the first quarter
table ch06 ch04 if ano4==2021 & nivel_ed==6 & ch07==2 , c (mean sestimado)

* We create the same table but for all possible age ranges for the year 2021 of the first quarter
table rango ch04 if ano4==2021 & nivel_ed==6 & ch07==2 , c (mean sestimado)

* We generate the necessary variables to graph a positive and negative standard error with respect to the mean
gen psd=sestimado+66516
gen nsd=sestimado-66516
lab var psd "Error Estim +"
lab var nsd "Error estim -"

* Male
twoway line sestimado ch06 if ano4==2021 & nivel_ed==6 & ch07==2 & ch04==1 || scatter p21 ch06 if ano4==2021 & nivel_ed==6 & ch07==2 & ch04==1  || line psd ch06 if ano4==2021 & nivel_ed==6 & ch07==2 & ch04==1 || line nsd ch06 if ano4==2021 & nivel_ed==6 & ch07==2 & ch04==1

* Female
twoway line sestimado ch06 if ano4==2021 & nivel_ed==6 & ch07==2 & ch04==2 || scatter p21 ch06 if ano4==2021 & nivel_ed==6 & ch07==2 & ch04==2  || line psd ch06 if ano4==2021 & nivel_ed==6 & ch07==2 & ch04==2 || line nsd ch06 if ano4==2021 & nivel_ed==6 & ch07==2 & ch04==2

* Predict 
twoway line sestimado ch06 if ano4==2021 & nivel_ed==6 & ch07==2 & ch04==1 || scatter p21 ch06 if ano4==2021 & nivel_ed==6 & ch07==2 & ch04==1  || line sestimado ch06 if ano4==2021 & nivel_ed==6 & ch07==2 & ch04==2 || scatter p21 ch06 if ano4==2021 & nivel_ed==6 & ch07==2 & ch04==2 

/* To calculate each person's salary we must take into account the variables:
p21= -58819.85(constant) + 41299.1*1 (completed university)+ -18256.82 * 0 (male) + 3548.38 * age + -34.11837 * age squared + 21528.94 * 1 (if you are united/married)*/

* Franco $67572.312
display -58819.85 + 41299.1*1 +  -18256.82  * 0  + 3548.38 * 23 + -34.11837 * 529 +  21528.94 * 1 

* Juanse $71393.709
display -58819.85 + 41299.1*1 +  -18256.82  * 0  + 3548.38 * 25 + -34.11837 * 625 +  21528.94 * 1

* Tadeo $44030.319
display -58819.85 + 41299.1*1 +  -18256.82  * 0  + 3548.38 * 22 + -34.11837 * 484 +  21528.94 * 0

* Valentin $65559.259
display -58819.85 + 41299.1*1 +  -18256.82  * 0  + 3548.38 * 22 + -34.11837 * 484 +  21528.94 * 1

* We run a registry of income, educational level, sex, age, ageˆ2 and marital status for the year 2022 of the first quarter
reg p21 pc si sc ui uc fem ch06 ch062 ep if ano4==2022

* Estimated salary
predict sestimado2

* We created a table to observe the estimated average salary with completed university education and married, for both sexes for the year 2022 of the first quarter
table ch04 if ano4==2022 & nivel_ed==6 & ch07==2 , c (mean sestimado2)

* We create the same table but now for all possible cases of age between 25-65 for the year 2022 of the first quarter
table ch06 ch04 if ano4==2022 & nivel_ed==6 & ch07==2 , c (mean sestimado2)

* We create the same table but for all possible age ranges for the year 2022 of the first quarter
table rango ch04 if ano4==2022 & nivel_ed==6 & ch07==2 , c (mean sestimado2)

* We generate the necessary variables to graph a positive and negative standard error with respect to the mean
gen psd2=sestimado2+115039
gen nsd2=sestimado2-115039
lab var psd2 "Error Estim +"
lab var nsd2 "Error estim -"

* Male
twoway line sestimado2 ch06 if ano4==2022 & nivel_ed==6 & ch07==2 & ch04==1 || scatter p21 ch06 if ano4==2022 & nivel_ed==6 & ch07==2 & ch04==1  || line psd2 ch06 if ano4==2022 & nivel_ed==6 & ch07==2 & ch04==1 || line nsd2 ch06 if ano4==2022 & nivel_ed==6 & ch07==2 & ch04==1

* Female
twoway line sestimado2 ch06 if ano4==2022 & nivel_ed==6 & ch07==2 & ch04==2 || scatter p21 ch06 if ano4==2022 & nivel_ed==6 & ch07==2 & ch04==2  || line psd2 ch06 if ano4==2022 & nivel_ed==6 & ch07==2 & ch04==2 || line nsd2 ch06 if ano4==2022 & nivel_ed==6 & ch07==2 & ch04==2

* Predict
twoway line sestimado2 ch06 if ano4==2022 & nivel_ed==6 & ch07==2 & ch04==1 || scatter p21 ch06 if ano4==2022 & nivel_ed==6 & ch07==2 & ch04==1  || line sestimado2 ch06 if ano4==2022 & nivel_ed==6 & ch07==2 & ch04==2 || scatter p21 ch06 if ano4==2022 & nivel_ed==6 & ch07==2 & ch04==2 
 
/*To calculate each person's salary we must take into account the variables:
p21= 9565.047 (constant) + 88941.69*1 (full university student)+ -31166.78 * 0 (male) + 946.4528 * age + .2351816 * age squared + 6819.971 * 1 (if you are united/married)*/

* Franco $127219.53
display 9565.047 + 88941.69*1 +  -31166.78 * 0  + 946.4528 * 23 + .2351816 * 529 +   6819.971 * 1 

* Juanse $129135.02
display 9565.047 + 88941.69*1 +  -31166.78 * 0  + 946.4528 * 25 + .2351816 * 625 +   6819.971 * 1 

* Tadeo $119442.53
display 9565.047 + 88941.69*1 +  -31166.78 * 0  + 946.4528 * 22 + .2351816 * 484 +   6819.971 * 0 

* Valentin $126262.5
display 9565.047 + 88941.69*1 +  -31166.78 * 0  + 946.4528 * 22 + .2351816 * 484 +   6819.971 * 1

/*******************************************************************************/
* 2) Section 2
*==============================================================================*

* Import
use "$input\jtpa", clear	
															 
* Identification
lab var earnings "ingresos acumulados en 30 meses"
lab var jtpa_offer "Obtuvieron la oferta de la capacitacion"
lab var jtpa_training "Realizaron la capacitacion"
lab def catjtpa_training 0 "No"
lab def catjtpa_training 1 "Si", add
lab val jtpa_training catjtpa_training
lab var sex "Sexo"
lab def catsex 0 "Mujer"
lab def catsex 1 "Varon", add
lab val sex catsex
lab var hsorged "secundaria completa"
lab var black "Black"
lab var hispanic "Hispanic"
lab var married "Casado/a"
lab var wkless13 "Trabajaron menos de 13 semanas el ultimo año"
lab var age2225 "Rango 22-25 años"
lab var age2629 "Rango 26-29 años"
lab var age3035 "Rango 30-35 años"
lab var age3644 "Rango 36-44 años"
lab var age4554 "Rango 45-54 años"

* We generate the logarithmic variable
gen logingresos = log(earnings)

* We run the regression in the levels and logarithm models
reg earnings jtpa_training
reg logingresos jtpa_training

* We run the model lin-lin and log - lin controlling by sex hsorged black hispanic married wkless13
reg earnings jtpa_training sex hsorged black hispanic married wkless13 
reg logingresos jtpa_training sex hsorged black hispanic married wkless13 

* We generate an interaction variable between sex and jtpa_training
gen sextrai = sex*jtpa_training

* We run the lin-lin and log-lin regression with the new variable
reg earnings jtpa_training sex sextrai hsorged black hispanic married wkless13 
reg logingresos jtpa_training sex sextrai hsorged black hispanic married wkless13 

* We show a table to observe the differences
table jtpa_training sex , c(mean earnings)

* We run the regression of the instrumental variable of the first stage
ivregress 2sls logingresos (jtpa_training=jtpa_offer), first 

* We observe the significance, we need a statistic greater than 10
estat firststage

* We run the regression
ivregress 2sls logingresos sex sextrai hsorged black hispanic married wkless13 (jtpa_training=jtpa_offer), first

* We observe the significance, we need a statistic greater than 10
estat firststage 

* We run the regression of the instrumental variable of the first stage
ivregress 2sls earnings (jtpa_training=jtpa_offer), first 

* We observe the significance, we need a statistic greater than 10
estat firststage

* We run the regression
ivregress 2sls earnings (jtpa_training=jtpa_offer) sex sextrai hsorged black hispanic married wkless13, first 

* We observe the significance, we need a statistic greater than 10
estat firststage 
