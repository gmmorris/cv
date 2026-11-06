# CV — Gidi Meir Bravo-Rose

A single-page, responsive web CV that also prints to a 3-page A4 PDF.
No framework, no dependencies, no build tooling beyond Chrome.

| File | What it is |
|------|------------|
| `index.html` | **All the content.** Edit text here. |
| `style.css` | Design: screen (responsive, light/dark) and `@media print` / `@page` for the PDF. |
| `fonts/` | Self-hosted Inter and Source Serif 4 (Latin subsets). |
| `scripts/build.sh` | Copies the site to `_site/` and prints `Gidi-Meir-Bravo-Rose-CV.pdf` with headless Chrome. |
| `.github/workflows/publish.yml` | On push to `master`: builds and pushes `_site/` to the `gh-pages` branch. |

## Editing

Open `index.html` and change the text. The patterns to copy:

- **A role:** an `<article class="entry">` with a `.when` date and a `<ul>` of bullets.
  Lead each bullet with `<strong>Headline.</strong>`; end with
  `<li class="outcome"><b>Impact:</b> …</li>`.
- **Earlier experience:** a one-line `<div class="entry compact">`.
- **Toolset:** a `<div><dt>Group</dt><dd><ul><li>…</li></ul></dd></div>`; the `·`
  separators are added by CSS.

Preview by opening `index.html` in a browser. Use the browser's print preview
(or run the build) to see the PDF pagination.

## Publishing

```sh
./scripts/build.sh   # optional: check _site/ and the PDF locally
git commit -am "Update CV" && git push
```

The GitHub Action rebuilds the site and PDF and publishes them to GitHub Pages
(served from the `gh-pages` branch). The PDF is always generated from the same
HTML, so the two never drift.

## Print layout notes

- ⌘P in the browser uses the same print stylesheet as the generated PDF, so
  they paginate identically: all roles on pages 1–2, toolset/education/open
  source always starting page 3 (`#toolset { break-before: page }`).
- Breaks only fall between bullets, never inside one; role headings stay with
  their first bullet.
- The running header on pages 2+ ("Page N of M") uses `@page` margin boxes
  (Chrome 131+). Page 1 sets those boxes to empty content so Chrome doesn't
  add its own date/title header when "Headers and footers" is ticked.
  Safari and Firefox print the same layout without the running header.
- The layout is tight: page 2 has about 2mm to spare. If an edit pushes
  "Earlier experience" onto page 3, tweak the spacing in the `@media print`
  block of `style.css` (`.entry li` / `.entry` margins, body `line-height`),
  then check with `./scripts/build.sh`.
