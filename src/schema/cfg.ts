import { relations } from 'drizzle-orm';
import { date, index, pgSchema, varchar } from 'drizzle-orm/pg-core';

import { commonColumns } from '../common.js';

import * as ach from './ach.js';
import * as usr from './usr.js';

export const schema = pgSchema('cfg');

export const quantityUnit = schema.table('quantity_unit', {
  ...commonColumns,
  name: varchar({ length: 10 }).notNull().unique(),
  description: varchar({ length: 255 }),
});

export const quantityUnitRelations = relations(quantityUnit, ({ many }) => ({
  achAchievements: many(ach.achievement),
}));

export const period = schema.table(
  'period',
  {
    ...commonColumns,
    startAt: date().notNull(),
    endAt: date().notNull(),
  },
  (table) => [
    index('period_start_at_end_at_index').on(table.startAt, table.endAt),
  ],
);

export const periodRelations = relations(period, ({ many }) => ({
  usrWorkouts: many(usr.workout),
  usrAchievements: many(usr.achievement),
  usrAchievementProgresses: many(usr.achievementProgress),
}));
