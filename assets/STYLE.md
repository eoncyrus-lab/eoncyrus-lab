# Profile visual system

The profile uses the **Quiet Signal** visual direction: restrained technical surfaces, a small functional color system, and text-first project descriptions.

## Rules

- Use SVG as the source of truth for brand and decorative assets.
- Keep critical facts, project descriptions, and links in Markdown rather than inside images.
- Keep dark and light variants geometrically identical; only colors and surface tones change.
- Do not use unreviewed generated faces, hands, logos, or small text in profile assets.
- The supplied `avatar.png` and `chibi-*.png` images are approved profile identity/storytelling assets; do not regenerate or edit them automatically.
- Prefer a small number of reusable shapes over a new illustration for every project.

## Tokens

| Role | Dark | Light |
| --- | --- | --- |
| Surface | `#090d12` | `#f8fafc` |
| Text | `#f0f6fc` | `#1f2328` |
| Muted text | `#8b949e` | `#57606a` |
| Signal blue | `#79c0ff` | `#0969da` |
| System teal | `#56d4c8` | `#0f9d91` |
| Decision violet | `#d2a8ff` | `#8250df` |
| Warning amber | `#ffa657` | `#bc4c00` |

## Validation

Run `bash scripts/check-profile.sh` before committing. The check validates local references, SVG XML, rendered SVG output, stale asset references, and the profile asset size budget.
