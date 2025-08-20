"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.WebhooksController = void 0;
const common_1 = require("@nestjs/common");
let WebhooksController = class WebhooksController {
    verify(mode, token, challenge, res) {
        const expected = process.env.WABA_VERIFY_TOKEN;
        if (mode === 'subscribe' && token === expected) {
            return res.status(200).send(challenge ?? '');
        }
        return res.sendStatus(403);
    }
            handle(payload) {
    console.log('Incoming request:', JSON.stringify(payload, null, 2)); // Log the incoming payload
    console.log('Webhook WhatsApp payload:', JSON.stringify(payload, null, 2)); // Existing log
    console.log('Sending response to WhatsApp...'); // Log before sending a response

    return 'OK';
}
    }

exports.WebhooksController = WebhooksController;
__decorate([
    (0, common_1.Get)('whatsapp'),
    __param(0, (0, common_1.Query)('hub.mode')),
    __param(1, (0, common_1.Query)('hub.verify_token')),
    __param(2, (0, common_1.Query)('hub.challenge')),
    __param(3, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, String, Object]),
    __metadata("design:returntype", void 0)
], WebhooksController.prototype, "verify", null);
__decorate([
    (0, common_1.Post)('whatsapp'),
    (0, common_1.HttpCode)(200),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], WebhooksController.prototype, "handle", null);
exports.WebhooksController = WebhooksController = __decorate([
    (0, common_1.Controller)('webhooks')
], WebhooksController);
//# sourceMappingURL=webhooks.controller.js.map