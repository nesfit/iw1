# IW1
Lectures and computer labs storage for [IW1](https://www.fit.vut.cz/study/course/IW1/) course at FIT VUT.

The lecture decks are published at <https://nesfit.github.io/iw1/> (built from
`main` by [GitHub Actions](.github/workflows/pages.yml)); click a lecture in the
table to open it, no local build needed.


| ID      | Datum  | Téma                                                                                                    |
| ------- | ------ | ------------------------------------------------------------------------------------------------------- |
| **L00** | 18.09. | **[Úvod](https://nesfit.github.io/iw1/L00/L00.html)** |
| **L01** | 18.09. | **[Instalace, Update, Migrace](https://nesfit.github.io/iw1/L01/L01.html)** |
| E01     | 18.09. | Instalace, Update, Migrace                                                                              |
| **L02** | 18.09. | **[Vytváření bitových kopií systému, konfigurační průchody, virtuální disky](https://nesfit.github.io/iw1/L02/L02.html)** |
| **L03** | 02.10. | **[Správa a nasazení bitových kopií systému, ovladačů, balíčků, Windows Autopilot a Intune](https://nesfit.github.io/iw1/L03/L03.html)** |
| E02     | 02.10. | Bitové kopie systému – Windows ADK, Windows PE, úprava WIM pomocí DISM, Sysprep a nasazení obrazu       |
| **L04** | 02.10. | **[Nastavení sítě, IPv4, IPv6, směrování, nástroje pro správu, bezdrátové sítě, tiskárny](https://nesfit.github.io/iw1/L04/L04.html)** |
| **L05** | 02.10. | **[Windows Firewall, vzdálená plocha/správa](https://nesfit.github.io/iw1/L05/L05.html)** |
| E03     | 02.10. | Síťování ve Windows, Windows Firewall, IP adresace, vzdálená správa                                     |
| **L06** | 02.10. | **[Sdílení a zabezpečení prostředků, soubory offline, NTFS, EFS, BitLocker](https://nesfit.github.io/iw1/L06/L06.html)** |
| E04     | 02.10. | Sdílení a zabezpečení prostředků, soubory offline, NTFS, EFS                                            |
| **L07** | 09.10. | **[Řízení uživatelských účtů (UAC)](https://nesfit.github.io/iw1/L07/L07.html)** |
| E05     | 09.10. | UAC, zásady omezení softwaru a AppLocker; správa disků – dynamické disky, RAID svazky, Storage Spaces   |
| **L08** | 09.10. | **[Správa zařízení, disků, ovladačů a napájení](https://nesfit.github.io/iw1/L08/L08.html)** |
| **L09** | 09.10. | **[Monitorování a výkon – Zabezpečení Windows, Správce úloh, služby, Prohlížeč událostí, Sledování výkonu](https://nesfit.github.io/iw1/L09/L09.html)** |
| E06     | 09.10. | Sledování výkonu, Prohlížeč událostí a přeposílání událostí, Historie souborů, zálohování, hlášení chyb  |
| **L10** | 09.10. | **[Zálohování a obnova dat, stínové kopie, předchozí verze, bitová kopie, Windows Recovery Environment](https://nesfit.github.io/iw1/L10/L10.html)** |
| **L11** | 09.10. | **[Kompatibilita aplikací, virtualizace pomocí Hyper-V, VPN](https://nesfit.github.io/iw1/L11/L11.html)** |
| **L12** | 09.10. | **[Windows Update, WSUS a Windows Autopatch, Microsoft Edge](https://nesfit.github.io/iw1/L12/L12.html)** |

## Repository layout

- [lectures/](lectures/) – lecture decks as Marp Markdown, one directory per
  lecture, shared theme in `lectures/themes/`. Published to
  <https://nesfit.github.io/iw1/> on every push to `main`. See
  [lectures/README.md](lectures/README.md) for how to preview and export.
- [exercises/](exercises/) – computer labs E01–E06 with the C304 station
  contract in [exercises/README.md](exercises/README.md).

## Develop

The repository is a Nix flake ([FLAKE_STYLE.md](FLAKE_STYLE.md)):

```bash
nix develop               # marp-cli, python-pptx, chromium, nil, nixfmt
nix run .#preview         # live preview of the lectures
nix build .#lectures      # HTML export of every deck into ./result
nix run .#pdf             # PDF export into ./build
nix fmt && nix flake check
```

With direnv installed, `direnv allow` loads the shell automatically.
