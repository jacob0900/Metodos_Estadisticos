10
#Librerias

library(tidyverse)

#Datos 
df <- data.frame(Empleados = c(0.66, 0.63, 0.65, 0.69, 0.44, 0.63, 0.61, 0.42, 0.59, 0.46),
                 Agricultores = c(0.65, 0.60, 0.69, 0.73, 0.52, 0.85, 0.81, NA, NA, NA),
                 NoExpuestos = c(0.93, 0.99, 0.96, 0.74, 0.81, 0.93, 0.63, 0.68, 0.99, NA))

#Eda (tarea)




#Extraccion de los grupos 
empleado = na.omit(df$Empleados)
agricultores = na.omit(df$Agricultores)
noexpuestos = na.omit(df$NoExpuestos)

#Tamaños de las muestras
n1 = length(empleado)
n2 = length(agricultores)
n3 = length(noexpuestos)

N = n1 + n2 + n3
k = ncol(df)

#calculo de promedios 

xbar_1= mean(empleado)
xbar_2= mean(agricultores)
xbar_3= mean(noexpuestos)
xbar_total= (sum(empleado)+sum(agricultores)+sum(noexpuestos)) / N

#Hallemos SST

SST= sum((empleado - xbar_total)^2) + sum(( agricultores - xbar_total)^2) + sum(( noexpuestos - xbar_total)^2)

#Hallamos el SSA
SSA = n1*(xbar_1-xbar_total)^2 + n2*(xbar_2-xbar_total)^2 + n1*(xbar_3-xbar_total)^2

#Hallemos SSE

SSE=SSA+SST
#Hallemos el MSA y MSE
MSA = SSA/ (k-1)
MSE = SSE/(N-k)

#Hallamos el estaditico de prueba F
F = MSA / MSE

# F critico 
alpha = 0.05
v1= k-1
v2= N-k
F_critico = qf(1-alpha, df1=v1, df2=v2)

print(F_critico)
print(F)









