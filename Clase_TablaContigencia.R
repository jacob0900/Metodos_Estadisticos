# Crear la tabla de contingencia
observados <- matrix(c(82, 93, 25,
                       70, 62, 18,
                       62, 67, 21),
                     nrow = 3, byrow = FALSE,
                     dimnames = list(
                       Opinion = c("A favor", "En contra", "Sin decisión"),
                       Ciudad = c("Barranquilleros", "Samarios", "Cartageneros")
                     ))

filas_total = rowSums(observados)
col_total= colSums(observados)
total_general = sum(observados)

esperados = outer(filas_total,col_total,
                  FUN= function(f,c)f*c/total_general)

chi_cuadrado = sum((observados-esperados)^2/esperados)
alpha= 0.05
gl = (nrow(observados)-1)*(ncol(observados)-1)
chi_tabulado = qchisq(1-alpha, df=gl)

if(chi_cuadrado>chi_tabulado){
  print("Los grupos son no homogeneos y dependientes")
}else{
  print("Los grupos son homogeneos e independientes ")
}
