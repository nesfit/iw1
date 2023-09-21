# AutomatedLab

- [Github](https://github.com/AutomatedLab/AutomatedLab)
- [Docs](https://automatedlab.org/en/)

```
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V /NoRestart

Install-PackageProvider Nuget -Force
Install-Module AutomatedLab -SkipPublisherCheck -AllowClobber -Force
```

## First steps

Read Automated Lab [docs](https://automatedlab.org/en/latest/Wiki/Basic/gettingstarted/)

# Docx to MD convert

```bash
➜ pandoc --extract-media ./img -t markdown-simple_tables-multiline_tables-grid_tables  *.docx -o README.md
```
