
#libreria
library(tidyverse)
library(car)

# Crear conjunto de datos
datos <- data.frame(
  metodo = c(rep("Metodo_A", 18), rep("Metodo_B", 18), rep("Metodo_C", 18)),
  tiempo_reaccion = c(
    1, 2, 3, 4, 5, 6, 7, 8, 9, 16, 27, 28, 29, 30, 51, 52, 53, 342,          # Método A
    40, 41, 42, 43, 44, 45, 46, 47, 48, 67, 88, 89, 90, 91, 92, 93, 94, 293, # Método B
    19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 25, 36, 37, 58, 59, 60, 71, 72   # Método C
  )
)


#normalidad 
  datos %>% 
    group_by(metodo) %>% 
    summarise(est = shapiro.test(tiempo_reaccion)$statistic,
              pvalor = shapiro.test(tiempo_reaccion)$p.value)

#homocedasticidad 
leveneTest(tiempo_reaccion ~ factor(metodo), data= datos)

#Kurskal_Wallis
kurskal.test(tiempo_reaccion ~factor(metodo), data= datos)

#Prueba post-hoc
pairwise.wilcox.test(x= datos$tiempo_reaccion,
                     g = datos$metodo,
                     p.adjust.methods ='bonferroni')
