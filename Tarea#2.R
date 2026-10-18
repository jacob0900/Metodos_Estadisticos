# Tabla de contingencia
observados <- matrix(c(13, 18, 32,
                       10, 12, 6),
                     nrow = 3, byrow = FALSE,
                     dimnames = list(
                       Doctores = c("Menos de 5", "Entre 5 y 8", "Más de 8"),
                       Proyecto = c("Con proyecto", "Sin proyecto")
                     ))
filas_totales=rowSums(observados)
col_totales=colSums(observados)
tamaño_muestral=sum(observados)

esperados = outer(filas_totales,col_totales, FUN=function(f,c) f*c/tamaño_muestral)
print("Como todos los esperados son <5 podemso usar una prueba chi ")

chi_critico = sum((observados-esperados)^2/esperados)

gl=(nrow(observados)-1)*(ncol(observados)-1)
alpha = 0.05

chi_tab = qchisq(1-alpha, df=gl)


  print("Hay una diferencia estadisticamente significativa que nos hace pensar que el numero de doctores
        con investigacion varia dependeiendo de si tiene trabajo social o no ")

