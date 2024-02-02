import type { Class } from 'type-fest';
import { Module, OnApplicationShutdown } from '@nestjs/common';
import { drizzle } from 'drizzle-orm/node-postgres';
import { ach, cfg, usr, wrk } from './schema/index.js';
import { getDrizzleSchema } from './common.js';
import { getClient } from './database.js';

const allSchemas = {
  ...getDrizzleSchema(ach, 'ach'),
  ...getDrizzleSchema(cfg, 'cfg'),
  ...getDrizzleSchema(usr, 'usr'),
  ...getDrizzleSchema(wrk, 'wrk'),
};

function getClazz<T>(): Class<T> {
  return class {} as Class<T>;
}

const client = getClient();

const database = drizzle(client, {
  schema: allSchemas,
});

export class Drizzle extends getClazz<typeof database>() {}

@Module({
  exports: [Drizzle],
  providers: [
    {
      provide: Drizzle,
      useValue: database,
    },
  ],
})
export class DrizzleOrmModule implements OnApplicationShutdown {
  async onApplicationShutdown(): Promise<void> {
    await client.end();
  }
}
