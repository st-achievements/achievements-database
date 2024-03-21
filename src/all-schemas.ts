import { getDrizzleSchema } from './common.js';
import { ach, cfg, iam, usr, wrk } from './schema/index.js';

export const allSchemas = {
  ...getDrizzleSchema(ach, 'ach'),
  ...getDrizzleSchema(cfg, 'cfg'),
  ...getDrizzleSchema(usr, 'usr'),
  ...getDrizzleSchema(wrk, 'wrk'),
  ...getDrizzleSchema(iam, 'iam'),
};
