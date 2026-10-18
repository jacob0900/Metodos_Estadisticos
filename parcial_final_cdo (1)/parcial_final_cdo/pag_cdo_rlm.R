# 8.12.1  Variables dummy
#
# La palabra dummy o binaria es la denominación genérica para una variable 
# que toma valores de 0 o de 1 y que se utiliza para re-expresar variables cualitativas.
#
# El conjunto de datos Taiwan Real Estate Valuation proviene de registros 
# de transacciones inmobiliarias realizadas en el distrito de Sindian, 
# perteneciente a la New Taipei City (Taiwán). Su propósito principal es 
# servir como base para el análisis y modelado del precio por unidad de área 
# de las viviendas, utilizando variables que describen características físicas, 
# de ubicación y de entorno urbano.
#
# El conjunto contiene alrededor de 414 observaciones y 7 variables, sin valores perdidos. 
# Las transacciones corresponden a los años 2012 y 2013, donde la variable de fecha se 
# expresa como un número decimal (por ejemplo, 2013.250 representa marzo de 2013).
#
# Las variables incluidas son las siguientes:
#
#   dist_to_mrt_m : distancia al sistema MRT más cercano, en metros 
#                   (accesibilidad al transporte).
#
#   n_convenience : número de tiendas de conveniencia cercanas dentro del radio 
#                   peatonal (amenidades de barrio).
#
#   house_age_years : antigüedad de la vivienda como variable categórica ordinal 
#                     con tres niveles: "0 to 15", "15 to 30" y "30 to 45" años.
#
#   price_twd_msq : variable objetivo, precio de venta por m² en TWD.
#
# Este conjunto es ampliamente utilizado en ejercicios de análisis exploratorio, 
# regresión lineal múltiple y modelos predictivos de precios de vivienda.
#
# Por lo general, se observa que el precio por unidad de área tiende a disminuir 
# con el aumento de la distancia al metro y la edad de la vivienda, mientras que 
# incrementa con el número de tiendas cercanas o la proximidad a zonas urbanas.
#
# El archivo en formato .fst se puede cargar en R mediante el paquete fst, 
# utilizando la función read_fst(), lo que permite una lectura rápida de datos binarios.

library(fst)
df = read_fst("C:/Users/boolean/Desktop/parcial_final_cdo/taiwan_real_estate.fst")

unique(df$house_age_years)

# 8.12.2 Transformación de la variable house_age_years en variables dummy
#
# La variable house_age_years contiene tres categorías que representan intervalos 
# de antigüedad de las viviendas:
#
# 1. “0 to 15” : viviendas nuevas o recientes
# 2. “15 to 30” : viviendas de edad media
# 3. “30 to 45” : viviendas antiguas
#
# Para incorporar esta variable categórica en un modelo de regresión, es necesario 
# transformarla en variables numéricas indicadoras (dummies). Crearemos dos variables 
# binarias que resuman la información:
#
#   AgeMed  = 1 si house_age_years es “15 to 30”, en otro caso 0.
#   AgeOld  = 1 si house_age_years es “30 to 45”, en otro caso 0.
#
# La categoría “0 to 15” actuará como la referencia (ambas variables valen 0).
#
# 8.12.2.1 Reglas de interpretación
#
# 1. Si AgeMed = 1 y AgeOld = 0, la vivienda tiene entre 0 y 15 años.
# 2. Si AgeMed = 1 y AgeOld = 0, la vivienda tiene entre 15 y 30 años.
# 3. Si AgeMed = 0 y AgeOld = 1, la vivienda tiene entre 30 y 45 años.
#
# 8.12.2.2 Ejemplo de transformación
#
# Precio | Área | house_age_years | AgeMed | AgeOld
# 21.5     32       0 to 15           0        0
# 19.8     18       15 to 30          1        0
# 16.7     20       30 to 45          0        1
# 22.9     27       15 to 30          1        0
# 18.9     26       30 to 45          0        1
#
# De esta forma, las dos nuevas variables (AgeMed y AgeOld) logran representar la información 
# original de house_age_years, reduciendo la categoría base (0 to 15) a la situación donde ambas son cero.
#
# Nota: En R, esta codificación se genera automáticamente al usar funciones como lm() o model.matrix() 
# cuando house_age_years se declara como factor.
library(tidyverse)
df %>% 
  ggplot(aes(price_twd_msq)) +
  geom_histogram(bins=10)+
  facet_wrap(vars(house_age_years))+
  theme_bw()

#Calculemos el promedio por categoria
summary_stats = df %>% 
  group_by(house_age_years) %>% 
  summarise(mean_by_group = mean(price_twd_msq))
summary_stats

#Como house_age_years es una variable categorica definida en R, de manera inmediata se obtiene la variable dummy:
#Quitar el orden manteniendo los niveles
df = df %>% 
  mutate(house_age_years = factor(house_age_years,
         levels = levels(house_age_years),ordered = FALSE))
#Generar la matriz de diseño (variables dummy)
matriz = model.matrix(~ house_age_years,data = df)

#modelo price_twd_msq vs house_age_years
mdl_price_vs_age = lm(price_twd_msq ~ house_age_years,data = df)

#resultado 
summary(mdl_price_vs_age)

# (Intercept) = 12.6375: Representa el valor promedio esperado del precio por metro cuadrado
# (price_twd_msq) para viviendas en la categoría base (house_age_years = "0 to 15").
# Es decir, una vivienda con antigüedad de 0 a 15 años tiene un precio medio aproximado
# de 12.64 TWD/m².

# house_age_years15 to 30 = -2.7607: Indica que, manteniendo todo lo demás constante,
# las viviendas con 15 a 30 años de antigüedad tienen un precio promedio 2.76 TWD/m²
# menor que las viviendas nuevas (0–15 años). El valor p (< 0.001) muestra que esta
# diferencia es altamente significativa estadísticamente.

# house_age_years30 to 45 = -1.2442: Indica que las viviendas con 30 a 45 años tienen,
# en promedio, un precio 1.24 TWD/m² menor que las viviendas nuevas. La diferencia
# también es significativa (p < 0.05).

# El modelo confirma una relación negativa entre la antigüedad y el precio de la vivienda:
# a medida que las viviendas son más antiguas, su precio promedio por metro cuadrado
# tiende a disminuir. Esto sugiere que el valor de las propiedades disminuye con la edad,
# aunque el efecto parece ser más fuerte entre 15 y 30 años, y luego se atenúa
# ligeramente en viviendas más antiguas.

#Hagamos el rlm

#modelo del rlm
model = lm(price_twd_msq ~ .,data = df)

summary(model)
