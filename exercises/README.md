# IW1 exercises

## How the exercises are run (from September 2026)

- The course is taught in three one-day modules (Fridays 18. 9., 2. 10. and 9. 10. 2026; blocks
  7–13 h and 13–19 h). Module 1 = E01 + E02 (7 points: E01 4, E02 3), module 2 = E03 + E04
  (7 points), module 3 = E05 + E06 (6 points); 20 points in total, they form the
  zápočet.
- There is no lecturer-led part. Every exercise is `Lab 00` (AutomatedLab setup of
  the VMs) followed by `Lab 01`, `Lab 02`, … that students work through on their
  own, following the step-by-step instructions, and ask the lecturer only about
  details. `Bodované úkoly` at the end are graded.
- The introductory theory at the top of each exercise explains the topic; it is
  meant mainly for students who complete the exercise on their own.
- Absence: the exercise can be completed offline (at home, in Hyper-V or another
  hypervisor) and reported by e-mail to pluskal@vut.cz as one PDF: a short
  description of how each task was solved plus screenshots showing the tasks were
  done to a reasonable extent.

## Station contract (C304, rebuilt August 2026)

Everything in `E01`–`E06` assumes the environment below. Check edits against
this section and update it when the room changes.

- 19 seats `h01`–`h19`: Windows 11 Education 25H2 (build 26200), 64 GB RAM,
  AMD Ryzen 5 PRO 5650G (6C/12T), one Realtek 2.5GbE NIC.
- Students work as the local user `root` / `root4lab` (local admin, autologon;
  note the lower-case `l` – the VM accounts use `root4Lab`).
- Drives: `C:` system — **UWF-protected**, but as of 9/2026 every station runs
  the disk overlay in **persistent** mode (`uwfmgr get-config`: *Persistent:
  ON*, *Persistent overlay will be preserved after system restart*), so a
  reboot does **not** roll back C: — `C:\ProgramData\AutomatedLab` metadata,
  Hyper-V VM registrations and scheduled tasks survive it (checked on all 19
  stations on 2026-09-24). Only switching the overlay back to rollback mode
  (or an explicit overlay reset) discards them. `D:` (data-ssd) and `E:`
  (data-nvme) **persist** in any case.
  Because they persist, student artifacts accumulate there (e.g. the WinPE
  ISOs students copy into `D:\LabSources\ISOs` in E02 Lab 02) — sweep them
  between semesters, keeping the `D:\LabSources` payloads and
  `E:\AutomatedLab-VMs\BASE_*.vhdx`.
- Hyper-V enabled; default VM + VHD path `E:\AutomatedLab-VMs`. The
  `BASE_*.vhdx` parent disks there survive resets — never delete them, they
  cut a redeploy from ~40 to ~7 minutes.
- AutomatedLab **5.61.0** (AllUsers), LabSources at `D:\LabSources`.
- `D:\LabSources\ISOs` contains exactly:

  | file | operating systems AutomatedLab detects |
  | --- | --- |
  | `win11.iso` | Windows 11 10.0.26100, multi-edition (Home/Education/**Pro**/…) — labs use `'Windows 11 Pro'`, E05 also `'Windows 11 Education'` |
  | | the ISO is **24H2 (build 26100)**, so every lab VM runs 24H2 while the hosts run 25H2 (26200) |
  | `SERVER_EVAL_x64FRE_en-us.iso` | `'Windows Server 2022 Datacenter Evaluation (Desktop Experience)'` (+ Standard, + Core variants) |
  | `winpe-w10-amd64.iso`, `winpe-w11-amd64.iso` | plain ADK WinPE amd64, no add-ons |

- `D:\LabSources\SoftwarePackages\IW1\E06\utils` should hold a copy of
  `exercises/E06/utils` (Crash.exe, alloc_memory.ps1, simulate_workload.vbs,
  send_nefs_mail.vbs, fsaTemplate.xml); E06 Lab 00 falls back to downloading
  them from GitHub `main` when the folder is missing. E01 Lab 06 downloads
  `HardwareReadiness.ps1` into the VM if it is not in SoftwarePackages.

