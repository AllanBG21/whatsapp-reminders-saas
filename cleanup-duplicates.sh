#!/bin/bash

# Script para limpiar issues duplicados del proyecto WhatsApp SaaS
# Este script cierra issues duplicados basándose en títulos similares

REPO="allanbarahona-web3/whatsapp-reminders-saas"

echo "🧹 Limpiando issues duplicados en: $REPO"
echo "⚠️  Este script cerrará issues duplicados automáticamente"
echo ""

# Función para confirmar acción
confirm_action() {
    read -p "¿Continuar? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Operación cancelada"
        exit 1
    fi
}

# Función para listar todos los issues abiertos
list_open_issues() {
    echo "📋 Obteniendo lista de issues abiertos..."
    gh issue list --repo $REPO --state open --json number,title,createdAt --limit 50 > issues_temp.json
    
    if [ ! -s issues_temp.json ]; then
        echo "❌ Error: No se pudieron obtener los issues"
        exit 1
    fi
    
    echo "✅ Issues obtenidos correctamente"
}

# Función para identificar duplicados
identify_duplicates() {
    echo ""
    echo "🔍 Identificando duplicados..."
    
    # Títulos únicos que creamos con el script anterior
    declare -a unique_titles=(
        "🔧 Configuración inicial del proyecto"
        "🚀 Integración WhatsApp Business API básica"
        "🚀 Sistema de respuestas automáticas"
        "🚀 Integración con Google Sheets"
        "🚀 Sistema de webhooks configurables"
        "🚀 Dashboard básico para configuración"
        "🚀 Sistema de pricing y planes"
    )
    
    # Array para almacenar duplicados encontrados
    declare -a duplicates_to_close=()
    
    for title in "${unique_titles[@]}"; do
        echo "🔎 Buscando duplicados de: $title"
        
        # Buscar issues con este título exacto
        matching_issues=$(cat issues_temp.json | jq -r --arg title "$title" '.[] | select(.title == $title) | .number')
        
        # Convertir a array
        readarray -t issue_numbers <<< "$matching_issues"
        
        if [ ${#issue_numbers[@]} -gt 1 ]; then
            echo "  ⚠️  Encontrados ${#issue_numbers[@]} issues con el mismo título"
            
            # Mantener el primero (más antiguo), marcar los demás como duplicados
            for ((i=1; i<${#issue_numbers[@]}; i++)); do
                if [ ! -z "${issue_numbers[i]}" ]; then
                    echo "  🗑️  Issue #${issue_numbers[i]} marcado para cerrar"
                    duplicates_to_close+=("${issue_numbers[i]}")
                fi
            done
        else
            echo "  ✅ No hay duplicados"
        fi
    done
    
    echo ""
    echo "📊 Resumen:"
    echo "  - Issues duplicados encontrados: ${#duplicates_to_close[@]}"
    
    if [ ${#duplicates_to_close[@]} -eq 0 ]; then
        echo "🎉 ¡No hay duplicados para limpiar!"
        cleanup_temp_files
        exit 0
    fi
    
    echo "  - Issues que se cerrarán: ${duplicates_to_close[*]}"
}

# Función para cerrar duplicados
close_duplicates() {
    echo ""
    echo "🗑️  Cerrando issues duplicados..."
    
    for issue_num in "${duplicates_to_close[@]}"; do
        if [ ! -z "$issue_num" ]; then
            echo "  ⏳ Cerrando issue #$issue_num..."
            
            # Cerrar el issue con un comentario explicativo
            gh issue close $issue_num --repo $REPO --comment "🤖 Issue duplicado cerrado automáticamente. Favor usar el issue original para este feature."
            
            if [ $? -eq 0 ]; then
                echo "  ✅ Issue #$issue_num cerrado exitosamente"
            else
                echo "  ❌ Error cerrando issue #$issue_num"
            fi
            
            # Pausa pequeña para no saturar la API
            sleep 1
        fi
    done
}

# Función para mostrar estado final
show_final_status() {
    echo ""
    echo "📈 Estado final:"
    
    # Contar issues abiertos restantes
    open_count=$(gh issue list --repo $REPO --state open | wc -l)
    echo "  - Issues abiertos restantes: $open_count"
    
    # Mostrar link para verificar
    echo ""
    echo "🔗 Verificar en: https://github.com/$REPO/issues"
}

# Función para limpiar archivos temporales
cleanup_temp_files() {
    if [ -f "issues_temp.json" ]; then
        rm issues_temp.json
        echo "🧹 Archivos temporales limpiados"
    fi
}

# Función principal
main() {
    echo "🎯 Iniciando limpieza de duplicados..."
    
    # Verificar que gh CLI está instalado y autenticado
    if ! command -v gh &> /dev/null; then
        echo "❌ Error: GitHub CLI (gh) no está instalado"
        echo "Instalar con: sudo apt install gh"
        exit 1
    fi
    
    # Verificar autenticación
    if ! gh auth status &> /dev/null; then
        echo "❌ Error: No estás autenticado con GitHub"
        echo "Ejecuta: gh auth login"
        exit 1
    fi
    
    # Confirmación antes de proceder
    confirm_action
    
    # Ejecutar pasos
    list_open_issues
    identify_duplicates
    
    if [ ${#duplicates_to_close[@]} -gt 0 ]; then
        echo ""
        echo "⚠️  Se cerrarán ${#duplicates_to_close[@]} issues duplicados"
        confirm_action
        close_duplicates
    fi
    
    show_final_status
    cleanup_temp_files
    
    echo ""
    echo "✅ ¡Limpieza completada!"
}

# Manejar interrupción del script
trap cleanup_temp_files EXIT

# Ejecutar script principal
main

# Consejos para el usuario
echo ""
echo "💡 Consejos aprendidos:"
echo "  - Siempre verifica antes de ejecutar scripts de creación"
echo "  - Usa 'gh issue list' para ver issues desde terminal"
echo "  - Los scripts pueden usar jq para procesar JSON"
echo "  - GitHub CLI permite automatizar casi todo"
