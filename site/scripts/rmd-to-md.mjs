// The murder example's write-up lives in examples/murder/analysis.Rmd, because that is the file a
// participant opens in RStudio and runs chunk by chunk. The site shows the same document.
//
// An .Rmd is markdown already — the only difference is the chunk header, ```{r name, opts}, which
// no markdown renderer knows. So this rewrites those to plain ```r and drops the YAML block, and
// Astro renders the result like any other page. One source of truth: edit the .Rmd.
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname } from 'node:path';

const src = '../examples/murder/analysis.Rmd';
const dst = 'src/content/murder.md';

let t = readFileSync(src, 'utf8');
t = t.replace(/^---\n[\s\S]*?\n---\n/, '');          // the YAML header; the page supplies its own title
t = t.replace(/^```\{r[^}]*\}/gm, '```r');            // ```{r chunk-name, echo=FALSE} -> ```r
mkdirSync(dirname(dst), { recursive: true });
writeFileSync(dst, t);
console.log(`rmd-to-md: ${src} -> ${dst} (${t.split('```r').length - 1} chunks)`);
