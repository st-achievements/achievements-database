import { migrate } from 'drizzle-orm/node-postgres/migrator';
import { config } from 'dotenv';
import { drizzle } from 'drizzle-orm/node-postgres';
import { getClient } from './database.js';

config();

const client = getClient();

const database = drizzle(client);

await migrate(database, { migrationsFolder: 'migrations' });

await client.end();
