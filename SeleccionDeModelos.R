library(tidyverse)
library(fst)
library(MASS)


df = read_csv("C:/Users/jacob/OneDrive/Escritorio/Datasets/50_Startups.csv")

## modelos 

modelo_null = lm(y ~ 1, data= df)
modelo_full = lm(y ~ ., data= df)
sel_foward <- stepAIC(modelo_null,
                      scope=list(modelo_null, modelo_full),
                      direction = "both",
                      trace = FALSE
                      )







