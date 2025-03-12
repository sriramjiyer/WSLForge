# Stop-WslDistro

## SYNOPSIS

Stop a WSL distro.

## SYNTAX

### __AllParameterSets

```text
Stop-WslDistro [-Distro] <string> [<CommonParameters>]
```

## ALIASES

Terminate-WslDistro

## DESCRIPTION

Stops a WSL distro.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > Stop-WslDistro --Name 'Ubuntu'
```

Stops the Ubuntu distro.

## PARAMETERS

### -Distro

Distro

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases:
- Name
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
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
