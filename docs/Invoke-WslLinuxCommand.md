# Invoke-WslLinuxCommand

## SYNOPSIS

Invoke a command in a WSL distro.

## SYNTAX

### DefaultDistribution (Default)

```text
Invoke-WslLinuxCommand -LinuxCommand <string[]> [-User <string>] [-Directory <string>]
 [-ShellType <string>] [-Exec] [<CommonParameters>]
```

### System

```text
Invoke-WslLinuxCommand -LinuxCommand <string[]> [-System] [-User <string>] [-Directory <string>]
 [-ShellType <string>] [-Exec] [<CommonParameters>]
```

### DistributionName

```text
Invoke-WslLinuxCommand -LinuxCommand <string[]> [-DistributionName <string>] [-User <string>]
 [-Directory <string>] [-ShellType <string>] [-Exec] [<CommonParameters>]
```

### DistributionId

```text
Invoke-WslLinuxCommand -LinuxCommand <string[]> [-DistributionId <string>] [-User <string>]
 [-Directory <string>] [-ShellType <string>] [-Exec] [<CommonParameters>]
```

## ALIASES

Invoke-WslCommand, iwlc

## DESCRIPTION

Invokes a command in a WSL distro.
Can be used to run a command in a specific distro or the default distro.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > Invoke-WslLinuxCommand --distribution 'Ubuntu' -- 'ls -l'
```

Runs 'ls -l' in the Ubuntu distro.

### EXAMPLE 2

```powershell
PS > Invoke-WslLinuxCommand -- 'whoami'
```

Runs 'whoami' in the default distro.

## PARAMETERS

### -Directory

Set working directory for the command.

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

DistributionId of the distro on which to run the command.

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

Name of the distro on which to run the command.

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

### -Exec

Execute command directly without shell.

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

### -LinuxCommand

LinuxCommand to be executed.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: true
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ShellType

ShellType to use for the command.

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
- none
HelpMessage: ''
```

### -System

Runs command on System Distro

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

Run command as this distro user.

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
