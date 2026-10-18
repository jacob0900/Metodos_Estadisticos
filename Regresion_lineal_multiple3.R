library(lmtest)
library(car)
library(tidyverse)
library(GGally)
library(scatterplot3d)
library(plotly)
library(readr)

#data 
df <- read_table("C:/Users/jacob/OneDrive/Escritorio/Datasets/data_pintura.txt")

modelo = lm(y~x1+x2, data=df)
summary(modelo)


car::durbinWatsonTest(modelo)

#independencia
r <- residuals(modelo)
acf(r, las= 1, main="", lag.max=80)

#normalidad
shapiro.test(r)
car::qqPlot(r, las=1)

#media de errores
mean(r)
t.test(r, mu=0)

#varianza constante

lmtest::bptest(modelo) #varianza constante, pvalor= 0.53

plot(modelo, col='darkgreen', which=1:3)

#residuales crudos

r<- residuals(modelo)
r_est <- rstandard(modelo)
r_estud <- rstudent(modelo)

which(r_estud< -3 | r_estud > 3)

#prueba de hipotesis: h0= la observación i-ésima no es un otlier, h1= la observación i-ésima si es un outlier

#prueba de bonferroni para datos atípicos

outlierTest(modelo, n.max=5)

#observaciones influenciales
influenceIndexPlot(modelo, vars='Bonf', las=1)

#distancia de cook
Di= cooks.distance(modelo)

n<- nobs(modelo)
p<- length(coef(modelo))
umbral = 4/(n-p-2)

idx_infl= which(Di > umbral)
print(idx_infl)
influenceIndexPlot(modelo, vars= 'Cook')

#eliminamos los datos que empeoran el modelo
df2<- df[-c(18, 28 , 38 , 77),]
modelo2=lm(y~x1+x2, data=df2)

summary(modelo2)
summary(modelo)

#mejoró el modelo 



# Pruebas globales e individual de multicolinealidad
library(mctest)
mctest(modelo, type = "b")








