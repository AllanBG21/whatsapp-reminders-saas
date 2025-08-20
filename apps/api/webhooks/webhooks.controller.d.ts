import { Response } from 'express';
export declare class WebhooksController {
    verify(mode: string, token: string, challenge: string, res: Response): Response<any, Record<string, any>>;
    handle(payload: any): string;
}
