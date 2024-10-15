import { tsupConfig } from '@st-api/config';
import { defineConfig } from 'tsup';

export default defineConfig({
  ...tsupConfig,
  entry: {
    index: './src/index.ts',
  },
  experimentalDts: {
    entry: {
      index: './src/index.ts',
    },
  },
  external: ['vitest'],
});
