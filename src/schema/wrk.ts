import { relations } from 'drizzle-orm';
import { pgSchema, varchar } from 'drizzle-orm/pg-core';

import { commonColumns } from '../common.js';

import * as ach from './ach.js';
import * as usr from './usr.js';

export const schema = pgSchema('wrk');

export const workoutType = schema.table('workout_type', {
  ...commonColumns,
  name: varchar({ length: 255 }).notNull().unique(),
});

export const workoutTypeRelations = relations(workoutType, ({ many }) => ({
  usrWorkouts: many(usr.workout),
  achAchievementWorkoutTypes: many(ach.achievementWorkoutType),
}));
