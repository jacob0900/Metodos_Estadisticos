library(GGally)
library(tidyverse)
##Lectura de datos

df = data_pintura
head(df)
# En este caso, la variable respuesta y representa el espesor de la capa de pintura (en micrones),
# mientras que x1 corresponde a la presión del aire (en psi) y x2 a la velocidad 
# de la banda transportadora (en m/s).

labs_cols = c("x1" = "Presion del aire (psi)",
              "x2" = "Velocidad de banda (m/s)",
              "y" = "Espesor (micrones)")

# Red de gráficos:
df %>% 
  ggpairs(
    columns = c("x1", "x2", "y"),
    columnLabels = labs_cols[c("x1", "x2", "y")],
    diag  = list(continuous = "densityDiag"),
    upper = list(continuous = GGally::wrap("cor", method = "pearson", stars = TRUE, size = 4)),
    lower = list(continuous = GGally::wrap("smooth", method = "lm", se = FALSE))
  ) +
  theme_bw() +
  labs(title = "Relaciones entre y (espesor), x1 (presión) y x2 (velocidad)",
       subtitle = "Diagonal: densidades • Superior: correlación (★ p-valor) • Inferior: ajuste lineal")

# • La Figura anterior muestra la red de diagramas de dispersión entre la variable respuesta y
#   (espesor de la capa de pintura) y las variables predictoras x1 (presión del aire) y x2
#   (velocidad de la banda transportadora). A partir del gráfico se pueden obtener las siguientes
#   conclusiones:
#
# a. Relación entre y y x1 (presión del aire): Se observa una fuerte correlación positiva (r = 0.890,
#    altamente significativa).
#    A medida que la presión del aire aumenta, también lo hace el espesor de la capa de pintura.
#    Esto indica que x1 tiene una influencia directa e importante sobre la variable respuesta.
#
# b. Relación entre y y x2 (velocidad de la banda): Se presenta una correlación negativa moderada
#    (r = -0.317), estadísticamente significativa. A mayor velocidad de la banda, el espesor tiende a
#    disminuir, lo cual es consistente con el comportamiento físico del proceso: una mayor velocidad
#    reduce el tiempo de exposición y, por tanto, la cantidad de pintura depositada.
#
# c. Relación entre x1 y x2: La correlación entre las variables explicativas es muy baja (r = -0.041),
#    indicando independencia práctica entre ambas. Esto es favorable, ya que sugiere ausencia de
#    multicolinealidad, lo que garantiza estimadores más estables en el modelo.
#
# 3. Un gráfico en 3D permite explorar visualmente la relación conjunta entre las tres variables del
#    proceso de pintura electrostática: el espesor de la capa (y), la presión del aire (x1) y la velocidad
#    de la banda transportadora (x2). Este diagrama puede generarse con el paquete scatterplot3d,
#    como se muestra a continuación:

library(scatterplot3d)

# Gráfico 3D

scatterplot3d(
  x = df$x1,
  y = df$x2,
  z = df$y,
  pch = 16,
  color = "steelblue",
  type = "h",          # Líneas verticales desde el plano XY
  highlight.3d = TRUE, # Resalta profundidad con color
  angle = 55,
  xlab = "Presión del aire (psi)",
  ylab = "Velocidad de la banda (m/s)",
  zlab = "Espesor de la capa (micrones)",
  cex.lab = 1.1
)

# • El gráfico 3D muestra que al aumentar la presión del aire, el espesor de la capa también aumenta,
#   mientras que al incrementar la velocidad de la banda, el espesor disminuye ligeramente.
#
# 4. El mismo gráfico de dispersión 3D puede construirse de manera interactiva con el paquete plotly.
#    Esto permite rotar, acercar o explorar los puntos desde diferentes ángulos, lo cual facilita la
#    visualización del comportamiento del espesor frente a la presión y la velocidad.

library(plotly)

# Gráfico 3D interactivo

plot_ly(
  data = df,
  x = ~x1,
  y = ~x2,
  z = ~y,
  type = "scatter3d",
  mode = "markers",
  marker = list(size = 5, color = ~y, colorscale = "Reds", showscale = TRUE)
) %>%
  layout(
    title = list(text = "Gráfico 3D interactivo: relación entre presión, velocidad y espesor"),
    scene = list(
      xaxis = list(title = list(text = "Presión del aire (psi)")),
      yaxis = list(title = list(text = "Velocidad de la banda (m/s)")),
      zaxis = list(title = list(text = "Espesor de la capa (micrones)"))
    )
  )
