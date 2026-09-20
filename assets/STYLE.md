# Profile visual system

The profile uses the **Quiet Investor's Desk** visual direction: editorial research surfaces, ink and paper neutrals, restrained gold and sage accents, and dusty plum borrowed from the silver-haired avatar. The character layer adds warmth without displacing the investment thesis.

## Rules

- Use SVG as the source of truth for brand and decorative assets.
- Keep critical facts, project descriptions, and links in Markdown rather than inside images.
- Keep each desktop dark/light pair and each mobile dark/light pair geometrically identical; only colors and surface tones change.
- Do not use unreviewed generated faces, hands, logos, or small text in profile assets.
- The supplied `avatar.png` is the canonical profile identity asset, but the README does not repeat it because GitHub already displays the account avatar.
- Use `chibi-focus.png` as the research-desk pause in the main narrative; keep `chibi-cozy.png` and `chibi-rest.png` together near the end as an after-hours coda.
- Keep the character layer and research layer distinct: character art carries mood, while SVG surfaces carry sources, thesis, judgment, and compounding motifs.
- Avoid speculative trading imagery, neon cyberpunk palettes, candlestick dashboards, and finance-ad visual language.
- Prefer a small number of reusable shapes over a new illustration for every project.
- Use the mobile hero below 640 px; remove microcopy rather than shrinking desktop details until they are unreadable.

## Tokens

| Role | Dark | Light |
| --- | --- | --- |
| Paper / surface | `#111417` | `#f8f5ee` |
| Ink / text | `#f0ece5` | `#26231f` |
| Muted text | `#aaa198` | `#706960` |
| Compounding gold | `#d1a84f` | `#916300` |
| Research sage | `#78aa91` | `#3e705e` |
| Avatar plum | `#c18ca5` | `#855a70` |

## Validation

Run `bash scripts/check-profile.sh` before committing. The check validates local references, SVG XML, rendered SVG output, stale asset references, and the profile asset size budget.
