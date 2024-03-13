import { getDrizzleSchema } from './common.js';
import { ach, cfg, usr, wrk } from './schema/index.js';

export const allSchemas = {
  ...getDrizzleSchema(ach, 'ach'),
  ...getDrizzleSchema(cfg, 'cfg'),
  ...getDrizzleSchema(usr, 'usr'),
  ...getDrizzleSchema(wrk, 'wrk'),
};
