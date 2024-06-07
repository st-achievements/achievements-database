import { relations } from 'drizzle-orm';
import {
  boolean,
  index,
  integer,
  pgSchema,
  varchar,
} from 'drizzle-orm/pg-core';

import { commonColumns, PgEnumAsType } from '../common.js';

import * as cfg from './cfg.js';
import * as usr from './usr.js';
import * as wrk from './wrk.js';

export const schema = pgSchema('ach');

export const WorkoutTypeConditionEnum = schema.enum('workout_type_condition', [
  'anyOf',
  'allOf',
  'any',
  'exclusiveAny',
  'exclusiveAnyOf',
]);

export type WorkoutTypeConditionType = PgEnumAsType<
  typeof WorkoutTypeConditionEnum
>;

export const PeriodConditionEnum = schema.enum('workout_period_condition', [
  'sameDay',
  'sameWeek',
  'sameMonth',
  'samePeriod',
  'singleSession',
]);

export type PeriodConditionType = PgEnumAsType<typeof PeriodConditionEnum>;

export const FrequencyEnum = schema.enum('frequency', ['day', 'week', 'month']);

export type FrequencyType = PgEnumAsType<typeof FrequencyEnum>;

export const FrequencyConditionEnum = schema.enum('frequency_condition', [
  'every',
]);

export type FrequencyConditionType = PgEnumAsType<
  typeof FrequencyConditionEnum
>;

export const achievement = schema.table('achievement', {
  ...commonColumns,
  name: varchar('name', { length: 255 }).notNull(),
  description: varchar('description', { length: 5000 }),
  imageUrl: varchar('image_url', { length: 4000 }),
  levelId: integer('level_id')
    .references(() => level.id)
    .notNull(),
  quantityNeeded: integer('quantity_needed').notNull(),
  quantityUnitId: integer('quantity_unit_id')
    .references(() => cfg.quantityUnit.id)
    .notNull(),
  workoutTypeCondition: WorkoutTypeConditionEnum(
    'workout_type_condition',
  ).notNull(),
  periodCondition: PeriodConditionEnum('period_condition').notNull(),
  frequency: FrequencyEnum('frequency'),
  frequencyCondition: FrequencyConditionEnum('frequency_condition'),
  hasProgressTracking: boolean('has_progress_tracking')
    .default(false)
    .notNull(),
});

export const achievementRelations = relations(achievement, ({ one, many }) => ({
  level: one(level, {
    fields: [achievement.levelId],
    references: [level.id],
  }),
  usrAchievements: many(usr.achievement),
  usrAchievementProgresses: many(usr.achievementProgress),
  achievementWorkoutTypes: many(achievementWorkoutType),
  cfgQuantityUnit: one(cfg.quantityUnit, {
    fields: [achievement.quantityUnitId],
    references: [cfg.quantityUnit.id],
  }),
}));

export const achievementWorkoutType = schema.table(
  'achievement_workout_type',
  {
    ...commonColumns,
    achievementId: integer('achievement_id')
      .references(() => achievement.id)
      .notNull(),
    workoutTypeId: integer('workout_type_id')
      .references(() => wrk.workoutType.id)
      .notNull(),
  },
  (table) => ({
    achievementIdIndex: index(
      'achievement_workout_type_achievement_id_index',
    ).on(table.achievementId),
  }),
);

export const achievementWorkoutTypeRelations = relations(
  achievementWorkoutType,
  ({ one }) => ({
    achievement: one(achievement, {
      fields: [achievementWorkoutType.achievementId],
      references: [achievement.id],
    }),
    wrkWorkoutType: one(wrk.workoutType, {
      fields: [achievementWorkoutType.workoutTypeId],
      references: [wrk.workoutType.id],
    }),
  }),
);

export const level = schema.table('ach_level', {
  ...commonColumns,
  name: varchar('name', { length: 255 }).notNull(),
  imageUrl: varchar('image_url', { length: 4000 }),
});

export const levelRelations = relations(level, ({ many }) => ({
  achievements: many(achievement),
}));
