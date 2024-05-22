import { getAuthContext } from '@st-achievements/core';
import { safe } from '@st-api/core';
import camelcase from 'camelcase';
import {
  boolean,
  integer,
  jsonb,
  type PgEnum,
  type PgSchema,
  serial,
  timestamp,
} from 'drizzle-orm/pg-core';
import type { CamelCase, StringKeyOf } from 'type-fest';

export type MetadataColumnType = Record<
  string,
  string | number | boolean | undefined | null
>;

function getUserIdFromContext(): number {
  const [, auth] = safe(() => getAuthContext());
  return auth?.userId ?? -1;
}

export const commonColumnsWithoutId = {
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at')
    .defaultNow()
    .notNull()
    .$onUpdate(() => new Date()),
  active: boolean('active').default(true).notNull(),
  metadata: jsonb('metadata').$type<MetadataColumnType>().notNull().default({}),
  createdBy: integer('created_by')
    .notNull()
    .$default(() => getUserIdFromContext()),
  updatedBy: integer('updated_by')
    .notNull()
    .$default(() => getUserIdFromContext()),
};

export const commonColumns = {
  id: serial('id').primaryKey(),
  ...commonColumnsWithoutId,
} as const;

type TransformDrizzleSchema<
  S extends string,
  T extends { schema: PgSchema<S>; [key: string]: unknown },
> = {
  [K in StringKeyOf<T> as CamelCase<`${S}_${K}`>]: T[K];
};

export function getDrizzleSchema<
  T extends { schema: PgSchema<S>; [key: string]: unknown },
  S extends string,
>(schema: T, name: S): TransformDrizzleSchema<S, T> {
  if (name !== schema.schema.schemaName) {
    throw new Error(
      `Schema name is different from name. Schema: "${schema.schema.schemaName}" - Name: "${name}"`,
    );
  }
  const newSchema: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(schema)) {
    const newKey = camelcase(`${name}_${key}`);
    newSchema[newKey] = value;
  }
  return newSchema as TransformDrizzleSchema<S, T>;
}

export type PgEnumAsType<T> = T extends PgEnum<infer A> ? A[number] : never;
