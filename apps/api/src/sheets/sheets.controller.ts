import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { SheetsService } from './sheets.service';

@Controller('sheets')
export class SheetsController {
  constructor(private readonly sheetsService: SheetsService) {}

  @Post('log-message')
  async logMessage(@Body() data: {
    from: string;
    message: string;
    type?: string;
  }) {
    return this.sheetsService.logMessage({
      ...data,
      timestamp: new Date(),
    });
  }

  @Get('config')
  async getConfig() {
    return this.sheetsService.getConfig();
  }

  @Post('create-sheet/:id')
  async createSheet(@Param('id') spreadsheetId: string) {
    return this.sheetsService.createSheet(spreadsheetId);
  }
  @Post('add-user')
  async addUser(@Body() userData: any) {
    return this.sheetsService.addUser(userData);
  }

  @Get('users')
  async getUsers() {
    return this.sheetsService.getUsers();
  }


  @Post('add-reminder')
  async addReminder(@Body() reminderData: any) {
    return this.sheetsService.addReminder(reminderData);
  }

  @Get('reminders')
  async getReminders() {
    return this.sheetsService.getReminders();
  }

  @Post('add-analytic')
  async addAnalytic(@Body() analyticData: any) {
    return this.sheetsService.addAnalytic(analyticData);
  }

  @Get('analytics')
  async getAnalytics() {
    return this.sheetsService.getAnalytics();
  }

  @Post('add-template')
  async addTemplate(@Body() templateData: any) {
    return this.sheetsService.addTemplate(templateData);
  }

  @Get('templates')
  async getTemplates() {
    return this.sheetsService.getTemplates();
  }

}
