import { Injectable } from '@nestjs/common';
import { google } from 'googleapis';
import { GoogleAuth } from 'google-auth-library';


@Injectable()
export class SheetsService {
  private auth: GoogleAuth;
  private sheets: any;

  constructor() {
    this.initializeGoogleSheets();
  }

  private async initializeGoogleSheets() {
    try {
      this.auth = new GoogleAuth({
        keyFile: process.env.GOOGLE_CREDENTIALS_PATH,
        scopes: ['https://www.googleapis.com/auth/spreadsheets'],
      });

      this.sheets = google.sheets({ version: 'v4', auth: this.auth });
      console.log('✅ Google Sheets API initialized successfully');
    } catch (error) {
      console.error('❌ Error initializing Google Sheets:', error);
    }
  }

  async logMessage(data: {
    from: string;
    message: string;
    timestamp: Date;
    type?: string;
  }) {
    try {
      const spreadsheetId = process.env.GOOGLE_SHEET_ID;
      const range = 'Messages!A:D';

      const values = [[
        data.timestamp.toISOString(),
        data.from,
        data.message,
        data.type || 'text'
      ]];

      await this.sheets.spreadsheets.values.append({
        spreadsheetId,
        range,
        valueInputOption: 'RAW',
        requestBody: { values },
      });

      console.log(`✅ Message logged: ${data.from} - ${data.message}`);
      return { success: true };
    } catch (error) {
      console.error('❌ Error logging message:', error);
      return { success: false, error: error.message };
    }
  }

  async getConfig(): Promise<Record<string, string>> {
    try {
      const spreadsheetId = process.env.GOOGLE_SHEET_ID;
      const range = 'Config!A:B';

      const response = await this.sheets.spreadsheets.values.get({
        spreadsheetId,
        range,
      });

      const rows = response.data.values || [];
      const config: Record<string, string> = {};

      // Skip header row and process data
      for (let i = 1; i < rows.length; i++) {
        const [keyword, response] = rows[i];
        if (keyword && response) {
          config[keyword.toLowerCase()] = response;
        }
      }

      console.log(`✅ Config loaded: ${Object.keys(config).length} keywords`);
      return config;
    } catch (error) {
      console.error('❌ Error loading config:', error);
      return {};
    }
  }

  async createSheet(spreadsheetId: string) {
    try {
      // Create Messages sheet with headers
      await this.sheets.spreadsheets.values.update({
        spreadsheetId,
        range: 'Messages!A1:D1',
        valueInputOption: 'RAW',
        requestBody: {
          values: [['Timestamp', 'From', 'Message', 'Type']]
        },
      });

      // Create Config sheet with headers and sample data
      await this.sheets.spreadsheets.values.update({
        spreadsheetId,
        range: 'Config!A1:B3',
        valueInputOption: 'RAW',
        requestBody: {
          values: [
            ['Keyword', 'Response'],
            ['hola', '¡Hola! ¿En qué te ayudo?'],
            ['precio', 'Contáctanos para información de precios']
          ]
        },
      });

      console.log('✅ Google Sheet initialized with headers and sample config');
      return { success: true };
    } catch (error) {
      console.error('❌ Error creating sheet structure:', error);
      return { success: false, error: error.message };
    }
  }
  
  async addReminder(reminderData: any) {
    try {
      const values = [[
        new Date().toISOString(),  // 'timeStamp'
        reminderData.phone,  // 'user'
        reminderData.message, // 'Reminder Text'
        reminderData.scheduledTime, // 'when to send'
        reminderData.frequency || 'once', // 'daily, once, weekly'
        reminderData.status || 'pending' // pending, sent, cancelled
      ]];

      await this.sheets.spreadsheets.values.append({
        spreadsheetId: process.env.GOOGLE_SHEET_ID,
        range: 'Reminders!A:F',
        valueInputOption: 'RAW',
        requestBody: { values }
      });

      console.log('✅ Reminder added to sheet');
      return { success: true, message: 'Reminder added successfully' };
    } catch (error) {
      console.log('❌ Error adding reminder:', error.message);
      return { success: false, error: error.message };
    }
  }

