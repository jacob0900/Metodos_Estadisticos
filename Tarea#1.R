# Tabla de contingencia
observados <- matrix(c(42, 33, 25,
                       40, 21, 39),
                     nrow = 3, byrow = FALSE,
                     dimnames = list(
                       Tiempo = c("Menos de 10 días", "De 10 a 20 días", "Más de 20 días"),
                       Sexo = c("Macho", "Hembra")
                     ))
filas_totales = rowSums(observados)
col_totales = colSums(observados)
tamaño_mustral = sum(observados)

Esperados = outer(filas_totales,col_totales, FUN = function (f,c) (f*c)/tamaño_mustral)
print("todos los esperados son <5 por lo que podemos aplicar una prueba chi")
chi_critico = sum((observados-Esperados)^2/Esperados)

alpha = 0.05
gl=(nrow(observados)-1)*(ncol(observados)-1)
chi_tab= qchisq((1-alpha), df=gl)

if(chi_critico>chi_tab){
  print("Los grupos son no homogeneos y dependientes")
}else{
  print("No importa si es macho o hembra, ambos tienen la misma probabilidad de sobrevivir los mismo dias
        en el invierno ")
}
