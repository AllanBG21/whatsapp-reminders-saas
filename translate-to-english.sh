#!/bin/bash

# Script para traducir todos los issues del proyecto a inglés
REPO="allanbarahona-web3/whatsapp-reminders-saas"

echo "🌍 Translating project issues to English..."
echo "📋 Repository: $REPO"
echo ""

# Función de confirmación
confirm_action() {
    read -p "Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Operation cancelled"
        exit 1
    fi
}

# Función para actualizar milestones
update_milestones() {
    echo "📅 Updating milestones to English..."
    
    # Obtener milestones actuales
    milestones=$(gh api repos/$REPO/milestones --jq '.[] | {number, title}')
    
    # Sprint 1 - MVP Básico → Sprint 1 - Basic MVP
    gh api repos/$REPO/milestones/1 \
        --method PATCH \
        --field title="Sprint 1 - Basic MVP" \
        --field description="WhatsApp API + basic automated responses" 2>/dev/null || true
    
    # Sprint 2 - Integraciones → Sprint 2 - Integrations
    gh api repos/$REPO/milestones/2 \
        --method PATCH \
        --field title="Sprint 2 - Integrations" \
        --field description="Google Sheets + webhooks + n8n integrations" 2>/dev/null || true
    
    # Sprint 3 ya está en inglés, solo actualizar descripción
    gh api repos/$REPO/milestones/3 \
        --method PATCH \
        --field title="Sprint 3 - SaaS Features" \
        --field description="Dashboard + pricing + deployment" 2>/dev/null || true
        
    echo "✅ Milestones updated"
}

# Función para traducir issues específicos
translate_issues() {
    echo "📝 Translating issues to English..."
    
    # Issue #9: Configuración inicial del proyecto
    gh issue edit 9 \
        --title "🔧 Initial project setup" \
        --body "**Description:**
Set up basic NestJS project structure for WhatsApp SaaS

**Tasks:**
- [ ] Initialize NestJS project
- [ ] Configure TypeScript and linting
- [ ] Set up environment variables
- [ ] Create folder structure
- [ ] Basic README

**Acceptance criteria:**
- Project runs with \`npm start\`
- Environment variables configured
- Clear folder structure" || true
    
    # Issue #10: Integración WhatsApp Business API básica
    gh issue edit 10 \
        --title "🚀 Basic WhatsApp Business API integration" \
        --body "**Description:**
Implement basic connection with WhatsApp Business API

**Tasks:**
- [ ] Configure webhook to receive messages
- [ ] Implement basic message sending
- [ ] Phone number validation
- [ ] Basic error handling

**Acceptance criteria:**
- Receives WhatsApp messages
- Can send automated responses
- Error logging working" || true
    
    # Issue #11: Sistema de respuestas automáticas
    gh issue edit 11 \
        --title "🚀 Automated response system" \
        --body "**Description:**
Create system for automatically responding to messages

**Tasks:**
- [ ] Incoming message parser
- [ ] Automated response engine
- [ ] Default response configuration
- [ ] Basic testing

**Acceptance criteria:**
- Responds automatically to keywords
- Default response for unrecognized messages
- Basic unit testing" || true
    
    # Issue #12: Integración con Google Sheets
    gh issue edit 12 \
        --title "🚀 Google Sheets integration" \
        --body "**Description:**
Connect WhatsApp with Google Sheets for logging and configuration

**Tasks:**
- [ ] Configure Google Sheets API
- [ ] Endpoint to write messages to sheet
- [ ] Read configurations from sheet
- [ ] API error handling

**Acceptance criteria:**
- Messages saved to Google Sheets
- Configurations read from sheet
- Rate limit handling" || true
    
    # Issue #13: Sistema de webhooks configurables
    gh issue edit 13 \
        --title "🚀 Configurable webhook system" \
        --body "**Description:**
Implement webhooks for external integrations

**Tasks:**
- [ ] Endpoint to receive webhooks
- [ ] Webhook sending system
- [ ] Destination URL configuration
- [ ] Retry logic for failures

**Acceptance criteria:**
- Receives external webhooks
- Sends data to configured URLs
- Automatic retry on failures" || true
    
    # Issue #14: Dashboard básico para configuración
    gh issue edit 14 \
        --title "🚀 Basic configuration dashboard" \
        --body "**Description:**
Create web interface to configure WhatsApp bot

**Tasks:**
- [ ] Basic frontend (React/HTML)
- [ ] Automated response configuration
- [ ] Received messages visualization
- [ ] Integration configuration

**Acceptance criteria:**
- Functional web interface
- CRUD for automated responses
- Responsive dashboard" || true
    
    # Issue #15: Sistema de pricing y planes
    gh issue edit 15 \
        --title "🚀 Pricing and plans system" \
        --body "**Description:**
Implement different pricing plans for the SaaS

**Tasks:**
- [ ] Plan models (Free, Pro, Enterprise)
- [ ] Per-plan limits (messages/month)
- [ ] Basic billing system
- [ ] Plan upgrade/downgrade

**Acceptance criteria:**
- 3 clearly defined plans
- Limits automatically enforced
- Functional upgrade flow" || true
    
    echo "✅ All issues translated"
}

# Función para mostrar resultado final
show_final_status() {
    echo ""
    echo "📊 Final status:"
    echo "✅ All milestones translated to English"
    echo "✅ All issue titles translated to English"
    echo "✅ All issue descriptions translated to English"
    echo ""
    echo "🔗 Check at: https://github.com/$REPO/issues"
    echo ""
    echo "🎯 Ready to code like a pro in English! 🚀"
}

# Función principal
main() {
    echo "⚠️  This will update ALL project issues and milestones to English"
    confirm_action
    
    # Verificar autenticación
    if ! gh auth status &> /dev/null; then
        echo "❌ Error: Not authenticated with GitHub"
        echo "Run: gh auth login"
        exit 1
    fi
    
    update_milestones
    translate_issues
    show_final_status
    
    echo "✅ Translation completed!"
}

# Ejecutar
main
