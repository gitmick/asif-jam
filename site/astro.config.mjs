import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

// site/base are set for GitHub Pages under gitmick/asif-jam. Change both together if the
// repository moves; a wrong base silently breaks every asset path and nothing errors.
export default defineConfig({
  site: 'https://gitmick.github.io',
  base: '/asif-jam',
  outDir: '../docs',
  vite: { plugins: [tailwindcss()] },
});
