# Move-WslDistro

## SYNOPSIS

Move a WSL distro.

## SYNTAX

### __AllParameterSets

```text
Move-WslDistro [-Distro] <string> [-Location] <string> [<CommonParameters>]
```

## ALIASES

There are no aliases for this cmdlet.

## DESCRIPTION

Moves a WSL distro to a new location on disk.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > Move-WslDistro --Name 'Ubuntu' --Location 'C:\wsl\Ubuntu'
```

Moves the Ubuntu distro to 'C:\wsl\Ubuntu'.

## PARAMETERS

### -Distro

Name of Distro to be moved.

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

### -Location

Location to which the distro is to be moved.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases:
- Folder
- Path
- Directory
ParameterSets:
- Name: (All)
  Position: 1
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
