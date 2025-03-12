# Enter-WslShell

## SYNOPSIS

Enter a WSL distro shell.

## SYNTAX

### DefaultDistribution (Default)

```text
Enter-WslShell [-User <string>] [-Directory <string>] [-ShellType <string>] [<CommonParameters>]
```

### System

```text
Enter-WslShell [-System] [-User <string>] [-Directory <string>] [-ShellType <string>]
 [<CommonParameters>]
```

### DistributionName

```text
Enter-WslShell [-DistributionName <string>] [-User <string>] [-Directory <string>]
 [-ShellType <string>] [<CommonParameters>]
```

### DistributionId

```text
Enter-WslShell [-DistributionId <string>] [-User <string>] [-Directory <string>]
 [-ShellType <string>] [<CommonParameters>]
```

## ALIASES

Enter-WslDistro

## DESCRIPTION

Enters a WSL distro shell.
Can be used to enter a shell in a specific distro or the default distro.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > Enter-WslShell --distribution 'Ubuntu'
```

Enters the shell in the Ubuntu distro.

### EXAMPLE 2

```powershell
PS > Enter-WslShell
```

Enters the shell in the default distro.

## PARAMETERS

### -Directory

Set working directory for the shell.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases:
- dir
- path
- folder
- location
- cd
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

### -DistributionId

DistributionId of the distro in which to enter the shell.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases:
- guid
- id
ParameterSets:
- Name: DistributionId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DistributionName

Name of the distro in which to enter the shell.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases:
- distro
- name
ParameterSets:
- Name: DistributionName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ShellType

ShellType to use for the shell.

```yaml
Type: System.String
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
- standard
- login
HelpMessage: ''
```

### -System

Enter shell in System Distro

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: System
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -User

Enter shell as this distro user.

```yaml
Type: System.String
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
