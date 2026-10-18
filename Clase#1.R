 library(tidyverse)
#Libreria



#Datos
url <- "https://raw.githubusercontent.com/cdeoroaguado/Datos/refs/heads/main/datamanip/sales.csv"
datos <- read.csv(url)


#estructura de datos
dim(datos)
colnames(datos)
str(datos)


#ETL
datos %>%
  select(-X,-date)  -> df

#5 filas

head(df,n=5)
#valores nulos 

df%>%
  summarise(across(everything(), ~sum(is.na(.))))
#otras formas de mirar NAs


missmap(df)
