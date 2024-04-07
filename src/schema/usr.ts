import { relations } from 'drizzle-orm';
import {
  doublePrecision,
  index,
  integer,
  pgSchema,
  primaryKey,
  smallint,
  timestamp,
  varchar,
} from 'drizzle-orm/pg-core';

import { commonColumns, commonColumnsWithoutId } from '../common.js';

import * as ach from './ach.js';
import * as cfg from './cfg.js';
import * as iam from './iam.js';
import * as wrk from './wrk.js';

export const schema = pgSchema('usr');

export const user = schema.table('user', {
  ...commonColumns,
  externalId: varchar('external_id', { length: 255 }).unique(),
  name: varchar('name', { length: 255 }).notNull().unique(),
});

export const userRelations = relations(user, ({ many }) => ({
  achievements: many(achievement),
  workouts: many(workout),
  achievementProgresses: many(achievementProgress),
  apiKeys: many(iam.apiKey),
}));

export const achievement = schema.table(
  'usr_achievement',
  {
    ...commonColumns,
    userId: integer('user_id')
      .references(() => user.id)
      .notNull(),
    achAchievementId: integer('ach_achievement_id')
      .references(() => ach.achievement.id)
      .notNull(),
    achievedAt: timestamp('achieved_at').notNull().defaultNow(),
    periodId: integer('period_id')
      .references(() => cfg.period.id)
      .notNull(),
  },
  (table) => ({
    userPeriodIndex: index('usr_achievement_user_period_index').on(
      table.userId,
      table.periodId,
    ),
  }),
);

export const achievementRelations = relations(achievement, ({ one }) => ({
  achAchievement: one(ach.achievement, {
    fields: [achievement.achAchievementId],
    references: [ach.achievement.id],
  }),
  user: one(user, {
    fields: [achievement.userId],
    references: [user.id],
  }),
  cfgPeriod: one(cfg.period, {
    fields: [achievement.periodId],
    references: [cfg.period.id],
  }),
}));

export const workout = schema.table(
  'usr_workout',
  {
    ...commonColumns,
    userId: integer('user_id')
      .references(() => user.id)
      .notNull(),
    workoutTypeId: integer('workout_type_id')
      .references(() => wrk.workoutType.id)
      .notNull(),
    duration: doublePrecision('duration').notNull(),
    startedAt: timestamp('started_at').notNull(),
    endedAt: timestamp('ended_at').notNull(),
    externalId: varchar('external_id', { length: 255 }).notNull().unique(),
    distance: doublePrecision('distance'),
    energyBurned: doublePrecision('energy_burned').notNull(),
    workoutName: varchar('workout_name', { length: 255 }),
    periodId: integer('period_id')
      .references(() => cfg.period.id)
      .notNull(),
  },
  (table) => ({
    userPeriodWorkoutType: index(
      'usr_workout_user_period_workout_type_index',
    ).on(table.userId, table.periodId, table.workoutTypeId),
    userPeriodStartedAtEndedAt: index(
      'usr_workout_user_period_started_at_ended_at_index',
    ).on(table.userId, table.periodId, table.startedAt, table.endedAt),
    userPeriodWorkoutTypeStartedAtEndedAt: index(
      'usr_workout_user_period_workout_type_started_at_ended_at_index',
    ).on(
      table.userId,
      table.periodId,
      table.workoutTypeId,
      table.startedAt,
      table.endedAt,
    ),
  }),
);

export const workoutRelations = relations(workout, ({ one }) => ({
  user: one(user, { fields: [workout.userId], references: [user.id] }),
  wrkWorkoutType: one(wrk.workoutType, {
    fields: [workout.workoutTypeId],
    references: [wrk.workoutType.id],
  }),
  cfgPeriod: one(cfg.period, {
    fields: [workout.periodId],
    references: [cfg.period.id],
  }),
}));

export const achievementProgress = schema.table(
  'usr_achievement_progress',
  {
    ...commonColumnsWithoutId,
    quantity: smallint('quantity').notNull(),
    achAchievementId: integer('ach_achievement_id')
      .references(() => ach.achievement.id)
      .notNull(),
    userId: integer('user_id')
      .references(() => user.id)
      .notNull(),
    periodId: integer('period_id')
      .references(() => cfg.period.id)
      .notNull(),
  },
  (table) => ({
    achievementUserPeriodIndex: index(
      'usr_achievement_progress_achievement_user_period_index',
    ).on(table.achAchievementId, table.userId, table.periodId),
    pk: primaryKey({
      columns: [table.achAchievementId, table.userId, table.periodId],
    }),
  }),
);

export const achievementProgressRelations = relations(
  achievementProgress,
  ({ one }) => ({
    achAchievement: one(ach.achievement, {
      fields: [achievementProgress.achAchievementId],
      references: [ach.achievement.id],
    }),
    user: one(user, {
      fields: [achievementProgress.userId],
      references: [user.id],
    }),
    cfgPeriod: one(cfg.period, {
      fields: [achievementProgress.periodId],
      references: [cfg.period.id],
    }),
  }),
);
