verificar_supuestos_texto <- function(modelo3){
  
  cat("=== VERIFICACIÓN DE SUPUESTOS (Basado en texto proporcionado) ===\n\n")
  
  # Extraer residuos
  r <- residuals(modelo3) 
  
  # 1. INDEPENDENCIA (Sección 7.8.2 del texto)
  cat("1. INDEPENDENCIA:\n")
  # Prueba de Durbin-Watson (mencionada en el texto)
  if(require(car)) {
    dw_test <- car::durbinWatsonTest(modelo3)
    cat("   Prueba Durbin-Watson:\n")
    cat("   Estadístico D-W =", round(dw_test$dw, 4), "\n")
    cat("   p-value =", round(dw_test$p, 4), "\n")
    if(dw_test$p > 0.05) {
      cat("   ✓ No se rechaza H0: Los errores son independientes\n")
    } else {
      cat("   ✗ Se rechaza H0: Los errores NO son independientes\n")
    }
  }
  
  # Gráfico ACF (mencionado en el texto)
  acf(r, main = "Función de Autocorrelación (ACF) de los residuales")
  
  # 2. NORMALIDAD (Sección 7.8.3 del texto)
  cat("\n2. NORMALIDAD:\n")
  # Prueba de Shapiro-Wilk (mencionada en el texto)
  shapiro_test <- shapiro.test(r)
  cat("   Prueba Shapiro-Wilk:\n")
  cat("   W =", round(shapiro_test$statistic, 4), "\n")
  cat("   p-value =", round(shapiro_test$p.value, 4), "\n")
  if(shapiro_test$p.value > 0.05) {
    cat("   ✓ No se rechaza H0: Los errores siguen distribución normal\n")
  } else {
    cat("   ✗ Se rechaza H0: Los errores NO siguen distribución normal\n")
  }
  
  # Gráfico Q-Q (mencionado en el texto)
  car::qqPlot(r, main = "Gráfico Q-Q de los residuales")
  
  # 3. MEDIA CERO (Sección 7.8.4 del texto)
  cat("\n3. MEDIA CERO:\n")
  media_residuos <- mean(r)
  cat("   Media de los residuos =", format(media_residuos, scientific = FALSE), "\n")
  # Prueba t de una muestra (mencionada en el texto)
  t_test <- t.test(r, mu = 0)
  cat("   Prueba t: p-value =", round(t_test$p.value, 4), "\n")
  if(t_test$p.value > 0.05) {
    cat("   ✓ No se rechaza H0: La media de los errores es cero\n")
  } else {
    cat("   ✗ Se rechaza H0: La media de los errores NO es cero\n")
  }
  
  # 4. HOMOCEDASTICIDAD (Sección 7.8.5 del texto)
  cat("\n4. HOMOCEDASTICIDAD (Varianza constante):\n")
  # Prueba de Breusch-Pagan (mencionada en el texto)
  if(require(lmtest)) {
    bp_test <- lmtest::bptest(modelo3)
    cat("   Prueba Breusch-Pagan:\n")
    cat("   BP =", round(bp_test$statistic, 4), "\n")
    cat("   p-value =", round(bp_test$p.value, 4), "\n")
    if(bp_test$p.value > 0.05) {
      cat("   ✓ No se rechaza H0: La varianza es constante\n")
    } else {
      cat("   ✗ Se rechaza H0: La varianza NO es constante\n")
    }
  }
  
  # Gráfico de residuos vs ajustados (mencionado en el texto)
  plot_data <- data.frame(
    Ajustados = fitted(modelo3),
    Residuales = r
  )
  
  print(
    ggplot(plot_data, aes(x = Ajustados, y = Residuales)) +
      geom_point(size = 3, alpha = 0.7) +
      geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
      geom_smooth(method = "loess", se = FALSE, color = "blue") +
      labs(title = "Residuales vs Valores Ajustados - Verificación Homocedasticidad",
           x = "Valores Ajustados", y = "Residuales") +
      theme_bw()
  )
  
  cat("\n=== RESUMEN FINAL ===\n")
  cat("Basado en la verificación, el modelo3", 
      ifelse(bp_test$p.value > 0.05 & dw_test$p > 0.05 & shapiro_test$p.value > 0.05,
             "CUMPLE", "NO CUMPLE"), 
      "con los supuestos de los errores.\n")
}

# USAR LA FUNCIÓN
verificar_supuestos_texto(modelo3)


