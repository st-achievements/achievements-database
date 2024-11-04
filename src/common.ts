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

export function __INTERNAL_SET_GET_USER_ID_FROM_CONTEXT(
  callback: () => number | null | undefined,
) {
  GetUserIdFromContext.fn = callback;
}

const GetUserIdFromContext: { fn: () => number | null | undefined } = {
  fn: () => -1,
};

function getUserIdFromContext(): number {
  let userId;
  try {
    userId = GetUserIdFromContext.fn();
  } catch {
    /* empty */
  }
  return userId ?? -1;
}

export const commonColumnsWithoutId = {
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at')
    .defaultNow()
    .notNull()
    .$onUpdate(() => new Date()),
  inactivatedAt: timestamp(),
  metadata: jsonb('metadata').$type<MetadataColumnType>().notNull().default({}),
  createdBy: integer('created_by')
    .notNull()
    .default(-1)
    .$default(() => getUserIdFromContext()),
  updatedBy: integer('updated_by')
    .notNull()
    .default(-1)
    .$default(() => getUserIdFromContext())
    .$onUpdate(() => getUserIdFromContext()),
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