# El gráfico 3D interactivo muestra que el espesor de la capa aumenta con la presión del aire
# y disminuye ligeramente al aumentar la velocidad de la banda, confirmando una tendencia lineal
# coherente con el modelo de regresión múltiple.
#
# Para ajustar (entrenar) el modelo de regresión múltiple, encontremos los coeficientes; lo haremos
# paso a paso:

# 1) Construir matriz de diseño X y vector y
# X incluye el intercepto y las variables x1 y x2.
# y se convierte en matriz para operaciones matriciales.
X <- cbind(Intercept = 1, x1 = df$x1, x2 = df$x2)
y <- as.matrix(df$y)

# 2) Calcular X'X
# XtX es la matriz producto entre X transpuesta y X.
XtX <- t(X) %*% X
print(round(XtX, 6))

# Invertir X'X
# XtX_inv es la inversa necesaria para la fórmula de mínimos cuadrados.
XtX_inv <- solve(XtX)
print(round(XtX_inv, 6))

# Calcular X'y
# Xty es el producto entre X transpuesta y el vector respuesta y.
Xty <- t(X) %*% y
print(round(Xty, 6))

# 3) Estimadores del RLM: beta_hat = (X'X)^{-1} X'y

beta_hat <- XtX_inv %*% Xty
rownames(beta_hat) <- c("(Intercepto)","x1","x2")
colnames(beta_hat) <- "Estimadores"

print(round(beta_hat, 6))

#Para estimar el modelo de RLM, utilizamos la función lm como se muestra a continuación:

# ajuste del modelo de RLM
modelo <- lm(y ~ x1 + x2, data = df)
summary(modelo)

# El modelo estimado con los datos experimentales es:
# ŷᵢ = 66.285 + 1.483 x1ᵢ − 1.055 x2ᵢ,   εᵢ ~ N(0, σ²),  σ² = constante.
#
# Interpretación:
# β1 = 1.483: al aumentar la presión del aire en una unidad (1 psi),
#     el espesor promedio de la capa aumenta aproximadamente 1.483 micrones,
#     manteniendo constante la velocidad de la banda.
#
# β2 = −1.055: al incrementar la velocidad de la banda en una unidad (1 m/s),
#     el espesor promedio disminuye en aproximadamente 1.055 micrones,
#     manteniendo constante la presión del aire.
#
# β0 = 66.285: representa el espesor promedio estimado cuando tanto la presión
#     como la velocidad son cero (valor teórico de referencia).
#
# 7. Ahora, obtengamos los residuos paso a paso:

# Valores ajustados y residuales (opcional para comprobar)
y_hat <- X %*% beta_hat
e <- y-y_hat
head(cbind(y_observado=y[,1],y_ajustado=y_hat[,1],residuo=e[,1]))

#Usando la función resid, obtienes el residual
residuos <- resid(modelo)
head(residuos)

#coeficientes estimados
coefficients(modelo)

# A partir de estos coeficientes, el modelo ajustado será:
# ŷ = 66.285 + 1.483 x1 − 1.055 x2
#
# Note que esta es la ecuación de un plano en el espacio (x1, x2, y).

#ESTIMADOR INSESGADO DE o^2 (VARIANZA^2 = sigma^2)
library(knitr)

# Variables target e independientes
y  <- df$y
x1 <- df$x1
x2 <- df$x2

# 1) Matriz de diseño X
X <- cbind(Intercepto = 1, x1 = x1, x2 = x2)

# 2) Estimación de betas
XtX   <- t(X) %*% X
Xty   <- t(X) %*% y
beta_hat <- solve(XtX, Xty)

print(beta_hat)

# 3) Calcular SSE usando:
SSE <- as.numeric(t(y) %*% y - t(beta_hat) %*% t(X) %*% y)

# 4) Verificación con residuos directos
y_hat <- X %*% beta_hat
e <- y - y_hat
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

kable(resultados, digits = 6, align = c("c", "c"), caption = "Resumen de resultados del modelo")

# estimación de sigma^2
summary(modelo)$sigma^2

# Por lo tanto, el modelo estimado será:
#
# ŷ = 66.285 + 1.483 x1 − 1.055 x2
#
# ε ~ N(0, σ²)
#
# σ² = 7.655

# --- Tabla ANOVA en R para RMarkdown ---
library(knitr)

