# IW1 lectures

The lecture decks are plain Markdown rendered with [Marp](https://marp.app/).
One directory per lecture, images next to the deck:

```
lectures/
  themes/iw1.css      shared theme (header, footer, "n / total", title/section slides)
  L00/L00.md          deck
  L00/img/            pictures referenced from the deck (relative paths)
```

| ID  | Téma                                                                                                | Stav |
| --- | --------------------------------------------------------------------------------------------------- | ---- |
| L00 | Úvod                                                                                                | ✔    |
| L01 | Instalace, Update, Migrace                                                                          | ✔    |
| L02 | Vytváření bitových kopií systému, konfigurační průchody, virtuální disky                            | ✔    |
| L03 | Správa a nasazení bitových kopií systému, ovladačů, balíčků, MDT                                    | ✔    |
| L04 | Nastavení sítě, IPv4, IPv6, směrování, nástroje pro správu, bezdrátové sítě, tiskárny               | ✔    |
| L05 | Windows Firewall, vzdálená plocha/správa                                                            | ✔    |
| L06 | Sdílení a zabezpečení prostředků, soubory offline, NTFS, EFS, BitLocker                             | ✔    |
| L07 | Řízení uživatelských účtů (UAC)                                                                     | ✔    |
| L08 | Správa zařízení, disků, ovladačů a napájení                                                         | ✔    |
| L09 | Monitorování a výkon, centrum akcí, správce úloh, služby, event viewer, perfmon                     | ✔    |
| L10 | Zálohování a obnova dat, stínové kopie, předchozí verze, bitová kopie, Windows Recovery Environment | ✔    |
| L11 | Kompatibilita aplikací, virtualizace pomocí Hyper-V, VPN, NAP, RD Gateway                           | ✔    |
| L12 | Windows Update, WSUS                                                                                | ✔    |

## Working on the slides

```bash
nix develop                 # marp-cli, python-pptx, chromium (Linux), nil, nixfmt
nix run .#preview           # live preview of lectures/ at http://localhost:8080
nix build .#lectures        # result/Lxx/Lxx.html for every deck
nix build .#lectures-pdf    # result/Lxx/Lxx.pdf (Linux; headless chromium)
nix run .#pdf               # build/Lxx/Lxx.pdf with a local browser (any OS)
nix run .#pptx-dump -- .tmp/iw1-lecture-01.pptx --images lectures/L01/img
```

VS Code: install the *Marp for VS Code* extension and set
`"markdown.marp.themes": ["./lectures/themes/iw1.css"]` in the workspace
settings; the preview then matches the CLI output.

## Deck conventions

- Front matter of every deck:

  ```yaml
  ---
  marp: true
  theme: iw1
  paginate: true
  title: IW1 – Lxx Název
  header: 'Desktop systémy Microsoft Windows <span>Název přednášky</span>'
  footer: 'Jan Fiedor, Peter Solár, Jan Pluskal'
  ---
  ```

- `---` separates slides. First slide `<!-- _class: title -->` +
  `<!-- _header: '' -->`, chapter dividers `<!-- _class: section -->`.
- One `# Heading` per slide; bullets nest with two spaces. Long bullets may be
  wrapped in the source (soft breaks are ignored); use `\` at the end of a
  line for a real line break (addresses, signatures).
- Two columns: `<div class="cols">` with two blocks inside (text left, image right is
  the usual pairing).
- A slide that overflows gets `<!-- _class: dense -->` (smaller font) before
  it is split in two; never drop content to make it fit. Centre an image
  with `![center](img/foo.png)`, size it with `![w:600](img/foo.png)`.
- Speaker notes are ordinary HTML comments (`<!-- ... -->`); `nix run .#pdf`
  exports them with `--pdf-notes`.
- Content that needs a decision before the next run is marked
  `<!-- REVIEW: ... -->` right above the affected slide text. Search for
  `REVIEW:` before the semester starts.
- The old `.pptx` sources live in `.tmp/` (git-ignored) until every deck is
  converted; use `nix run .#pptx-dump` to pull their text, links and images.
