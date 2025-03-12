# Find-WslDistro

## SYNOPSIS

Finds WSL distros.

## SYNTAX

### __AllParameterSets

```text
Find-WslDistro [[-Name] <string>] [-Detail] [<CommonParameters>]
```

## ALIASES

There are no aliases for this cmdlet.

## DESCRIPTION

Executes wsl.exe --list --online and returns details.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > Find-WslDistro
```

Finds all WSL distros online.

### EXAMPLE 2

```powershell
PS > Find-WslDistro -Name 'U*'
```

Finds all WSL distros online that start with 'U'.

### EXAMPLE 3

```powershell
PS > Find-WslDistro -Name 'Ubuntu' -detail
```

Finds WSL distros online named 'Ubuntu' and returns full details.

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

Name of the distro to find.
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
