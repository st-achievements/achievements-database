import { StApiName } from '@st-api/core';
import { Logger } from '@st-api/firebase';
import { drizzle, type NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { Pool } from 'pg';
import type { Class } from 'type-fest';

import { allSchemas } from './all-schemas.js';
import { DATABASE_CONNECTION_STRING } from './database-connection-string.secret.js';
import { getClient } from './database.js';
import { FactoryProvider, InjectionToken, Provider } from '@stlmpp/di';

function getClazz<T>(): Class<T> {
  return class {} as Class<T>;
}

export class Drizzle extends getClazz<NodePgDatabase<typeof allSchemas>>() {}

const InternalClientToken = new InjectionToken<Pool>(
  'DRIZZLE_INTERNAL_CLIENT_TOKEN',
);

const DrizzleLogger = Logger.create('drizzle');

export function provideDrizzle(): Provider[] {
  return [
    new FactoryProvider(
      InternalClientToken,
      (apiName) =>
        getClient({
          connectionString: DATABASE_CONNECTION_STRING.value(),
          applicationName: apiName,
        }),
      [StApiName],
    ),
    new FactoryProvider(
      Drizzle,
      (client) =>
        drizzle(client, {
          casing: 'snake_case',
          schema: allSchemas,
          logger: {
            logQuery: (query, params) =>
              DrizzleLogger.debug(`${query}; -- ${JSON.stringify(params)}`),
          },
        }),
      [InternalClientToken],
    ),
  ];
}
