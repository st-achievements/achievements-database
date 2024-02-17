import { defineSecret } from 'firebase-functions/params';

export const DATABASE_CONNECTION_STRING: ReturnType<typeof defineSecret> =
  defineSecret('DATABASE_CONNECTION_STRING');
