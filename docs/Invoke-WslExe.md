# Invoke-WslExe

## SYNOPSIS

Powershell wrapper to wsl.exe

## SYNTAX

### __AllParameterSets

```text
Invoke-WslExe [[-OutputEncoding] <string>] [[-Arguments] <string[]>] [<CommonParameters>]
```

## ALIASES

There are no aliases for this cmdlet.

## DESCRIPTION

Executes wsl.exe after setting console output encoding and returns output or exception.
This primarily is a helper funtion that should be rarely used directly.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > Invoke-WslExe --list --online
```

## PARAMETERS

### -Arguments

Arguments to pass to wsl.exe

```yaml
Type: System.String[]
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
  ValueFromRemainingArguments: true
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutputEncoding

Output Encoding to use.
Default is Unicode (UTF16-LE).

```yaml
Type: System.String
DefaultValue: UnicodeEncoding
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
- UnicodeEncoding
- UTF8Encoding
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
