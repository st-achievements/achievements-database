import { index, jsonb, pgSchema, varchar } from 'drizzle-orm/pg-core';
import { commonColumns } from '../common.js';

export const schema = pgSchema('cfg');

export const dataMigrationExecution = schema.table(
  'data_migration_execution',
  {
    ...commonColumns,
    objectName: varchar('object_name', { length: 255 }).notNull(),
    objectContent: jsonb('object_content').notNull(),
  },
  (table) => ({
    objectNameIndex: index('data_migration_execution_object_name_index').on(
      table.objectName,
    ),
  }),
);
