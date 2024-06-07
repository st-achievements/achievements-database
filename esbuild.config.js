import { build } from 'esbuild';
import { rimraf } from 'rimraf';
import { readFileSync } from 'node:fs';

await rimraf('dist');

/**
 * @type {import('type-fest').PackageJson}
 */
const packageJson = JSON.parse(readFileSync('package.json', 'utf8'));

const externals = [
  ...Object.keys(packageJson.dependencies),
  ...Object.keys(packageJson.peerDependencies),
];

await build({
  entryPoints: ['./src/schema/*', './src/migration.ts', './src/studio.ts'],
  bundle: true,
  format: 'esm',
  minify: false,
  platform: 'node',
  outdir: 'dist',
  external: externals,
});
