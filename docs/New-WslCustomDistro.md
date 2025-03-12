# New-WslCustomDistro

## SYNOPSIS

Creates a custom WSL distro.

## SYNTAX

### __AllParameterSets

```text
New-WslCustomDistro [[-Name] <string>] [[-UserDataFile] <string>] [[-RootfsFile] <string>]
 [<CommonParameters>]
```

## ALIASES

There are no aliases for this cmdlet.

## DESCRIPTION

Creates a custom WSL distro.
It uses a cloud-init user data file to configure the distro.
The user data file can be created using New-WslCloudInitUserData.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > New-WslCustomDistro --Name 'MyDistro' --UserDataFile 'C:\path\to\MyDistro.user-data'
```

Creates a custom distro named MyDistro using the user data file MyDistro.user-data.

## PARAMETERS

### -Name

Name of the distro.

```yaml
Type: System.String
DefaultValue: CustomDistro
SupportsWildcards: false
ParameterValue: []
Aliases:
- Distro
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

### -RootfsFile

Root filesystem archive file to use for the distro.

```yaml
Type: System.String
DefaultValue: https://cloud-images.ubuntu.com/wsl/releases/noble/current/ubuntu-noble-wsl-amd64-wsl.rootfs.tar.gz
SupportsWildcards: false
ParameterValue: []
Aliases:
- Rootfs
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UserDataFile

User data file to configure the distro.

```yaml
Type: System.String
DefaultValue: '"$HOME/.cloud-init/$Name.user-data"'
SupportsWildcards: false
ParameterValue: []
Aliases:
- UserData
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
