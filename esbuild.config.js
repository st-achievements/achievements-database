import { build } from 'esbuild';
import fastglob from 'fast-glob';
import { rimraf } from 'rimraf';

await rimraf('dist');

const files = await fastglob('src/**/*.ts');

await build({
  entryPoints: files,
  bundle: false,
  format: 'esm',
  minify: true,
  platform: 'node',
  outdir: 'dist',
});
