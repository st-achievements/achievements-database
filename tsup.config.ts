import { tsupConfig } from '@st-api/config';
import { defineConfig } from 'tsup';

export default defineConfig({
  ...tsupConfig,
  external: ['vitest'],
});
