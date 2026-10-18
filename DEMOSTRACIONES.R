###############################################################
# MODELO DE REGRESIÓN MÚLTIPLE (ECUACIONES 8.2 A 8.7)
###############################################################

# (8.2) Modelo:
# y_i = β_0 + β_1 x_{i1} + β_2 x_{i2} + ... + β_k x_{ik} + ε_i
#     = β_0 + Σ_{j=1}^k β_j x_{ij} + ε_i ,   i = 1, 2, ..., n

# (8.3) Función de mínimos cuadrados:
# S(β_0, β_1, ..., β_k) 
#   = Σ_{i=1}^n ε_i^2
#   = Σ_{i=1}^n ( y_i - β_0 - Σ_{j=1}^k β_j x_{ij} )^2

# Para minimizar S se derivan las parciales:

# (8.4a) Derivada respecto a β_0:
# ∂S/∂β_0 = -2 Σ_{i=1}^n ( y_i - β_0 - Σ_{j=1}^k β_j x_{ij} ) = 0

# (8.4b) Derivada respecto a β_j:
# ∂S/∂β_j = -2 Σ_{i=1}^n ( y_i - β_0 - Σ_{m=1}^k β_m x_{im} ) x_{ij} = 0
# para j = 1, 2, ..., k

# Estas derivadas producen las ecuaciones normales:

# (8.5) ECUACIONES NORMALES EN FORMA ESCALAR:

# n β_0 + β_1 Σ x_{i1} + β_2 Σ x_{i2} + ... + β_k Σ x_{ik} = Σ y_i
#
# β_0 Σ x_{i1} + β_1 Σ x_{i1}^2 + β_2 Σ x_{i1} x_{i2} + ... + β_k Σ x_{i1} x_{ik} = Σ x_{i1} y_i
#
#  ...
#
# β_0 Σ x_{ik} 
# + β_1 Σ x_{ik} x_{i1} 
# + β_2 Σ x_{ik} x_{i2} 
# + ... 
# + β_k Σ x_{ik}^2 
# = Σ x_{ik} y_i

###############################################################
# NOTACIÓN MATRICIAL
###############################################################

# Modelo:
# y = X β + ε

# S(β) = ε' ε = (y - Xβ)' (y - Xβ)
#
# Expansión:
# S(β) = y'y - β'X'y - y'Xβ + β'X'Xβ
#      = y'y - 2 β'X'y + β'X'Xβ

# Derivada vectorial:
# ∂S/∂β = -2 X'y + 2 X'X β = 0

# Ecuaciones normales matriciales:
# (8.6)   X'X β = X'y

# Solución de mínimos cuadrados:
# (8.7)   β̂ = (X'X)^{-1} X'y

###############################################################
# MATRIZ EXPLÍCITA DE X'X Y X'y (Correspondencia con 8.5)
###############################################################

# [ n              Σ x_{i1}        Σ x_{i2}      ...      Σ x_{ik}      ]   [ β_0 ]   [ Σ y_i      ]
# [ Σ x_{i1}       Σ x_{i1}^2      Σ x_{i1}x_{i2} ...      Σ x_{i1}x_{ik} ] * [ β_1 ] = [ Σ x_{i1}y_i ]
# [ Σ x_{i2}       Σ x_{i2}x_{i1}  Σ x_{i2}^2      ...      Σ x_{i2}x_{ik} ]   [ β_2 ]   [ Σ x_{i2}y_i ]
# [   ...              ...             ...         ...         ...        ]   [ ... ]   [    ...     ]
# [ Σ x_{ik}       Σ x_{ik}x_{i1}  Σ x_{ik}x_{i2} ...      Σ x_{ik}^2     ]   [ β_k ]   [ Σ x_{ik}y_i ]

###############################################################
# FIN DEL SCRIPT
###############################################################










###############################################################
# PROPIEDADES ESTADÍSTICAS DEL ESTIMADOR DE MÍNIMOS CUADRADOS
# DEMOSTRACIÓN DE QUE  β̂  ES INSESGADO
###############################################################

