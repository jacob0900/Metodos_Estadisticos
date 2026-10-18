library(tidyverse)
library(GGally)
library(scatterplot3d)
library(plotly)
library(knitr)

#data 
datos <- read_table("C:/Users/jacob/OneDrive/Escritorio/Datasets/data_pintura.txt")


#EDA 
datos %>% 
  ggpairs()+
  theme_bw()

#grafica 3d
plot_ly(
  data = datos, x = ~x1, y = ~x2, z = ~y,
  type = 'scatter3d'
) %>% 
  layout(scene = list(
    xaxis = list(title = 'presion del aire'),
    yaxis = list(title = 'velocidad'),
    zaxis = list(title = 'espesor de la capa')
  ))

##Ajustamos el modelo 
modelo = lm(y~x1+x2,data=datos)
summary(modelo)

#ajuste del modelo paso a paso 
X=cbind(intecepto=1,x1=datos$x1,x2=datos$x2)
dim(X)
y = as.matrix(datos$y)
dim(y)

XtX= t(X)%*%X
det(XtX)
XtX_inv= solve(XtX)
Xty= t(X)%*%y
betas_hat = XtX_inv%*%Xty
rownames(betas_hat) <- c("(Intercepto)","x1","x2")
colnames(betas_hat) <- "Estimadores"

print(round(betas_hat, 6))

# Interpretación de los coeficientes del modelo lineal:

# β1 = 1.483  
# Al aumentar la presión del aire en una unidad (1 psi),
# el espesor promedio de la capa aumenta aproximadamente 1.483 micrones,
# manteniendo constante la velocidad de la banda.

# β2 = -1.055  
# Al incrementar la velocidad de la banda en una unidad (1 m/s),
# el espesor promedio disminuye en aproximadamente 1.055 micrones,
# manteniendo constante la presión del aire.

# β0 = 66.285  
# Representa el espesor promedio estimado cuando tanto la presión como la velocidad son cero,
# es decir, un valor teórico de referencia del modelo.


# 3) Calcular SSE usando:
SSE <- as.numeric(t(y) %*% y - t(betas_hat) %*% t(X) %*% y)

#hallemos el yhat
y_hat= X%*% betas_hat
e = y -y_hat
summary(e)
summary(modelo)


#residuos 
residuo=resid(modelo)
head(residuo)
head(e) 



SSE_residuos <- sum(e^2)

# 5) MSE y RMSE
n <- nrow(X)           # número de observaciones
p <- ncol(X)           # número de parámetros (incluido intercepto)

MSE  <- SSE / (n - p)   # Error cuadrático medio
RMSE <- sqrt(MSE)       # Raíz del error cuadrático medio

# 6) Mostrar resultados

resultados <- data.frame(
  Métrica = c("n (obs)", "p (parámetros)", "SSE", "MSE", "RMSE"),
  Valor = c(n, p, SSE, MSE, RMSE)
)

knitr::kable(resultados, digits = 6, align = c("c", "c"), caption = "Resumen de resultados del modelo")

summary(modelo)$sigma^2





