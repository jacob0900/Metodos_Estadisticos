library(tidyverse)


df <- read_table("C:/Users/jacob/OneDrive/Escritorio/Datasets/data_pintura.txt")
## table(df$a,df$b)

## Estimacionde los betas 
y=df$y
x1=df$x1
x2=df$x2

#Matriz 
X= cbind(Intercepto=1, x1=x1, x2=x2)
XtX= t(X)%*%X
Xty= t(X)%*%y
betas_hat= solve(XtX,Xty)


y_hat= X%*%betas_hat
e=y-y_hat
SSE = t(e)%*%e

SSE = t(y)%*%y-t(betas_hat)%*%t(X)%*%y

## MSE
n= nrow(X)
p=ncol(X)

MSE= SSE/(n-p)
RMSE= sqrt(MSE)

modelo=lm(y~1+x1+x2,data=df)
summary(modelo)$sigma^2

### Hagamos el anova 

SST= t(y)%*%y- (sum(y))^2/n
SSR= SST - SSE
k=p-1
MSR= SSR/k

F0=MSR/MSE
pvalor =pf(F0,k,n-p,lower.tail=FALSE)
  
##Algunos de los estimadores es diferente de cero 

summary(modelo)$coefficients

## prueba de significancia paso a paso 

XtX_inv= solve(XtX)
Vb= as.numeric(MSE)*XtX_inv
se_b= sqrt(diag(Vb))
tcalc = betas_hat/se_b
pvalor= 2*pt(-abs(tcalc), df = n-p  )

#Intevalo de confianza de los betas 
confint.default(modelo)

##paso a paso ic
alpha= 0.05
tcrit = qt(1-alpha/2, df = n-p)

lower <- as.vector(betas_hat) - tcrit * se_b
upper <- as.vector(betas_hat) + tcrit * se_b

res_ci <- data.frame(
  Coeficiente = colnames(X),
  Estimador = as.vector(betas_hat),
  Std.Error = se_b,
  t_crit = tcrit,
  IC_inf = lower,
  IC_sup = upper,
  check.names = FALSE
)
print(res_ci)

# intervalos de confianza del 95% para los coeficientes
confint.default(modelo)


## Calculamos los R2
R2= 1-SSE/SST
R2_ajustado= 1-(SSE/(n-p))/(SST/(n-1))
  
##Intervalo de confianza para E(Y|xo)
dato_nuevo=data.frame(
  x1=10,
  x2= 8
) 
predict(modelo, newdata= dato_nuevo)
predict(modelo, newdata= dato_nuevo, inteval = 'confidence')

  
##Intervalo de confianza para E(Y|xo) pao a paso
x0_trans = cbind(intercepto=1,x1=10,x2= 8)
y_hat= x0_trans%*%betas_hat
v_mean_y = as.numeric(MSE)*x0_trans%*%XtX_inv%*%t(x0_trans)
se_mean_y= sqrt(v_mean_y)
alpha= 0.05
tcrit = qt(1-alpha/2, df = n-p)

IC_mean_inf= y_hat - tcrit* se_mean_y
IC_mean_sup= y_hat + tcrit* se_mean_y


# Supongamos que queremos determinar el espesor de la capa de pintura para las condiciones
# x0 = (10, 8), es decir, cuando x1 = 10 y x2 = 8.
# En R procedemos de la siguiente manera:


# cálculo de E[y|x_1 = 10, x_2 = 8]
dato_nuevo <- data.frame(x1 = 10, x2 = 8)
predict(modelo, newdata = dato_nuevo)



# Esto es cuando queremos hacer una estimacion de l 95%
# cálculo de E[y|x_1 = 10, x_2 = 8]
predict(modelo, newdata = dato_nuevo, interval = 'confidence')