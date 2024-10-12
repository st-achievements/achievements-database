import { tsupConfig } from '@st-api/config';
import { defineConfig } from 'tsup';
import fs from 'node:fs';
import timers from 'node:timers/promises';
import fsp from 'node:fs/promises';

async function fixDtsFile(filePath: string): Promise<void> {
  const file = await fsp.readFile(filePath, 'utf-8');
  await fsp.writeFile(filePath, file.replaceAll(`';`, `.js';`));
}

export default defineConfig({
  ...tsupConfig,
  dts: false,
  entry: {
    index: './src/index.ts',
  },
  experimentalDts: {
    entry: {
      index: './src/index.ts',
    },
  },
  external: ['vitest'],
  plugins: [
    ...(tsupConfig.plugins ?? []),
    {
      name: 'dts-fix',
      buildEnd: () => {
        (async () => {
          while (!fs.existsSync('dist/index.d.ts')) {
            await timers.setTimeout(500);
          }
          await fsp.cp('.tsup/declaration/src', 'dist/src', {
            recursive: true,
          });
          await Promise.all([
            fixDtsFile('dist/index.d.ts'),
            fixDtsFile('dist/_tsup-dts-rollup.d.ts'),
          ]);
        })();
      },
    },
  ],
});