anova_tab <- data.frame(
  `Fuente de variación` = c("Regresión", "Residuales", "Total"),
  `Suma de cuadrados`   = c("SSR", "SSE", "SST"),
  `Grados de libertad`  = c("k", "n - k - 1", "n - 1"),
  `Cuadrado medio`      = c("MSR = SSR / k", "MSE = SSE / (n - k - 1)", "---")
)

kable(
  anova_tab,
  caption = "Análisis de varianza para determinar la significancia del modelo",
  align = "lccc"
)

#HAGAMOS EL ANOVA

# 1) Cálculo algebraico de SST 
SST <- as.numeric(t(y) %*% y - (sum(y)^2)/n)

# 2) Cálculo algebraico de SSR 
SSR <- as.numeric(t(beta_hat) %*% t(X) %*% y - (sum(y)^2)/n)

# 3) Cálculo algebraico de SSE 
SSE <- as.numeric(t(y) %*% y - t(beta_hat) %*% t(X) %*% y)

# 4) ANOVA (df, MS, F0 y p-valor) ---
k <- p -1
df_reg <- k
df_res <- n - k - 1
df_tot <- n - 1

MSR <- SSR / df_reg
MSE <- SSE / df_res
F0  <- MSR / MSE
p_val <- pf(F0, df_reg, df_res, lower.tail = FALSE)

# 5) Mostrar resultados en tablas 

tab_anova <- data.frame(
  `Fuente de variación` = c("Regresión", "Residuales", "Total"),
  `Suma de cuadrados`   = c(SSR, SSE, SST),
  `Gl`                  = c(df_reg, df_res, df_tot),
  `Cuadrado medio`      = c(MSR, MSE, NA),
  `F0`                  = c(F0, NA, NA),
  `p-valor`             = c(p_val, NA, NA)
)

kable(
  tab_anova,
  digits = 6,
  align = "lrrrrr",
  caption = "Tabla ANOVA (derivada algebraicamente)"
)
#Verificamos con la funcion
summary(modelo)$fstatistic

#PRUEBA INDIVIDUAL DE SIGNIFICANCIA PARA LOS COEFICIENTES

#Seguimos con ejemplo del espesor de la pintura. Usando la función lm y 
#summary podemos obtener la inferencia para cada β

summary(modelo)$coefficients

#HAGAMOS EL PASO A PASO
# Matrices
y  <- df$y
X  <- cbind(Intercepto = 1, x1 = df$x1, x2 = df$x2)

# Dimensiones
n <- nrow(X)  
p <- ncol(X) 

# Estimacion de betas
XtX      <- t(X) %*% X
XtX_inv  <- solve(XtX)
Xty      <- t(X) %*% y
beta_hat <- XtX_inv %*% Xty

# Residuos y varianza residual
y_hat <- X %*% beta_hat
e     <- y - y_hat
SSE   <- as.numeric(crossprod(e))
MSE   <- SSE / (n - p)

# Varianza-covarianza de betas
Vb <- as.matrix(MSE * XtX_inv)

# Error estándar de cada beta_hat_j
se_b <- sqrt(diag(Vb))

# Estadístico t calculado
tval <- beta_hat / se_b
df_t <- n - p

# p-valores bilaterales: 2*P(T > |t|)
pval <- 2 * pt(-abs(tval), df = df_t)

#INVERVALOS DE CONFIANZA PARA B_j

alpha <- 0.05 # cambia si deseas otro nivel
tcrit <- qt(1 - alpha/2, df = n - p)

lower <- as.vector(beta_hat) - tcrit * se_b
upper <- as.vector(beta_hat) + tcrit * se_b

res_ci <- data.frame(
  Coeficiente = colnames(X),
  Estimador = as.vector(beta_hat),
  Std.Error = se_b,
  t_crit = tcrit,
  IC_inf = lower,
  IC_sup = upper,
  check.names = FALSE
)
print(res_ci)

#Una forma de construir los intervalos de confianza para los coeficientes del modelo es 
#utilizando la función confint.default
confint.default(modelo)

#COEFICIENTE DE DETERMINACION R^2 y R^2 AJUSTADO DE LA RLM

