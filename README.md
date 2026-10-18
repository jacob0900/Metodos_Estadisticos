# Métodos Estadísticos

Códigos en **R** y **R Markdown** que se trabajaron durante el curso de **Métodos Estadísticos**, materia de la cual soy monitor. Incluye los scripts vistos en clase, las tareas, guías de apoyo, ejercicios de preparación para los parciales y trabajos del curso.

## Temas y archivos

### 1. Introducción a R y análisis exploratorio

| Archivo | Contenido |
|---|---|
| `Clase#1.R`, `Clase#2.R` | Carga de datos y diagramas de caja con `ggplot2` |
| `Guia EDA.Rmd` | Guía de análisis exploratorio: naturaleza de las variables, valores faltantes y resumen de la variable objetivo |
| `Guia Graficos.Rmd` | Qué gráfico usar según el tipo de variable (cualitativa o cuantitativa), con plantillas personalizables |
| `Univariante.Rmd`, `EDAFINAL.Rmd` | Análisis univariado completo del dataset *Concrete Compressive Strength* |

### 2. Pruebas de normalidad

| Archivo | Contenido |
|---|---|
| `Clase#3.R` | Shapiro-Wilk, Kolmogorov-Smirnov y Lilliefors, y prueba *t* para datos antes y después de una intervención |
| `FuncionNormalidad.R` | Función que evalúa la normalidad de todas las variables numéricas de un data frame y resume las conclusiones |

### 3. Tablas de contingencia (chi-cuadrado)

| Archivo | Contenido |
|---|---|
| `Clase_TablaContigencia.R` | Prueba chi-cuadrado de independencia y homogeneidad, paso a paso: frecuencias esperadas, estadístico y valor crítico |
| `Tarea#1.R` – `Tarea#6.R` | Ejercicios de tablas de contingencia |

### 4. Comparación de grupos

| Archivo | Contenido |
|---|---|
| `METODOS (1).Rmd` | Comparación de medias entre dos grupos: prueba F de igualdad de varianzas, *t* para muestras independientes (manual), Wilcoxon y Kruskal-Wallis |
| `ANOVA.R` | ANOVA de un factor paso a paso, con el estadístico F y su valor crítico |
| `Tukey.R` | ANOVA con verificación de supuestos (Shapiro-Wilk, Bartlett) y comparaciones múltiples de Tukey |
| `Kruskal-Wallis.R` | Enfoque no paramétrico: verificación de supuestos (Shapiro-Wilk, Levene) y comparaciones por pares con Wilcoxon |

### 5. Correlación

| Archivo | Contenido |
|---|---|
| `CodigoCoeficientesDeCorrelacion.R` | Coeficientes de correlación de Pearson, Spearman y Kendall con sus pruebas de significancia |
| `Tarea#7.Rmd` – `Tarea#12.Rmd` | Ejercicios de correlación: cálculo de *r* con Sxx, Syy y Sxy, y prueba de hipótesis H₀: ρ = 0 |

### 6. Regresión lineal simple

| Archivo | Contenido |
|---|---|
| `RegresionLinealSimpleClase.R`, `ClaseRegresion2.R` | Ajuste paso a paso (Sxx, Sxy, β₀, β₁), residuos, SSE, MSE y R², comparados con `lm()` |
| `Prueba_de_hipotesis_beta0,beta1.Rmd` | Pruebas de hipótesis para β₀ y β₁ |
| `SupuestosDeErrores.R` | Función que verifica los supuestos de los errores: independencia (Durbin-Watson), normalidad (Shapiro-Wilk), homocedasticidad (Breusch-Pagan) y media cero |
| `EjerciciosRLS.Rmd` | Ejercicios completos: insesgadez de los estimadores, inferencia, predicción y diagnóstico |
| `Tarea#13RLS.R`, `Tarea#14.Rmd`, `Tarea#15.Rmd` | Tareas de regresión lineal simple |

### 7. Regresión lineal múltiple

| Archivo | Contenido |
|---|---|
| `Regresion_lineal_multiple.R` | Ajuste e interpretación de los coeficientes |
| `Regresion_lineal_multiple2.R` | Estimación matricial de los β, ANOVA, pruebas de significancia e intervalos de confianza del 95 % |
| `Regresion_lineal_multiple3.R` | Multicolinealidad y verificación de supuestos |
| `DEMOSTRACIONES.R` | Desarrollo de las ecuaciones del modelo de regresión múltiple (mínimos cuadrados, ecuaciones normales) |
| `VariablesDummy.R`, `DUMMY.Rmd` | Variables dummy y matriz de diseño con el dataset *Taiwan Real Estate* |
| `SeleccionDeModelos.R`, `SeleccionDeModelos#2.R` | Selección de modelos con `stepAIC`, AIC y comparación con ANOVA |
| `TAREA.Rmd`, `TareaFinalJacoboLondoño.Rmd` | ANOVA, Tukey y regresión con variables dummy |

### 8. Preparación de parciales

| Archivo | Contenido |
|---|---|
| `Preparacion3parcial#1.Rmd`, `#2`, `#3`, `#7` | Ejercicios de preparación para el tercer parcial (regresión, predicción y supuestos) |
| `parcial3JacoboLondoño (1).Rmd` | Solución del tercer parcial |
| `parcial_final_cdo (1)/` | Scripts y datos del parcial final: regresión múltiple con `data_pintura.txt`, selección de modelos con `inyectora.txt` (todas las regresiones posibles) y variables dummy con `taiwan_real_estate.fst` |

### 9. Talleres y trabajos

| Archivo | Contenido |
|---|---|
| `Plantilla_Taller 1_.Rmd` | Taller 1: eficiencia de los chatbots en la industria |
| `Punto2_Taller2.Rmd` | Taller 2: intervalos de confianza para la media |
| `Plantilla_Trabajo_final (2).Rmd` | Plantilla del trabajo final (planteamiento, objetivos, justificación y EDA) |
| `Trabajo_final.Rmd` | Trabajo final: bienestar subjetivo |

### 10. Notas del curso

- `Notas_metodos_final (4).Rmd`: notas del curso con análisis exploratorio, pruebas de normalidad, comparación de varianzas, ANOVA y Tukey.
- `Capítulo 8 Regresión lineal multiple _ Notas de métodos estadísticos.html`: capítulo de regresión lineal múltiple.

Los archivos `.html` son las versiones renderizadas de los `.Rmd`. Se pueden abrir en el navegador para ver los resultados sin ejecutar R.

## Cómo usarlo

Requisitos: **R** y **RStudio**.

Paquetes que se usan en los scripts:

```r
install.packages(c("tidyverse", "readxl", "knitr", "kableExtra", "GGally", "gridExtra",
                   "patchwork", "plotly", "scatterplot3d", "reshape2", "ggpubr", "Amelia",
                   "nortest", "car", "lmtest", "MASS", "olsrr", "mctest", "rstatix",
                   "emmeans", "effsize", "agricolae", "fst", "openintro", "MAVE"))
```

- Los `.R` se abren y ejecutan en RStudio.
- Los `.Rmd` se compilan con **Knit**.
- Algunos scripts leen los datos desde una ruta local, por ejemplo `read_table("C:/Users/.../data_rls.txt")`. Cambia esa ruta por la de tu copia de los datos.

## Autor

- **Jacobo Londoño**, monitor de Métodos Estadísticos. [LinkedIn](https://www.linkedin.com/in/jacobo-londo%C3%B1o-baquero-a2b86733a/)
