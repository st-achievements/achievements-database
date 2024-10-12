import { eslint } from '@st-api/config';

export default [
  ...eslint,
  {
    rules: {
      '@typescript-eslint/no-unsafe-assignment': 'off',
      '@typescript-eslint/no-unsafe-return': 'off',
      '@typescript-eslint/ no-unsafe-argument': 'off',
    },
  },
];
