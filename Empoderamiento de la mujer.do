clear all
cd "C:\TIF EMPODERAMIENTO ECONOMETRIA 02"
use RE516171_2023
merge 1:1 CASEID using RE758081_2023
keep if _merge==3
drop _merge
merge 1:1 CASEID using REC0111_2023
keep if _merge==3
drop _merge
merge 1:1 CASEID using RE223132_2023
keep if _merge==3
drop _merge
merge 1:1 CASEID using REC84DV_2023
keep if _merge==3
drop _merge 
merge 1:1 CASEID using REC91_2023
keep if _merge==3
drop _merge
*Variables de control a considerar
*variables para la Y : V632 V743A V743B V743C V743D V743E V744A V744B V744C V744D V744E D104 D106 D107 D108 

keep V632 V743A V743B V743C V743D V743E V744A V744B V744C V744D V744E D101A D101C D101D D104 D106 D107 D108 S108Y V219 V501 V012 V025 V131 V151 V702 V746 SREGION
*Renonbrando variables 
*Dimensión Vida y Salud Fisica (25%)
//Autonomia en salud sexual y reproductiva 12,5%
rename V632 dec_anticonceptivo
drop if dec_anticonceptivo==. 
// Cuidados de su salud propia 12,5%
rename V743A dec_salud

*Dimensión Control sobre el entorno material(25%)
//Participación sobre las compras del hogar 12,5%
rename V743B dec_compras_grandes
rename V743C dec_compras_diarias
//Participación deciciones sobre la alimentación del hogar 12,5%
rename V743E dec_comida

*Dimensión Relaciones Sociales
// Autonomia en las relaciones Sociales
rename V743D dec_visitas
//Amenazas de Libertad de afiliación
rename D101A celos
drop if celos ==. 
drop if celos==8
rename D101C limita_ver_amigos 
drop if limita_ver_amigos ==8 // 8 no sabe a considerar
rename D101D limita_ver_familia 
drop if limita_ver_familia ==8 // 8 no sabe a considerar

*Dimención Integridad fisca y seguridad
//Aceptación de la violencia Fisca
rename V744A sale_sin_decir
drop if sale_sin_decir== 8
rename V744B decuida_niños
drop if decuida_niños==8
rename V744C discute
drop if discute==8 
rename V744D negarse_relaciones_sexuales
drop if negarse_relaciones_sexuales==8
rename V744E quema_comida
drop if quema_comida==8
//Padecimiento de violencia conyugal
rename D104 violencia_emocional
rename D106 violencia_fisica_debil
rename D107 violencia_fisica_fuerte
rename D108 violencia_sexual

//INDEPENDIENTES_REGRESORES / Xs
gen Reduca=.
replace Reduca=3 if S108Y==1
replace Reduca=9 if S108Y==2
replace Reduca=14 if S108Y==3
replace Reduca=17 if S108Y==4
replace Reduca=19 if S108Y==5
replace Reduca=21 if S108Y==6 
rename S108Y educ
drop if educ==.
drop if educ==7

rename V219 n_de_hijos

rename V501 est_cvl

rename V012 edad
gen edad2=edad^2

rename V025 residencia

rename V131 et

rename V151 sexo_jefe

rename V702 educ_companero 

drop if educ_companero==.
drop if educ_companero==98
gen Reduca_companero=.
replace Reduca_companero=0 if educ_companero==0
replace Reduca_companero=3 if educ_companero==1
replace Reduca_companero=9 if educ_companero==2
replace Reduca_companero=14 if educ_companero==3
replace Reduca_companero=17 if educ_companero==4
replace Reduca_companero=19 if educ_companero==5
replace Reduca_companero=21 if educ_companero==6 
rename V746 ingreso
drop if ingreso==.
drop if ingreso==8
rename SREGION region
preserve
restore /// parea restaurar la varaible

