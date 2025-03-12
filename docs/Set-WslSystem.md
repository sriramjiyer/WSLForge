# Set-WslSystem

## SYNOPSIS

Set WSL system configuration.

## SYNTAX

### __AllParameterSets

```text
Set-WslSystem [[-DefaultVersion] <short>] [[-DefaultDistro] <string>] [<CommonParameters>]
```

## ALIASES

There are no aliases for this cmdlet.

## DESCRIPTION

Sets WSL system configuration.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > Set-WslSystem --DefaultVersion 2
```

Sets the default WSL version to 2.

## PARAMETERS

### -DefaultDistro

Set DefaultDistro

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DefaultVersion

Set DefaultVersion

```yaml
Type: System.Int16
DefaultValue: 0
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues:
- 1
- 2
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