# Sabemos que el estimador de mínimos cuadrados es:
#
#   β̂ = (X'X)^{-1} X' y
#
# y el modelo es:
#
#   y = Xβ + ε
#
# Sustituimos y en la expresión del estimador:

#   β̂ = (X'X)^{-1} X' (Xβ + ε)
#
# Expandiendo:

#   β̂ = (X'X)^{-1} X'X β  +  (X'X)^{-1} X' ε
#
# Como (X'X)^{-1} X'X = I_p (la matriz identidad p×p), entonces:

#   β̂ = β + (X'X)^{-1} X' ε

###############################################################
# CÁLCULO DEL VALOR ESPERADO
###############################################################

# Tomamos esperanza en ambos lados:

#   E(β̂) = E[ β + (X'X)^{-1} X' ε ]
#
# β es constante → E(β) = β. Entonces:

#   E(β̂) = β + (X'X)^{-1} X' E(ε)
#
# Por suposición del modelo clásico, E(ε) = 0. Por tanto:

#   E(β̂) = β + (X'X)^{-1} X' * 0
#   E(β̂) = β

###############################################################
# CONCLUSIÓN
###############################################################

# El estimador de mínimos cuadrados β̂ es INSesgado, porque:
#
#        E(β̂) = β
#
###############################################################
# FIN
###############################################################







###############################################################
# PROPIEDADES ESTADÍSTICAS Y VARIANZA DE β̂
###############################################################

# Probemos inicialmente que:
#   Var(A z) = A Var(z) A'
#
# En efecto, sea z un vector aleatorio con:
#   E(z) = μ
# y varianza:
#   Var(z) = E[ (z - μ)(z - μ)' ].
#
# Sea A una matriz constante de dimensión compatible y definamos y = A z.
# Entonces:
#   E(y) = E(A z) = A E(z) = A μ
# por lo que:
#
# Var(y) = E[ (y - E(y)) (y - E(y))' ]
#        = E[ (A z - A μ) (A z - A μ)' ]
#        = E[ A (z - μ) (z - μ)' A' ]   (factorizando A y A' al ser constantes)
#        = A E[ (z - μ) (z - μ)' ] A'
#        = A Var(z) A'.
#
# En consecuencia:
#   Var(A z) = A Var(z) A'
#
# Nota: si la transformación es afín y = A z + b con b constante,
#       el término b no afecta a la varianza y el resultado se mantiene.

###############################################################
# RECORDATORIO: Estimador de mínimos cuadrados
###############################################################

# El estimador de mínimos cuadrados se define como:
#   β̂ = (X' X)^{-1} X' y
#
# y el modelo lineal se expresa como:
#   y = X β + ε
#   E(ε) = 0
#   Var(ε) = σ^2 I

# Sustituyendo y en la expresión de β̂:
#
#   β̂ = (X' X)^{-1} X' (X β + ε)
#      = β + (X' X)^{-1} X' ε

###############################################################
# VARIANZA DE β̂
###############################################################

# Ahora calculamos la varianza de β̂:
#
#   Var(β̂) = Var[ β + (X' X)^{-1} X' ε ]
#           = Var[ (X' X)^{-1} X' ε ]
#
# Nota: β es constante, por lo tanto no contribuye a la varianza.

# Aplicando la propiedad de la varianza de una transformación lineal:
#   Var(A z) = A Var(z) A'
#
# con A = (X' X)^{-1} X' y z = ε, obtenemos:
#
#   Var(β̂) = (X' X)^{-1} X' Var(ε) X (X' X)^{-1}

# Como por hipótesis del modelo Var(ε) = σ^2 I, sustituimos:
#
#   Var(β̂) = (X' X)^{-1} X' (σ^2 I) X (X' X)^{-1}
#           = σ^2 (X' X)^{-1} X' X (X' X)^{-1}
#           = σ^2 (X' X)^{-1}

# Por lo tanto, la varianza del estimador de mínimos cuadrados es:
#   Var(β̂) = σ^2 (X' X)^{-1}

###############################################################
# VARIANZAS Y COVARIANZAS DE LOS COMPONENTES
###############################################################

