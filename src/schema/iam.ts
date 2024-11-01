import { relations } from 'drizzle-orm';
import { index, integer, pgSchema, varchar } from 'drizzle-orm/pg-core';

import { commonColumns } from '../common.js';

import * as usr from './usr.js';

export const schema = pgSchema('iam');

export const apiKey = schema.table(
  'api_key',
  {
    ...commonColumns,
    key: varchar({ length: 1000 }).notNull(),
    salt: varchar({ length: 50 }).notNull(),
    userId: integer()
      .references(() => usr.user.id)
      .notNull(),
  },
  (table) => ({
    userIdIndex: index('api_key_user_id_index').on(table.userId),
  }),
);

export const apiKeyRelations = relations(apiKey, ({ one }) => ({
  user: one(usr.user, {
    fields: [apiKey.userId],
    references: [usr.user.id],
  }),
}));
