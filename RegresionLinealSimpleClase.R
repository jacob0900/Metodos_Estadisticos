library(tidyverse)

#Importar datos 
df <- read_table("C:/Users/jacob/OneDrive/Escritorio/Datasets/data_rls.txt")
#5 primeras lineas
df %>% 
  head(n=5)
#Estrutura de los datos 
str(df)

#Grafico de dispersion 
df %>% 
  ggplot(mapping = aes(x=Edad, y=Resistencia))+
  geom_point()+
  geom_smooth(formula = 'y~x', method = 'lm')+
  theme_bw()

#Correlacion 
cor(df$Edad,df$Resistencia)
#Paso a paso la rls
y=df$Resistencia
x=df$Edad
n = nrow(df)
#promedios 
xbar=mean(x)
ybar=mean(y)
#Calculo Sxx y Sxy
Sxx = sum((x-xbar)^2)
Sxy = sum((x-xbar)*(y-ybar))

b1= Sxy/Sxx
b0 = ybar -b1*xbar

#funcion lm
modelo = lm(formula = Resistencia~Edad, data=df)
modelo 

#coeficientes 
b0 = modelo$coefficients[1]
b1 = modelo$coefficients[2]

#hallar residuos
yhat = b0+b1*x
e = y-yhat

# SSE 
SSE = sum(e^2)
gl = n-2
MSE = SSE /gl


RSE = sqrt(MSE)


#Usando la funcion 
summary(modelo)$sigma

#coeficiente de determinacion
summary(modelo)$r.square
#R2 paso a paso 
SST <- sum((y - y_bar)^2)
SSE <- sum((y - y_hat)^2)
SSR = SST - SSE 
prin("tambien puedo escribirlo asi sum((yhat-mean(y))^2) al SSR")
SST = sum((y-mean(y))^2)
R2 = 1 - SSR/SST



