#datos inyectora
df = inyectora
head(df,3)

#En total se tienen 100 unidades experimentales. Dado que en los datos sólo existen la variable respuesta y las covariables

#Hagamos el modelo de rlm

#modelo de RLM ajustado
mod_iny = lm(y ~.,data = df)
summary(mod_iny)
# Como el número de variables independientes es k = 10,
# debemos estimar 2^k − 1 = 1023 modelos diferentes al utilizar
# el Método de todas las regresiones posibles.
#
# Para encontrar el mejor modelo, usamos la función
# ols_step_all_possible del paquete olsrr.
#
# Para más detalles, se recomienda escribir
# ?ols_step_all_possible en la consola de R.

#metodo de todas las regresiones posibles
library(olsrr)
k = ols_step_all_possible(mod_iny)
#En el objeto  k se encuentran todos los resultados. 
#La función ols_step_all_possible permite estimar 11 indicadores diferentes que facilitan la elección del mejor modelo.  

#SI QUEREMOS ESCOGER EL MEJOR MODELO UTILIZANDO EL R^2adj basta con escribir:
results = k$result
results[which.max(results$adjr),]

#Si usamos AIC el mejor modelo sera
# mejor modelo basado en el Cp
results[which.min(with(results, (cp-n)^2)), ]

#Si usamos el estadistico de mallows, el mejor modelo sera:
# mejor modelo basado en el AIC
results[which.min(results$aic), ]

#Otra posibilidad es utilizar dos criterios selección a la vez:
# selección usando el R^2_{adj} y el AIC
require(ggplot2)
ggplot(results, aes(x = adjr, y = aic)) + geom_point() + theme_minimal() + xlab(expression(R^2 *" ajustado")) + ylab("AIC")
#De acuerdo con la definicion de cada criterio, el mejor modelo debe tener un R^2adj -> 1 y AIC -> 0.
#De la grafica, es posible observar que hay 4 modelos que sobresalen:

#seleccion de modelos competitivos
subset(results,aic < 350 & adjr>0.8,select = n:aic)

# 8.13.2.1 Método forward (agregación progresiva)
# Inicia con un modelo nulo (solo con el intercepto) y agrega la variable
# que más mejora el criterio seleccionado.
# El proceso continúa hasta que ninguna variable adicional logre una mejora significativa.
#
# Pasos principales:
# 1. Comenzar con el modelo vacío.
# 2. Probar la inclusión de cada variable independiente y seleccionar la que más
#    mejora el criterio (menor AIC/BIC o mayor F parcial).
# 3. Si la mejora es significativa, agregar dicha variable al modelo.
# 4. Repetir el proceso hasta que no haya mejoras importantes.
#
# Ventajas: útil cuando hay muchos predictores y pocos efectos claros;
#           evita ajustar modelos innecesariamente grandes.
# Limitaciones: puede omitir variables que solo son útiles cuando se incluyen
#               junto con otras.
#
# 8.13.2.2 Método backward (eliminación regresiva)
# Comienza con el modelo completo (todas las variables) y elimina la variable
# menos significativa en cada iteración según el criterio de selección.
#
# Pasos principales:
# 1. Ajustar el modelo con todas las variables candidatas.
# 2. Evaluar la contribución de cada variable (p. ej., p-valor, AIC, BIC).
# 3. Eliminar la variable menos relevante o la que más mejora el criterio
#    al ser eliminada.
# 4. Repetir hasta que no convenga eliminar más predictores.
#
# Ventajas: parte del modelo más informativo y detecta fácilmente variables
#           redundantes.
# Limitaciones: requiere que el modelo completo sea estimable
#               (puede fallar con alta multicolinealidad).
#
# 8.13.2.3 Método stepwise (bidireccional)
# Combina los procedimientos forward y backward.
# Después de agregar una variable, revisa si alguna debe salir; y tras eliminar una,
# revisa si alguna debe entrar nuevamente.
#
# Pasos principales:
# 1. Iniciar con un modelo base (nulo o con algunas variables relevantes).
# 2. Evaluar qué variable nueva puede entrar al modelo y si mejora el criterio.
# 3. Revisar si alguna variable incluida deja de ser significativa y debe eliminarse.
# 4. Repetir el proceso hasta que no haya cambios que mejoren el modelo.
#
# Ventajas: ofrece un equilibrio práctico entre los métodos forward y backward.
# Limitaciones: no garantiza encontrar el modelo óptimo global;
#               puede ser inestable si hay colinealidad entre predictores.