//GENERACIÓN DE VARIABLES PARA Y
*Generación de la variable dummy //1 no decide//0 si decide sobre el uso de anticonceptivos
gen dec_anticonceptivob = cond(inlist(dec_anticonceptivo, 1, 3), 0, 1)
*Generación de la variable dummy //1 no decide//0 si decide sobre el cuidado de su salud propia
gen dec_saludb = cond(inlist(dec_salud, 1, 2, 3), 0, 1) 
//*Generación de la variable dummy //1 no decide//0 si decide sobre compras grandes
gen dec_compras_grandesb = cond(inlist(dec_compras_grandes, 1,2,3), 0, 1)
//Generación de la variable dummy //1 no decide//0 si decide sobre compras diarias
gen dec_compras_diariasb = cond(inlist(dec_compras_diarias, 1, 2,3), 0, 1)
//Generación de la variable dummy //1 no decide//0 si decide sobre la comida
gen dec_comidab = cond(inlist(dec_comida, 1, 2,3), 0, 1)
//Generación de la variable dummy //1 no decide//0 si decide sobre a quien visitar
gen dec_visitasb = cond(inlist(dec_visitas, 1, 2,3), 0, 1)
//Generación de la variable dummy //1 no decide//0 si la pareja es celosa
gen celosb = cond(inlist(celos, 0), 0, 1)
//Generación de la variable dummy //1 no decide//0 si la pareja le limita ver a sus amistades
gen limita_ver_amigosb = cond(inlist(limita_ver_amigos, 0), 0, 1)
//Generación de la variable dummy //1 no decide//0 si la pareja le limita ver a sus familiares
gen limita_ver_familiab = cond(inlist(limita_ver_familia, 0), 0, 1)
//Generación de la variable dummy //1 no decide//0 si esta deacuerdo a recibir violencia por salir sin decir
gen sale_sin_decirb = cond(inlist(sale_sin_decir, 0), 0, 1)
//Generación de la variable dummy //1 no decide//0 si esta deacuerdo a recibir violencia por descuidar a los niños
gen decuida_niñosb = cond(inlist(decuida_niños, 0), 0, 1)
//Generación de la variable dummy //1 no decide//0 si esta deacuerdo a recibir violencia si ella dicute con el
gen discuteb = cond(inlist(discute, 0), 0, 1)
//Generación de la variable dummy //1 no decide//0 si esta deacuerdo a recibir violencia si se niega a tener relaciones sexuales
gen negarse_relaciones_sexualesb = cond(inlist(negarse_relaciones_sexuales, 0), 0, 1)
//Generación de la variable dummy //1 no decide//0 si esta deacuerdo a recibir violencia si quema la comida
gen quema_comidab = cond(inlist(quema_comida, 0), 0, 1)
//Generación de la variable dummy //1 no decide//0 si recibio violencia emocional
gen violencia_emocionalb = cond(inlist(violencia_emocional, 0), 0, 1)
//Generación de la variable dummy //1 no decide//0 si recibio violencia fisica debil
gen violencia_fisica_debilb = cond(inlist(violencia_fisica_debil, 0), 0, 1)
//Generación de la variable dummy //1 no decide//0 si recibio violencia fisica fuerte
gen violencia_fisica_fuerteb = cond(inlist(violencia_fisica_fuerte, 0), 0, 1)
//Generación de la variable dummy //1 no decide//0 si recibio violencia sexual
gen violencia_sexualb = cond(inlist(violencia_sexual, 0), 0, 1)

***GENERACIÓN DE VARIABLES PARA Xs
gen residenciab = cond(inlist(residencia, 1), 0, 1)
//Generación de la variable dummy //1 rural//0 urbano
gen sexo_jefeb = cond(inlist(sexo_jefe, 1), 0, 1)
//Generación de la variable dummy //1 mujer//0 hombre
gen ingresob = cond(inlist(ingreso,1,3,4),0,1)
//Generación de la variable dummy //1,3,4(>=companero) 0//2(<companero) 1

***SUMATORIAS PARA INDICADORES y PONDERACIONES 
*Dimensión Vida y Salud Fisica (25%)
//Autonomia en salud sexual y reproductiva 12,5%
gen autonomia_s_r = dec_anticonceptivob * 0.125
// Cuidados de su salud propia 12,5%
gen cuidado_s_p = dec_saludb * 0.125
*Dimensión Control sobre el entorno material(25%)
//Participación sobre las compras del hogar 12,5%
gen participacion_comp = ((dec_compras_grandesb + dec_compras_diariasb)*0.125)/2
//Participación deciciones sobre la alimentación del hogar 12,5%
gen participacion_comidahog = dec_comidab * 0.125

*Dimensión Relaciones Sociales (25%)
// Autonomia en las relaciones Sociales
gen autonomia_r_s = dec_visitasb * 0.125
//Amenazas de Libertda de afiliación
gen amenazas_l_e = ((celosb + limita_ver_amigosb + limita_ver_familiab)*0.125)/3
*Dimención Integridad fisica y seguridad (25%)
//Aceptación de la violencia Fisca 12,5%
gen aceptacion_v_f = ((sale_sin_decirb + decuida_niñosb + discuteb + negarse_relaciones_sexualesb + quema_comidab)*0.125)/5
//Padecimiento de violencia conyugal 12,5%
gen padecimiento_v_c = ((violencia_emocionalb + violencia_fisica_debilb + violencia_fisica_fuerteb + violencia_sexualb)*0.125)/4

* GENERAMOS EL INDICE DESEMPODERAMIENTO = SUMATORIAS
gen indice_desempoderamiento = (autonomia_s_r + cuidado_s_p + participacion_comp + participacion_comidahog + autonomia_r_s + amenazas_l_e + aceptacion_v_f + padecimiento_v_c)
***DIFERENCIA DE UMBRAL//corte 0.2
gen Di = cond(indice_desempoderamiento >= 0.2, 1, 0)
///Luego, para identificar si la mujer i estuvo o no desempoderada, se estableció el punto de corte de k. 
///Así, la mujer i cuyo puntaje de privación fue mayor que el punto de corte 𝑐𝑐𝑖𝑖 ≥ 𝑘𝑘, fue considerada como 
///desempoderada (Di
///=1); mientras que, si su puntaje de privación fue menor o igual al punto de corte 𝑐𝑐𝑖𝑖 < 𝑘𝑘, fue considerada como suficientemente empoderada (Di=0)


// MODELO PROBIT
probit Di edad edad2 n_de_hijos est_cvl residenciab sexo_jefeb ingresob et region dec_anticonceptivo educ educ_companero
mfx



