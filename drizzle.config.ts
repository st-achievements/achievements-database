import { defineConfig } from 'drizzle-kit';

export function getConnectionString(): string {
  const connectionString = process.env.DATABASE_CONNECTION_STRING;
  if (!connectionString) {
    throw new Error('Connection string not found');
  }
  return connectionString;
}

export default defineConfig({
  schema: './dist/schema/*',
  out: './migrations',
  driver: 'pg',
  dbCredentials: {
    connectionString: getConnectionString(),
  },
});
