import { Config } from 'drizzle-kit';
import { getConnectionString } from './src/get-connection-string';

export default {
  schema: './dist/schema/*',
  out: './migrations',
  driver: 'pg',
  dbCredentials: {
    connectionString: getConnectionString(),
  },
} satisfies Config;
