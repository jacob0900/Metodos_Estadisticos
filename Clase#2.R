#libreria 
library("tidyverse")
install.packages("patchwork")
library(patchwork)

#Datos 
url <- "https://raw.githubusercontent.com/cdeoroaguado/Datos/refs/heads/main/datamanip/sales.csv"
datos <- read.csv(url)

str(datos)

datos %>% 
  select(-X,-date) -> df


df %>% 
  summarise(
    n = length(unemployment),
    media = mean(unemployment),
    ds = sd(unemployment),
    mediana = median(unemployment),
    minimo = min(unemployment),
    maximo = max(unemployment),
    Q1 = quantile(unemployment, 0.25),
    Q3 = quantile(unemployment, 0.75),
    IQR = IQR(unemployment)
  ) %>% 
  mutate(variable = 'unemployment') -> var_num_employ

bind_rows(var_num_temp,var_num_fuel,var_num_temp) %>% 
  select(variable,everything())



# Boxplot de temperature_c
p1 <- df %>%
  ggplot(aes(x="", y = temperature_c)) +
  geom_boxplot(fill = "#1f77b4", alpha = 0.7) +
  labs(
    title = "Distribucion de temperatura",
    y = "Temperatura (°C)",
    x = ""
  ) +
  theme_bw()

# Boxplot de fuel_price_usd_per_l
p2 <- df %>%
  ggplot(aes(x="",y = fuel_price_usd_per_l)) +
  geom_boxplot(fill = "#2ca02c", alpha = 0.7) +
  labs(
    title = "Distribucion del precio del combustible",
    y = "Precio (USD/litro)",
    x = ""
  ) +
  theme_bw()

# Boxplot de unemployment
p3 <- df %>%
  ggplot(aes(x="",y = unemployment)) +
  geom_boxplot(fill = "#d62728", alpha = 0.7) +
  labs(
    title = "Distribucion del desempleo",
    y = "Tasa de desempleo (%)",
    x = ""
  ) +
  theme_bw()

# Unir los tres gráficos en una sola visualización
p1 + p2 + p3  
