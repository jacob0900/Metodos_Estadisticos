# Tabla de contingencia
observados <- matrix(c(12, 17, 10,
                       14, 37, 32,
                       19, 42, 17),
                     nrow = 3, byrow = TRUE,
                     dimnames = list(
                       Estrato = c("Bajo", "Medio", "Alto"),
                       Hermanos = c("0-1", "2-3", "Más de 3")
                     ))
filas_totales = rowSums(observados)
col_totales = colSums(observados)
tamaño_muestral = sum(observados)

esperados= outer(filas_totales,col_totales,
                 FUN= function(f,c) f*c/tamaño_muestral)
print("podemos observar que todos los esperados son mayores a 5 por lo que podemos aplicar una prueba chi ")

chi_crit=sum((observados-esperados)^2/esperados)
alpha= 0.05
gl=((nrow(observados))-1)*(ncol(observados)-1)
chi_tab= qchisq((1-alpha), df=gl)

if(chi_crit>chi_tab){
  print("Con una significancia estaditica del 0.05 porciento podemos
        afirmar que el número de hermanos es independiente del estrato")
}else{
  print("Los grupos son homogeneos e independientes ")
}