  async getReminders() {
    try {
      const response = await this.sheets.spreadsheets.values.get({
        spreadsheetId: process.env.GOOGLE_SHEET_ID,
        range: 'Reminders!A:F'
      });

      console.log('✅ Reminders retrieved');
      return { success: true, data: response.data.values || [] };
    } catch (error) {
      console.log('❌ Error getting reminders:', error.message);
      return { success: false, error: error.message };
    }
  }


  async addAnalytic(analyticData: any) {
    try {
      const values = [[
        new Date().toISOString(),  // 'timeStamp'
        analyticData.phone,  // 'user'
        analyticData.action, // 'Reminder Text
        analyticData.session_id,
        analyticData.event_type, // pending, sent, cancelled
      ]];

      await this.sheets.spreadsheets.values.append({
        spreadsheetId: process.env.GOOGLE_SHEET_ID,
        range: 'Analytics!A:E',
        valueInputOption: 'RAW',
        requestBody: { values }
      });

      console.log('✅ Analytic added to sheet');
      return { success: true, message: 'Analytic added successfully' };
    } catch (error) {
      console.log('❌ Error adding analytic:', error.message);
      return { success: false, error: error.message };
    }
  }

  async getAnalytics() {
    try {
      const response = await this.sheets.spreadsheets.values.get({
        spreadsheetId: process.env.GOOGLE_SHEET_ID,
        range: 'Analytics!A:E'
      });

      console.log('✅ Analytics retrieved');
      return { success: true, data: response.data.values || [] };
    } catch (error) {
      console.log('❌ Error getting analytics:', error.message);
      return { success: false, error: error.message };
    }
  }

  async addTemplate(templateData: any) {
    try {
      const values = [[
        new Date().toISOString(),  // 'timeStamp'
        templateData.name,  // 'user'
        templateData.content, // 'Reminder Text'
        templateData.phone, // 'when to send'
        templateData.category || 'once', // 'daily, once, weekly'
        templateData.status || 'pending' // pending, sent, cancelled
      ]];

      await this.sheets.spreadsheets.values.append({
        spreadsheetId: process.env.GOOGLE_SHEET_ID,
        range: 'Templates!A:F',
        valueInputOption: 'RAW',
        requestBody: { values }
      });

      console.log('✅ Template added to sheet');
      return { success: true, message: 'Template added successfully' };
    } catch (error) {
      console.log('❌ Error adding template:', error.message);
      return { success: false, error: error.message };
    }
  }

  async getTemplates() {
    try {
      const response = await this.sheets.spreadsheets.values.get({
        spreadsheetId: process.env.GOOGLE_SHEET_ID,
        range: 'Templates!A:F'
      });

      console.log('✅ Templates retrieved');
      return { success: true, data: response.data.values || [] };
    } catch (error) {
      console.log('❌ Error getting templates:', error.message);
      return { success: false, error: error.message };
    }
  }

  async addUser(userData: any) {
  try {
    const values = [[
      new Date().toISOString(),
      userData.phone,
      userData.name || 'Unknown',
      userData.status || 'active',
      userData.plan || 'free'
    ]];  // ← 5 valores

    await this.sheets.spreadsheets.values.append({
      spreadsheetId: process.env.GOOGLE_SHEET_ID,
      range: 'Users!A:E',  // ← 5 columnas (A,B,C,D,E)
      valueInputOption: 'RAW',
      requestBody: { values }
    });

    console.log('✅ User added to sheet');
    return { success: true, message: 'User added successfully' };
  } catch (error) {
    console.log('❌ Error adding user:', error.message);
    return { success: false, error: error.message };
  }
}

async getUsers() {
  try {
    const response = await this.sheets.spreadsheets.values.get({
      spreadsheetId: process.env.GOOGLE_SHEET_ID,
      range: 'Users!A:E'  // ← Mismo range en ambos métodos
    });

    console.log('✅ Users retrieved');
    return { success: true, data: response.data.values || [] };
  } catch (error) {
    console.log('❌ Error getting users:', error.message);
    return { success: false, error: error.message };
  }
}
}