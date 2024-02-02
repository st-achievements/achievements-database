import {
  index,
  integer,
  numeric,
  pgSchema,
  timestamp,
  uuid,
  varchar,
} from 'drizzle-orm/pg-core';
import { commonColumns } from '../common.js';
import { achievement as achAchievement } from './ach.js';
import { relations } from 'drizzle-orm';
import { workoutType as wrkWorkoutType } from './wrk.js';

export const schema = pgSchema('usr');

export const usr = schema.table('user', {
  externalId: varchar('external_id', { length: 255 }).unique(),
  name: varchar('name', { length: 255 }).notNull().unique(),
  ...commonColumns,
});

export const userRelations = relations(usr, ({ many }) => ({
  achievements: many(achievement),
  workouts: many(workout),
}));

export const achievement = schema.table(
  'usr_achievement',
  {
    userId: integer('user_id')
      .references(() => usr.id)
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
  user: one(usr, {
    fields: [achievement.userId],
    references: [usr.id],
  }),
}));

export const workout = schema.table(
  'workout',
  {
    ...commonColumns,
    userId: integer('user_id')
      .references(() => usr.id)
      .notNull(),
    workoutTypeId: integer('workout_type_id')
      .references(() => wrkWorkoutType.id)
      .notNull(),
    duration: numeric('duration', { scale: 2, precision: 6 }).notNull(),
    startedAt: timestamp('started_at').notNull(),
    endedAt: timestamp('ended_at').notNull(),
    externalId: varchar('external_id', { length: 255 }).notNull().unique(),
    distance: numeric('distance', { scale: 2, precision: 6 }),
    energyBurned: numeric('energy_burned', {
      scale: 2,
      precision: 6,
    }).notNull(),
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
  user: one(usr, { fields: [workout.userId], references: [usr.id] }),
  wrkWorkoutType: one(wrkWorkoutType, {
    fields: [workout.workoutTypeId],
    references: [wrkWorkoutType.id],
  }),
}));
