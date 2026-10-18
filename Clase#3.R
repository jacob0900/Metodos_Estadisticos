# Datos de tiempos antes y después de la intervención educativa
datos <- data.frame(
  estudiante = c(1:10),
  antes = c(12.9, 13.5, 12.8, 15.6, 17.2, 19.2, 12.6, 15.3, 14.4, 11.3),
  despues = c(12.7, 13.6, 12.0, 15.2, 16.8, 20.0, 12.0, 15.9, 16.0, 11.1)
)

# Aplico Shapiro porque es mas rigurosa que kolmogorof 

shapiro.test(datos$antes)
shapiro.test(datos$despues)
#como el pvalor es mayor que .5 entonces sigue la normal 
#Como el numero de datos es menor a 30 entonces aplicamos una t_test

t.test(x=datos$despues,
       y=datos$antes,
       paried= TRUE)


#ejemplo nilños vs madres
library(openintro)
library(tidyverse)
data('births')
df <- births
head(births)

df %>% 
  select(weight,smoke) %>% 
  group_by(smoke) %>% 
  summarise(n= length(weight),
            prom =mean(weight),
            ds = sd(weight),
            mediana = median(weight),
            RIC = IQR(weight),
            min = min(weight),
            max = max(weight))
#normalidad 
df %>% 
  group_by(smoke) %>% 
  summarise(n= length(weight),
            est_ks = ks.test(scale(weight), 'pnorm')$statistic,
            p_ks = ks.test(scale(weight), 'pnorm')$p.value,
            est_sw = shapiro.test(weight)$statistic,
            p_sw = shapiro.test(weight)$p.value,
            est_lt = lillie.test(weight)$statistic,
            p_lt= lillie.test(weight)$p.value )

t.test(weight ~ smoke 
       paried =
  
       )












