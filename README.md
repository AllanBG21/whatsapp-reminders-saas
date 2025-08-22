# 🤖 WhatsApp Reminders SaaS

[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![NestJS](https://img.shields.io/badge/NestJS-10+-red.svg)](https://nestjs.com/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5+-blue.svg)](https://www.typescriptlang.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Production-ready WhatsApp Business API integration with Google Sheets database for automated messaging, reminders, and customer management.**

---

## 🌟 **Features**

✅ **Complete WhatsApp Business Integration**
- Real-time webhook processing
- Automated response system with custom configurations
- Message logging and analytics
- Template management

✅ **Google Sheets as Database**
- User management (CRUD operations)
- Reminder scheduling and tracking
- Analytics and reporting
- Template storage and management
- Real-time data synchronization

✅ **Production Ready**
- NestJS architecture with proper modules
- Environment validation and configuration
- Error handling and logging
- API documentation and testing endpoints

---

## 🚀 **Tech Stack**

| Category | Technology |
|----------|------------|
| **Backend** | NestJS + TypeScript |
| **Frontend** | Next.js + Tailwind CSS |
| **Database** | Google Sheets API |
| **Integration** | WhatsApp Business Cloud API |
| **Development** | pnpm, Ngrok |

---

## 📋 **API Endpoints**

### **WhatsApp Integration**
```http
GET  /api/whatsapp/webhook     # Webhook verification
POST /api/whatsapp/webhook     # Receive WhatsApp messages
GET  /api/whatsapp/env-check   # Environment validation
```

### **User Management**
```http
POST /api/sheets/add-user      # Create new user
GET  /api/sheets/users         # List all users
```

### **Reminder System**  
```http
POST /api/sheets/add-reminder  # Schedule new reminder
GET  /api/sheets/reminders     # List all reminders
```

### **Analytics & Tracking**
```http
POST /api/sheets/add-analytic  # Log user actions
GET  /api/sheets/analytics     # Get analytics data
POST /api/sheets/log-message   # Log WhatsApp messages
```

### **Template Management**
```http
POST /api/sheets/add-template  # Create message template
GET  /api/sheets/templates     # List all templates
```

### **Configuration**
```http
GET /api/sheets/config         # Get bot configuration and responses
```

---

## ⚡ **Quick Start**

### **1. Prerequisites**
```bash
# Install Node.js 18+
node --version

# Install pnpm
npm install -g pnpm
```

### **2. Clone and Install**
```bash
git clone <your-repo-url>
cd whatsapp-reminders-saas
pnpm install
```

### **3. Environment Setup**
```bash
# Copy environment template
cp .env.example .env

# Edit with your credentials
nano .env
```

### **4. Google Sheets Setup**
1. Create a Google Cloud Project
2. Enable Google Sheets API
3. Create a Service Account
4. Download `service-account.json` to `apps/api/`
5. Share your Google Sheet with the service account email

### **5. WhatsApp Business Setup**
1. Create Meta Developer Account
2. Set up WhatsApp Business App
3. Get Phone Number ID and Access Token
4. Configure Webhook URL

### **6. Run Application**
```bash
# Start API server
cd apps/api
pnpm nest start

# In another terminal - Start frontend
cd apps/web  
pnpm dev
```

---

## 🔧 **Environment Variables**

Create `.env` file in the root directory:

```bash
# WhatsApp Business API
WABA_TOKEN=your_whatsapp_business_token
WABA_PHONE_NUMBER_ID=your_phone_number_id  
WABA_VERIFY_TOKEN=your_custom_verify_token

# Google Sheets Integration
GOOGLE_SHEETS_ID=your_google_sheet_id
GOOGLE_SERVICE_ACCOUNT_PATH=./service-account.json

# Server Configuration
PORT=4001
NODE_ENV=development

# Development (optional)
NGROK_AUTHTOKEN=your_ngrok_token
```

---

## 📊 **Data Structure**

### **Users Sheet**
| Column | Type | Description |
|--------|------|-------------|
| timestamp | DateTime | Creation date |
| phone | String | Phone number (+country_code) |
| name | String | User full name |
| status | String | active, inactive, blocked |
| plan | String | free, premium, enterprise |

### **Reminders Sheet**
| Column | Type | Description |
|--------|------|-------------|
| timestamp | DateTime | Creation date |
| phone | String | Target phone number |
| message | String | Reminder message |
| scheduledTime | DateTime | When to send |
| frequency | String | once, daily, weekly, monthly |
| status | String | pending, sent, failed |

### **Analytics Sheet**
| Column | Type | Description |
|--------|------|-------------|
| timestamp | DateTime | Event time |
| phone | String | User phone |
| action | String | Event type |
| session_id | String | Session identifier |
| event_type | String | success, error, info |

---

## 🧪 **Testing**

### **Test Google Sheets Integration**
```bash
# Add test user
curl -X POST http://localhost:4001/api/sheets/add-user \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "+1234567890",
    "name": "John Doe", 
    "status": "active",
    "plan": "premium"
  }'

# Get all users
curl http://localhost:4001/api/sheets/users
```

### **Test WhatsApp Webhook**
```bash
# Simulate WhatsApp message
curl -X POST http://localhost:4001/api/whatsapp/webhook \
  -H "Content-Type: application/json" \
  -d '{
    "entry": [{
      "changes": [{
        "value": {
          "messages": [{
            "from": "1234567890",
            "text": {"body": "Hello!"}
          }]
        }
      }]
    }]
  }'
```

---

## 🚀 **Production Deployment**

### **Using Ngrok (Development)**
```bash
# Install ngrok
npm install -g ngrok

# Expose local server
ngrok http 4001

# Update webhook URL in Meta Developer Console
# https://your-ngrok-url.ngrok-free.app/api/whatsapp/webhook
```

### **Production Server**
1. Deploy to VPS/Cloud (DigitalOcean, AWS, etc.)
2. Set up reverse proxy (Nginx)
3. Configure SSL certificates
4. Set up process manager (PM2)
5. Update webhook URL to your domain

---

## 📁 **Project Structure**

```
whatsapp-reminders-saas/
├── apps/
│   ├── api/                 # NestJS Backend
│   │   ├── src/
│   │   │   ├── sheets/      # Google Sheets module
│   │   │   ├── whatsapp/    # WhatsApp module  
│   │   │   └── main.ts      # Application entry
│   │   ├── service-account.json  # Google credentials
│   │   └── package.json
│   ├── web/                 # Next.js Frontend
│   │   ├── src/
│   │   └── package.json
│   └── scripts/             # Utility scripts
│       └── update-token.sh  # Token management
├── .env.example             # Environment template
├── package.json             # Root package configuration
└── README.md               # This file
```

---

## 🤖 **Bot Commands**

The bot automatically responds to:

| Command | Response | Configured In |
|---------|----------|---------------|
| `hola` | "¡Hola! ¿En qué te ayudo? TEST 22" | Google Sheets Config |
| `precio` | "Contáctanos para información de precios Ago22" | Google Sheets Config |

*Configure more responses in the Google Sheets config sheet*

---

## 🔍 **Troubleshooting**

### **Common Issues**

**❌ Webhook not receiving messages**
- Check ngrok is running and URL is updated
- Verify webhook URL in Meta Developer Console  
- Check server logs for errors

**❌ Google Sheets not updating**
- Verify service account email has sheet access
- Check `GOOGLE_SHEETS_ID` in environment
- Validate service account JSON file

**❌ WhatsApp messages not sending**
- Verify `WABA_TOKEN` is valid and not expired
- Check `WABA_PHONE_NUMBER_ID` is correct
- Ensure phone number is verified in Meta Business

### **Debug Commands**
```bash
# Check environment configuration
curl http://localhost:4001/api/whatsapp/env-check

# View server logs  
cd apps/api
pnpm nest start --watch

# Test Google Sheets connection
curl http://localhost:4001/api/sheets/users
```

---

## 📈 **Next Steps**

- [ ] Implement scheduled reminder sending
- [ ] Add user authentication and dashboard
- [ ] Create advanced analytics and reporting
- [ ] Set up automated testing (Jest)
- [ ] Configure CI/CD pipeline
- [ ] Add Docker containerization
- [ ] Implement rate limiting and security

---

## �� **Contributing**

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🆘 **Support**

- **Issues**: [GitHub Issues](https://github.com/yourusername/whatsapp-reminders-saas/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/whatsapp-reminders-saas/discussions)

---

**⭐ Star this repository if it helped you!**
