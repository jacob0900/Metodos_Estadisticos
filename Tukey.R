# Datos de calificaciones por grupo de enseñanza
datos <- data.frame(
  Grupo = rep(c("A", "B", "C"), each = 10),
  Calificaciones = c(75, 78, 80, 82, 85, 88, 90, 92, 95, 98,   # Grupo A
                     68, 70, 72, 74, 76, 78, 80, 82, 84, 86,   # Grupo B
                     60, 63, 66, 69, 72, 75, 78, 81, 84, 87)   # Grupo C
)

#EDA (tarea)

#Normalidad
datos %>% 
  group_by(Grupo) %>% 
  summarise(est = shapiro.test(Calificaciones)$statistic,
            pvalor = shapiro.test(Calificaciones)$p.value)

#Homogeneidad de varianzas 
bartlett.test(Calificaciones ~ Grupo,data = datos)

#anova

modelo = aov(Calificaciones ~ Grupo,data = datos)
summary(modelo)

#Tukey para saber cual es diferente a que 
TukeyHSD(modelo)





