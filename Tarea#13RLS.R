print("Pronostique el número de libras del vapor consumido en un mes donde la temperatura promedio es 65 °C")
x_65 <- 65
y_hat65 <- 245.82+ 1.13*x_65
print(y_hat65)
print("Esta es el numero de libras por vapor")


print("Si dos meses difieren en sus temperaturas promedio por 5 °C
      , ¿cuánto predice que será diferente el número de libras del vapor consumido?")

x_70 <- 70
y_hat70 <- 245.82+ 1.13*x_70
dif<- y_hat70 - y_hat65


print("la diferencia es de")
print(dif)






