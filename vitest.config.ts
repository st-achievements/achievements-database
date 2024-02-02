import { vitestConfig } from '@st-api/config';
import { defineConfig, mergeConfig } from 'vitest/config';

export default defineConfig(async (env) =>
  mergeConfig(await vitestConfig(env), {}),
);
