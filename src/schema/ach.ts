import { index, integer, pgSchema, varchar } from 'drizzle-orm/pg-core';
import { commonColumns } from '../common.js';
import { relations } from 'drizzle-orm';
import { achievement as usrAchievement } from './usr.js';

export const schema = pgSchema('ach');

export const achievement = schema.table(
  'achievement',
  {
    name: varchar('name', { length: 255 }).notNull(),
    description: varchar('description', { length: 5000 }),
    imageUrl: varchar('image_url', { length: 4000 }),
    levelId: integer('level_id')
      .references(() => level.id)
      .notNull(),
    ...commonColumns,
  },
  (table) => ({
    levelIdIndex: index('achievement_level_id_index').on(table.levelId),
  }),
);

export const achievementRelations = relations(achievement, ({ one, many }) => ({
  level: one(level, {
    fields: [achievement.levelId],
    references: [level.id],
  }),
  usrAchievements: many(usrAchievement),
}));

export const level = schema.table('level', {
  name: varchar('name', { length: 255 }).notNull(),
  imageUrl: varchar('image_url', { length: 4000 }),
  ...commonColumns,
});

export const levelRelations = relations(level, ({ many }) => ({
  achievement: many(achievement),
}));
