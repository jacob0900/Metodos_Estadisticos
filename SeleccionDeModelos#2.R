library(tidyverse)
library(fst)
library(MASS)
library(olsrr)

df = read_csv("C:/Users/jacob/OneDrive/Escritorio/Datasets/50_Startups.csv")

## seleccion del modelo paso a paso 

modelo_completo = lm(Profit~ ., data=df)
summary(modelo_completo)

submodelo_1 <- lm(Profit ~ `R&D Spend` + 
                    Administration + 
                    `Marketing Spend`, data = df)
summary(submodelo_1)
anova(modelo_completo, submodelo_1)

submodelo_2 <- lm(Profit ~ `R&D Spend`+ 
                    `Marketing Spend`, data = df)
summary(submodelo_2)
anova(submodelo_1, submodelo_2)

submodelo_3 <- lm(Profit ~ `R&D Spend` 
                    , data = df)
summary(submodelo_3)
anova(submodelo_2, submodelo_3)

#Mostrar AIC individualmente 

AIC(modelo_completo)
AIC(submodelo_1)
AIC(submodelo_2)
AIC(submodelo_3)

# O todos juntos en una tabla 
AIC(modelo_completo,submodelo_1,submodelo_2,submodelo_3)

k = ols_step_all_possible(modelo_completo)
results=k$result
results[which.min(results$sbic)]




