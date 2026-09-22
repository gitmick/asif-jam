// Two documents on this site are not written for the site: they are files a participant opens
// and runs. The site shows the same bytes rather than a retelling, so a page cannot drift from
// the thing it describes. This script is the whole of that arrangement.
//
//   examples/murder/analysis.Rmd          -> src/content/murder.md
//   examples/trees-and-culture/out/poster.md -> src/content/poster.md
//
// The murder write-up is an .Rmd, which is markdown apart from the chunk header ```{r …} that
// no markdown renderer knows, so those become plain ```r and the YAML block goes.
//
// The poster is already markdown — 07-poster.R writes it out of the chain's own result files —
// and needs only its image links repointed from out/ to where the site serves those exact bytes.
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname } from 'node:path';

const write = (dst, text) => { mkdirSync(dirname(dst), { recursive: true }); writeFileSync(dst, text); };

let rmd = readFileSync('../examples/murder/analysis.Rmd', 'utf8')
  .replace(/^---\n[\s\S]*?\n---\n/, '')      // the YAML header; the page supplies its own title
  .replace(/^```\{r[^}]*\}/gm, '```r');      // ```{r chunk-name, echo=FALSE} -> ```r
write('src/content/murder.md', rmd);
console.log(`murder: ${rmd.split('```r').length - 1} chunks`);

// /kton/files holds one copy of every file in the chain, at the bytes the fotons recorded, so
// the lens can fetch a figure back off this page and re-hash it.
let poster = readFileSync('../examples/trees-and-culture/out/poster.md', 'utf8')
  .replace(/\]\(out\//g, '](/asif-jam/kton/files/');
write('src/content/poster.md', poster);
console.log(`poster: ${poster.length} characters, images at /asif-jam/kton/files/`);
