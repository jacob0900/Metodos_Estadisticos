# ============================================================================
# ANÁLISIS DE CORRELACIÓN EN R
# ============================================================================

# ----------------------------------------------------------------------------
# CORRELACIÓN DE PEARSON
# ----------------------------------------------------------------------------
# ¿Cuándo usarla?
# - Cuando los datos son normales (siguen una curva en forma de campana)
# - Cuando la relación entre variables es lineal (forma una línea recta)
# - Cuando no hay valores extremos que distorsionen los resultados
# - Ambas variables deben ser continuas (números con decimales)

cor(x, y, method = "pearson")      # Solo calcula el coeficiente de correlación
cor.test(x, y, method = "pearson") # Calcula correlación + prueba estadística

# ----------------------------------------------------------------------------
# CORRELACIÓN DE SPEARMAN  
# ----------------------------------------------------------------------------
# ¿Cuándo usarla?
# - Cuando los datos NO son normales
# - Cuando la relación no es lineal pero sí monótona (siempre sube o siempre baja)
# - Con datos ordinales (que se pueden ordenar: malo, regular, bueno)
# - Es más resistente a valores extremos que Pearson

cor(x, y, method = "spearman")      # Solo calcula el coeficiente
cor.test(x, y, method = "spearman") # Calcula correlación + prueba estadística

# ----------------------------------------------------------------------------
# CORRELACIÓN DE KENDALL
# ----------------------------------------------------------------------------
# ¿Cuándo usarla?
# - Con muestras pequeñas (menos de 30 observaciones)
# - Cuando hay muchos empates en los datos
# - Es la más robusta contra valores extremos
# - Funciona bien con cualquier tipo de distribución

cor(x, y, method = "kendall")      # Solo calcula el coeficiente
cor.test(x, y, method = "kendall") # Calcula correlación + prueba estadística

# ============================================================================
# CÓMO INTERPRETAR LOS RESULTADOS
# ============================================================================

# ----------------------------------------------------------------------------
# VALOR DE CORRELACIÓN (r):
# ----------------------------------------------------------------------------
# Este número va de -1 a 1 y nos dice qué tan fuerte es la relación

#  -1.0 a -0.7: Relación negativa FUERTE (cuando una sube, la otra baja mucho)
#  -0.7 a -0.3: Relación negativa MODERADA (cuando una sube, la otra baja un poco)
#  -0.3 a  0.3: Relación DÉBIL o SIN relación (las variables no se relacionan)
#   0.3 a  0.7: Relación positiva MODERADA (cuando una sube, la otra sube un poco)
#   0.7 a  1.0: Relación positiva FUERTE (cuando una sube, la otra sube mucho)

# ----------------------------------------------------------------------------
# P-VALUE (nivel de significancia):
# ----------------------------------------------------------------------------
# Nos dice si podemos confiar en que la correlación es real

# p < 0.05: SÍ hay correlación real (podemos confiar en el resultado)
# p ≥ 0.05: NO podemos asegurar que hay correlación (puede ser casualidad)

# ----------------------------------------------------------------------------
# INTERVALO DE CONFIANZA:
# ----------------------------------------------------------------------------
# Es un rango donde probablemente está el valor real de correlación

# Si NO incluye 0: La correlación SÍ es significativa
# Si incluye 0: NO es significativa (podría no haber correlación real)

# ============================================================================
# DIFERENCIAS ENTRE LOS MÉTODOS
# ============================================================================

# PEARSON:   - Da el valor más alto cuando los datos son perfectamente lineales
#            - Es el más usado cuando se cumplen todos sus requisitos
#            - Muy sensible a valores extremos

# SPEARMAN:  - Da valores similares a Pearson, pero más bajos si hay curvas
#            - Funciona con datos que no son normales
#            - Menos sensible a valores extremos que Pearson

# KENDALL:   - Siempre da valores más bajos que los otros dos
#            - Es el más robusto (resistente a problemas en los datos)
#            - Recomendado para muestras pequeñas