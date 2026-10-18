# Tabla de contingencia
observados <- matrix(c(7, 9, 14,
                       11, 13, 9,
                       32, 28, 27),
                     nrow = 3, byrow = TRUE,
                     dimnames = list(
                       Alivio = c("Sin alivio", "Cierto alivio", "Alivio completo"),
                       Remedio = c("Remedio 1", "Remedio 2", "Remedio 3")
                     ))
total_filas = rowSums(observados)
col_total = colSums(observados)
tamaño_muestral= sum(observados)

esperados=outer(total_filas, col_total,
                FUN= function(f,c) f*c/tamaño_muestral)
print("podemos observar que todos los esperados son mayores a 5 por lo que podemos aplicar una prueba chi ")

chi_crit = sum((observados-esperados)^2/esperados)
alpha = 0.05
gl=(nrow(observados)-1)*(ncol(observados)-1)

chi_tab= qchisq(1-alpha, df=gl)



if(chi_crit>chi_tab){
  print("Con una significancia estaditica del 0.05 porciento podemos
        afirmar que el número de hermanos es independiente del estrato")
}else{
  print("podemos afirmar con una significancia estadistica del 0.05
        que Independientemente del remedio vas a sentir el mismo grado de alivio ")
}