# La varianza del componente β̂_j y la covarianza entre β̂_i y β̂_j
# están dadas por los elementos de la matriz σ^2 (X'X)^{-1}:
#
#   Var(β̂_j) = σ^2 [ (X' X)^{-1} ]_{jj},   j = 0, 1, ..., p
#
#   Cov(β̂_i, β̂_j) = σ^2 [ (X' X)^{-1} ]_{ij},   i ≠ j

###############################################################
# FIN
###############################################################








############################################################
# Estimación de la varianza sigma^2 en regresión múltiple
############################################################

# La suma de cuadrados del error (SSE) en regresión múltiple se define como:
# SSE = sum_{i=1}^n (y_i - ŷ_i)^2 = e'e
# donde e es el vector de residuos.

# Usando notación matricial:
# SSE = e'e

# Como e = y - Xβ̂, sustituimos:

# SSE = (y - Xβ̂)'(y - Xβ̂)
#     = y'y - β̂'X'y - y'Xβ̂ + β̂'X'Xβ̂
#     = y'y - 2β̂'X'y + β̂'X'Xβ̂

# Observamos que las ecuaciones normales cumplen:
# X'X β̂ = X'y
# por lo que:
# β̂'X'Xβ̂ = β̂'X'y

# Así, la expresión final queda:
# SSE = y'y - β̂'X'y

############################################################
# Grados de libertad y estimación de sigma^2
############################################################

# SSE posee (n - p) grados de libertad,
# donde n = número de observaciones,
# y p = número de parámetros (incluyendo intercepto).

# El Cuadrado Medio Residual (MSE) se define como:
# MSE = SSE / (n - p)

# Este MSE es el estimador insesgado de la varianza σ^2 del error:
# σ̂^2 = SSE / (n - p)

############################################################
# Fórmulas finales:
#
# SSE = ∑_{i=1}^n (y_i - ŷ_i)^2
# MSE = SSE / (n - p)
# σ̂^2 = MSE
############################################################








############################################################
# Demostración de que  E(MSE) = σ^2
############################################################

# Supuestos del modelo lineal múltiple:
#   y = Xβ + ε
#   E(ε) = 0
#   Var(ε) = σ^2 I
# con X fija (no aleatoria).

############################################################
# Definición de la matriz sombrero:
#   H = X (X'X)^{-1} X'
#
# Los residuos son:
#   e = y - ŷ = (I - H) y
#
# Como y = Xβ + ε y (I - H)X = 0 (propiedad de H),
# entonces:
#
#   e = (I - H)(Xβ + ε)
#     = (I - H)Xβ + (I - H)ε
#     = (I - H)ε
############################################################

# La suma de cuadrados residual:
#   SSE = e'e
#
# Sustituyendo e = (I - H)ε:
#
#   SSE = ε'(I - H)'(I - H)ε
#
# Como (I - H) es idempotente y simétrica:
#   (I - H)' = (I - H)
#   (I - H)(I - H) = (I - H)
#
# Entonces:
#   SSE = ε'(I - H)ε

############################################################
# Para calcular la esperanza, usamos la identidad:
#
#   E(z' A z) = tr( A E(zz') )
#
# para A constante.
#
# Aplicando esta identidad:
#
# E(SSE) = E( ε'(I - H)ε )
#        = E[ tr( (I - H) εε' ) ]
#        = tr( (I - H) E(εε') )
#
# Como Var(ε) = E(εε') = σ^2 I:
#
#        = tr( (I - H) σ^2 I )
#        = σ^2 tr( I - H )
#
# Y como:
#   tr(I - H) = n - tr(H)
############################################################

# Propiedad clave:
# H es idempotente y simétrica, por lo que:
#   tr(H) = rank(H) = p
# donde p incluye intercepto.
#
# Entonces:
#
#   E(SSE) = σ^2 (n - p)

############################################################
# Por definición:
#   MSE = SSE / (n - p)
#
# Por linealidad de la esperanza:
#
#   E(MSE) = E(SSE)/(n - p)
#          = σ^2 (n - p) / (n - p)
#          = σ^2
#
# Resultado:
#   E(MSE) = σ^2
############################################################

# QED
############################################################








############################################################
# Demostración: E( z' A z ) = tr( A E( z z' ) )   (A constante)
############################################################

