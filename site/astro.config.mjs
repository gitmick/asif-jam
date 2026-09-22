import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

// site/base are set for GitHub Pages under gitmick/asif-jam. Change both together if the
// repository moves; a wrong base silently breaks every asset path and nothing errors.
export default defineConfig({
  site: 'https://gitmick.github.io',
  base: '/asif-jam',
  outDir: '../docs',
  // /murder was the published address of the murder write-up before the examples section
  // existed. Links to it are out there, so it still resolves.
  // The target needs the base spelled out: Astro prefixes the page it generates but not the
  // location it redirects to, and a bare /examples/murder lands outside the site entirely.
  redirects: { '/murder': '/asif-jam/examples/murder' },
  vite: { plugins: [tailwindcss()] },
});