###############################################################
# Recordemos que, adicional al MSE, a partir de la tabla ANOVA 
# es posible calcular el porcentaje de variabilidad de la 
# respuesta explicado por el modelo de regresión lineal múltiple (RLM),
# conocido como coeficiente de determinación o, simplemente, R^2:
#
#                   R^2 = SSR / SST = 1 − SSE / SST
#
# El coeficiente R^2 mide qué proporción de la variabilidad total 
# de y es explicada por el modelo. Sin embargo, R^2 tiende a aumentar 
# conforme se agregan más variables, incluso si no son relevantes.
#
# Por ello se recomienda utilizar el R^2 ajustado, definido como:
#
#        R^2_ajustado = 1 − [ SSE / (n − p) ]  /  [ SST / (n − 1) ]
#
# La interpretación de esta medida es similar a la del R^2: indica 
# la proporción de la variabilidad explicada, pero *corrigiendo* 
# el sesgo por el número de predictores en el modelo.
###############################################################

#HALLAMOS R^2 y R^2 AJUSTADO
R2 <- SSR/SST
R2_ajusta <- 1-(SSE/(n-p))/(SST/(n-1))

# Supongamos que queremos determinar el espesor de la capa de pintura
# para las condiciones x0 = (10, 8), es decir, cuando x1 = 10 y x2 = 8.
# En R procedemos de la siguiente manera:

# cálculo de E[y|x_1 = 10, x_2 = 8]
dato_nuevo <- data.frame(x1 = 10, x2 = 8)
predict(modelo, newdata = dato_nuevo)

# Si trabajamos bajo las condiciones x0, se espera que, en promedio,
# el espesor de la capa de pintura sea 72.67 micrones.
#
# Para otros argumentos y opciones, se sugiere al lector escribir
# ?predict.lm en la consola de R.
#
# Ahora, si es de interés calcular un intervalo de confianza del 95%,
# agregamos el argumento interval = 'confidence' a la instrucción anterior:

# cálculo de E[y|x_1 = 10, x_2 = 8]
predict(modelo, newdata = dato_nuevo, interval = 'confidence')

# Por lo tanto, se espera que, si continuamos trabajando bajo las condiciones
# x1 = 10 y x2 = 8, el espesor de capa promedio sea 72.67 micrones.
#
# A nivel poblacional, dicho promedio se encontrará en el intervalo
# (71.646, 73.695) con una confianza del 95%.

#HAGAMOSLO PASO A PASO

# 1) modelo ajustado
modelo <- lm(y ~ x1 + x2, data = df)
summary(modelo)

# 2) dato_nuevo'
dato_nuevo <- data.frame(x1 = 10, x2 = 8) 

# 3) Extraer la matriz de diseño del modelo y dimensiones

X  <- model.matrix(modelo)      # matriz de diseño usada al ajustar
n  <- nrow(X)                   # número de observaciones
p  <- length(coef(modelo))      # número de parámetros (incluye intercepto)
gl <- n - p                     # grados de libertad residuales

# 4) Construir la fila de diseño del punto nuevo x0
TT  <- delete.response(terms(modelo))
x0 <- model.matrix(TT, dato_nuevo)             # matriz 1x(p)

# 5) Estimaciones básicas del modelo
beta_hat   <- coef(modelo)                     # betas
yhat_mean  <- drop(x0 %*% beta_hat)            # E[Y|x0] estimado
print(yhat_mean)

# 6) Estimar sigma^2 = SSE/(n - p)
SSE <- sum(residuals(modelo)^2)         # suma de cuadrados de residuos
sigma2_hat <- SSE / gl

# 6) Calcular la inversa de X'X
XtX_inv <- solve(t(X) %*% X)

# 7) se_mean= (sigma^2 * x0'(X'X)^{-1}x0)
se_mean <- sqrt(drop(x0 %*% XtX_inv %*% t(x0)) * sigma2_hat)

# 8) Valor crítico t para nivel 1 - alpha
alpha <- 0.05
tcrit <- qt(1 - alpha/2, df = gl)

# Paso 8) Intervalo de confianza para E[Y|x0]
ci_low  <- yhat_mean - tcrit * se_mean
ci_high <- yhat_mean + tcrit * se_mean

resultado_media <- data.frame(
  .fitted   = yhat_mean,
  se_mean   = se_mean,
  conf_low  = ci_low,
  conf_high = ci_high,
  df        = gl,
  level     = 1 - alpha
)
resultado_media

#INTEVALO DE PREDICCION PARA E[Y | x_0]

#Para calcular un intervalo de predicción del  95%, agregamos el argumento 
#interval = 'prediction' a la instrucción anterior:
# intervalo de predicción para E[y|x_1 = 10, x_2 = 8]
predict(modelo, newdata = dato_nuevo, interval = 'prediction')


