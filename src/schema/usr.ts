import { relations } from 'drizzle-orm';
import {
  doublePrecision,
  index,
  integer,
  pgSchema,
  timestamp,
  varchar,
} from 'drizzle-orm/pg-core';

import { commonColumns } from '../common.js';

import { achievement as achAchievement } from './ach.js';
import { workoutType as wrkWorkoutType } from './wrk.js';

export const schema = pgSchema('usr');

export const user = schema.table('user', {
  externalId: varchar('external_id', { length: 255 }).unique(),
  name: varchar('name', { length: 255 }).notNull().unique(),
  ...commonColumns,
});

export const userRelations = relations(user, ({ many }) => ({
  achievements: many(achievement),
  workouts: many(workout),
}));

export const achievement = schema.table(
  'usr_achievement',
  {
    userId: integer('user_id')
      .references(() => user.id)
      .notNull(),
    achAchievementId: integer('ach_achievement_id')
      .references(() => achAchievement.id)
      .notNull(),
    achievedAt: timestamp('achieved_at').notNull().defaultNow(),
    ...commonColumns,
  },
  (table) => ({
    achAchievementIdIndex: index('achievement_ach_achievement_id_index').on(
      table.achAchievementId,
    ),
    userIdIndex: index('achievement_user_id_index').on(table.userId),
  }),
);

export const achievementRelations = relations(achievement, ({ one }) => ({
  achAchievement: one(achAchievement, {
    fields: [achievement.achAchievementId],
    references: [achAchievement.id],
  }),
  user: one(user, {
    fields: [achievement.userId],
    references: [user.id],
  }),
}));

export const workout = schema.table(
  'workout',
  {
    ...commonColumns,
    userId: integer('user_id')
      .references(() => user.id)
      .notNull(),
    workoutTypeId: integer('workout_type_id')
      .references(() => wrkWorkoutType.id)
      .notNull(),
    duration: doublePrecision('duration').notNull(),
    startedAt: timestamp('started_at').notNull(),
    endedAt: timestamp('ended_at').notNull(),
    externalId: varchar('external_id', { length: 255 }).notNull().unique(),
    distance: doublePrecision('distance'),
    energyBurned: doublePrecision('energy_burned').notNull(),
    workoutName: varchar('workout_name', { length: 255 }),
  },
  (table) => ({
    workoutTypeIdIndex: index('workout_workout_type_id_index').on(
      table.workoutTypeId,
    ),
    externalIdIndex: index('workout_external_id_index').on(table.externalId),
  }),
);

export const workoutRelations = relations(workout, ({ one }) => ({
  user: one(user, { fields: [workout.userId], references: [user.id] }),
  wrkWorkoutType: one(wrkWorkoutType, {
    fields: [workout.workoutTypeId],
    references: [wrkWorkoutType.id],
  }),
}));
