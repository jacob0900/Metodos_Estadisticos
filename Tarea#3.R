# Tabla de contingencia
observados <- matrix(c(5, 70, 121,
                       4, 45, 169),
                     nrow = 3, byrow = FALSE,
                     dimnames = list(
                       Respuesta = c("Siempre", "A veces", "Nunca"),
                       Sexo = c("Hombres", "Mujeres")
                     ))
filas_totales = rowSums(observados)
col_totales = colSums(observados)
tamaño_muestral = sum(observados)

esperados = outer(filas_totales,col_totales,
                  FUN=function(f,c)  f*c/tamaño_muestral)

print("Resulta que los esperados de la categoria Siemore dieron menores a 5
      por lo que combinaremos la variable siempre con algunas veces 
      para poder aplicar la prueba chi ")

observados_combinado <- matrix(c(5+70, 4+45,  # Combinar filas 1 y 2
                                 121, 169),     # Mantener fila 3
                               nrow = 2, byrow = TRUE,
                               dimnames = list(
                                 Comportamiento = c("Sí hace algo", "Nunca lo hace"),
                                 Sexo = c("Hombres", "Mujeres")
                               ))

filas_totales1=rowSums(observados_combinado)
col_totales1=colSums(observados_combinado)
tamaño_muestral1= sum(observados_combinado)

esperados1= outer(filas_totales1,col_totales1,
                  FUN= function(f,c) f*c/tamaño_muestral1)
print("Ahora que los esperados son todos mayores a 5 podemos aplicar la prueba chi")

chi_crit=sum((observados_combinado-esperados1)^2/esperados1)

alpha=0.05
gl=(nrow(observados_combinado)-1)*(ncol(observados_combinado)-1)

chi_tab = qchisq((1-alpha), df=gl)

if(chi_crit>chi_tab){
  print("El hecho de ser mujer o hombre afecta en 
        el hecho de que se acuesten a las 10 de la noche o no lo hagan")
}else{
  print("Los grupos son homogeneos e independientes ")
}





