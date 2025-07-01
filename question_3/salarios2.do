*************
* ARGENTINA *
************* 
clear
cls
global eph = "D:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Argentina\salarios_2019-2022\"

*scalar ppp_2011 = 2.73

scalar ipc_t419 = 3787.81948389623
scalar ipc_t120 = 4202.12297043626
scalar ipc_t220 = 4465.25957111728
scalar ipc_t320 = 4784.84524266065
scalar ipc_t420 = 5341.72860817634
scalar ipc_t121 = 6130.97206585114
scalar ipc_t221 = 6838.41578184711
scalar ipc_t321 = 7442.38363838393
scalar ipc_t421 = 8152.27117693775
scalar ipc_t122 = 9366.42164990277
scalar ipc_t222 = 11019.5911686535
scalar ipc_t322 = 13196.3491360086


foreach x in t419 t120 t220 t320 t420 t121 t221 t321 t421 t122 t222 {

cap noi use "$eph\usu_individual_`x'.dta", clear
*gen ppp=2.768382
*gen ipc=ipc_`x'
*keep ano4 ch04 p21 tot_p12 pp07h pp03c estado cat_ocup ppp ipc pondera
keep ano4 ch04 p21 tot_p12 pp07h pp03c estado cat_ocup pondera
rename ch04 sexo

gen fac=pondera

*Recuperación de ingresos por rangos de salarios mínimos;
replace p21=. if p21==-9
replace tot_p12=. if p21==-9
egen ingreso = rsum(p21 tot_p12), missing
cap noi replace pp03c="." if pp03c=="NA"
cap noi destring pp03c, replace
gen ocupado=1 if estado==1
/*
gen cotiza1=1 		if pp07h==1	
gen asalariado=1	if estado==1 & cat_ocup==3	
gen formal=0 		if asalariado==1		
replace formal=1	if cotiza1==1 & asalariado==1
label define formal 0 "Informal" 1 "Formal"
label value formal formal 

g ingreso_real=ingreso/ppp/ipc
label var ingreso_real "Ingreso laboral monetario total a US$PPP(2011)"
*/
*gen inflacion= ipc_`x'/ipc_2011

gen fr_`x'=ipc_t419/ipc_`x'

gen ingreso_real=ingreso*(fr_`x')

*sum ingreso if ocupado==1 & ingreso>0 & sexo==2 [iw=fac]

*tab ocupado if ocupado==1 & ingreso>0 [iw=fac]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==2 [iw=fac]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==1 [iw=fac]

*sum ingreso_real if ocupado==1 & ingreso_real>0 [iw=fac]
*sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==2 [iw=fac]
sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==1 [iw=fac]
}




* BOLIVIA
**********
clear
cls
cd "D:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Bolivia\urbano"

scalar ipc_4T2019 = 104.579455647133
scalar ipc_1T2020 = 103.8501204838
scalar ipc_2T2020 = 104.4500468832
scalar ipc_3T2020 = 104.865034294467
scalar ipc_4T2020 = 104.522011455133
scalar ipc_1T2021 = 105.142350089967
scalar ipc_2T2021 = 104.9376462765
scalar ipc_3T2021 = 105.341338201467
scalar ipc_4T2021= 105.3413657597
scalar ipc_1T2022 = 105.918959570867
scalar ipc_2T2022 = 106.3620792672


foreach x in   4T2019 1T2020 2T2020 3T2020 4T2020 1T2021 2T2021 3T2021 4T2021 1T2022 2T2022{ 

use ECE_`x'_URB.dta, clear

*Se eliminan a los trabajadores domésticos y del hogar; 
drop if s1_05==10 | s1_05==11 | s1_05==12

gen fac=fact_trim

*Recuperación de ingresos por rangos de salarios mínimos;
gen ingreso = ylab
rename fac factor

*generando la variable ocupados
gen ocupado=cond(condact==1,1,0)

gen mv=cond(ingreso==. & ocupado==1,1,0)
rename s1_02 sexo
keep ingreso sexo factor mv ocupado

*Se eliminan a los hogares que tienen valores perdidos en ingreso;
replace mv=1 if mv>0 & mv!=.
drop if mv==1

gen fr_`x'=ipc_4T2019/ipc_`x'

gen ingreso_real=ingreso*(fr_`x')

*sum ingreso if ocupado==1 & ingreso>0 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]

*tab ocupado if ocupado==1 & ingreso>0 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
tab ocupado if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]


*sum ingreso_real if ocupado==1 & ingreso_real>0 [iw=fac]
*sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==2 [iw=fac]
*sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==1 [iw=fac]

}



* BRASIL
*********

cd "D:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Brasil\2019-2022"

scalar ipc_t042019 = 5271.02666666667
scalar ipc_t012020 = 5341.55333333333
scalar ipc_t022020 = 5323.00666666667
scalar ipc_t032020 = 5364.61333333333
scalar ipc_t042020 = 5495.07666666667
scalar ipc_t012021 = 5623.88
scalar ipc_t022021 = 5733.95
scalar ipc_t032021 = 5881.87666666667
scalar ipc_t042021 = 6071.41333333333
scalar ipc_t012022 = 6228.08666666667
scalar ipc_t022022 = 6417.20333333333
scalar ipc_t032022 = 6390.38666666667


foreach x in t042019 t012020 t022020 t032020 t042020 t012021 t022021 t032021 t042021 t012022 t022022 t032022 { 

use PNADC_`x'.dta, clear

//Se eliminan a los trabajadores domésticos y del hogar; 
keep if V2005!=18

gen fac=V1028

*Recuperación de ingresos por rangos de salarios mínimos;
gen ingreso=VD4020

rename fac factor
gen ocupado=VD4002
gen mv=cond(ingreso==. & ocupado==1,1,0)
rename V2007 sexo
keep ingreso sexo factor mv ocupado

*Se eliminan a los hogares que tienen valores perdidos en ingreso;
replace mv=1 if mv>0 & mv!=.
drop if mv==1

gen fr_`x'=ipc_t042019/ipc_`x'
gen ingreso_real=ingreso*(fr_`x')

*sum ingreso if ocupado==1 & ingreso>0 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]

*tab ocupado if ocupado==1 & ingreso>0 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]

*sum ingreso_real if ocupado==1 & ingreso_real>0 [iw=fac]
*sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==2 [iw=fac]
sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==1 [iw=fac]
}



* CHILE 
********

cd "D:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Chile\2018-2022"

scalar ipc_19 = 103.560
scalar ipc_20 = 106.547
scalar ipc_21 = 113.613

foreach x in 19 20 21 { 
    
use ene_esi_`x'.dta, clear
    
*Generando la condición de actividad;
gen ocupado=cond(activ==1,1,0)

*Recuperación de ingresos por rangos de salarios mínimos;
gen ingreso=ing_t_t
gen tamh = 1
rename fact_cal_esi factor

gen mv=cond(ingreso==. & ocupado==1,1,0)
keep ingreso sexo factor mv ocupado

*Se eliminan a los hogares que tienen valores perdidos en ingreso;
replace mv=1 if mv>0 & mv!=.
drop if mv==1

gen fr_`x'=ipc_19/ipc_`x'
gen ingreso_real=ingreso*(fr_`x')

*sum ingreso if ocupado==1 & ingreso>0 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]

*tab ocupado if ocupado==1 & ingreso>0 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]


*sum ingreso_real if ocupado==1 & ingreso_real>0 [iw=factor]
*sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==2 [iw=factor]
sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==1 [iw=factor]
}



* MEXICO 
*********


cd "D:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Mexico\2019-2022"

scalar ipc_t419=105.261
scalar ipc_t120=106.724
scalar ipc_t220=106.220
scalar ipc_t320=107.808
scalar ipc_t420=108.967
scalar ipc_t121=110.980
scalar ipc_t221=112.542
scalar ipc_t321=114.060
scalar ipc_t421=116.584
scalar ipc_t122=119.047
scalar ipc_t222=121.291
scalar ipc_t322=123.774


 foreach x in t419 t120 t220 t320 t420 t121 t221 t321 t421 t122 t222 t322{
     
	 use enoe`x'.dta, clear
	 
cap noi rename ocupado  employed  
gen ocupado=cond(clase1==1 & clase2==1,1,0)

destring p6b2 p6c p6_9 p6a3 p6c p6b2, replace
recode p6b2 (999998=.) (999999=.)

*Recuperación de ingresos por rangos de salarios mínimos;
gen ingreso=p6b2
replace ingreso=0 if ocupado==0
replace ingreso=0 if p6b2==. & (p6_9==9 | p6a3==3)
replace ingreso=0.5*salario if p6b2==. & p6c==1
replace ingreso=1*salario if p6b2==. & p6c==2
replace ingreso=1.5*salario if p6b2==. & p6c==3
replace ingreso=2.5*salario if p6b2==. & p6c==4
replace ingreso=4*salario if p6b2==. & p6c==5
replace ingreso=7.5*salario if p6b2==. & p6c==6
replace ingreso=10*salario if p6b2==. & p6c==7

cap noi rename fac_tri factor
cap noi rename fac factor 
destring ent, replace

gen mv=cond(ingreso==. & ocupado==1,1,0)
cap noi destring sex, replace
rename sex sexo

gen fr_`x'=ipc_t419/ipc_`x'
gen ingreso_real=ingreso*(fr_`x')

keep  ingreso ingreso_real sexo factor ent mv ocupado



*sum ingreso if ocupado==1 & ingreso>0 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]

*tab ocupado if ocupado==1 & ingreso>0 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]
 
*sum ingreso_real if ocupado==1 & ingreso_real>0 [iw=factor]
*sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==2 [iw=factor]
sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==1 [iw=factor]
 
 }
 

**************
* COSTA RICA *
************** 
cls
global ece = "D:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Costa Rica\2010_2022\"

scalar ipc_t419 = 99.1239776417608
scalar ipc_t120 = 99.4043830230606
scalar ipc_t220 = 98.9373439614232
scalar ipc_t320 = 99.2150459091168
scalar ipc_t420 = 99.6490551599639
scalar ipc_t121 = 100.015787323161
scalar ipc_t221 = 100.407943053117
scalar ipc_t321 = 100.951870337046
scalar ipc_t421 = 102.688283272694
scalar ipc_t122 = 104.745108100376
scalar ipc_t222 = 109.086094954227
scalar ipc_t322 = 112.382065264805

foreach x in t419 t120 t220 t320 t420 t121 t221 t321 t421 t122 t222 t322 {

use "$ece\`x'.dta" , clear

*gen ppp=349.407

*gen ipc=ipc_`x'
*gen anio=id_amo


*Recuperación de ingresos por rangos de salarios mínimos;
gen ingreso=ingreso_total
rename factor_ponderacion factor

*gen ocupado=1 if ocupado==1
/*
gen asalariado=1 if posicion_empleo==1

gen formal=1 if formalidad_informalidad==1
replace formal=0 if formalidad_informalidad==2
label define formal 0 "Informal" 1 "Formal"
label value formal formal 

keep anio ingreso ocupado asalariado formal factor ppp ipc 

g ingreso_real=ingreso/ppp/ipc
label var ingreso_real "Ingreso laboral monetario total a US$PPP(2011)"

cap noi save"$ece\cri_`x'.dta", replace
*/

gen fr_`x'=ipc_t419/ipc_`x'
gen ingreso_real=ingreso*(fr_`x')

keep ingreso ingreso_real sexo ocupado factor 

*sum ingreso if ocupado==1 & ingreso>0 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]

*tab ocupado if ocupado==1 & ingreso>0 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]

*sum ingreso_real if ocupado==1 & ingreso_real>0 [iw=factor]
*sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==2 [iw=factor]
sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==1 [iw=factor]

}




**************
*    PERU    *
************** 
cls
global epe = "D:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Peru\2019-2022\"

scalar  ipc_t1219 = 92.1399925330876
scalar  ipc_t0120 = 92.1895712817569
scalar  ipc_t0220 = 92.3206390707161
scalar  ipc_t0320 = 92.9170303880033
scalar  ipc_t0420 = 93.0142055130683
scalar  ipc_t0520 = 93.204097335048
scalar  ipc_t0620 = 92.9560841633195
scalar  ipc_t0720 = 93.3861811793687
scalar  ipc_t0820 = 93.2832332195989
scalar  ipc_t0920 = 93.4104286127018
scalar  ipc_t1020 = 93.4260987274024
scalar  ipc_t1120 = 93.9123624949692
scalar  ipc_t1220 = 93.9581285619732
scalar  ipc_t0121 = 94.6561451002628
scalar  ipc_t0221 = 94.5375735473133
scalar  ipc_t0321 = 95.3311869507106
scalar  ipc_t0421 = 95.2313830125361
scalar  ipc_t0521 = 95.4852294275117
scalar  ipc_t0621 = 95.9814390796482
scalar  ipc_t0721 = 96.948489573628
scalar  ipc_t0821 = 97.9033694822447
scalar  ipc_t0921 = 98.2953966184284
scalar  ipc_t1021 = 98.8691125131803
scalar  ipc_t1121 = 99.2232454403164
scalar  ipc_t1221 = 100
scalar  ipc_t0122 = 100.037268
scalar  ipc_t0222 = 100.34884
scalar  ipc_t0322 = 101.836672
scalar  ipc_t0422 = 102.816232
scalar  ipc_t0522 = 103.211072
scalar  ipc_t0622 = 104.439931
scalar  ipc_t0722 = 105.422597
scalar  ipc_t0822 = 106.125283
scalar  ipc_t0922 = 106.679849
scalar  ipc_t1022 = 107.050724


foreach x in t1219 t0120 t0220 t0320 t0420 t0520 t0620 t0720 t0820 t0920 t1020 t1120 t1220 t0121 t0221 t0321 t0421 t0521 t0621 t0721 t0821 t0921 t1021 t1121 t1221 t0122 t0222 t0322 t0422 t0522 t0622 t0722 t0822 t0922 t1022 {

use "$epe\EPE_`x'.dta" , clear

*gen ppp=1.57918
*gen ipc=ipc_`x'
*destring pano, gen(anio)


*Recuperación de ingresos por rangos de salarios mínimos;
gen ingreso = ingtot
rename facexp factor
cap noi rename p107 sexo
cap noi rename c207 sexo
cap noi rename ocup300 ocu200

gen ocupado=1 if ocu200==1
/*
gen asalariado=1 if p206==3 | p206==4

gen cotiza=1 if p222==1

gen formal=0 if asalariado==1
replace formal=1 if cotiza==1 & asalariado==1
label define formal 0 "Informal" 1 "Formal"
label value formal formal 

keep anio ingreso ocupado asalariado formal factor ppp ipc 

g ingreso_real=ingreso/ppp/ipc
label var ingreso_real "Ingreso laboral monetario total a US$PPP(2011)"

cap noi save"$epe\per_`x'.dta", replace
*/
gen fr_`x'=ipc_t1219/ipc_`x'
gen ingreso_real=ingreso*(fr_`x')

*sum ingreso if ocupado==1 & ingreso>0 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]

*tab ocupado if ocupado==1 & ingreso>0 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]

*sum ingreso_real if ocupado==1 & ingreso_real>0 [iw=factor]
*sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==2 [iw=factor]
sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==1 [iw=factor]
}




**************
*  URUGUAY   *
************** 
global ech = "D:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Uruguay\2019-2022\"

scalar  ipc_t1219 = 203.02
scalar  ipc_t0120 = 207.27
scalar  ipc_t0220 = 208.54
scalar  ipc_t0320 = 211.32
scalar  ipc_t0420 = 215.54
scalar  ipc_t0520 = 216.76
scalar  ipc_t0620 = 216.8
scalar  ipc_t0720 = 217.99
scalar  ipc_t0820 = 219.24
scalar  ipc_t0920 = 220.64
scalar  ipc_t1020 = 221.92
scalar  ipc_t1120 = 222.55
scalar  ipc_t1220 = 222.13
scalar  ipc_t0121 = 225.69
scalar  ipc_t0221 = 227.55
scalar  ipc_t0321 = 228.95
scalar  ipc_t0421 = 230.1
scalar  ipc_t0521 = 231.15
scalar  ipc_t0621 = 232.69
scalar  ipc_t0721 = 233.9
scalar  ipc_t0821 = 235.89
scalar  ipc_t0921 = 236.98
scalar  ipc_t1021 = 239.44
scalar  ipc_t1121 = 240.05
scalar  ipc_t1221 = 239.81
scalar  ipc_t0122 = 244.09
scalar  ipc_t0222 = 247.68
scalar  ipc_t0322 = 250.42
scalar  ipc_t0422 = 251.65
scalar  ipc_t0522 = 252.82
scalar  ipc_t0622 = 254.3

foreach x in t1219 t0120 t0220 t0320 t0420 t0520 t0620 t0720 t0820 t0920 t1020 t1120 t1220 t0121 t0221 t0321 t0421 t0521 t0621 t0721 t0821 t0921 t1021 t1121 t1221 t0122 t0222 t0322 t0422 t0522 t0622 {

use "$ech\ECH_`x'.dta" , clear

*gen ppp=16.60844
*gen ipc=ipc_`x'
*destring anio, replace


*Recuperación de ingresos por rangos de salarios mínimos;
destring pt4, replace
gen ingreso = pt4 if pt4>0
cap noi rename pesomen factor
*cap noi rename pesotri factor
cap noi gen factor=w_tri*3
rename e26 sexo

gen ocupado=1 if pobpcoac==2
/*
gen asalariado=1 if f73==1 | f73==2

gen cotiza=1 if f82==1

gen formal=0 if asalariado==1
replace formal=1 if cotiza==1 & asalariado==1
label define formal 0 "Informal" 1 "Formal"
label value formal formal 

keep anio ingreso ocupado asalariado formal factor ppp ipc 

g ingreso_real=ingreso/ppp/ipc
label var ingreso_real "Ingreso laboral monetario total a US$PPP(2011)"

cap noi save"$ech\ury_`x'.dta", replace
*/

gen fr_`x'=ipc_t1219/ipc_`x'
gen ingreso_real=ingreso*(fr_`x')


*sum ingreso if ocupado==1 & ingreso>0 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]

*tab ocupado if ocupado==1 & ingreso>0 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]

*sum ingreso_real if ocupado==1 & ingreso_real>0 [iw=factor]
*sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==2 [iw=factor]
sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==1 [iw=factor]
}



*******************************************************

/*
p7028 ¿En su empleo anterior ..... era: 

a. Obrero o empleado de empresa particular? 
b. Obrero o empleado del gobierno? 
c. Empleado doméstico? 
d. Trabajador por cuenta propia?
e. Patrón o empleador? 
f. Trabajador familiar sin remuneración? 
g. Trabajador sin remuneración en empresas o negocios de otros hogares? 
h. Jornalero o peón? 
i. Otro


P6920 ¿Está... cotizando actualmente a un fondo de pensiones? 
1 Sí 
2 No 
3 Ya es pensionado
*/

**************
*  COLOMBIA  *
************** 
global geih = "D:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Colombia\2019-2022\"


foreach x in 12_2019 1_2020 2_2020 3_2020 4_2020 5_2020 6_2020 7_2020 8_2020 9_2020 10_2020 11_2020 12_2020 1_2021 2_2021 3_2021 4_2021 5_2021 6_2021 7_2021 8_2021 9_2021 10_2021 11_2021 12_2021 1_2022 2_2022 3_2022 4_2022 5_2022 6_2022 7_2022 8_2022 9_2022  {
    
	use "$geih\ocup_`x'.dta" , clear
	tostring directorio secuencia_p orden hogar area, replace
	gen str foliop = (directorio + secuencia_p + orden + hogar + area)
	keep foliop inglabo oci p7028 p6920
	sort foliop
	save "$geih\ingreso_`x'.dta", replace
	
	
	use "$geih\cgp_`x'.dta", clear 
	*Se eliminan a los trabajadores domésticos y del hogar
	keep if p6050!=6 & p6050!=8
	tostring directorio secuencia_p orden hogar area, replace
	gen str foliop = (directorio + secuencia_p + orden + hogar + area)
	gen str folioh = (directorio + secuencia_p + hogar + area)
	
	cap noi rename p3271 p6020
	cap noi rename p6020 sexo
	cap noi gen fac=fex_c_2011
	cap noi gen fac=fex_c18
	keep folioh foliop fac p6050 sexo
	sort foliop
	merge foliop using "$geih\ingreso_`x'.dta"
	tab _merge
	drop _merge
	
	save "$geih\geih_`x'.dta", replace
}



scalar ipc_12_2019 = 103.8
scalar ipc_1_2020 = 104.24
scalar ipc_2_2020 = 104.94
scalar ipc_3_2020 = 105.53
scalar ipc_4_2020 = 105.7
scalar ipc_5_2020 = 105.36
scalar ipc_6_2020 = 104.97
scalar ipc_7_2020 = 104.97
scalar ipc_8_2020 = 104.96
scalar ipc_9_2020 = 105.29
scalar ipc_10_2020 = 105.23
scalar ipc_11_2020 = 105.08
scalar ipc_12_2020 = 105.48
scalar ipc_1_2021 = 105.91
scalar ipc_2_2021 = 106.58
scalar ipc_3_2021 = 107.12
scalar ipc_4_2021 = 107.76
scalar ipc_5_2021 = 108.84
scalar ipc_6_2021 = 108.78
scalar ipc_7_2021 = 109.14
scalar ipc_8_2021 = 109.62
scalar ipc_9_2021 = 110.04
scalar ipc_10_2021 = 110.06
scalar ipc_11_2021 = 110.6
scalar ipc_12_2021 = 111.41
scalar ipc_1_2022 = 113.26
scalar ipc_2_2022 = 115.11
scalar ipc_3_2022 = 116.26
scalar ipc_4_2022 = 117.71
scalar ipc_5_2022 = 118.7
scalar ipc_6_2022 = 119.31
scalar ipc_7_2022 = 120.27
scalar ipc_8_2022 = 121.5
scalar ipc_9_2022 = 122.63

foreach x in 12_2019 1_2020 2_2020 3_2020 4_2020 5_2020 6_2020 7_2020 8_2020 9_2020 10_2020 11_2020 12_2020 1_2021 2_2021 3_2021 4_2021 5_2021 6_2021 7_2021 8_2021 9_2021 10_2021 11_2021 12_2021 1_2022 2_2022 3_2022 4_2022 5_2022 6_2022 7_2022 8_2022 9_2022 {
    
	use "$geih\geih_`x'.dta", clear
	
*Ingresos
destring inglabo, replace
destring fac, replace dpcomma
gen ingreso = inglabo if inglabo>0
rename fac factor

gen ocupado=1 if oci==1

/*
gen asalariado=1 if p7028==1 | p7028==2

gen cotiza=1 if p6920==1

gen formal=0 if asalariado==1
replace formal=1 if cotiza==1 & asalariado==1
label define formal 0 "Informal" 1 "Formal"
label value formal formal 

keep anio ingreso ocupado asalariado formal factor ppp ipc 

g ingreso_real=ingreso/ppp/ipc
label var ingreso_real "Ingreso laboral monetario total a US$PPP(2011)"
*/

gen fr_`x'=ipc_12_2019/ipc_`x'
gen ingreso_real=ingreso*(fr_`x')

*sum ingreso if ocupado==1 & ingreso>0 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*sum ingreso if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]

*tab ocupado if ocupado==1 & ingreso>0 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==2 [iw=factor]
*tab ocupado if ocupado==1 & ingreso>0 & sexo==1 [iw=factor]

*sum ingreso_real if ocupado==1 & ingreso_real>0 [iw=factor]
*sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==2 [iw=factor]
sum ingreso_real if ocupado==1 & ingreso_real>0 & sexo==1 [iw=factor]
	
}



* Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre
global geih = "E:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Colombia\2019\"
foreach x in Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
    
    import delimited "$geih\`x'\Resto - Desocupados.csv", clear
	save "$geih\`x'\Resto - Desocupados.dta", replace
	
	import delimited "$geih\`x'\Cabecera - Desocupados.csv", clear
	save "$geih\`x'\Cabecera - Desocupados.dta", replace
	append using "$geih\`x'\Resto - Desocupados.dta", force
	save "$geih\`x'\desoc_`x'.dta", replace	
	}
	
	
global geih = "E:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Colombia\2020\"
foreach x in Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
    
    use "$geih\`x'\Resto - Desocupados.dta", clear
	append using "$geih\`x'\Resto - Desocupados.dta", force
	save "$geih\`x'\desoc_`x'.dta", replace	
	}

global geih = "E:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Colombia\2021\"
foreach x in Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
    
    use "$geih\`x'\Resto - Desocupados.dta", clear
	append using "$geih\`x'\Resto - Desocupados.dta", force
	save "$geih\`x'\desoc_`x'.dta", replace	
	}






global geih = "E:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Colombia\2019-2022\"


foreach x in 12_2019 1_2020 2_2020 3_2020 4_2020 5_2020 6_2020 7_2020 8_2020 9_2020 10_2020 11_2020 12_2020 1_2021 2_2021 3_2021 4_2021 5_2021 6_2021 7_2021 8_2021 9_2021 10_2021 11_2021 12_2021 1_2022 2_2022 3_2022 4_2022 5_2022 6_2022 7_2022 8_2022 9_2022  {
    
	use "$geih\ocup_`x'.dta" , clear
	tostring directorio secuencia_p orden hogar area, replace
	gen str foliop = (directorio + secuencia_p + orden + hogar + area)
	keep foliop inglabo oci p7028 p6920
	sort foliop
	save "$geih\ingreso_`x'.dta", replace
	
	
	use "$geih\cgp_`x'.dta", clear 
	*Se eliminan a los trabajadores domésticos y del hogar
	keep if p6050!=6 & p6050!=8
	tostring directorio secuencia_p orden hogar area, replace
	gen str foliop = (directorio + secuencia_p + orden + hogar + area)
	gen str folioh = (directorio + secuencia_p + hogar + area)
	
	cap noi rename p3271 p6020
	cap noi rename p6020 sexo
	cap noi gen fac=fex_c_2011
	cap noi gen fac=fex_c18
	keep folioh foliop fac p6050 sexo
	sort foliop
	merge foliop using "$geih\ingreso_`x'.dta"
	tab _merge
	drop _merge
	save "$geih\ingreso2_`x'.dta", replace
	
	use "$geih\cgp_`x'.dta", clear 
	
	
	save "$geih\geih2_`x'.dta", replace
}



global geih = "E:\Indice de Pobreza Laboral. IPAL\Actualización 2022 (En proceso)\Colombia\2019-2022\"

foreach x in 12_2019 1_2020 2_2020 3_2020 4_2020 5_2020 6_2020 7_2020 8_2020 9_2020 10_2020 11_2020 12_2020 1_2021 2_2021 3_2021 4_2021 5_2021 6_2021 7_2021 8_2021 9_2021 10_2021 11_2021 12_2021 1_2022 2_2022 3_2022 4_2022 5_2022 6_2022 7_2022 8_2022 9_2022  {

use "$geih\desoc_`x'.dta" , clear
rename *, lower
tostring directorio secuencia_p orden hogar, replace
gen str foliop = (directorio + secuencia_p + orden + hogar)
keep foliop dsi
sort foliop
save "$temp\desempleo`x'.dta", replace

use "$geih\cgp_`x'.dta", clear 
//Se eliminan a los trabajadores domésticos y del hogar; 
keep if p6050!=6 & p6050!=8
tostring directorio secuencia_p orden hogar, replace
gen str foliop = (directorio + secuencia_p + orden + hogar)
gen str folioh = (directorio + secuencia_p + hogar + area)

cap noi rename p6040 edad
cap noi rename p3271 p6020
cap noi rename p6020 sexo
cap noi gen fac=fex_c_2011
cap noi gen fac=fex_c18
keep folioh foliop fac p6050 sexo edad
sort foliop

merge foliop using "$temp\desempleo`x'.dta", force

gen tamh = 1 

gen jhombre=1 if p6050==1 & sexo==1
gen jmujer=1 if p6050==1 & sexo==2
egen jefe_mujer = max(jmujer), by(folioh)
egen jefe_hombre = max(jhombre), by(folioh)


gen jefe_mujer_ni=0 if jefe_mujer==1
replace jefe_mujer_ni=1 if jmujer==1 & dsi==1

gen jefe_hombre_ni=0 if jefe_hombre==1
replace jefe_hombre_ni=1 if jhombre==1 & dsi==1

collapse(sum) tamh  (max) jefe_hombre jefe_mujer jefe_mujer_ni (mean) factor, by(folioh);

sum jefe_mujer_ni [w=factorp] 
}








