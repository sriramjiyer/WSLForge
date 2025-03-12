# ConvertTo-GzipBase64

## SYNOPSIS

Produces a gzipped base64 encoded string from various sources

## SYNTAX

### __AllParameterSets

```text
ConvertTo-GzipBase64 [-Source] <Object> [-InsertLineBreaks] [-NoCompress] [<CommonParameters>]
```

## ALIASES

There are no aliases for this cmdlet.

## DESCRIPTION

Produces a gzipped base64 encoded string from various sources including files, URLs, strings, and byte arrays.
Compression on by default, but can be disabled.

## EXAMPLES

### EXAMPLE 1

```powershell
PS > ConvertTo-GzipBase64 -Source 'https://example.com/somefile.txt'
```

### EXAMPLE 2

```powershell
PS > ConvertTo-GzipBase64 -Source 'C:\path\to\somefile.txt'
```

### EXAMPLE 3

```powershell
PS > ConvertTo-GzipBase64 -Source 'This is a string'
```

### EXAMPLE 4

```powershell
PS > ConvertTo-GzipBase64 -Source ( [byte[]](72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 33, 33 ) )
```

## PARAMETERS

### -InsertLineBreaks

Insert line breaks every 76 characters in the resulting encoded string.
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

### -NoCompress

Skip compression.
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

### -Source

Data source to be compressed and encoded.
Can be a file path (string that resolves to a file path), URL (string starts with https), string (any other string) or byte array.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
ParameterValue: []
Aliases: []
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
