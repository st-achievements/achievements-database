import { tsupConfig } from '@st-api/config';
import { defineConfig } from 'tsup';

export default defineConfig({
  ...tsupConfig,
  entry: {
    index: './src/index.ts',
  },
  dts: {
    entry: {
      index: './src/index.ts',
    },
  },
  external: ['vitest'],
});
