
# ============================================================================
# FUNCIÓN PARA EVALUAR NORMALIDAD DE TODAS LAS VARIABLES DE UN DATAFRAME
# ============================================================================

evaluar_normalidad_dataframe <- function(df, alpha = 0.05) {
  # Verificar que el input sea un dataframe
  if (!is.data.frame(df)) {
    stop("ERROR: El objeto debe ser un dataframe")
  }
  
  # Seleccionar solo variables numéricas
  variables_numericas <- df[sapply(df, is.numeric)]
  
  if (ncol(variables_numericas) == 0) {
    stop("ERROR: No se encontraron variables numéricas en el dataframe")
  }
  
  # Crear dataframe para almacenar resultados
  resultados <- data.frame(
    Variable = character(),
    N_observaciones = integer(),
    Prueba_utilizada = character(),
    Estadistico = numeric(),
    P_value = numeric(),
    Es_normal = character(),
    Conclusion = character(),
    stringsAsFactors = FALSE
  )
  
  cat("============================================================================\n")
  cat("EVALUACIÓN DE NORMALIDAD POR VARIABLE\n")
  cat("============================================================================\n")
  cat("Criterio: p >", alpha, "= Normal | p ≤", alpha, "= No normal\n\n")
  
  # Evaluar cada variable numérica
  for (i in 1:ncol(variables_numericas)) {
    variable_nombre <- names(variables_numericas)[i]
    datos <- variables_numericas[, i]
    
    # Remover valores NA
    datos_limpios <- datos[!is.na(datos)]
    n <- length(datos_limpios)
    
    cat("Variable:", variable_nombre, "\n")
    cat("├─ Observaciones válidas:", n, "\n")
    
    # Verificar si hay suficientes datos
    if (n < 3) {
      cat("├─ ADVERTENCIA: Muy pocos datos (n < 3) para evaluar normalidad\n")
      cat("└─ CONCLUSIÓN: No se puede determinar\n\n")
      
      resultados <- rbind(resultados, data.frame(
        Variable = variable_nombre,
        N_observaciones = n,
        Prueba_utilizada = "Ninguna",
        Estadistico = NA,
        P_value = NA,
        Es_normal = "Indeterminado",
        Conclusion = "Muy pocos datos"
      ))
      next
    }
    
    # Verificar si todos los valores son iguales (varianza = 0)
    if (var(datos_limpios) == 0) {
      cat("├─ ADVERTENCIA: Todos los valores son iguales (varianza = 0)\n")
      cat("└─ CONCLUSIÓN: No se puede evaluar normalidad\n\n")
      
      resultados <- rbind(resultados, data.frame(
        Variable = variable_nombre,
        N_observaciones = n,
        Prueba_utilizada = "Ninguna",
        Estadistico = NA,
        P_value = NA,
        Es_normal = "Indeterminado",
        Conclusion = "Varianza cero"
      ))
      next
    }
    
    # Decidir qué prueba usar y ejecutarla
    if (n < 30) {
      # Usar Shapiro-Wilk
      cat("├─ Prueba: Shapiro-Wilk (n < 30)\n")
      tryCatch({
        test_result <- shapiro.test(datos_limpios)
        estadistico <- test_result$statistic
        p_value <- test_result$p.value
        prueba_usada <- "Shapiro-Wilk"
        
        cat("├─ Estadístico W =", round(estadistico, 4), "\n")
        cat("├─ p-value =", format(p_value, scientific = TRUE, digits = 4), "\n")
        
      }, error = function(e) {
        cat("├─ ERROR en Shapiro-Wilk:", e$message, "\n")
        estadistico <- NA
        p_value <- NA
        prueba_usada <- "Error"
      })
      
    } else {
      # Usar Kolmogorov-Smirnov
      cat("├─ Prueba: Kolmogorov-Smirnov (n ≥ 30)\n")
      tryCatch({
        test_result <- ks.test(datos_limpios, "pnorm", 
                               mean = mean(datos_limpios), 
                               sd = sd(datos_limpios))
        estadistico <- test_result$statistic
        p_value <- test_result$p.value
        prueba_usada <- "Kolmogorov-Smirnov"
        
        cat("├─ Estadístico D =", round(estadistico, 4), "\n")
        cat("├─ p-value =", format(p_value, scientific = TRUE, digits = 4), "\n")
        
      }, error = function(e) {
        cat("├─ ERROR en Kolmogorov-Smirnov:", e$message, "\n")
        estadistico <- NA
        p_value <- NA
        prueba_usada <- "Error"
      })
    }
    
    # Interpretar resultado
    if (!is.na(p_value)) {
      if (p_value > alpha) {
        es_normal <- "SÍ"
        conclusion <- paste("Normal (p =", round(p_value, 4), ")")
        cat("└─ CONCLUSIÓN: ✓ Los datos SÍ son normales\n\n")
      } else {
        es_normal <- "NO"
        conclusion <- paste("No normal (p =", round(p_value, 4), ")")
        cat("└─ CONCLUSIÓN: ✗ Los datos NO son normales\n\n")
      }
    } else {
      es_normal <- "Error"
      conclusion <- "No se pudo calcular"
      cat("└─ CONCLUSIÓN: No se pudo determinar\n\n")
    }
    
    # Guardar resultados
    resultados <- rbind(resultados, data.frame(
      Variable = variable_nombre,
      N_observaciones = n,
      Prueba_utilizada = prueba_usada,
      Estadistico = estadistico,
      P_value = p_value,
      Es_normal = es_normal,
      Conclusion = conclusion
    ))
  }
  
  # Resumen final
  cat("============================================================================\n")
  cat("RESUMEN DE RESULTADOS\n")
  cat("============================================================================\n")
  
  normales <- sum(resultados$Es_normal == "SÍ", na.rm = TRUE)
  no_normales <- sum(resultados$Es_normal == "NO", na.rm = TRUE)
  indeterminados <- sum(resultados$Es_normal %in% c("Indeterminado", "Error"), na.rm = TRUE)
  
  cat("Variables normales:", normales, "\n")
  cat("Variables no normales:", no_normales, "\n")
  cat("Variables indeterminadas:", indeterminados, "\n")
  cat("Total evaluadas:", nrow(resultados), "\n\n")
  
  # Mostrar tabla de resultados
  print(resultados)
  
  # Devolver resultados invisiblemente
  return(invisible(resultados))
}

