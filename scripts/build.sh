#!/usr/bin/env bash
# Builds the publishable site into _site/: the static files plus a PDF
# printed from index.html with headless Chrome, so web and PDF never drift.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
out="$root/_site"
pdf="Gidi-Meir-Bravo-Rose-CV.pdf"

find_chrome() {
	for candidate in "${CHROME:-}" google-chrome google-chrome-stable chromium chromium-browser \
		"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"; do
		if [ -n "$candidate" ] && command -v "$candidate" >/dev/null 2>&1; then
			echo "$candidate"
			return
		fi
	done
	echo "Chrome not found. Set CHROME=/path/to/chrome" >&2
	exit 1
}

rm -rf "$out"
mkdir -p "$out"
cp -R "$root/index.html" "$root/style.css" "$root/favicon.svg" "$root/fonts" "$out/"

"$(find_chrome)" --headless --disable-gpu --no-sandbox \
	--no-pdf-header-footer --virtual-time-budget=10000 \
	--print-to-pdf="$out/$pdf" "file://$out/index.html" 2>/dev/null

echo "Built $out (with $pdf)"
