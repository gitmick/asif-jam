# Signing identities

Two Ed25519 keypairs sign the lineage under `site/public/kton/data/`. Only the **public** halves
are here; `.gitignore` keeps the private ones out, because anyone who can read one can sign as it.

| | keyid | signs |
|---|---|---|
| `asif-jam` | `168df9923571f725` | the seven fotons of `examples/trees-and-culture` — what each step read, wrote, and ran |
| `asif-jam-review` | `661531a51d0c6a2b` | the claim attached to that poster's bytes, saying the conclusion does not survive validation |

They are deliberately two identities and not one. A foton says *this computation happened*; a
claim says *someone thinks this about it*. Collapsing them into a single signer would lose the
distinction the whole jam is about — that a result can be perfectly reproducible and still wrong,
and that those are two different records signed by two different people.

The public halves are what `bin/build-lineage` writes into `keys.json` beside the union, and they
are what a reader's browser verifies the signatures against. Without the private halves you can
verify everything here and sign nothing, which is the correct amount of authority for a clone.
