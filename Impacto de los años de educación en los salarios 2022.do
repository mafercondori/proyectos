clear all
cd "C:\Users\COMPUTER\OneDrive\TIFECON"
use enaho01-2023-200
merge 1:1 conglome vivienda hogar codperso using enaho01a-2023-300
drop _merge
merge 1:1 conglome vivienda hogar codperso using enaho01a-2023-400
drop _merge
merge 1:1 conglome vivienda hogar codperso using enaho01a-2023-500
drop if _merge==1 | _merge==2
drop _merge
generate reduca =0 if p301a==1
replace reduca=p301b+0 if p301a==2 //educaci´on incial
replace reduca=p301b+0 if p301a==3 //primaria incompleta
replace reduca=p301b+0 if p301a==4 //primaria completa
replace reduca=p301c+0 if p301a==3 & p301b==0 //primaria incompleta
replace reduca=p301c+0 if p301a==4 & p301b==0 //primaria completa
replace reduca=p301b+6 if p301a==5 //secundaria incompleta
replace reduca=p301b+6 if p301a==6 //secundaria completa
replace reduca=p301b+11 if p301a==7 //Superior No Universitaria Incompleta
replace reduca=p301b+11 if p301a==8 //Superior No Universitaria Completa
replace reduca=p301b+11 if p301a==9 //Superior Universitaria Incompleta
replace reduca=p301b+11 if p301a==10 //Superior Universitaria Completa
replace reduca=p301b+16 if p301a==11 //Postgrado
gen dpto= real(substr(ubigeo,1,2))
label define dpto ///
1"Amazonas" ///
2"Ancash" ///
3"Apurimac" ///
4"Arequipa" ///
5"Ayacucho" ///
6"Cajamarca" ///
7"callao" ///
8"Cusco" ///
9"Huancavelica" ///
10"Huanuco" ///
11"Ica" ///
12"Junin" ///
13"La Libertad" ///
14"Lambayeque" ///
15"Lima" ///
16"Loreto" ///
17"Madre de Dios" ///
18"Moquegua" ///
19"Pasco" ///
20"Piura" ///
21"Puno" ///
22"San Martin" ///
23"Tacna" ///
24"Tumbes" ///
25"Ucayali" 
lab val dpto dpto 
lab var dpto "Departamentos"
keep  p523 p524a1 reduca p207 p513a1 p4021 ubigeo
rename p523 ingmensual
rename p524a1 ingreso
rename p207 sexo
rename p513a1 explab
rename p4021 estsalud
gen dsexo=(sexo==1)
gen destsalud=(estsalud==0)
gen dingmensual=(ingmensual==4)
drop if ingmensual == 1 | ingmensual == 2 | ingmensual == 3
drop if ingmensual == .

// Crear nuevas variables
gen ln_ingreso = log(ingreso) // Crear el logaritmo natural del ingreso
gen lexplab2 = explab^2 // Crear la variable de experiencia al cuadrado

// Ajustar el modelo de Mincer con variables adicionales
// reg ln_ingreso reduca lexplab2 explab^2 dsexo destsalud

eststo clear

// Modelo 1
quietly regress ln_ingreso reduca
eststo modelo_1

// Modelo 2
quietly regress ln_ingreso reduca explab
eststo modelo_2

// Modelo 3
quietly regress ln_ingreso reduca explab lexplab2
eststo modelo_3

// Modelo 4
quietly regress ln_ingreso reduca explab lexplab2 dsexo
eststo modelo_4

// Modelo 5
quietly regress ln_ingreso reduca explab lexplab2 dsexo destsalud
eststo modelo_5


// Tabla de resultados
esttab, nodepvar nonumbe ar2
// Calcular percentiles
summarize ln_ingreso, detail

// Almacenar los valores de los percentiles
local p25 = r(p25)
local p75 = r(p75)

// Eliminar los outliers
drop if ln_ingreso < `p25' | ln_ingreso > `p75'

// Verificar los datos después de eliminar outliers
summarize ln_ingreso