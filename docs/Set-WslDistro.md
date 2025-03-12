# Set-WslDistro

## SYNOPSIS

Set WSL distro configuration.

## SYNTAX

### User

```text
Set-WslDistro [-Distro] <string> [-User] <string> [<CommonParameters>]
```

### Sparse

```text
Set-WslDistro [-Distro] <string> [-Sparse] <string> [<CommonParameters>]
```

### Version

```text
Set-WslDistro [-Distro] <string> [-Version] <short> [<CommonParameters>]
```

## ALIASES

There are no aliases for this cmdlet.

## DESCRIPTION

Sets WSL distro configuration.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > Set-WslDistro --Name 'Ubuntu' --User 'root'
```

Sets the default user in the Ubuntu distro to root.

## PARAMETERS

### -Distro

Name of Distro to be configured.

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

### -Sparse

Set disk file to sparse or non-sparse.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: Sparse
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues:
- true
- false
HelpMessage: ''
```

### -User

Name of default distro user.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: User
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Version

Set WSL version.

```yaml
Type: System.Int16
DefaultValue: 0
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: Version
  Position: 1
  IsRequired: true
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