# ============================================================================
# FUNCIÓN SIMPLIFICADA (SOLO MUESTRA CONCLUSIONES)
# ============================================================================

normalidad_rapida <- function(df, alpha = 0.05) {
  # Obtener resultados sin mostrar detalles
  resultados <- suppressMessages(
    capture.output(
      evaluar_normalidad_dataframe(df, alpha), 
      type = "message"
    )
  )
  
  # Recalcular para obtener solo resultados
  variables_numericas <- df[sapply(df, is.numeric)]
  
  if (ncol(variables_numericas) == 0) {
    stop("ERROR: No se encontraron variables numéricas en el dataframe")
  }
  
  resumen <- data.frame(
    Variable = character(),
    Es_normal = character(),
    stringsAsFactors = FALSE
  )
  
  for (i in 1:ncol(variables_numericas)) {
    variable_nombre <- names(variables_numericas)[i]
    datos <- variables_numericas[, i]
    datos_limpios <- datos[!is.na(datos)]
    n <- length(datos_limpios)
    
    if (n < 3 || var(datos_limpios) == 0) {
      es_normal <- "Indeterminado"
    } else {
      if (n < 30) {
        test_result <- tryCatch(shapiro.test(datos_limpios), error = function(e) NULL)
      } else {
        test_result <- tryCatch(ks.test(datos_limpios, "pnorm", 
                                        mean = mean(datos_limpios), 
                                        sd = sd(datos_limpios)), 
                                error = function(e) NULL)
      }
      
      if (is.null(test_result)) {
        es_normal <- "Error"
      } else {
        es_normal <- ifelse(test_result$p.value > alpha, "SÍ", "NO")
      }
    }
    
    resumen <- rbind(resumen, data.frame(
      Variable = variable_nombre,
      Es_normal = es_normal
    ))
  }
  
  cat("RESUMEN RÁPIDO DE NORMALIDAD\n")
  cat("============================\n")
  print(resumen)
  
  return(invisible(resumen))
}
