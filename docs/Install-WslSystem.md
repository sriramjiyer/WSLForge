# Install-WslSystem

## SYNOPSIS

Install WSL system features.

## SYNTAX

### __AllParameterSets

```text
Install-WslSystem [-PreRelease] [-EnableWsl1] [<CommonParameters>]
```

## ALIASES

There are no aliases for this cmdlet.

## DESCRIPTION

Installs only WSL system features.
It uses web download from Microsoft store.
It does not install any distros.
Use New-WslDistro to install distros available in Microsoft store.
To install a customized Ubuntu distro use New-WslCloudInitUserData and New-WslCustomDistro.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > Install-WslSystem
```

## PARAMETERS

### -EnableWsl1

Enable WSL1 in addition to WSL2.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PreRelease

Allow install of PreRelease version.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

- [WSLForge](WSLForge.md)