library(MASS)
# metodo de forward 
modelo_null <- lm(y ~ 1, data = df)
modelo_full <- lm(y ~ ., data = df)
sel_forward <- stepAIC(modelo_null,
                       scope = list(lower = modelo_null,
                                    upper = modelo_full),
                       direction = "forward", trace = FALSE)
summary(sel_forward)

library(MASS)
# metodo de backward
modelo_full <- lm(y ~ ., data = df)
sel_backward <- stepAIC(modelo_full, direction = "backward",
                        trace = FALSE)
summary(sel_backward)


library(MASS)
sel_both <- stepAIC(modelo_null,scope = list(lower = modelo_null,
                                             upper = modelo_full),
                    direction = "both", trace = FALSE)
summary(sel_both)
#Realizando el método por varias vias vemos que el mejor modelo tiene 10 variables desde la  x1 hasta la  xn

# El conjunto de datos 50_Startups.csv contiene información sobre 50 nuevas empresas (startups)
# y sus respectivos valores de inversión, gastos y beneficios. Se utiliza comúnmente para 
# ejemplificar análisis de regresión lineal múltiple y evaluación de factores que influyen 
# en las utilidades netas de las empresas.
#
# Cada fila representa una empresa, y cada columna corresponde a una variable:
#
# Variable            Descripción                                                        Tipo
# ---------------------------------------------------------------------------------------------
# R&D Spend          Gasto en investigación y desarrollo (Research & Development)        Numérica
#                    medido en dólares. Representa la inversión en innovación            (continua)
#                    y desarrollo tecnológico.
#
# Administration     Gastos administrativos de la empresa (salarios, servicios,          Numérica
#                    gestión interna).                                                   (continua)
#
# Marketing Spend    Gasto en marketing y publicidad, en dólares.                        Numérica
#                                                                                         (continua)
#
# State              Estado de EE. UU. donde la empresa opera                            Categórica
#                    (California, New York, Florida).
#
# Profit             Utilidad neta de la empresa después de todos los gastos.            Numérica
#                    Es la variable dependiente del modelo.                              (continua)
#
# El objetivo principal es modelar la variable Profit (beneficio) en función de las 
# variables de gasto (R&D Spend, Administration, Marketing Spend) y la localización (State).
#
# Se busca identificar qué factores explican mejor la rentabilidad y en qué medida 
# contribuyen al beneficio total de cada empresa.

dataset = X50_Startups
head(dataset)
str(dataset)

#Codifiquemos las variables categoricas
dataset$State = factor(dataset$State,
                       levels = c("New York", "California", "Florida"),
                       labels = c(1, 2, 3))
#Ahora construyamos un modelo optimo con la eliminacion hacia atras usando los p valores de los coeficientes
#R^2 y R^2 adj

regression = lm(formula = Profit ~ `R&D Spend` + Administration + `Marketing Spend` + State,data = dataset)
summary(regression)

#Quitemos la variable state
regression_b = lm(formula = Profit ~ `R&D Spend` + Administration + `Marketing Spend`,data = dataset)
summary(regression_b)

#Veamos si hay diferencias significativas entre los dos modelos

anova(regression,regression_b)

#Ahora quitemos la variable Administration
regression_c = lm(formula = Profit ~  `R&D Spend`+ `Marketing Spend`,data = dataset)
summary(regression_c)

anova(regression,regression_c)

anova(regression_b,regression_c)
# Eliminemos Marketing.Spend, puesto que el p-valor es mayor a 0.05

regression_d = lm(formula = Profit ~ `R&D Spend`, data = dataset)
summary(regression_d)
#Podemos notar que el  R2 bajo más con respecto a los otros modelos. Además, el  R2adj 
#bajo notoriamente con respecto al modelo anterior. Con lo analizado, el modelo optimo es el regression_c
modelo_null = lm(formula = Profit ~ 1, data = dataset)
modelo_full = lm(formula = Profit ~ ., data = dataset)

modelo.optimo <- stepAIC(modelo_null,scope = list(lower = modelo_null,
                                                  upper = modelo_full),
                         direction = "both", trace = FALSE)
summary(modelo.optimo)




