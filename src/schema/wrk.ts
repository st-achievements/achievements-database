import { pgSchema, varchar } from 'drizzle-orm/pg-core';
import { commonColumns } from '../common.js';
import { relations } from 'drizzle-orm';
import { workout as usrWorkout } from './usr.js';

export const schema = pgSchema('wrk');

export const workoutType = schema.table('workout_type', {
  ...commonColumns,
  name: varchar('name', { length: 255 }).notNull().unique(),
});

export const workoutTypeRelations = relations(workoutType, ({ many }) => ({
  usrWorkout: many(usrWorkout),
}));