- vSwitches: ONLY the built-in **Default Switch** (NAT — gives VMs DHCP and
  internet). There is **no 'External' switch and none must be created**: it
  would rebind the station's only physical NIC. The labs create the internal
  **Private1** (`192.168.0.0/24`) switch themselves.

## Lab definition conventions

Every exercise carries the same canonical AutomatedLab block; keep the shared
part identical and the per-exercise delta minimal:

- a cleanup prologue makes the script **re-runnable from scratch at any
  time** — whether the previous run's VMs are still registered or were
  dropped by a UWF rollback (removes this lab's VMs,
  orphaned VM folders on E: and stale metadata; keeps `BASE_*.vhdx`),
- `New-LabDefinition -Name <exercise id> … -VmPath 'E:\AutomatedLab-VMs'`,
  `Set-LabInstallationCredential -Username root -Password root4Lab`
  (all VM accounts and the `testing.local` domain use root / root4Lab),
- defaults `'Windows 11 Pro'`, 8 GB RAM, 4 vCPU per machine — at most 3 VMs
  concurrently (host budget ≤ 32 GB RAM and ≤ 12 vCPU for VMs); every machine is
  **Generation 2 with Secure Boot (Microsoft Windows template) and a vTPM**, set
  once in `$PSDefaultParameterValues` (`VmGeneration = 2`,
  `HypervProperties = @{ EnableTpm = 'true'; EnableSecureBoot = 'on'; SecureBootTemplate = 'MicrosoftWindows' }`)
  so the VMs meet the Windows 11 hardware requirements (BitLocker, Setup checks),
  Consequence: Windows 11 24H2 turns on **device encryption** of the OS volume
  during its unattended install (BitLocker, clear key, no protector). It blocks
  `Sysprep /generalize` (0x80310039), so E02 decrypts C: on W11-SOURCE in Lab 00;
  other exercises can use the encrypted state as teaching material (`manage-bde -status`),
- adapters: `LAN0` → 'Default Switch' (DHCP), `LAN1` → Private1 with fixed
  addressing — clients `.10`/`.11`/`.12`, DC `.20`, domain client `.21`; LAN1
  never gets a default gateway (there is no router in the lab network). In E03
  the script leaves LAN1 on W11-2/W11-3 unconfigured after installation so the
  students assign `.11`/`.12` themselves in Lab 01.
  **Exception:** in the domain labs (E05, E06) every machine has only the
  Private1 adapter (no internet) — AutomatedLab 5.61 crashes in
  `Wait-LWHypervVMRestart` ('Cannot index into a null array') when machines
  with more than one adapter wait behind a RootDC installation; a one-line
  fix in `AutomatedLabWorker.psm1` would lift this (in
  `Wait-LWHypervVMRestart`, under the multi-NIC check, delay the inspected
  machine first — `$delayedStart += $StartMachinesWhileWaiting[0]` — and
  only then filter it out of the list, keeping the result an array),
- AutomatedLab deploys every VM with **UAC disabled, Windows Firewall off in all
  profiles and Remote Desktop enabled without NLA** (unattend + Initialization
  script). E03 restores the Windows defaults after installation (firewall on,
  RD off, NLA on); E03, E04 and E05 re-enable UAC at the end of their script,
  and E02 additionally removes AutomatedLab's autologon (plaintext `Winlogon\DefaultPassword`)
  and re-enables UAC on W11-SOURCE before the Lab00 checkpoint – without it the image
  captured in E02 hangs in OOBE ("Just a moment") after deployment,
- teardown between exercises: `Import-Lab -Name <id> -NoValidation;
  Remove-Lab` — in a fresh session AutomatedLab 5.61 prints red
  `Get-LabMachineDefinition`/`AddRange` errors while doing so; they are
  harmless (VMs and switches are removed). With the persistent UWF overlay a
  reboot removes nothing; the next lab script's cleanup prologue removes its
  own leftovers, but VMs of other exercises stay registered until their
  teardown.

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
