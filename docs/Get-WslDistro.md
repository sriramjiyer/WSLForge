# Get-WslDistro

## SYNOPSIS

Gets installed WSL distro details.

## SYNTAX

### __AllParameterSets

```text
Get-WslDistro [[-Name] <string>] [-Detail] [-State <string[]>] [<CommonParameters>]
```

## ALIASES

Get-WslInstalledDistro

## DESCRIPTION

Gets installed WSL distro details from the registry.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > Get-WslDistro
```

Get all distros installed on this machine.

### EXAMPLE 2

```powershell
PS > Get-WslDistro -Name 'U*'
```

Get all distros installed on this machine that start with 'U'.

## PARAMETERS

### -Detail

Return full details.
Default is false.

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

### -Name

Name of the distro.
Default is all distros.
Wildcards are supported.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases:
- distro
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -State

State of the distro.
Default is all distros.

```yaml
Type: System.String[]
DefaultValue: ''
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
AcceptedValues:
- Running
- Stopped
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
