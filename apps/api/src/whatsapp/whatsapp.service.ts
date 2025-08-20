import { Injectable, HttpException } from '@nestjs/common';
import axios from 'axios';

@Injectable()
export class WhatsappService {
  // 1) Enviar PLANTILLA (template)
  async sendTemplate(args: {
    phoneNumberId: string;
    token: string;
    to: string;       // E.164 SOLO dígitos (sin +), ej: 50671508835
    template: string; // ej: "hello_world"
    lang?: string;    // ej: "en_US" (por defecto para hello_world)
    params?: string[];
  }) {
    const { phoneNumberId, token, to, template, lang = 'en_US', params = [] } = args;

    try {
      const url = `https://graph.facebook.com/v21.0/${phoneNumberId}/messages`;

      const payload: any = {
        messaging_product: 'whatsapp',
        to,
        type: 'template',
        template: {
          name: template,
          language: { code: lang },
        },
      };

      // Solo agrega "components" si hay params
      if (params.length) {
        payload.template.components = [
          { type: 'body', parameters: params.map((t) => ({ type: 'text', text: t })) },
        ];
      }

      const res = await axios.post(url, payload, {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });
      return res.data;
    } catch (err: any) {
      const status = err?.response?.status || 500;
      const details = err?.response?.data || err?.message || 'Unknown error';
      // eslint-disable-next-line no-console
      console.error('WA API error (template):', details);
      throw new HttpException({ message: 'WA API error', details }, status);
    }
  }

  // 2) Enviar TEXTO libre (para auto-replies dentro de la ventana 24h)
  async sendText(args: {
    phoneNumberId: string;
    token: string;
    to: string;   // E.164 SOLO dígitos (sin +)
    text: string;
  }) {
    const { phoneNumberId, token, to, text } = args;

    try {
      const url = `https://graph.facebook.com/v21.0/${phoneNumberId}/messages`;
      const payload = {
        messaging_product: 'whatsapp',
        to,
        type: 'text',
        text: { body: text },
      };

      const res = await axios.post(url, payload, {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });
      return res.data;
    } catch (err: any) {
      const status = err?.response?.status || 500;
      const details = err?.response?.data || err?.message || 'Unknown error';
      // eslint-disable-next-line no-console
      console.error('WA API error (text):', details);
      throw new HttpException({ message: 'WA API error', details }, status);
    }
  }
}
