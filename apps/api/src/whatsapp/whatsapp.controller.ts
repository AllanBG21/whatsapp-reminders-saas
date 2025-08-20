import { Body, Controller, Get, Post, Query, Res } from '@nestjs/common';
import { WhatsappService } from './whatsapp.service';
import type { Response } from 'express';

@Controller('whatsapp')
export class WhatsappController {
  constructor(private readonly wa: WhatsappService) {}

  
  @Get('webhook')
  verify(
    @Query('hub.mode') mode: string,
    @Query('hub.verify_token') token: string,
    @Query('hub.challenge') challenge: string,
    @Res() res: Response,
  ) {
    if (mode === 'subscribe' && token === process.env.WABA_VERIFY_TOKEN) {
      return res.status(200).send(challenge);
    }
    return res.sendStatus(403);
  }

  @Post('webhook')
async webhook(@Body() body: any, @Res() res: Response) {
  try {
    const entries = body?.entry || [];
    for (const entry of entries) {
      for (const change of (entry.changes || [])) {
        const value = change.value || {};

        // (A) Incoming messages from user
        if (Array.isArray(value.messages)) {
          for (const msg of value.messages) {
            const from = msg.from; // E.164 (digits only, no +)
            const textBody =
              msg.text?.body ??
              (msg.type === 'button' ? msg.button?.text : undefined) ??
              (msg.type === 'interactive' ? msg.interactive?.button_reply?.title : undefined);

            // Debug log
            // eslint-disable-next-line no-console
            console.log('<< Incoming message', { from, type: msg.type, textBody });

            // Auto-reply (works if 24h window is open)
            if (from) {
              await this.wa.sendText({
                phoneNumberId: process.env.WABA_PHONE_NUMBER_ID!,
                token: process.env.WABA_TOKEN!,
                to: from,
                text: textBody
                  ? `Recibido: "${textBody}". Gracias por escribir.`
                  : 'Recibido. Gracias por escribir.',
              });
            }
          }
        }

        // (B) Message status updates (sent, delivered, read)
        if (Array.isArray(value.statuses)) {
          // eslint-disable-next-line no-console
          console.log('** Status updates **', JSON.stringify(value.statuses, null, 2));
        }
      }
    }
    return res.status(200).send('EVENT_RECEIVED');
  } catch (err) {
    // eslint-disable-next-line no-console
    console.error('Webhook handler error:', err);
    // Always 200 to avoid retries while debugging
    return res.sendStatus(200);
  }
}

    
  

  @Post('send-template')
  async sendTemplate(@Body() body: {
    to: string;
    template: string;
    params?: string[];
    phoneNumberId?: string;
    token?: string;
    lang?: string;
  }) {
    return this.wa.sendTemplate({
      phoneNumberId: body.phoneNumberId || process.env.WABA_PHONE_NUMBER_ID!,
      token: body.token || process.env.WABA_TOKEN!,
      to: body.to,
      template: body.template,
      params: body.params || [],
      lang: body.lang || 'es',
    });
  }
  @Get('env-check')
  envCheck() {
    return {
      hasPhoneNumberId: Boolean(process.env.WABA_PHONE_NUMBER_ID),
      hasToken: Boolean(process.env.WABA_TOKEN),
      verifyToken: process.env.WABA_VERIFY_TOKEN ? 'set' : 'missing',
    };
  }
}
