# CV — Gidi Meir Bravo-Rose

A single-page, responsive web CV that also prints to a 3-page A4 PDF.
Live at **https://gmmorris.github.io/cv/**.

No framework, no dependencies: plain HTML and CSS, plus headless Chrome to
make the PDF.

| File | What it is |
|------|------------|
| `index.html` | **All the content.** This is the file you edit. |
| `style.css` | Design: screen (responsive, light/dark), and `@media print` / `@page` for the PDF. |
| `fonts/` | Self-hosted Inter and Source Serif 4 (Latin subsets). |
| `scripts/build.sh` | Copies the site to `_site/` and prints `Gidi-Meir-Bravo-Rose-CV.pdf` from it with headless Chrome. |
| `.github/workflows/publish.yml` | On every push to `master`: runs the build and publishes `_site/` to the `gh-pages` branch. |

## Deploying changes

**Pushing to `master` deploys.** There's no separate deploy command. The
GitHub Action rebuilds the site and the PDF from `index.html`, then GitHub
Pages serves the result, usually within a minute.

### 1. Make the change

Edit `index.html`. The patterns to copy:

- **A role:** an `<article class="entry">` with a `.when` date and a `<ul>`
  of bullets. Start each bullet with `<strong>Headline.</strong>` and end the
  list with `<li class="outcome"><b>Impact:</b> …</li>`.
- **Earlier experience:** a one-line `<div class="entry compact">`.
- **Toolset:** `<div><dt>Group</dt><dd><ul><li>…</li></ul></dd></div>`. CSS
  adds the `·` separators in print and the chips on screen.
- **Links to essays:** any `https://gidi.io/…` link gets the ↗ marker and
  hover hint automatically.

If you've changed the CV in the Claude Design canvas instead, export it to
PDF and ask Claude to "update the CV site from this PDF". It diffs the
export against the site and applies only what changed.

### 2. Check it locally

```sh
./scripts/build.sh
python3 -m http.server 8000 --directory _site
```

Then open http://127.0.0.1:8000/ and check:

- **Desktop and mobile:** use DevTools device mode (⌘⌥I, then ⇧⌘M) at about 390px.
- **Print:** ⌘P should show **3 pages**: all roles on pages 1–2, and the
  toolset starting page 3.
- **The PDF:** `open _site/Gidi-Meir-Bravo-Rose-CV.pdf` shows what the
  Download PDF button will serve.

### 3. Publish

```sh
git add -A
git commit -m "Update CV: <what changed>"
git push origin master
```

### 4. Confirm it's live

- **Action:** the run appears under the repo's **Actions** tab. It takes
  about 30 seconds.
- **Site:** refresh https://gmmorris.github.io/cv/. The CDN can hold the old
  page for a minute or two, so a hard refresh (⇧⌘R) helps.

### Troubleshooting

| Symptom | Fix |
|---------|-----|
| The PDF has 4 pages, or "Earlier experience" spills onto page 3 | The print layout is tight (page 2 has about 2mm spare). Shorten the text, or tighten the spacing in the `@media print` block of `style.css` (`.entry li` / `.entry` margins, body `line-height`), then rebuild. |
| The Action fails at "Push to gh-pages" | Repo **Settings → Actions → General → Workflow permissions** must be "Read and write". |
| The PDF link 404s right after a deploy | The CDN cached an earlier 404. Wait a few minutes. |
| `build.sh` says Chrome wasn't found | Install Chrome, or set `CHROME=/path/to/chrome`. |

## Where the PDF lives

The PDF isn't committed to `master`. It's generated on every deploy and
committed to the **`gh-pages`** branch with the rest of the published site.
That way it's always built from the current `index.html` and can never go
stale. Every published version is in `gh-pages`' history.

## Print layout notes

- ⌘P in the browser uses the same print stylesheet as the generated PDF, so
  both have the same page breaks. Breaks only fall between bullets, role
  headings stay with their first bullet, and the toolset always starts a new
  page (`#toolset { break-before: page }`).
- The running header on pages 2+ ("Page N of M") uses `@page` margin boxes,
  which need Chrome 131 or later. Page 1 sets those boxes to empty content, so
  Chrome doesn't add its own date/title header when "Headers and footers" is
  ticked. Safari and Firefox print the same layout without the running header.
- Everything in the "Screen-only enhancements" section of `style.css` (the
  timeline, chips and essay markers) never prints.
