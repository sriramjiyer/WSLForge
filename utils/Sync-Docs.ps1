[CmdletBinding()]
param()

# Module name
$ModuleNames = 'WSLForge'

# Get parent folder of parent folder of this script
$RepoRoot = Split-Path -Path $PSScriptRoot -Parent

# DocsFolder 
$DocsFolder = Join-Path -Path $RepoRoot -ChildPath 'docs'

# Remove the docs folder if it exists
if (Test-Path -Path $DocsFolder -PathType Container) {
    Remove-Item -Path $DocsFolder -Recurse -Force -ErrorAction Stop
}

# Create the docs folder
$null = New-Item -Path $DocsFolder -ItemType Directory -ErrorAction Stop

# Load the module
# $ModuleFile = Join-Path -Path $RepoRoot -ChildPath 'src' -AdditionalChildPath "$ModuleName.psd1"
# Import-Module -Name $ModuleFile -Force -ErrorAction Stop

<#
Function Help

# FunctionName

Module: ModuleNameLink

Aliases: Alias1, Alias2

## Synopsis

Syntax
Syntax
Syntax
Syntax
...

## Description

Description

## Examples

### Example 1
```powershell
Code
```
Remarks

...

## Parameters

### -ParameterName

Description

#>

foreach ($ModuleName in $ModuleNames) {
    # Load the module
    $ModuleFile = Join-Path -Path $RepoRoot -ChildPath 'src' -AdditionalChildPath "$ModuleName.psd1"
    Import-Module -Name $ModuleFile -Force -ErrorAction Stop

    # Generate function documentation for each function using platyps
    $FunctionDocs = Get-Command -Module $ModuleName -CommandType Function | 
    New-CommandHelp

    # Get all Aliases in the module
    $Aliases = Get-Command -Module $ModuleName -CommandType Alias |
    Group-Object -Property { $_.ReferencedCommand.Name } -AsHashTable

    foreach ( $FunctionDoc in $FunctionDocs ) {
        # update the markdown documentation
        $FunctionDoc.Aliases = $Aliases[$FunctionDoc.Title] |
        Select-Object -ExpandProperty Name |
        Join-String -Separator ', '

        # Get examples and update the markdown documentation
        [string[]]$Examples = (
            Get-Help -Name $FunctionDoc.Title -Examples |
            ForEach-Object -Process { $_.examples.example } |
            ForEach-Object -Process {
                @(
                    '```powershell'
                    "$($_.introduction.Text)$($_.code)"
                    '```'
                    ''
                    ($_.remarks.Text)|out-string
                ) -join "`n"
            }
        ).Trim() 

        # Replace Examples in Function documentation
        0 .. ($Examples.Count - 1) |
        ForEach-Object { $FunctionDoc.Examples[$_].Remarks = $Examples[$_] }

        # Add module link
        $FunctionDoc.RelatedLinks.Add(
            [Microsoft.PowerShell.PlatyPS.Model.Links]::new(
                "$($FunctionDoc.ModuleName).md",
                $($FunctionDoc.ModuleName)
            )
        )

        # Get parameter validateset values and update the markdown documentation
        $ParameterHelp = Get-Command -Name $FunctionDoc.Title |
        Select-Object -ExpandProperty Parameters

        foreach ($parameter in $FunctionDoc.Parameters) {
            $ParameterHelp[$parameter.Name].Attributes |
            Where-Object -FilterScript { $_ -is [System.Management.Automation.ValidateSetAttribute] } |
            Select-Object -ExpandProperty ValidValues |
            ForEach-Object -Process { $parameter.AddAcceptedValue( $_ ) }
        }

        # Get markdown documentation
        $Markdown = $FunctionDoc.ToMarkdownString()

        # Remove top matter from markdown documentation
        $Markdown = ($Markdown -split "`n---`r*`n*", 2)[1].Trim()

        # Add lang id text to syntax blocks
        $Markdown = $Markdown -replace "```````n$($FunctionDoc.Title)", "``````text`n$($FunctionDoc.Title)"

        # Update template when there are no aliases
        if (-not $FunctionDoc.Aliases) {
            $Markdown = $Markdown -replace 'This cmdlet has the following aliases,\s*{{Insert list of aliases}}', 'There are no aliases for this cmdlet.'
        }

        # Write to file
        $Markdown |
        Set-Content -Path (Join-Path -Path $DocsFolder -ChildPath "$($FunctionDoc.Title).md") -Encoding utf8NoBOM
    }

    # Create module documentation
    @(
        # Module name
        "# $ModuleName"

        # Description
        Get-Module -Name $ModuleName | 
        Select-Object -ExpandProperty Description

        # Table of functions
        @(
            # Table header
            "| Function | Description |"
            "|----------|-------------|"

            $FunctionDocs |
            ForEach-Object -Process {
                # Row of function name and description
                "|[$($_.Title)]($($_.Title).md)|$($_.Synopsis)|"
            }
        ) -join "`n"
    ) -join "`n`n" |
    Set-Content -Path (Join-Path -Path $DocsFolder -ChildPath "$ModuleName.md") -Encoding utf8NoBOM
}

<#
$c = Get-Command -Module WSLForge -CommandType Function
$h = $c |  New-CommandHelp
$a = Get-Command -Module WSLForge -CommandType Alias | Group-Object -Property { $_.ReferencedCommand.Name } -AsHashTable
$h | ForEach-Object -Process { $_.Aliases = $a[$_.Title] | Select-Object -ExpandProperty Name | Join-String -Separator ', '  }


