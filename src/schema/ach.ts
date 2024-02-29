import { relations } from 'drizzle-orm';
import { index, integer, pgEnum, pgSchema, varchar } from 'drizzle-orm/pg-core';

import { commonColumns, PgEnumAsType } from '../common.js';

import * as cfg from './cfg.js';
import * as usr from './usr.js';
import * as wrk from './wrk.js';

export const schema = pgSchema('ach');

export const WorkoutTypeConditionEnum = pgEnum('workout_type_condition', [
  'anyOf',
  'allOf',
  'any',
  'all',
  'exclusiveAny',
  'exclusiveAnyOf',
]);

export type WorkoutTypeConditionType = PgEnumAsType<
  typeof WorkoutTypeConditionEnum
>;

export const PeriodConditionEnum = pgEnum('workout_period_condition', [
  'hours',
  'days',
  'weeks',
  'months',
  'sameDay',
  'sameWeek',
  'sameMonth',
  'sameYear',
  'samePeriod',
  'singleSession',
]);

export type PeriodConditionType = PgEnumAsType<typeof PeriodConditionEnum>;

export const FrequencyEnum = pgEnum('frequency', [
  'hour',
  'day',
  'week',
  'month',
]);

export type FrequencyType = PgEnumAsType<typeof FrequencyEnum>;

export const FrequencyConditionEnum = pgEnum('frequency_condition', [
  'every',
  'any',
]);

export type FrequencyConditionType = PgEnumAsType<
  typeof FrequencyConditionEnum
>;

export const achievement = schema.table(
  'achievement',
  {
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
    periodConditionQuantity: integer('period_condition_quantity'),
    frequency: FrequencyEnum('frequency'),
    frequencyQuantity: integer('frequency_quantity'),
    frequencyCondition: FrequencyConditionEnum('frequency_condition'),
  },
  (table) => ({
    levelIdIndex: index('achievement_level_id_index').on(table.levelId),
    quantityUnitIdIndex: index('achievement_quantity_unit_id_index').on(
      table.quantityUnitId,
    ),
  }),
);

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
    workoutTypeIdIndex: index(
      'achievement_workout_type_workout_type_id_index',
    ).on(table.workoutTypeId),
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
