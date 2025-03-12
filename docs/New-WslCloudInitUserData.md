# New-WslCloudInitUserData

## SYNOPSIS

Creates a cloud-init user data file for WSL2

## SYNTAX

### __AllParameterSets

```text
New-WslCloudInitUserData [[-Name] <string>] [-Path <string>] [-Locale <string>] [-Hostname <string>]
 [-Username <string>] [-UserShell <string>] [-TrustedCaCerts <string[]>] [-DisableSystemD]
 [-DisableAppendWinPath] [-DistroIcon <string>] [-CreateNssDb] [-EnableDocker]
 [-EnableAzureP2SVpnClient] [-AzureP2SVpnProfiles <Object>] [-EnableSqlcmdGo] [-EnableMsSqlTools18]
 [-EnablePwsh] [-PowershellModules <string[]>] [-EnableAzPowershell] [-DisableWslu]
 [-EnableDotnet8Sdk] [-EnableVscode] [-EnableAzCopy] [-EnableBlobFuse2] [-EnableAzCli]
 [-EnableAksCli] [-EnableHelm] [-EnableSqlServer] [-EnableNodejs] [-EnableGhcli] [-SshPort <int>]
 [-SshAuthorizedKeys <string[]>] [-EnableAll] [<CommonParameters>]
```

## ALIASES

There are no aliases for this cmdlet.

## DESCRIPTION

Creates a cloud-init user data file for WSL2.
It contains configuration settings for the WSL2 distro.
Distros like Ubuntu have cloud init preconfigured which will read the file and configure the distro during the first boot.

It is usually YAML file, but can also be a JSON file.
This command creates a JSON file.

By default, this command creates the file in $HOME/.cloud-init where looks for it.
If you are creating one for use on another machine or testing, it can be created in a different location by specifying the Path parameter.

File name is same as the distro name with .user-data suffix.
cloud-init will look for the file with this name on first boot to configure the distro.
If one is not found, it use default.user-data if it is present.
To create a default.user-data file, that will configure all future distros on the machine, specify the 'default' for the Name parameter.

Refer to parameter help for various distro configuration options.
This command only handles generation of very few cloud-init options.
For more advanced configuration, you can create the file manually or add the required settings to the file created by this command.

Refer to https://cloudinit.readthedocs.io/en/latest for more information on cloud-init user data.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > New-WslCloudInitUserData -Name 'Ubuntu'
```

Creates a cloud-init user data file for Ubuntu distro

### EXAMPLE 2

```powershell
PS > New-WslCloudInitUserData -Name 'MyDistro' -UserShell '/usr/bin/pwsh' -PowershellModules ImportExcel
```

Creates a cloud-init user data file for MyDistro distro with PowerShell and ImportExcel module installed and shell set to powershell.

## PARAMETERS

### -AzureP2SVpnProfiles

Azure P2S VPN profiles to add to the distro.
Default is none.
Specifile list of profile xml file paths or http(s) URL or xml document strings or XmlDocument objects.

```yaml
Type: System.Object
DefaultValue: '@()'
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

### -CreateNssDb

Enable creating a new NSS database for the user.
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

### -DisableAppendWinPath

Disable appending Windows PATH to Linux PATH in the distro.
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

### -DisableSystemD

Disable systemd in the distro.
Default is false.
Strongly recommended to keep it enabled.

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

### -DisableWslu

Disable install WSL Utilities in the distro.
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

### -DistroIcon

Path to a .ico file to use as the distro icon.
Default is none.
It can be a local file path on this machine or a http(s) URL or a byte array.

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

### -EnableAksCli

Install AKS CLI in the distro.
Default is false.
This will also install Azure CLI in the distro.

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

### -EnableAll

Enable all features.
Default is false.
SSH Server is not enabled with this parameter.
Please use SSH Port parameter explicitly to enable SSH server.

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

### -EnableAzCli

Install Azure CLI in the distro.
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

### -EnableAzCopy

Install AzCopy in the distro.
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

### -EnableAzPowershell

Install Az PowerShell in the distro.
Default is false.
This will also install PowerShell in the distro.

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

### -EnableAzureP2SVpnClient

Install Azure P2S VPN client in the distro.
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

### -EnableBlobFuse2

Install BlobFuse2 in the distro.
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

### -EnableDocker

Enable Docker in the distro.
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

### -EnableDotnet8Sdk

Install .NET 8 SDK in the distro.
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

### -EnableGhcli

Install GitHub CLI in the distro.
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

### -EnableHelm

Install Helm in the distro.
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

### -EnableMsSqlTools18

Install MS SQL Tools 18 in the distro.
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

### -EnableNodejs

Install Node.js in the distro.
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

### -EnablePwsh

Install PowerShell in the distro.
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

### -EnableSqlcmdGo

Install sqlcmd GO version in the distro.
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

### -EnableSqlServer

Install SQL Server in the distro.
Default is false.
NOTE: Not implemented yet.
TODO

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

### -EnableVscode

Install Visual Studio Code in the distro.
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

### -Hostname

Hostname of the distro to be set in wsl.conf.
Default distro name.

```yaml
Type: System.String
DefaultValue: $Name
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

### -Locale

Locale to set for the distro.
Default is the windows system locale of this machine.

```yaml
Type: System.String
DefaultValue: ( ( Get-WinSystemLocale | Select-Object -ExpandProperty Name ) -replace '-', '_' )
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

Name of the distro.
Default is 'CustomDistro'.
To generate a default.user-data file, specify 'default'.

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

### -Path

Path to save the file.
Default is $HOME/.cloud-init.

```yaml
Type: System.String
DefaultValue: '"$HOME/.cloud-init"'
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

### -PowershellModules

Install PowerShell modules in the distro.
Default is none.
Multiple modules can be specified.
This will also install PowerShell in the distro.

```yaml
Type: System.String[]
DefaultValue: '@()'
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

### -SshAuthorizedKeys

SSH authorized keys to add to the distro.
Default is none.
Specify list of public key file paths or http(s) URL or public key strings.
SSH Server is not enabled by default.
SSH Port parameter must be specified to enable SSH server.

```yaml
Type: System.String[]
DefaultValue: '@()'
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

### -SshPort

Enable SSH server in the distro and set listen port.
It is not recommended to use port 22.
Specify a port higher than 1024 and less than 65000.
Default is none and SSH server is not enabled.
Ensure the port is unique among all distros on this machine.

```yaml
Type: System.Int32
DefaultValue: 0
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

### -TrustedCaCerts

Trusted CA certificates from this machine to add to the distro ca-certs and  NSS database.
Default is none.
Multiple certificates can be specified.
Wildcards are supported.
Specify thumprints or subject names.

```yaml
Type: System.String[]
DefaultValue: '@()'
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

### -Username

Username to create in the distro.
Default is the current user on this machine.

```yaml
Type: System.String
DefaultValue: $env:USERNAME
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

### -UserShell

Shell to set for the user.
Default is '/bin/bash'.
Choosing pwsh will also install PowerShell in the distro.

```yaml
Type: System.String
DefaultValue: /bin/bash
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
