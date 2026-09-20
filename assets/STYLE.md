# Profile visual system

The profile uses the **Quiet Compounding** visual direction: editorial research surfaces, ink and paper neutrals, restrained gold and green accents, and a small silver-haired character layer that adds warmth without displacing the investment thesis.

## Rules

- Use SVG as the source of truth for brand and decorative assets.
- Keep critical facts, project descriptions, and links in Markdown rather than inside images.
- Keep dark and light variants geometrically identical; only colors and surface tones change.
- Do not use unreviewed generated faces, hands, logos, or small text in profile assets.
- The supplied `avatar.png` is the canonical profile identity asset, but the README does not repeat it because GitHub already displays the account avatar.
- The supplied `chibi-*.png` images are approved storytelling assets; keep them together near the end as an after-hours coda.
- Keep the character layer and research layer distinct: character art carries mood, while SVG surfaces carry sources, thesis, judgment, and compounding motifs.
- Avoid speculative trading imagery, neon cyberpunk palettes, candlestick dashboards, and finance-ad visual language.
- Prefer a small number of reusable shapes over a new illustration for every project.

## Tokens

| Role | Dark | Light |
| --- | --- | --- |
| Surface | `#0d1117` | `#fbfaf6` |
| Text | `#f1f3f5` | `#25241f` |
| Muted text | `#a0a8b0` | `#665f55` |
| Compounding gold | `#d6a84b` | `#9a6200` |
| Research green | `#6fb69a` | `#2f7d63` |
| Risk burgundy | `#c98288` | `#8c3f4d` |
| Data blue | `#8fb8d8` | `#3f6f92` |

## Validation

Run `bash scripts/check-profile.sh` before committing. The check validates local references, SVG XML, rendered SVG output, stale asset references, and the profile asset size budget.
