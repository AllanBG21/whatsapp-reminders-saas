import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.setGlobalPrefix('api');           // todas las rutas bajo /api
  app.enableCors({ origin: [/localhost/], credentials: true }); // CORS dev
  await app.listen(4001);               // puerto API
}
bootstrap();