# dato nuevo
dato_nuevo <- data.frame(x1 = 10, x2 = 8)

# 1) Construir la fila de diseño x0 coherente con el modelo
TT  <- delete.response(terms(modelo))      # quita la respuesta de la fórmula
x0  <- model.matrix(TT, data = dato_nuevo) # matriz 1x(p)

# 2) Extraer cantidades del ajuste
X          <- model.matrix(modelo)         # matriz de diseño del entrenamiento
beta_hat   <- coef(modelo)                 # vector beta
n          <- nrow(X)
p          <- length(beta_hat)
gl         <- n - p

# 3) Predicción puntual en x0
yhat_0 <- drop(x0 %*% beta_hat)

# 4) Estimar la varianza residual sigma2 = SSE/(n-p)
SSE        <- sum(residuals(modelo)^2)
sigma2_hat <- SSE / gl

# 5) Calcular el leverage de x0: h0 = x0'(X'X)^{-1}x0
XtX_inv <- solve(t(X) %*% X)
h0      <- drop(x0 %*% XtX_inv %*% t(x0))

# 6) se_pred = sqrt(sigma2 * (1 + h0))
se_pred <- sqrt(sigma2_hat * (1 + h0))

# 7) Valor crítico t y extremos del intervalo
alpha <- 0.05
tcrit <- qt(1 - alpha/2, df = gl)

pred_low  <- yhat_0 - tcrit * se_pred
pred_high <- yhat_0 + tcrit * se_pred

## Resultado
resultado <- data.frame(
  .fitted   = yhat_0,
  se_pred   = se_pred,
  pred_low  = pred_low,
  pred_high = pred_high,
  df        = gl,
  level     = 1 - alpha
)

resultado

# Este resultado indica que, bajo las condiciones x1 = 10 y x2 = 8,
# el valor del espesor de la capa de pintura para la próxima unidad
# experimental será 72.67 micrones.
#
# A nivel poblacional, dicho valor se encontrará en el intervalo
# (67.085, 78.257) con una confianza del 95%.


#ANALISIS DE RESIDUALES
# El análisis de residuales en RLM es fundamental para:
#
# Validar los supuestos del error;
# identificar observaciones outlier o atípicas; e
# identificar observaciones influenciales.

#VALIDEMOS LOS SUPUESTOS DEL MODELO

# ajuste del modelo de RLM
modelo <- lm(y ~ x1 + x2, data = df)

#VALIDAMOS INDEPENDENCIA
library(car)
car:::durbinWatsonTest(modelo)
# ACF de los residuales
r <- residuals(modelo)  # cálculo de los residuales
acf(r, las = 1, main = "",lag.max = 80)
#Se cumple que los residuales del modelo ajustados son independientes.

#VALIDAMOS NORMALIDAD DE LOS ERRORES
shapiro.test(r)
# Q-Q plot usando el paquete car
library(car, quietly = TRUE)
car:::qqPlot(r, las = 1)
#Se cumple que los residuales del modelo ajustado siguen una distribución normal.

#MEDIA DE LOS ERRORES

#validacion media 0 en RLM
t.test(r,mu=0)
#Concluimos que con una confianza del  95%, que la media de los residuales es cero a nivel poblacional.


#VARIANZA CONSTANTE DE LOS ERRORES 
# prueba de Breusch-Pagan para varianza constante
library(lmtest)
lmtest:::bptest(modelo)
#Concluimos que la varianza del modelo es constante.


#Los gráficos de residuales explicados anteriormente se pueden obtener usando la función plot 
#sobre el modelo ajustado modelo:
par(mfrow=c(2, 2))
plot(modelo, las=1, col='darkseagreen', which=1:3)

#IDENTIFICACION DE OUTLIERS

# Los outliers son también conocidos como observaciones atípicas en los datos.
# A partir del modelo ajustado, podemos calcular:
#
# 1. Residuales crudos
#    ê_i = y_i − ŷ_i
#
# 2. Residuales estandarizados
#    d_i = ê_i / σ = ê_i / RMSE, donde RMSE = √MSE
#
# 3. Residuales estudiantizados
#    r_i = ê_i / (σ * √(1 − h_ii))
#
# donde h_ii = X (X'X)^{-1} X'_i es el leverage,
# y H = X (X'X)^{-1} X' es la matriz hat.


# residuales crudos
r_crudo <- residuals(modelo)

