import { Module, OnApplicationShutdown } from '@nestjs/common';
import { ModuleRef } from '@nestjs/core';
import { Logger } from '@st-api/firebase';
import { drizzle, type NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { Pool } from 'pg';
import type { Class } from 'type-fest';
import { DATABASE_CONNECTION_STRING } from './database-connection-string.secret.js';
import { getClient } from './database.js';
import { allSchemas } from './all-schemas.js';

function getClazz<T>(): Class<T> {
  return class {} as Class<T>;
}

export class Drizzle extends getClazz<NodePgDatabase<typeof allSchemas>>() {}

const InternalClientToken = 'DRIZZLE_INTERNAL_CLIENT_TOKEN';

const DrizzleLogger = Logger.create('drizzle');

@Module({
  exports: [Drizzle],
  providers: [
    {
      provide: InternalClientToken,
      useFactory: () => getClient(DATABASE_CONNECTION_STRING.value()),
    },
    {
      provide: Drizzle,
      useFactory: (client: Pool) =>
        drizzle(client, {
          schema: allSchemas,
          logger: {
            logQuery: (query, params) =>
              DrizzleLogger.debug(`${query}; -- ${JSON.stringify(params)}`),
          },
        }),
      inject: [InternalClientToken],
    },
  ],
})
export class DrizzleOrmModule implements OnApplicationShutdown {
  constructor(private readonly moduleRef: ModuleRef) {}

  async onApplicationShutdown(): Promise<void> {
    try {
      const client = this.moduleRef.get<Pool>(InternalClientToken);
      await client.end();
    } catch (error) {
      Logger.error('error on DrizzleOrmModule shutdown', error);
    }
  }
}
