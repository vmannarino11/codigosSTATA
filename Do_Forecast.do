/*******************************************************************************
                          Universidad de Buenos Aires
                              Econometría
*******************************************************************************/
 /*
Profesor: Gabriel Montes Rojas
Alumnos: Franco Linardi, Valentin Mannarino y Juan Sebastián Navajas Jauregui
Date: 30/11/2022
*/
/*******************************************************************************/
* 0) Set up environment
*==============================================================================*
clear all
set more off
global main "C:\Users\Usuario\OneDrive - Económicas - UBA\Valentin\Códigos\STATA\Forecast"
global input "$main\input"
global output "$main\output"
cd "$main"

/*******************************************************************************/
* Forecast
*==============================================================================*

* Open the database
import excel "$input\Serie IPC.xlsx" , sheet("Hoja1") firstrow case (lower)                                                       

/*******************************************************************************/
/* 1) Plot the series and perform statistical analysis to determine roots
units, the order of integration, and the presence of seasonality.
For the following questions you must work on the series without trend and seasonally adjusted*/
*==============================================================================* 

* We indicate that we will work with a time series 
tsset tiempo

* We observe a graph of ipc, then we create the variable l'ipc of ipc and we see the graph and then with the first difference
tsline ipc
gen lnipc = ln(ipc)
tsline lnipc
gen dlnipc = D.lnipc
tsline dlnipc

* First we will observe if it has a trend 
gen t = tiempo
gen t2 = t*t
reg dlnipc t t2
predict tendencia
tsline tendencia dlnipc
predict sintend, resid
tsline sintend

/*tsfilter hp ipcciclo=dlnipc, trend(ipctrend)

predict ipctrend 

tsline ipctrend

tsline dlnipc ipcciclo ipctrend 

reg dlnipc ipctrend

predict sinten, resid

tsline sinten*/

* Then we control if it has seasonality
reg sinten i.mes  
predict estacion
predict deses, resid 
tsline deses

* To observe if it has a unit root, we apply the Dickey - Fuller test
dfuller deses

* Does not have a unit root


/*******************************************************************************/
/* 2). Choose the best model for inflation (seasonally adjusted and detrended). Justify.*/
*==============================================================================* 

* We observe the autocorrelation and partial autocorrelation functions
 *Autocorrelation function - for MA 
ac deses

* Partial autocorrelation function - for AR
pac deses

* ARMA (0,0)*
arima deses, arima (0,0,0)

* ARMA (0,0)*
estat ic

* Ar(1)*
arima deses, arima (1,0,0)

* Ar(1)*
estat ic

* MA(1)*
arima deses, arima (0,0,1)

* MA(1)*
estat ic

* ARMA (1,1)*
arima deses, arima (1,0,1)

* ARMA (1,1)*
estat ic

* ARMA (2,2)*
arima deses, arima (2,0,2)

* ARMA (2,2)*
estat ic

* We are left with an AR (1)

/*******************************************************************************/
/* 3). Estimate a model for 2004-2021 and evaluate its prediction for inflation from January to April 2022.
Note: you must then add the trend and seasonality (if any) to the prediction that you removed in the previous point.*/
*==============================================================================* 

* We know that the AR model (1) has the form yt = Phi_0 + Phi_1 * Yt-1 + et
* Ar(1)
arima deses, arima (1,0,0)

* We use the y predicted
predict y_hat

* We generate the errors
gen e = dlnipc - y_hat