# residuales estudentizados
r_est <- rstudent(modelo)

# residuales estandarizados
r_normal <- rstandard(modelo)

# donde modelo es el objeto R que contiene en modelo de RLM estimado. 
#Para más detalles, se sugiere consultar la ayuda de cada función: 
#?residuals, ?rstudent y ?rstandard.

r = rstudent(modelo)
which(r < -3 | r>3)

# La observación 18 podría considerarse un outlier.
# En la práctica, el siguiente paso es evaluar la trazabilidad de esa observación
# y determinar si existen o no causas asignables para que esta sea un outlier.
#
# En caso de que exista una causa asignable, dicha observación debería removerse
# de la base de datos y, con los datos reducidos, estimar nuevamente el modelo de RLM.

# Otra forma de detectar outliers es a través de la prueba de Bonferroni.
#
# La prueba de hipótesis es:
#   H0 : la observación i-ésima NO es un outlier
#   vs
#   H1 : la observación i-ésima SÍ es un outlier
#
# Esta prueba está implementada en la función outlierTest del paquete car.

library(car)
outlierTest(modelo,n.max = 5)

# En la parte superior vemos que la observación 18 tiene el mayor valor
# del residual estudentizado. Sin embargo, el valor p = 0.1116 es superior a 0.05,
# por lo que no tenemos evidencia suficiente para concluir que dicha observación
# representa un outlier.
#
# Gráficamente es posible identificar cuáles son las observaciones influenciales
# utilizando la función influenceIndexPlot del paquete car:

# Gráfico de índices de influencia del modelo.
# 'vars = "Bonf"' indica que se graficará el valor p de la prueba de Bonferroni
# (detecta observaciones con residuales studentizados extremos).
# 'las = 1' cambia la orientación de las etiquetas del eje Y (horizontal), para mayor legibilidad.
influenceIndexPlot(modelo, vars = "Bonf", las = 1)

# La mayoría de las observaciones tienen p-valores cercanos a 1,
# lo que indica que no presentan evidencia de ser outliers en la variable dependiente.
#
# Solo una observación (la número 18) muestra un p-valor claramente más bajo
# (alrededor de 0.15), aunque aún no es menor que 0.05, el umbral común
# para considerar un outlier significativo con corrección de Bonferroni.

#IDENTIFICACION DE OBSERVACIONES INFLUENCIALES
# 1) Distancia de Cook
Di <- cooks.distance(modelo)

# 2) Define TU umbral (reemplaza el valor por el que manejas)
n <- nobs(modelo)
p <- length(coef(modelo))
umbral <- 4/(n-p-2)       

# 3) Índices por encima de tu umbral
infl_idx <- which(Di > umbral)
infl_idx
# 4) Tabla ordenada resaltando si supera tu umbral
ord <- order(Di, decreasing = TRUE)
tab <- data.frame(
  idx = ord,
  cooks_distance = Di[ord],
  supera_umbral  = Di[ord] > umbral
)
head(tab, 10)

# 5) Gráfico con tu umbral
plot(Di, type = "h",
     ylab = "Cook's distance (D_i)", xlab = "Índice",
     main = "Distancia de Cook (línea = tu umbral)")
abline(h = umbral, lty = 2)    # tu umbral
text(infl_idx, Di[infl_idx], labels = infl_idx, pos = 3, cex = 0.8)
influenceIndexPlot(modelo, vars="Cook")

#ANALISIS DE MULTICOLINEALIDAD
#ES VER SI TODAS LAS VARIABLES QUE ESTAN EN NEUSTRO DATASET ESTAN RELACIONADAS ENTRE SI, ENTONCES
#PRIMERAMENTE SE APLICA kappa(modelo) y eso nos va a decir si existe sospecha de multicolinealidad
#(si es >30). Y en mctest una por una y nos arroja si hay o no hay multicolinealidad mctest es mejor.
kappa(modelo) #48.62

#UTILIZAMOS VIF PARA DETECTAR CUALES DELAS VARIABLES INDEPENDIENTES ES MAS COLINEAL de LAS K MEDIDAS
# cálculo del VIF
car:::vif(modelo)
#Puesto que en ninguna de las dos variables controlables el  VIF>5, 
#concluimos que no existe multicolinealidad.
library(mctest)
mctest(modelo,type = "b")
#1 --> COLLINEARITY is detected by the test 
#0 --> COLLINEARITY is not detected by the test
#TODAS EN ESTE CASO DIERON 0




