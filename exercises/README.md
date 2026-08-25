# IW1 exercises

## Station contract (C304, rebuilt August 2026)

Everything in `E01`–`E06` assumes the environment below. Check edits against
this section and update it when the room changes.

- 19 seats `h01`–`h19`: Windows 11 Education 25H2 (build 26200), 64 GB RAM,
  AMD Ryzen 5 PRO 5650G (6C/12T), one Realtek 2.5GbE NIC.
- Students work as the local user `root` / `root4lab` (local admin, autologon).
- Drives: `C:` system — **UWF-protected** (a reboot rolls back everything on
  C:, including `C:\ProgramData\AutomatedLab` metadata and Hyper-V VM
  registrations); `D:` (data-ssd) and `E:` (data-nvme) **persist**.
- Hyper-V enabled; default VM + VHD path `E:\AutomatedLab-VMs`. The
  `BASE_*.vhdx` parent disks there survive resets — never delete them, they
  cut a redeploy from ~40 to ~7 minutes.
- AutomatedLab **5.61.0** (AllUsers), LabSources at `D:\LabSources`.
- `D:\LabSources\ISOs` contains exactly:

  | file | operating systems AutomatedLab detects |
  | --- | --- |
  | `win11.iso` | Windows 11 10.0.26100, multi-edition (Home/Education/**Pro**/…) — labs use `'Windows 11 Pro'`, E05 also `'Windows 11 Education'` |
  | `SERVER_EVAL_x64FRE_en-us.iso` | `'Windows Server 2022 Datacenter Evaluation (Desktop Experience)'` (+ Standard, + Core variants) |
  | `winpe-w10-amd64.iso`, `winpe-w11-amd64.iso` | plain ADK WinPE amd64, no add-ons |

- vSwitches: ONLY the built-in **Default Switch** (NAT — gives VMs DHCP and
  internet). There is **no 'External' switch and none must be created**: it
  would rebind the station's only physical NIC. The labs create the internal
  **Private1** (`192.168.0.0/24`) switch themselves.

## Lab definition conventions

Every exercise carries the same canonical AutomatedLab block; keep the shared
part identical and the per-exercise delta minimal:

- a cleanup prologue makes the script **re-runnable from scratch at any
  time** — including right after a UWF reset (removes this lab's VMs,
  orphaned VM folders on E: and stale metadata; keeps `BASE_*.vhdx`),
- `New-LabDefinition -Name <exercise id> … -VmPath 'E:\AutomatedLab-VMs'`,
  `Set-LabInstallationCredential -Username root -Password root4Lab`
  (all VM accounts and the `testing.local` domain use root / root4Lab),
- defaults `'Windows 11 Pro'`, 8 GB RAM, 4 vCPU per machine — at most 3 VMs
  concurrently (host budget ≤ 32 GB RAM and ≤ 12 vCPU for VMs),
- adapters: `LAN0` → 'Default Switch' (DHCP), `LAN1` → Private1 with fixed
  addressing — clients `.10`/`.11`/`.12`, DC `.20`, domain client `.21`,
- AutomatedLab **disables UAC** inside lab VMs; exercises that depend on UAC
  (E03, E05) re-enable it at the end of their script,
- teardown between exercises: `Import-Lab -Name <id> -NoValidation;
  Remove-Lab` — in a fresh session AutomatedLab 5.61 prints red
  `Get-LabMachineDefinition`/`AddRange` errors while doing so; they are
  harmless (VMs and switches are removed). A reboot works too: UWF resets C:
  and the next lab script cleans up the leftovers on E:.

Known cosmetic issue: the stations have Pester 6.x installed, which is
incompatible with AutomatedLab's post-deployment tests — `Install-Lab` ends
with red *“Lab deployment seems to have failed. The following tests were not
passed:”* + Dynamics test discovery errors even when everything deployed
fine. Judge the deployment by `Get-LabVM` / `Show-LabDeploymentSummary`, or
install Pester 5.7.x instead.

# AutomatedLab

- [Github](https://github.com/AutomatedLab/AutomatedLab)
- [Docs](https://automatedlab.org/en/)

How the stations were provisioned (already done on h01–h19):

```
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V /NoRestart

Install-PackageProvider Nuget -Force
Install-Module AutomatedLab -RequiredVersion 5.61.0 -Scope AllUsers -SkipPublisherCheck -AllowClobber -Force
```

## First steps

Read the AutomatedLab [getting started](https://automatedlab.org/en/latest/Wiki/Basic/gettingstarted/) guide.

# Docx to MD convert

Historical note — the exercises were converted from DOCX with:

```bash
➜ pandoc --extract-media ./img -t markdown-simple_tables-multiline_tables-grid_tables  *.docx -o README.md
```
