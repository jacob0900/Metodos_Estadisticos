# Tabla de contingencia
observados <- matrix(c(19, 26, 48,
                       30, 36, 21),
                     nrow = 2, byrow = TRUE,
                     dimnames = list(
                       Vista = c("Con problemas", "Sin problemas"),
                       Computador = c("Nunca", "A veces", "Siempre")
                     ))

filas_totales = rowSums(observados)
col_totales = colSums(observados)
total_muestral= sum(observados)

esperados= outer(filas_totales,col_totales,
                 FUN= function(f,c) f*c/total_muestral)

print("Todos los esperados nos dieron mayores a 5 por lo que podemos aplicar una prueba chi ")

chi_crit= sum((observados-esperados)^2/esperados)
alpha=0.05
gl=(nrow(observados)-1)*(ncol(observados)-1)
chi_tab=qchisq((1-alpha),df=gl)

if(chi_crit>chi_tab){
  print("Con una significancia estaditica del 0.05 porciento podemos afirmar que 
      los problemas visuales dependen de los habitos de trabajar en computador")
}else{
  print("Los grupos son homogeneos e independientes ")
}


