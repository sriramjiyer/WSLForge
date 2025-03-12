# Export-WslDistro

## SYNOPSIS

Export a WSL distro.

## SYNTAX

### __AllParameterSets

```text
Export-WslDistro [-Distro] <string> [[-FileName] <string>] [[-Format] <string>] [<CommonParameters>]
```

## ALIASES

There are no aliases for this cmdlet.

## DESCRIPTION

Exports a WSL distro to a tar.gz or vhd file.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > Export-WslDistro --Name 'Ubuntu'
```

Exports the Ubuntu distro to $HOME\work\wsl\images\$Distro.tar.gz

## PARAMETERS

### -Distro

Distro to be exported.

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

### -FileName

File to which the distro is to be exported.

```yaml
Type: System.String
DefaultValue: '"$HOME\work\wsl\images\$Distro.tar.gz"'
SupportsWildcards: false
ParameterValue: []
Aliases:
- File
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

### -Format

Format of the export file.

```yaml
Type: System.String
DefaultValue: tar.gz
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues:
- tar
- tar.gz
- vhd
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
