# IW1
Lectures and computer labs storage for [IW1](https://www.fit.vut.cz/study/course/294184) course at FIT VUT.


| ID      | Datum  | Téma                                                                                                    |
| ------- | ------ | ------------------------------------------------------------------------------------------------------- |
| **L00** | 18.09. | **Úvod**                                                                                                |
| **L01** | 18.09. | **Instalace, Update, Migrace**                                                                          |
| E01     | 18.09. | Instalace, Update, Migrace                                                                              |
| **L02** | 18.09. | **Vytváření bitových kopií systému, konfigurační průchody, virtuální disky**                            |
| **L03** | 18.09. | **Správa a nasazení bitových kopií systému, ovladačů, balíčků, Autopilot**                            |
| E02     | 18.09. | Vytváření, správa a nasazení bitových kopií systému, konfigurační průchody, virtuální disky             |
| **L04** | 02.10. | **Nastavení sítě, IPv4, IPv6, směrování, nástroje pro správu, bezdrátové sítě, tiskárny**               |
| **L05** | 02.10. | **Windows Firewall, vzdálená plocha/správa**                                                            |
| E03     | 02.10. | Síťování ve Windows, Windows Firewall, IP adresace, vzdálená správa                                     |
| **L06** | 02.10. | **Sdílení a zabezpečení prostředků, soubory offline, NTFS, EFS, BitLocker**                             |
| E04     | 02.10. | Sdílení a zabezpečení prostředků, soubory offline, NTFS, EFS                                            |
| **L07** | 02.10. | **Řízení uživatelských účtů (UAC)**                                                                     |
| E05     | 09.10. | Řízení uživatelských účtů (UAC)                                                                         |
| **L08** | 09.10. | **Správa zařízení, disků, ovladačů a napájení**                                                         |
| **L09** | 09.10. | **Monitorování a výkon, centrum akcí, správce úloh, služby, event viewer, perfmon**                     |
| E06     | 09.10. | Monitorování a výkon, centrum akcí, správce úloh, služby, event viewer, perfmon                         |
| **L10** | 09.10. | **Zálohování a obnova dat, stínové kopie, předchozí verze, bitová kopie, Windows Recovery Environment** |
| **L11** | 09.10. | **Kompatibilita aplikací, virtualizace pomocí Hyper-V, VPN, NAP, RD Gateway**                           |
| **L12** | 09.10. | **Windows Update, WSUS**                                                                                |

## Repository layout

- [lectures/](lectures/) – lecture decks as Marp Markdown, one directory per
  lecture, shared theme in `lectures/themes/`. See
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
