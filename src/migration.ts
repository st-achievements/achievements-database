import { config } from 'dotenv';
import { drizzle } from 'drizzle-orm/node-postgres';
import { migrate } from 'drizzle-orm/node-postgres/migrator';

import { getClient } from './database.js';

config();

const connectionString = process.env.DATABASE_CONNECTION_STRING;
if (!connectionString) {
  throw new Error('DATABASE_CONNECTION_STRING not found');
}

const client = getClient(connectionString);

const database = drizzle(client);

await migrate(database, { migrationsFolder: 'migrations' });

await client.end();
