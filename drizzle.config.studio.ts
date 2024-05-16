import { defineConfig } from 'drizzle-kit';

export function getConnectionString(): string {
  const connectionString = process.env.DATABASE_CONNECTION_STRING;
  if (!connectionString) {
    throw new Error('Connection string not found');
  }
  return connectionString;
}

export default defineConfig({
  dialect: 'postgresql',
  schema: './dist/studio.js',
  out: './migrations',
  dbCredentials: {
    url: getConnectionString(),
  },
  verbose: true,
});