$e = (Get-Help -Name $h[0].Title -Examples | ForEach-Object -Process { $_.examples.example } | ForEach-Object -Process { @('``` powershell', "$($_.introduction.Text)$($_.code)", '```', '',($_.remarks.Text)|out-string) -join "`n" }).Trim() 

0 .. ($e.Count - 1) | ForEach-Object { $h[0].Examples[$_].Remarks = $e[$_] }

$m = ($h[0].ToMarkdownString() -split "`n---`r*`n")[1].Trim()

$ModuleName |
ForEach-Object -Process {
    @(
        # Module name
        "# $_"

        # Description
        Get-Module -Name $_ | Select-Object -ExpandProperty Description

        # Table of functions
        @(
            # Table header
            "| Function | Description |"
            "|----------|-------------|"

            # Get all functions in the module
            Get-Command -Module $_ -CommandType Function |
            Select-Object -First 2 -Property @{
                Name = 'Cmd'
                Expression = { $_ }
            }, @{
                Name = 'Help'
                Expression = { Get-Help -Name $_.Name }
            } |
            # Generate doc for each function
            ForEach-Object -Process {
                # Row of function name and description
                "|[$($_.Help.Name)]($($_.Help.Name).md)|$($_.Help.Synopsis)|"
                # Function doc
                $null = @(
                    "# $($_.Help.Name)"
                    "Module: [$($_.Help.ModuleName)]($($_.Help.ModuleName).md)"
                    $_.Help.Synopsis
                    "## Syntax"
                    ( $_.Help.Syntax | Out-String).Trim() -split "`r*`n`r*`n" |
                    ForEach-Object -Process {
                        @(
                            '``` text'
                            $_
                            '```'
                        ) -join "`n"
                    }
                    "## Description"
                    $_.Help.Description.Text -replace 'https:\S+', '[$&]($&)'
                    "## Examples"
                    $i = 0
                    $_.Help.examples.example |
                    ForEach-Object -Process {
                        ++$i
                        "### Example $i"
                        @(
                            '``` powershell'
                            "$($_.introduction.Text) $($_.Code)"
                            '```'
                        ) -join "`n"
                        ( $_.remarks.Text -join "`n" ).Trim()
                    }
                    "## Parameters"
                    $_.Help.parameters.parameter |
                    ForEach-Object -Process {
                        "### -$($_.Name)"
                        ($_.description.Text -join "`n").Trim()
                        @(
                            "|     |     |"
                            "|-----|-----|"
                            "|Type| $($_.type.name)|"
                            "|Aliases| $($_.position)|"
                            "|Position| $($_.position)|"
                            "|Default value| $($_.defaultvalue)|"
                            "|Required| $($_.required)|"
                            "|Accept pipeline input| $($_.pipelineInput)|"
                            "|Accept wildcard characters| $($_.globbing)|"
                        ) -join "`n"
                    }
                ) -join "`n`n" | Set-Content -Path (Join-Path -Path $DocsFolder -ChildPath "$($_.Help.Name).md")
            }
        ) -join "`n"
    ) -join "`n`n" | Set-Content -Path (Join-Path -Path $DocsFolder -ChildPath "$_.md")
}
# Create module documentation
$Module = Get-Module -Name $ModuleName
@(
    "# $ModuleName"
    ""
    $Module.Description
    ""
    "| Function | Description |"
    "|----------|-------------|"
    $Module.ExportedFunctions.Values |
    ForEach-Object -Process {
        "|[$($_.Name)]($($_.Name).md)|$((Get-Help -Name $_.Name).Synopsis)|"
    }
) |
Join-String -Separator "`n" |
Set-Content -Path (Join-Path -Path $DocsFolder -ChildPath 'README.md')

# Create function documentation
$Module.ExportedFunctions.Values |
ForEach-Object -Process {
    $Function = $_
    $Help = Get-Help -Name $Function.Name -Full
    @(
        "# $($Function.Name)"
        "Reference"
        "Module: $($Module.Name)"
        $Help.Synopsis
        "## Syntax"
        '``` text'
        ( $Help.Syntax | Out-String ) -split "`r*`n" |
        Where-Object -FilterScript {
            $_ -notmatch '^\s*$'
        } |
        ForEach-Object -Process {
            $_
        } |
        Join-String -Separator "`n`n"
        '```'
        ""
        "## Description"
        ""
        $Help.Description.text
        ""
        "## Examples"
        ""
        $ExampleCount = 1
        $Help.examples.example |
        ForEach-Object -Process {
            "### Example $ExampleCount"
            ""
            '``` powershell'
            "$($_.introduction.text)$($_.code)"
            '```'
            ""
            ($_.remarks.text -join "`n").Trim()
            # (
                # $_.remarks |
                # Select-Object -ExpandProperty text |
                # Join-String -Separator "`n"
            # ).TrimEnd([Environment]::NewLine)
            ""
            $ExampleCount++
        }
        "## Parameters"
        $Help.Parameters.Values |
        ForEach-Object -Process {
            "### $($_.Name)"
        }
        ""
        "## Inputs"
        ""
        $Help.Inputs
        ""
        "## Outputs"
        ""
        $Help.Outputs
        ""
        "## Notes"
        ""
        $Help.Notes
        ""
    ) |
    Join-String -Separator "`n`n" |
    Set-Content -Path (Join-Path -Path $DocsFolder -ChildPath "$($Function.Name).md")
} 
#>