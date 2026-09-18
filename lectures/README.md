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
| L03 | Správa a nasazení bitových kopií systému, ovladačů, balíčků, Autopilot                           | ✔    |
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
- Every deck was brought to the 2026 state of Windows 11 24H2/25H2 in September
  2026. New facts carry a `Zdroj: <url>` line in the speaker note of the slide.
  The per-deck change logs (`Lxx/UPDATE-2026.md`) are the teacher's working
  notes and are git-ignored.
- Screenshots from Windows 7/8/10 are still in the decks. Each deck has one
  `<!-- TODO-SCREENSHOT: ... -->` comment after the front matter listing the
  slides whose screenshots should be retaken on a C304 station (Windows 11
  Education 25H2).
- The old `.pptx` sources live in `.tmp/` (git-ignored) until every deck is
  converted; use `nix run .#pptx-dump` to pull their text, links and images.

## Emphasis: what is bold, italic and code

The lecturer reads the slide in a glance while talking. Every mark has one
meaning, so the eye can jump from anchor to anchor without reading the prose.

- **Bold** (`**…**`, rendered blue) is the *anchor* of a bullet: the term,
  feature, tool or the one number/date the bullet is about.
  - Every top-level bullet on a content slide has one anchor, as close to the
    start of the bullet as the sentence allows (`- **Stínové kopie** – …`).
  - Two or more anchors in one bullet only when the bullet enumerates named
    items (`**Home**, **Pro**, **Enterprise**`) or contrasts two things.
  - Sub-bullets get an anchor only when they introduce a term of their own
    (a list of modes, editions, steps); explanatory sub-bullets stay plain.
    Third-level bullets never carry bold.
  - In a sequence of steps, the anchor is the word that distinguishes the
    step (the actor or the action).
  - Bold the term, never the sentence: at most ~4 words, no verbs or filler
    (`je`, `lze`, `vyžaduje`), no whole bullets. A number is the anchor only
    when the number is the point (`max. **64** stínových kopií na svazek`).
  - Bold does not mean "warning". Use `<span class="warn">…</span>` or the
    word `pozor` for that.
- *Italic* (`*…*`) marks names read out as they appear on screen, untranslated:
  the English original after a Czech term (`Stínová kopie svazku (*Volume
  Shadow Copy Service*, VSS)`), UI labels and the last item of a menu path
  (`Nastavení > Windows Update > *Vyhledat aktualizace*`), Group Policy
  setting names (*Configure Automatic Updates*), wizard and dialog titles,
  book titles, and status words quoted as-is (*deprecated*, *enablement
  package*). Italic is never used for emphasis.
- `code` is anything typed or a technical identifier: commands, cmdlets,
  parameters, file and registry paths, service names (`wuauserv`), ports,
  XML elements, environment variables.
- Nothing else: no bold+italic, no underline, no CAPS or emoji for emphasis.
  Headings carry no bold; in tables only the cell that is the point of the
  comparison is bold. Speaker notes (HTML comments) are plain text.
- The text of a bullet may be tightened so the anchor comes first (`Je
  určen pro` → `Určen pro`; `Každý svazek může obsahovat maximálně 64
  stínových kopií` → `Max. **64 stínových kopií** na svazek`), but the
  meaning, facts and order of bullets stay the same and nothing is dropped.
