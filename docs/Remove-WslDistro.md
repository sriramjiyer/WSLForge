# Remove-WslDistro

## SYNOPSIS

Remove a WSL distro.

## SYNTAX

### __AllParameterSets

```text
Remove-WslDistro [-Distro] <string> [<CommonParameters>]
```

## ALIASES

Unregister-WslDistro

## DESCRIPTION

Removes or unregister a WSL distro.
Use with caution as this will delete all data in the distro.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > Remove-WslDistro --Name 'Ubuntu'
```

Removes the Ubuntu distro.

## PARAMETERS

### -Distro

Name of Distro to be removed.

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