# Sea z un vector aleatorio (n×1) y A una matriz constante (n×n).
# Queremos probar que:
#    E( z' A z ) = tr( A E( z z' ) )

############################################################
# DEMOSTRACIÓN 1 — USANDO PROPIEDADES DE LA TRAZA (compacta)
############################################################

# Observamos primero que z' A z es un escalar. Para cualquier escalar s,
# s = tr(s). Por tanto:
#
#   z' A z = tr( z' A z ).
#
# Usamos la propiedad de la traza tr(B C) = tr(C B) (cuando dimensiones compatibles):
#
#   tr( z' A z ) = tr( A z z' ).
#
# Ahora tomamos esperanza en ambos lados:
#
#   E( z' A z ) = E[ tr( A z z' ) ].
#
# La traza es una suma finita y la esperanza es una operación lineal, por lo que
# podemos intercambiar expectativa y traza:
#
#   E[ tr( A z z' ) ] = tr( A E[ z z' ] ).
#
# En consecuencia:
#
#   E( z' A z ) = tr( A E( z z' ) ).
#
# QED.

############################################################
# DEMOSTRACIÓN 2 — POR COMPONENTES (elemental)
############################################################

# Escribimos z' A z por componentes. Sea z = (z_1, ..., z_n)' y A = (a_{ij}).
#
#   z' A z = sum_{i=1}^n sum_{j=1}^n z_i a_{ij} z_j
#          = sum_{i,j} a_{ij} z_i z_j.
#
# Tomando esperanza:
#
#   E( z' A z ) = sum_{i,j} a_{ij} E( z_i z_j ).
#
# Por otra parte, la matriz E( z z' ) tiene entradas E(z_i z_j).
# La traza de A E(z z') es:
#
#   tr( A E(z z') ) = sum_{i=1}^n [ A E(z z') ]_{ii}
#                   = sum_{i=1}^n sum_{j=1}^n a_{ij} E(z_j z_i).
#
# Como E(z_j z_i) = E(z_i z_j) (son iguales), relabellando índices vemos que
# ambas sumas coinciden:
#
#   tr( A E(z z') ) = sum_{i,j} a_{ij} E(z_i z_j) = E( z' A z ).
#
# QED.

############################################################
# Observaciones:
# - La demostración 1 es la estándar y más concisa: usar tr(scalar)=scalar,
#   tr(B C)=tr(C B) y linealidad de la esperanza.
# - La demostración 2 es útil para quien prefiere ver las sumatorias explícitas.
############################################################








###############################################################
# Demostración: E(MSR) = σ^2 + (β*' Xc' Xc β*) / k
###############################################################

# Partimos del hecho de que:
#     MSR = SSR / k
#
# Y que puede escribirse como:
#     MSR = (1/k) β*' Xc' Xc β*  +  (1/k) ε' H ε
#
# donde:
#   - Xc es la matriz de diseño centrada
#   - β* es el vector de coeficientes verdaderos sin el intercepto
#   - H = Xc (Xc'Xc)^(-1) Xc' es la matriz sombrero correspondiente

###############################################################
# 1. Esperanza del término aleatorio ε' H ε
###############################################################

# Sabemos que para cualquier matriz idempotente H:
#     E(ε' H ε) = σ^2 tr(H)
#
# Como H = Xc (Xc'Xc)^(-1) Xc' cumple:
#     tr(H) = k
#
# Entonces:
#     E( (1/k) ε' H ε ) = (1/k) σ^2 tr(H)
#                       = (1/k) σ^2 k
#                       = σ^2

###############################################################
# 2. Esperanza del término determinístico
###############################################################

# El término:
#     (1/k) β*' Xc' Xc β*
#
# no depende de la aleatoriedad, por lo tanto:
#     E( (1/k) β*' Xc' Xc β* ) = (1/k) β*' Xc' Xc β*

###############################################################
# 3. Sumando ambos resultados
###############################################################

# E(MSR) = σ^2 + (1/k) β*' Xc' Xc β*

###############################################################
# Resultado final
###############################################################

#     E(MSR) = σ^2 + (β*' Xc' Xc β*) / k
