import { Module } from '@nestjs/common';
import { WhatsappService } from './whatsapp.service';
import { WhatsappController } from './whatsapp.controller';
import { SheetsModule } from '../sheets/sheets.module';

@Module({
  providers: [WhatsappService],
  controllers: [WhatsappController],
  imports: [SheetsModule],
})
export class WhatsappModule {}
