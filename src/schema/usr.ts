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
  externalId: varchar({ length: 255 }).unique(),
  name: varchar({ length: 255 }).notNull().unique(),
  timezone: varchar({ length: 255 }).notNull().default('UTC'),
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
    ...commonColumnsWithoutId,
    userId: integer()
      .references(() => user.id)
      .notNull(),
    achAchievementId: integer()
      .references(() => ach.achievement.id)
      .notNull(),
    achievedAt: timestamp().notNull().defaultNow(),
    periodId: integer()
      .references(() => cfg.period.id)
      .notNull(),
  },
  (table) => [
    index('usr_achievement_user_period_index').on(table.userId, table.periodId),
    primaryKey({
      columns: [table.achAchievementId, table.userId, table.periodId],
    }),
    index('usr_achievement_user_achievement_index').on(
      table.userId,
      table.achAchievementId,
    ),
  ],
);

export const achievementRelations = relations(achievement, ({ one, many }) => ({
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
  usrAchievementProgress: many(achievementProgress),
}));

export const workout = schema.table(
  'usr_workout',
  {
    ...commonColumns,
    userId: integer()
      .references(() => user.id)
      .notNull(),
    workoutTypeId: integer()
      .references(() => wrk.workoutType.id)
      .notNull(),
    duration: doublePrecision().notNull(),
    startedAt: timestamp().notNull(),
    endedAt: timestamp().notNull(),
    externalId: varchar({ length: 255 }).notNull().unique(),
    distance: doublePrecision(),
    energyBurned: doublePrecision().notNull(),
    workoutName: varchar({ length: 255 }),
    periodId: integer()
      .references(() => cfg.period.id)
      .notNull(),
    achievementProcessedAt: timestamp('achievement_processed_at'),
  },
  (table) => [
    index('usr_workout_user_period_workout_type_index').on(
      table.userId,
      table.periodId,
      table.workoutTypeId,
    ),
    index('usr_workout_user_period_started_at_ended_at_index').on(
      table.userId,
      table.periodId,
      table.startedAt,
      table.endedAt,
    ),
    index('usr_workout_user_period_workout_type_started_at_ended_at_index').on(
      table.userId,
      table.periodId,
      table.workoutTypeId,
      table.startedAt,
      table.endedAt,
    ),
  ],
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
  'achievement_progress',
  {
    ...commonColumnsWithoutId,
    quantity: smallint().notNull(),
    achAchievementId: integer()
      .references(() => ach.achievement.id)
      .notNull(),
    userId: integer()
      .references(() => user.id)
      .notNull(),
    periodId: integer()
      .references(() => cfg.period.id)
      .notNull(),
  },
  (table) => [
    primaryKey({
      columns: [table.achAchievementId, table.userId, table.periodId],
    }),
    index('usr_achievement_progress_user_achievement_index').on(
      table.userId,
      table.achAchievementId,
    ),
  ],
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
    usrAchievement: one(achievement, {
      fields: [
        achievementProgress.achAchievementId,
        achievementProgress.userId,
        achievementProgress.periodId,
      ],
      references: [
        achievement.achAchievementId,
        achievement.userId,
        achievement.periodId,
      ],
    }),
  }),
);
