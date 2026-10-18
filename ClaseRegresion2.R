library(tidyverse)

#Importar datos 
df <- read_table("C:/Users/jacob/OneDrive/Escritorio/Datasets/data_rls.txt")
x <- df$Edad
y <- df$Resistencia
n <- nrow(df)
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
# Ajustar el modelo 
modelo <-lm(formula= Resistencia ~ Edad,
            data = df)
#coeficientes 
b0= modelo$coefficients[1]
b1=modelo$coefficients[2]

#hallar residuos
yhat = bo+b1*x
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
SSR = sum((yhat-mean(y))^2)
SST = sum((y-mean(y))^2)
R2 = SSR/SST





















