# WhatsApp Reminders SaaS

WhatsApp Business API integration for automated messaging and reminders.

## 🚀 Stack
- **Backend:** NestJS + TypeScript
- **Frontend:** Next.js + Tailwind CSS  
- **Integration:** WhatsApp Business Cloud API

## 📦 Setup

### 1. Install dependencies
```bash
pnpm install
```

### 2. Configure environment variables
```bash
# Copy and edit .env file
cp .env.example .env
```

### 3. Run the application
```bash
# Backend API
cd apps/api
pnpm nest start

# Frontend (separate terminal)
cd apps/web
pnpm dev
```

## 🔗 Endpoints
- `GET /api/whatsapp/webhook` - Webhook verification
- `POST /api/whatsapp/webhook` - Receive messages  
- `GET /api/whatsapp/env-check` - Environment check

## 🌐 Development URLs
- API: http://localhost:4001
- Web: http://localhost:3000

## 📱 Features
- Real-time WhatsApp message processing
- Automated response system
- Webhook verification for production
- Status tracking (sent/delivered)

## 🛠️ Development

### Project Structure
```
apps/
├── api/          # NestJS backend
└── web/          # Next.js frontend
```

### Environment Variables
```bash
WABA_TOKEN=your_whatsapp_token
WABA_PHONE_NUMBER_ID=your_phone_number_id
WABA_VERIFY_TOKEN=your_verify_token
PORT=4001
```

## 🚀 Deployment
- Configure webhook URL in Meta Developer Console
- Set up Ngrok for local development tunneling
- Ensure all environment variables are set
