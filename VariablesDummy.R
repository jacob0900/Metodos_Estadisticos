library(tidyverse)
library(fst)
library(readr)
library(olsrr)

df = read_fst("C:/Users/jacob/OneDrive/Escritorio/Datasets/taiwan_real_estate (3).fst")
head(df)
str(df)
unique(df$house_age_years)

##Grafico del precio segun la antiguedad 

df %>% 
  ggplot(aes(price_twd_msq))+
  geom_histogram(bins=10)+
  facet_grid(.~house_age_years)+
  theme_bw()

df %>% 
  group_by(house_age_years) %>% 
  summarise(mean = mean(price_twd_msq),
     sd= sd(price_twd_msq))
     
df_anova = df %>% 
  select(price_twd_msq, house_age_years)

anova= aov(price_twd_msq~house_age_years,
           data = df_anova)
summary(anova)
TukeyHSD(anova)


# Modelo 
df <- df %>% 
  mutate(house_age_years = factor(house_age_years,
                                  levels = levels(house_age_years),
                                  ordered = FALSE ))

rlm_precio_vs_age = lm(price_twd_msq~house_age_years,
                       data = df)

summary(rlm_precio_vs_age)

#modelo completo vs nulo 

modelo_nulo = lm(price_twd_msq~1,
                 data = df)

modelo_completo = lm(price_twd_msq~.,
                 data = df)
summary(modelo_completo)

#selccion del modelo 

df<- read_delim("C:/Users/jacob/OneDrive/Escritorio/Datasets/inyectora.txt", 
                delim = "\t", escape_double = FALSE, 
                trim_ws = TRUE)
mod_iny= lm( y ~ . , data=df)
summary(mod_iny)


k<- ols_step_all_possible(mod_iny)
result= k$result

result[which.max(result$rsquare),]
result[which.max(result$adjr),]
result[which.max(result$aic),]

ggplot(result, aes(rsquare, aic))+
  geom_point()
subset(result, aic<350 & rsquare>0.8, 
       select=n:aic)








