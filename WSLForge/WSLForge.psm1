<#
.SYNOPSIS
    Powershell wrapper to wsl.exe

.DESCRIPTION
    Executes wsl.exe after setting console output encoding and returns output or exception. This primarily is a helper funtion that should be rarely used directly.

.EXAMPLE
    Invoke-WslExe --list --online
#>

function Invoke-WslExe {
    [Alias('iwe')]
    [CmdletBinding()]
    param(
        # Output Encoding to use. Default is Unicode (UTF16-LE).
        [Parameter()]
        [ValidateSet('UnicodeEncoding', 'UTF8Encoding')]
        [string] $OutputEncoding = 'UnicodeEncoding',

        # Arguments to pass to wsl.exe
        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Arguments
    )
    $SaveEncoding = [console]::OutputEncoding

    if ( $OutputEncoding -eq 'UTF8Encoding' ) {
        [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
    } elseif ( $OutputEncoding -eq 'UnicodeEncoding' ) {
        [console]::OutputEncoding = New-Object System.Text.UnicodeEncoding
    }

    $Return = &wsl.exe $Arguments 2>&1

    [console]::OutputEncoding = $SaveEncoding

    if ( $LASTEXITCODE -ne 0 ) {
        throw "$LASTEXITCODE  $Return"
    } else {
        return $Return
    }
}

<#
.SYNOPSIS
    Finds WSL distros.

.DESCRIPTION
    Executes wsl.exe --list --online and returns details.

.EXAMPLE
    Find-WslDistro

    Finds all WSL distros online.

.EXAMPLE
    Find-WslDistro -Name 'U*'

    Finds all WSL distros online that start with 'U'.

.EXAMPLE
    Find-WslDistro -Name 'Ubuntu' -detail

    Finds WSL distros online named 'Ubuntu' and returns full details.
#>
function Find-WslDistro {
    [Alias('fiwd')]
    [CmdletBinding()]
    Param (
        # Name of the distro to find. Default is all distros. Wildcards are supported.
        [Parameter(Position = 0)]
        [Alias('distro')]
        [string]
        $Name,

        # Return full details. Default is false.
        [Parameter()]
        [switch]
        $Detail
    )

    if ( -not (Invoke-WslExe --status -OutputEncoding UnicodeEncoding -ErrorAction SilentlyContinue) ) {
        $Return = Invoke-WslExe --list --online -OutputEncoding UnicodeEncoding |
        Where-Object -FilterScript { $_ -ne '' } |
        Select-Object -Skip 4 -Property @{
            l = 'Name'
            e = { $_ -replace '^..','' -replace ' .*$','' }
        },
        @{
            l = 'FriendlyName'
            e = { $_ -replace '^..','' -replace '^[^ ]+ +','' }
        } |
        Where-Object -FilterScript {
            ( -not $Name ) -or $_.Name -like $Name
        }
    } else {
        $Return = Invoke-WslExe -OutputEncoding UnicodeEncoding --list --online |
        Select-Object -Skip 4 -Property @{
            l = 'Name'
            e = { $_ -replace ' .*$','' }
        },
        @{
            l = 'FriendlyName'
            e = { $_ -replace '^[^ ]+ +','' }
        } |
        Where-Object -FilterScript {
            ( -not $Name ) -or $_.Name -like $Name
        }
    }

    if ($Detail) {
        $Return
    } else {
        $Return.Name
    }
}

<#
.SYNOPSIS
    Gets installed WSL distro details.

.DESCRIPTION
    Gets installed WSL distro details from the registry.

.EXAMPLE
    Get-WslDistro

    .EXAMPLE
    Get-WslDistro -Name 'U*'
#>
function Get-WslDistro {
    [Alias('gwid', 'Get-WslInstalledDistro')]
    [CmdletBinding()]
    Param (
        # Name of the distro. Default is all distros. Wildcards are supported.
        [Parameter(Position = 0)]
        [Alias('distro')]
        [string]
        $Name,

        # Return full details. Default is false.
        [Parameter()]
        [switch]
        $Detail,

        # State of the distro. Default is all distros.
        [Parameter()]
        [ValidateSet('Running', 'Stopped')]
        [string[]]
        $State
    )

        $Return = Invoke-WslExe -OutputEncoding UnicodeEncoding --list --verbose |
        Select-Object -Skip 1 |
        ForEach-Object -Process {
            $Distro = $_ -split ' +'
            [pscustomobject]@{
                Name = $Distro[1]
                State = $Distro[2]
                WSLVersion = $Distro[3]
                DefaultDistro = $Distro[0] -eq '*'
            }
        } |
        Where-Object -FilterScript {
            ( -not $Name ) -or $_.Name -like $Name
        }

        if ($State) {
            $Return = $Return |
            Where-Object -FilterScript {
                $_.State -in $State
            }
        }

        if ($Detail) {
            $DistroHash = @{}

            $Return | ForEach-Object -Process {
                $DistroHash[$_.Name] = $_
            }

            Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss\*' |
            Where-Object -FilterScript {
                $_.DistributionName -in $Return.Name 
            } |
            Select-Object -Property *, @{
                Name = 'DistributionId'
                Expression = { $_.PSChildName -replace '{', '' -replace '}', '' -as [guid] }
            }, @{
                Name = 'RunState'
                Expression = { $DistroHash[$_.DistributionName].State }
            }, @{
                Name = 'Name'
                Expression = { $DistroHash[$_.DistributionName].Name }
            }, @{
                Name = 'DefaultDistro'
                Expression = { $DistroHash[$_.DistributionName].DefaultDistro }
            } -ExcludeProperty PS*, DistributionName
        } else {
            $Return.Name
        }
}

<#
.SYNOPSIS
    Invoke a command in a WSL distro.

.DESCRIPTION
    Invokes a command in a WSL distro. Can be used to run a command in a specific distro or the default distro.

.EXAMPLE
    Invoke-WslLinuxCommand --distribution 'Ubuntu' -- 'ls -l'

    Runs 'ls -l' in the Ubuntu distro.

.EXAMPLE
    Invoke-WslLinuxCommand -- 'whoami'

    Runs 'whoami' in the default distro.
#>
function Invoke-WslLinuxCommand {
    [Alias('iwlc', 'Invoke-WslCommand')]
    [CmdletBinding(DefaultParameterSetName = 'DefaultDistribution')]
    Param(
        # Runs command on System Distro
        [Parameter(ParameterSetName = 'System')]
        [switch]
        $System,

        # Name of the distro on which to run the command.
        [Parameter(ParameterSetName = 'DistributionName')]
        [Alias('distro', 'name')]
        [ArgumentCompleter({ Get-WslDistro -Name "$($args[2])*" })]
        [string]
        $DistributionName,

        # DistributionId of the distro on which to run the command.
        [Parameter(ParameterSetName = 'DistributionId')]
        [Alias('guid', 'id')]
        [string]
        $DistributionId,

        # Run command as this distro user.
        [Parameter()]
        [string]
        $User,

        # Set working directory for the command.
        [Parameter()]
        [Alias('dir', 'path', 'folder', 'location', 'cd')]
        [string]
        $Directory,

        # ShellType to use for the command.
        [Parameter()]
        [ValidateSet('standard', 'login', 'none')]
        [string]
        $ShellType,

        # Execute command directly without shell.
        [Parameter()]
        [switch]
        $Exec,

        # LinuxCommand to be executed.
        [Parameter(Mandatory, ValueFromRemainingArguments)]
        [string[]]
        $LinuxCommand
    )

    $WslArgs = @(
        if ($ShellType) { '--shell-type', $ShellType }
        if ($System) { '--system' }
        if ($DistributionName) { '--distribution', $DistributionName }
        if ($DistributionId) { '--distribution-id', $DistributionId }
        if ($User) { '--user', $User }
        if ($Directory) { '--cd', $Directory }
        if ($Exec) { '--exec' }
        "--"
    ) + $LinuxCommand

    Invoke-WslExe -OutputEncoding UTF8Encoding @WslArgs
}

<#
.SYNOPSIS
    Enter a WSL distro shell.

.DESCRIPTION
    Enters a WSL distro shell. Can be used to enter a shell in a specific distro or the default distro.

.EXAMPLE
    Enter-WslShell --distribution 'Ubuntu'

    Enters the shell in the Ubuntu distro.

.EXAMPLE
    Enter-WslShell

    Enters the shell in the default distro.
#>
function Enter-WslShell {
    [Alias('ews', 'Enter-WslDistro')]
    [CmdletBinding(DefaultParameterSetName = 'DefaultDistribution')]
    Param(
        # Enter shell in System Distro
        [Parameter(ParameterSetName = 'System')]
        [switch]
        $System,

        # Name of the distro in which to enter the shell.
        [Parameter(ParameterSetName = 'DistributionName')]
        [Alias('distro', 'name')]
        [ArgumentCompleter({ Get-WslDistro -Name "$($args[2])*" })]
        [string]
        $DistributionName,

        # DistributionId of the distro in which to enter the shell.
        [Parameter(ParameterSetName = 'DistributionId')]
        [Alias('guid', 'id')]
        [string]
        $DistributionId,

        # Enter shell as this distro user.
        [Parameter()]
        [string]
        $User,

        # Set working directory for the shell.
        [Parameter()]
        [Alias('dir', 'path', 'folder', 'location', 'cd')]
        [string]
        $Directory,

        # ShellType to use for the shell.
        [Parameter()]
        [ValidateSet('standard', 'login')]
        [string]
        $ShellType
    )

    $WslArgs = @(
        if ($ShellType) { '--shell-type', $ShellType }
        if ($System) { '--system' }
        if ($DistributionName) { '--distribution', $DistributionName }
        if ($DistributionId) { '--distribution-id', $DistributionId }
        if ($User) { '--user', $User }
        if ($Directory) { '--cd', $Directory }
    )

    &wsl.exe $WslArgs
}

<#
.SYNOPSIS
    Invoke WSL system debg shell.

.DESCRIPTION
    Invokes the WSL system debug shell.

.EXAMPLE
    Invoke-WslDebugShell
#>
function Invoke-WslDebugShell {
    [Alias('iwds')]
    [CmdletBinding()]
    Param()

    &wsl.exe --debug-shell
}

<#
.SYNOPSIS
    Get WSL system details.

.DESCRIPTION
    Gets WSL system details.
    
.EXAMPLE
    Get-WslSystem
#>
function Get-WslSystem {
    [Alias('gws')]
    [CmdletBinding()]
    param ()

    if ( -not (Invoke-WslExe -OutputEncoding UnicodeEncoding --status -ErrorAction SilentlyContinue) ) {
        return "wsl is not installed"
    }

    $Hash = @{}
    $(
        Invoke-WslExe -OutputEncoding UnicodeEncoding --version
        Invoke-WslExe -OutputEncoding UnicodeEncoding --status
    ) |
    Select-String -Pattern " *: *" |
    ForEach-Object -Process {
        $property, $value = $_ -split " *: *"
        $property = $property.Trim()
        $value = $value.Trim()
        $Hash[$property] = $value
    }
    [PSCustomObject]$Hash
}

<#
.SYNOPSIS
    Stop a WSL distro.

.DESCRIPTION
    Stops a WSL distro.

.EXAMPLE
    Stop-WslDistro --Name 'Ubuntu'

    Stops the Ubuntu distro.
#>
function Stop-WslDistro {
    [Alias('swd', 'Terminate-WslDistro')]
    [CmdletBinding()]
    param (
        # Distro
        [Parameter(Position = 0, Mandatory = $true)]
        [Alias('Name')]
        [ArgumentCompleter({ Get-WslDistro -Name "$($args[2])*" -State 'Running' })]
        [string]
        $Distro
    )

    Invoke-WslExe -OutputEncoding UnicodeEncoding --terminate $Distro
}

<#
.SYNOPSIS
    Stop WSL system.

.DESCRIPTION
    Stops all Distros and WSL system.

.EXAMPLE
    Stop-WslSystem
#>
function Stop-WslSystem {
    [Alias('sws')]
    [CmdletBinding()]
    param ()

    Invoke-WslExe -OutputEncoding UnicodeEncoding --shutdown
}

<#
.SYNOPSIS
    Remove a WSL distro.

.DESCRIPTION
    Removes or unregister a WSL distro. Use with caution as this will delete all data in the distro.

.EXAMPLE
    Remove-WslDistro --Name 'Ubuntu'

    Removes the Ubuntu distro.
#>
function Remove-WslDistro {
    [Alias('rwd', 'Unregister-WslDistro')]
    [CmdletBinding()]
    param (
        # Name of Distro to be removed.
        [Parameter(Position = 0, Mandatory = $true)]
        [Alias('Name')]
        [ArgumentCompleter({ Get-WslDistro -Name "$($args[2])*" })]
        [string]
        $Distro
    )

    Invoke-WslExe -OutputEncoding UnicodeEncoding --unregister $Distro
}

<#
.SYNOPSIS
    Move a WSL distro.

.DESCRIPTION
    Moves a WSL distro to a new location on disk.

.EXAMPLE
    Move-WslDistro --Name 'Ubuntu' --Location 'C:\wsl\Ubuntu'

    Moves the Ubuntu distro to 'C:\wsl\Ubuntu'.
#>
function Move-WslDistro {
    [Alias('mwd')]
    [CmdletBinding()]
    param (
        # Name of Distro to be moved.
        [Parameter(Position = 0, Mandatory = $true)]
        [Alias('Name')]
        [ArgumentCompleter({ Get-WslDistro -Name "$($args[2])*" })]
        [string]
        $Distro,

        # Location to which the distro is to be moved.
        [Parameter(Position = 1, Mandatory = $true)]
        [Alias('Folder', 'Path', 'Directory')]
        [ValidateScript({
            if ( -not (Test-Path -Path $_ -PathType Container -IsValid) ) {
                throw "$_ is not a valid directory"
            }
            if ( Test-Path (Join-Path -Path $_ -ChildPath '*.vhdx') ) {
                throw "$_ already contains a .vhdx file"
            }
            $true
        })]
        [string]
        $Location
    )

    $Location = if ( Test-Path -Path $Location) {
        Resolve-Path -Path $Location | Select-Object -ExpandProperty Path
    } else {
        New-Item -Path $Location -ItemType Directory | Select-Object -ExpandProperty FullName
    }

    Invoke-WslExe -OutputEncoding UnicodeEncoding --manage $Distro --move $Location
}

<#
.SYNOPSIS
    Set WSL distro configuration.

.DESCRIPTION
    Sets WSL distro configuration.

.EXAMPLE
    Set-WslDistro --Name 'Ubuntu' --User 'root'

    Sets the default user in the Ubuntu distro to root.
#>
function Set-WslDistro {
    [Alias('swd')]
    [CmdletBinding()]
    param (
        # Name of Distro to be configured.
        [Parameter(Position = 0, Mandatory = $true)]
        [Alias('Name')]
        [ArgumentCompleter({ Get-WslDistro -Name "$($args[2])*" })]
        [string]
        $Distro,

        # Name of default distro user.
        [Parameter(Position = 1, ParameterSetName = 'User', Mandatory)]
        [string]
        $User,

        # Set disk file to sparse or non-sparse.
        [Parameter(Position = 1, ParameterSetName = 'Sparse', Mandatory)]
        [ValidateSet('true', 'false')]
        [string]
        $Sparse,

        # Set WSL version.
        [Parameter(Position = 1, ParameterSetName = 'Version', Mandatory)]
        [ValidateSet('1', '2')]
        [Int16]
        $Version
    )

    if ($User) {
        Invoke-WslExe -OutputEncoding UnicodeEncoding --manage $Distro --set-default-user $User
    }

    if ($Sparse) {
        Invoke-WslExe -OutputEncoding UnicodeEncoding --manage $Distro --set-sparse $Sparse
    }

    if ($Version) {
        Invoke-WslExe -OutputEncoding UnicodeEncoding --set-version $Distro $Version
    }
}

<#
.SYNOPSIS
    Set WSL system configuration.

.DESCRIPTION
    Sets WSL system configuration.

.EXAMPLE
    Set-WslSystem --DefaultVersion 2

    Sets the default WSL version to 2.
#>
function Set-WslSystem {
    [Alias('sws')]
    [CmdletBinding()]
    param (
        # Set DefaultVersion
        [Parameter()]
        [ValidateSet('1', '2')]
        [Int16]
        $DefaultVersion,

        # Set DefaultDistro
        [Parameter()]
        [ValidateScript({
            if ( Get-WslDistro -Name $_ ) {
                $true
            } else {
                throw "$_ is not a valid distribution"
            }
        })]
        [ArgumentCompleter({ Get-WslDistro -Name "$($args[2])*" })]
        [string]
        $DefaultDistro
    )

    if ($DefaultVersion) {
        Invoke-WslExe -OutputEncoding UnicodeEncoding --set-default-version $DefaultVersion
    }

    if ($DefaultDistro) {
        Invoke-WslExe -OutputEncoding UnicodeEncoding --set-default $DefaultDistro
    }
}

<#
.SYNOPSIS
    Update WSL system.

.DESCRIPTION
    Updates WSL system.

.EXAMPLE
    Update-WslSystem

    Updates WSL system.
#>
function Update-WslSystem {
    [Alias('uws')]
    [CmdletBinding()]
    param (
        # Allow update to PreRelease version.
        [Parameter()]
        [switch]
        $PreRelease
    )

    $WslArgs = @(
        '--update'
        if ($PreRelease) { $WslArgs += '--pre-release' }
    )

    Invoke-WslExe -OutputEncoding UnicodeEncoding @WslArgs
}

<#
.SYNOPSIS
    UnInstall WSL system.
    
.DESCRIPTION
    UnInstalls WSL system. It will not remove any distros or data. However the distros will not be accesssible after uninstalling WSL system.

.EXAMPLE
    Uninstall-WslSystem

    Uninstalls WSL system.
#>
function Uninstall-WslSystem {
    [Alias('uws')]
    [CmdletBinding()]
    param ()

    Invoke-WslExe -OutputEncoding UnicodeEncoding --uninstall
}

<#
.SYNOPSIS
    Export a WSL distro.

.DESCRIPTION
    Exports a WSL distro to a tar.gz or vhd file.

.EXAMPLE
    Export-WslDistro --Name 'Ubuntu'

    Exports the Ubuntu distro to $HOME\work\wsl\images\$Distro.tar.gz
#>
function Export-WslDistro {
    [Alias('ewd')]
    [CmdletBinding()]
    param (
        # Distro to be exported.
        [Parameter(Position = 0, Mandatory = $true)]
        [Alias('Name')]
        [ArgumentCompleter({ Get-WslDistro -Name "$($args[2])*" })]
        [string]
        $Distro,

        # File to which the distro is to be exported.
        [Parameter(Position = 1)]
        [Alias('File')]
        [string]
        $FileName = "$HOME\work\wsl\images\$Distro.tar.gz",

        # Format of the export file.
        [Parameter(Position = 2)]
        [ValidateSet('tar', 'tar.gz', 'vhd')]
        [string]
        $Format = 'tar.gz'
    )

    $FileName = Join-Path -Path (
        Resolve-Path -Path ( Split-Path -Path $FileName -Parent ) -ErrorAction Stop
    ) -ChildPath (Split-Path -Path $FileName -Leaf)

    Invoke-WslExe -OutputEncoding UnicodeEncoding --export $Distro $FileName --format $Format
}

<#
.SYNOPSIS
    Import a WSL distro.

.DESCRIPTION
    Imports a WSL distro from a tar.gz or vhd file.

.EXAMPLE
    Import-WslDistro --Name 'Ubuntu' --File 'C:\work\wsl\images\Ubuntu.tar.gz' --Location 'C:\wsl\Ubuntu'

    Imports the Ubuntu distro from 'C:\work\wsl\images\Ubuntu.tar.gz' to 'C:\wsl\Ubuntu'.
#>
function Import-WslDistro {
    [Alias('iwd')]
    [CmdletBinding(DefaultParameterSetName = 'Import')]
    param (
        # Name of the imported distro.
        [Parameter(Position = 0, Mandatory = $true)]
        [Alias('Name')]
        [ValidateScript({
            if ( Get-WslDistro -Name $_ ) {
                throw "Distro $_ already exists"
            }
            $true
        })]
        [string]
        $Distro,

        # Export file from which the distro is to be imported.
        [Parameter(Position = 1, Mandatory = $true)]
        [ValidateScript({
            if ( -not (Test-Path -Path $_ -PathType Leaf) ) {
                throw "$_ is not a valid export file"
            }
            $true
        })]
        [string]
        $File,

        # Location to which the distro is to be imported.
        [Parameter(ParameterSetName = 'Import', Position = 2, Mandatory = $true)]
        [Alias('Folder', 'Path', 'Directory')]
        [ValidateScript({
            if ( -not (Test-Path -Path $_ -PathType Container -IsValid) ) {
                throw "$_ is not a valid directory"
            }
            if ( Test-Path (Join-Path -Path $_ -ChildPath '*.vhdx') ) {
                throw "$_ already contains a .vhdx file"
            }
            $true
        })]
        [string]
        $Location,

        # Version of the imported distro.
        [Parameter(ParameterSetName = 'Import')]
        [ValidateSet('1', '2')]
        [Int16]
        $Version,

        # Import file is a disk image.
        [Parameter(ParameterSetName = 'Import')]
        [switch]
        $Vhd,

        # Use the disk image as is.
        [Parameter(ParameterSetName = 'ImportInPlace')]
        [switch]
        $ImportInPlace
    )

    if ( $Location ) {
        $Location = if ( Test-Path -Path $Location) {
            Resolve-Path -Path $Location | Select-Object -ExpandProperty Path
        } else {
            New-Item -Path $Location -ItemType Directory | Select-Object -ExpandProperty FullName
        }
    }

    $WslArgs = @(
        if ($ImportInPlace) { '--import-in-place', $Distro, $File } else { '--import', $Distro, $Location, $File }
        if ($Version) { '--version', $Version }
        if ($Vhd) { '--vhd' }
    )

    Invoke-WslExe -OutputEncoding UnicodeEncoding @WslArgs
}

<#
.SYNOPSIS
    Install WSL system features.

.DESCRIPTION
    Installs only WSL system features. It uses web download from Microsoft store. It does not install any distros. Use New-WslDistro to install distros available in Microsoft store. To install a customized Ubuntu distro use New-WslCloudInitUserData and New-WslCustomDistro.

.EXAMPLE
    Install-WslSystem
#>
function Install-WslSystem {
    [Alias('iws')]
    [CmdletBinding()]
    param (
        # Allow install of PreRelease version.
        [Parameter()]
        [switch]
        $PreRelease,

        # Enable WSL1 in addition to WSL2.
        [Parameter()]
        [switch]
        $EnableWsl1
    )

    $WslArgs = @(
        '--install'
        '--no-distribution'
        '--web-download'
        if ($PreRelease) { $WslArgs += '--pre-release' }
        if ($EnableWsl1) { $WslArgs += '--enable-wsl1' }
    )

    Invoke-WslExe -OutputEncoding UnicodeEncoding @WslArgs
}

<#
.SYNOPSIS

    Produces a gzipped base64 encoded string from various sources

.DESCRIPTION

    Produces a gzipped base64 encoded string from various sources including files, URLs, strings, and byte arrays. Compression on by default, but can be disabled.

.EXAMPLE
    ConvertTo-GzipBase64 -Source 'https://example.com/somefile.txt'

.EXAMPLE
    ConvertTo-GzipBase64 -Source 'C:\path\to\somefile.txt'

.EXAMPLE
    ConvertTo-GzipBase64 -Source 'This is a string'

.EXAMPLE
    ConvertTo-GzipBase64 -Source ( [byte[]](72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 33, 33 ) )
#>
function ConvertTo-GzipBase64 {
    [CmdletBinding()]
    param (
        # Data source to be compressed and encoded. Can be a file path (string that resolves to a file path), URL (string starts with https), string (any other string) or byte array.
        [Parameter(Position = 0, Mandatory = $true )]
        $Source,

        # Insert line breaks every 76 characters in the resulting encoded string. Default is false.
        [Parameter()]
        [switch] $InsertLineBreaks,

        # Skip compression. Default is false.
        [Parameter()]
        [switch] $NoCompress
    )

    if ( $Source -is [string] -and $Source -like 'http*' ) {
        $FileBytes = ( Invoke-WebRequest -Uri $Source -Erroraction Stop ).Content
    } elseif ( $Source -is [string] -and ( Test-Path -Path $Source ) ) {
        $FileBytes = [System.IO.File]::ReadAllBytes($Source)
    } elseif ( $Source -is [string] ) {
        $FileBytes = [System.Text.Encoding]::UTF8.GetBytes($Source)
    } elseif ( $Source -is [byte[]] ) {
        $FileBytes = $Source
    } else {
        throw "Invalid source type"
    }

    if ( $NoCompress ) {
        $compressedBytes = $FileBytes
    } else {
        $compressedStream = New-Object System.IO.MemoryStream
        $gzipStream = New-Object System.IO.Compression.GzipStream(
            $compressedStream,
            [System.IO.Compression.CompressionMode]::Compress
        )
        $gzipStream.Write($FileBytes, 0, $FileBytes.Length)
        $gzipStream.Close()
        $compressedBytes = $compressedStream.ToArray()
        $compressedStream.Close()
    }
    
    if ( $InsertLineBreaks ) {
        [System.Convert]::ToBase64String($compressedBytes, 'InsertLineBreaks')
    } else {
        [System.Convert]::ToBase64String($compressedBytes)
    }
}

<#
.SYNOPSIS
    Creates a cloud-init user data file for WSL2

.DESCRIPTION
    Creates a cloud-init user data file for WSL2. It contains configuration settings for the WSL2 distro. Distros like Ubuntu have cloud init preconfigured which will read the file and configure the distro during the first boot.
    
    It is usually YAML file, but can also be a JSON file. This command creates a JSON file.
    
    By default, this command creates the file in $HOME/.cloud-init where looks for it. If you are creating one for use on another machine or testing, it can be created in a different location by specifying the Path parameter.

    File name is same as the distro name with .user-data suffix. cloud-init will look for the file with this name on first boot to configure the distro. If one is not found, it use default.user-data if it is present. To create a default.user-data file, that will configure all future distros on the machine, specify the 'default' for the Name parameter.

    Refer to parameter help for various distro configuration options. This command only handles generation of very few cloud-init options. For more advanced configuration, you can create the file manually or add the required settings to the file created by this command.

    Refer to https://cloudinit.readthedocs.io/en/latest for more information on cloud-init user data.

.EXAMPLE
    New-WslCloudInitUserData -Name 'Ubuntu'

    Creates a cloud-init user data file for Ubuntu distro

.EXAMPLE
    New-WslCloudInitUserData -Name 'MyDistro' -UserShell '/usr/bin/pwsh' -PowershellModules ImportExcel

    Creates a cloud-init user data file for MyDistro distro with PowerShell and ImportExcel module installed and shell set to powershell.
#>
function New-WslCloudInitUserData {
    [CmdletBinding()]
    param (
        # Name of the distro. Default is 'CustomDistro'. To generate a default.user-data file, specify 'default'.
        [Parameter(Position = 0)]
        [Alias('Distro')]
        [string] $Name = 'CustomDistro',

        # Path to save the file. Default is $HOME/.cloud-init.
        [Parameter()]
        [string] $Path = "$HOME/.cloud-init",

        # Locale to set for the distro. Default is the windows system locale of this machine.
        [Parameter()]
        [string] $Locale = ( ( Get-WinSystemLocale | Select-Object -ExpandProperty Name ) -replace '-', '_' ),

        # Hostname of the distro to be set in wsl.conf. Default distro name.
        [Parameter()]
        [string] $Hostname = $Name,

        # Username to create in the distro. Default is the current user on this machine.
        [Parameter()]
        [string] $Username = $env:USERNAME,

        # Shell to set for the user. Default is '/bin/bash'. Choosing pwsh will also install PowerShell in the distro.
        [Parameter()]
        [ArgumentCompleter({
            param($c, $p, $w, $a, $f)
            '/bin/bash', '/bin/sh', '/bin/zsh', '/bin/fish', '/usr/bin/pwsh' |
            Where-Object -FilterScript { $_ -like "*$w*" }
        })]
        [string] $UserShell = "/bin/bash",

        # Trusted CA certificates from this machine to add to the distro ca-certs and  NSS database. Default is none. Multiple certificates can be specified. Wildcards are supported. Specify thumprints or subject names.
        [Parameter()]
        [string[]] $TrustedCaCerts = @(),

        # Disable systemd in the distro. Default is false. Strongly recommended to keep it enabled.
        [Parameter()]
        [switch] $DisableSystemD,

        # Disable appending Windows PATH to Linux PATH in the distro. Default is false.
        [Parameter()]
        [switch] $DisableAppendWinPath,

        # Path to a .ico file to use as the distro icon. Default is none. It can be a local file path on this machine or a http(s) URL or a byte array.
        [Parameter()]
        [string] $DistroIcon,

        # Enable creating a new NSS database for the user. Default is false.
        [Parameter()]
        [switch] $CreateNssDb,

        # Enable Docker in the distro. Default is false.
        [Parameter()]
        [switch] $EnableDocker,

        # Install Azure P2S VPN client in the distro. Default is false.
        [Parameter()]
        [switch] $EnableAzureP2SVpnClient,

        # Azure P2S VPN profiles to add to the distro. Default is none. Specifile list of profile xml file paths or http(s) URL or xml document strings or XmlDocument objects.
        [Parameter()]
        $AzureP2SVpnProfiles = @(),

        # Install sqlcmd GO version in the distro. Default is false.
        [Parameter()]
        [switch] $EnableSqlcmdGo,

        # Install MS SQL Tools 18 in the distro. Default is false.
        [Parameter()]
        [switch] $EnableMsSqlTools18,

        # Install PowerShell in the distro. Default is false.
        [Parameter()]
        [switch] $EnablePwsh,

        # Install PowerShell modules in the distro. Default is none. Multiple modules can be specified. This will also install PowerShell in the distro.
        [Parameter()]
        [string[]] $PowershellModules = @(),

        # Install Az PowerShell in the distro. Default is false. This will also install PowerShell in the distro.
        [Parameter()]
        [switch] $EnableAzPowershell,

        # Disable install WSL Utilities in the distro. Default is false.
        [Parameter()]
        [switch] $DisableWslu,

        # Install .NET 8 SDK in the distro. Default is false.
        [Parameter()]
        [switch] $EnableDotnet8Sdk,

        # Install Visual Studio Code in the distro. Default is false.
        [Parameter()]
        [switch] $EnableVscode,

        # Install AzCopy in the distro. Default is false.
        [Parameter()]
        [switch] $EnableAzCopy,

        # Install BlobFuse2 in the distro. Default is false.
        [Parameter()]
        [switch] $EnableBlobFuse2,

        # Install Azure CLI in the distro. Default is false.
        [Parameter()]
        [switch] $EnableAzCli,

        # Install AKS CLI in the distro. Default is false. This will also install Azure CLI in the distro.
        [Parameter()]
        [switch] $EnableAksCli,

        # Install Helm in the distro. Default is false.
        [Parameter()]
        [switch] $EnableHelm,

        # Install SQL Server in the distro. Default is false. NOTE: Not implemented yet.
        [Parameter()] # TODO
        [switch] $EnableSqlServer,

        # Install Node.js in the distro. Default is false.
        [Parameter()]
        [switch] $EnableNodejs,

        # Install GitHub CLI in the distro. Default is false.
        [Parameter()]
        [switch] $EnableGhcli,

        # Enable SSH server in the distro and set listen port. It is not recommended to use port 22. Specify a port higher than 1024 and less than 65000. Default is none and SSH server is not enabled. Ensure the port is unique among all distros on this machine.
        [Parameter()]
        [int] $SshPort,

        # SSH authorized keys to add to the distro. Default is none. Specify list of public key file paths or http(s) URL or public key strings. SSH Server is not enabled by default. SSH Port parameter must be specified to enable SSH server.
        [Parameter()]
        [string[]] $SshAuthorizedKeys = @(),

        # Enable all features. Default is false. SSH Server is not enabled with this parameter. Please use SSH Port parameter explicitly to enable SSH server.
        [Parameter()]
        [switch] $EnableAll
    )

    if ( -not ( Test-Path -Path $Path -PathType Container ) ) {
        $null = New-Item -Path $Path -ItemType Directory -ErrorAction Stop
    }

    if ( $EnableAll ) {
        $CreateNssDb = $true
        $EnableDocker = $true
        $EnableAzureP2SVpnClient = $true
        $EnableSqlcmdGo = $true
        $EnableMsSqlTools18 = $true
        $EnablePwsh = $true
        $EnableAzPowershell = $true
        $EnableDotnet8Sdk = $true
        $EnableVscode = $true
        $EnableAzCopy = $true
        $EnableBlobFuse2 = $true
        $EnableAzCli = $true
        $EnableAksCli = $true
        $EnableHelm = $true
        $EnableNodejs = $true
        $EnableGhcli = $true
    }

    if ( $AzureP2SVpnProfiles) {
        $EnableAzureP2SVpnClient = $true
    }

    if ( $EnableAzureP2SVpnClient ) {
        $DisableWslu = $false
    }

    if ( $EnableSqlServer ) {
        throw "EnableSqlServer is not implmented yet"
    }

    if ( $UserShell -eq '/usr/bin/pwsh' -or $PowershellModules -or $EnableAzPowershell ) {
        $EnablePwsh = $true
    }

    if ( $EnableVscode ) {
        $CreateNssDb = $true
    }

    if ( $EnableAksCli ) {
        $EnableAzCli = $true
    }

    if ( $SshPort ) {
        $DisableSystemD = $false
    }

    $return = @{
        locale = $Locale
        user = @{
            name = $Username
            shell = $UserShell
            groups = @(
                if ( $EnableDocker ) {
                    "docker"
                }
            )
        }
        apt = @{
            sources = @{}
        }
        package_update = $true
        packages = @(
            "keychain"
            if ( $CreateNssDb ) {
                "libnss3-tools"
            }
            if ( -not $DisableWslu ) {
                "wslu"
                "gnome-keyring"
            }
            if ( $EnableDocker ) {
                "docker-ce"
                "docker-ce-cli"
                "containerd.io"
                "docker-buildx-plugin"
                "docker-compose-plugin"
            }
            if ( $EnableAzureP2SVpnClient ) {
                "microsoft-azurevpnclient"
            }
            if ( $EnableSqlcmdGo ) {
                "sqlcmd"
            }
            if ( $EnableMsSqlTools18 ) {
                "unixodbc-dev"
            }
            if ( $EnablePwsh ) {
                "powershell"
            }
            if ( $EnableDotnet8Sdk ) {
                "dotnet-sdk-8.0"
            }
            if ( $EnableVscode ) {
                "code"
            }
            if ( $EnableAzCopy ) {
                "azcopy"
            }
            if ( $EnableBlobFuse2 ) {
                "blobfuse2"
            }
            if ( $EnableAzCli ) {
                "azure-cli"
            }
            if ( $EnableHelm ) {
                "helm"
            }
            if ( $EnableNodejs ) {
                "nodejs"
            }
            if ( $EnableGhcli ) {
                "gh"
            }
            if ( $SshPort ) {
                "openssh-server"
            }
        )
        runcmd = @(
            if ( $CreateNssDb ) {
                "mkdir -p /home/$Username/.pki/nssdb"
                "chmod 750 /home/$Username/.pki/nssdb"
                "chmod 750 /home/$Username/.pki"
                "certutil -d sql:/home/$Username/.pki/nssdb -N --empty-password"
                'for f in /usr/local/share/ca-certificates/cloud*; do certutil -d sql:/home/{0}/.pki/nssdb -A -t "CT,c,c" -n $(basename $f .crt) -i $f; done' -f $Username
                "chown -R ${Username}:${Username} /home/$Username/.pki"
            }
            if ( $EnableMsSqlTools18 ) {
                "ACCEPT_EULA=Y apt-get install --yes mssql-tools18"
            }
            if ( $EnableAzPowershell ) {
                "pwsh -Command 'Install-module -Name Az.Tools.Installer -Scope Allusers -Force'"
                "pwsh -Command 'Install-AzModule -Repository PSGallery -Scope Allusers -Force'"
                "pwsh -Command 'Install-Module -Name Az.Tools.Predictor -Scope Allusers -Force'"
            }
            if ( $PowershellModules ) {
                "pwsh -Command 'Install-Module -Name $( $PowershellModules -join ',') -Scope Allusers -Force'"
            }
            if ( $EnableAksCli ) {
                "az aks install-cli"
            }
            if ( $SshPort ) {
                "systemctl daemon-reload"
                "systemctl restart ssh.socket"
            }
        )
        write_files = @(
            @{
                path = "/usr/local/bin/startkeepalive"
                owner = "root:root"
                permissions = "0755"
                append = $false
                content = @(
                    "#!/bin/bash"
                    "keychain -q"
                    ""
                ) -join "`n"
            }
            @{
                path = "/usr/local/bin/stopkeepalive"
                owner = "root:root"
                permissions = "0755"
                append = $false
                content = @(
                    "#!/bin/bash"
                    "keychain --stop all"
                    ""
                ) -join "`n"
            }
            @{
                path = "/etc/wsl.conf"
                owner = "root:root"
                permissions = "0644"
                append = $false
                content = @(
                    "[user]"
                    "default=$Username"
                    ""
                    "[network]"
                    "hostname = $Hostname"
                    ""

                    if ( -not $DisableSystemD ) {
                        "[boot]"
                        "systemd = true"
                        ""
                    }

                    if ( $DisableAppendWinPath ) {
                        "[interop]"
                        "appendWindowsPath = false"
                        ""
                    }
                ) -join "`n"
            }
            @{
                path = "/etc/wsl-distribution.conf"
                owner = "root:root"
                permissions = "0644"
                append = $false
                content = @(
                    if ( $DistroIcon ) {
                        "[shortcut]"
                        "icon = /usr/lib/wsl/distro.ico"
                        ""
                    }
                ) -join "`n"
            }
            if ( $DistroIcon) {
                @{
                    path = "/usr/lib/wsl/distro.ico"
                    owner = "root:root"
                    permissions = "0644"
                    append = $false
                    encoding = 'gzip+base64'
                    content = ConvertTo-GzipBase64 -Source $DistroIcon
                }
            }
            if ( $EnableVscode ) {
                @{
                    path = "/etc/profile.d/vscode.sh"
                    owner = "root:root"
                    permissions = "0644"
                    append = $false
                    content = @(
                        "export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt"
                        "export DONT_PROMPT_WSL_INSTALL=1"
                        ""
                    ) -join "`n"
                }
            }
            if ( $EnableAzureP2SVpnClient ) {
                @{
                    path = "/usr/local/bin/azvpn"
                    owner = "root:root"
                    permissions = "0755"
                    append = $false
                    content = @(
                        "#!/bin/bash"
                        "sudo /usr/local/bin/azvpnroot.bash"
                        ""
                    ) -join "`n"
                }
                @{
                    path = "/usr/local/bin/azvpnroot.bash"
                    owner = "root:root"
                    permissions = "0700"
                    append = $false
                    content = @(
                        '#!/bin/bash'
                        'if pgrep -f microsoft-azurevpnclient > /dev/null 2>&1'
                        'then'
                        '  echo "Already running"'
                        '  exit 1'
                        'fi'
                        ''
                        'mkdir -p $HOME/.xdg_runtime_dir'
                        'export XDG_RUNTIME_DIR=$HOME/.xdg_runtime_dir'
                        'export GALLIUM_DRIVER=d3d12'
                        ''
                        'if pgrep -u root -f gnome-keyring-daemon > /dev/null 2>&1'
                        'then'
                        '  echo "gnome-keyring-daemon already running"'
                        'else'
                        '  rm -fr ~/.local/share/keyrings/'
                        '  rm -fr ~/.cache/keyring-*'
                        '  cat /dev/urandom | tr -dc "a-zA-Z0-9" | head -c 20 | gnome-keyring-daemon --replace --unlock'
                        'fi'
                        ''
                        'nohup /opt/microsoft/microsoft-azurevpnclient/microsoft-azurevpnclient > /tmp/azvpn.log 2>&1 &'
                        ''
                    ) -join "`n"
                }
            }
            if ( $AzureP2SVpnProfiles ) {
                $AzureP2SVpnProfiles = $AzureP2SVpnProfiles | ForEach-Object -Process {
                    if ( $_ -is [string] ) {
                        if ( $_ -like 'http*' ) {
                            $FileBytes = ( Invoke-WebRequest -Uri $Source -Erroraction Stop ).Content
                        } elseif ( Test-Path -Path $_ ) {
                            $FileBytes = Get-Content -Path $_ -Raw
                        } else {
                            $FileBytes = $_
                        }
                        $XmlObj = [xml]$FileBytes
                    } elseif ( $_ -is [xml] ) {
                        $XmlObj = $_
                        $FileBytes = $XmlObj.OuterXml
                    } else {
                        throw "Invalid AzureP2SVpnProfiles type"
                    }
                    @{
                        profile = @{
                            path = "/home/root/.config/microsoft-azurevpnclient/profiles/$($XmlObj.AzVpnProfile.name)"
                            owner = "root:root"
                            permissions = "0644"
                            append = $false
                            content = $FileBytes
                        }
                        flutter = @(
                            "{server_name: $($XmlObj.AzVpnProfile.name)"
                            "fqdn: $($XmlObj.AzVpnProfile.serverlist.ServerEntry.fqdn)"
                            "profile_file_path: /root/$($XmlObj.AzVpnProfile.name).xml"
                            "profile_file_name: $($XmlObj.AzVpnProfile.name).xml"
                            "server_secret: $($XmlObj.AzVpnProfile.servervalidation.serversecret)"
                            "auth_type: $($XmlObj.AzVpnProfile.clientauth.type)"
                            "tenant: $($XmlObj.AzVpnProfile.clientauth.aad.tenant)"
                            "audience: $($XmlObj.AzVpnProfile.clientauth.aad.audience)"
                            "issuer: $($XmlObj.AzVpnProfile.clientauth.aad.issuer)"
                            "cert_hash: $($XmlObj.AzVpnProfile.servervalidation.Cert.hash)"
                            "cert_public_data_file_path: "
                            "cert_public_data_file_name: "
                            "cert_private_key_file_path: "
                            "cert_private_key_file_name: "
                            "is_highly_available: true"
                            "last_logged_user: "
                            "msal_cache: "
                            "cert_passphrase: "
                            "profile_data: "
                            "status: }"
                        ) -join ', '
                    }
                }

                $AzureP2SVpnProfiles |
                Select-Object -ExpandProperty profile

                @{
                    path = "/root/.local/share/microsoft-azurevpnclient/shared_preferences.json"
                    owner = "root:root"
                    permissions = "0644"
                    append = $false
                    content = '{{"flutter.profiles":["{0}"]}}' -f $(
                        $AzureP2SVpnProfiles | Join-String -Property flutter -Separator '","'
                    )
                }
            }

            if ( $SshPort ) {
                @{
                    path = "/etc/systemd/system/ssh.socket.d/listen.conf"
                    owner = "root:root"
                    permissions = "0644"
                    append = $false
                    content = @(
                        "[Socket]"
                        "ListenStream="
                        "ListenStream=$SshPort"
                        ""
                    ) -join "`n"
                }
            }
        )
    }

    if ( $EnableDocker ) {
        $return.apt.sources.docker = @{
            source = 'deb [arch=amd64 signed-by=$KEY_FILE] https://download.docker.com/linux/ubuntu $RELEASE stable'
            keyid = '9DC858229FC7DD38854AE2D88D81803C0EBFCD88'
        }
    }

    if ( $EnableAzureP2SVpnClient -or $EnableSqlcmdGo ) {
        $return.apt.sources.msjammy = @{
            source = 'deb [arch=amd64 signed-by=$KEY_FILE] https://packages.microsoft.com/ubuntu/22.04/prod jammy main'
            keyid = 'BC528686B50D79E339D3721CEB3E94ADBE1229CF'
        }
    }

    if ( $EnableMsSqlTools18 -or $EnablePwsh -or $EnableAzCopy -or $EnableBlobFuse2 ) {
        $return.apt.sources.msnoble = @{
            source = 'deb [arch=amd64 signed-by=$KEY_FILE] https://packages.microsoft.com/ubuntu/24.04/prod noble main'
            keyid = 'BC528686B50D79E339D3721CEB3E94ADBE1229CF'
        }
    }

    if ( $EnableVscode ) {
        $return.apt.sources.msvscode = @{
            source = 'deb [arch=amd64 signed-by=$KEY_FILE] https://packages.microsoft.com/repos/code stable main'
            keyid = 'BC528686B50D79E339D3721CEB3E94ADBE1229CF'
        }
    }

    if ( $EnableAzCli ) {
        $return.apt.sources.msazurecli = @{
            source = 'deb [arch=amd64 signed-by=$KEY_FILE] https://packages.microsoft.com/repos/azure-cli noble main'
            keyid = 'BC528686B50D79E339D3721CEB3E94ADBE1229CF'
        }
    }

    if ( $EnableHelm ) {
        $return.apt.sources.helm = @{
            source = 'deb [arch=amd64 signed-by=$KEY_FILE] https://baltocdn.com/helm/stable/debian/ all main'
            keyid = '81BF832E2F19CD2AA0471959294AC4827C1A168A'
        }
    }
    # gpg --show-keys helm.gpg

    if ( $EnableNodejs ) {
        $return.apt.sources.nodejs = @{
            source = 'deb [arch=amd64 signed-by=$KEY_FILE] https://deb.nodesource.com/node_22.x nodistro main'
            keyid = '6F71F525282841EEDAF851B42F59B5F99B1BE0B4'
        }
    }

    if ( $EnableGhcli ) {
        $return.apt.sources.ghcli = @{
            source = 'deb [arch=amd64 signed-by=$KEY_FILE] https://cli.github.com/packages stable main'
            keyid = '2C6106201985B60E6C7AC87323F3D4EA75716059'
        }
    }

    if ( $TrustedCaCerts ) {
        $return.ca_certs = @{}
        $return.ca_certs.trusted = @(
            $TrustedCaCerts | ForEach-Object -process {
                $s = $_
                Get-ChildItem -Path cert:/CurrentUser/Root |
                Where-Object -FilterScript { $_.Subject -like "*$s*" -or $_.Thumbprint -eq $_ } |
                ForEach-Object -Process {
                    @(
                        "-----BEGIN CERTIFICATE-----"
                        ConvertTo-GzipBase64 -Source ( $_.Export( 'Cert' ) ) -NoCompress -InsertLineBreaks
                        "-----END CERTIFICATE-----"
                        ""
                    ) -join "`n"
                }
            }
        )
    }

    if ( $SshAuthorizedKeys ) {
        $return.ssh_authorized_keys = @(
            $SshAuthorizedKeys | ForEach-Object -Process {
                if ( Test-Path -Path $_ ) {
                    Get-Content -Path $_ -Raw
                } else {
                    $_
                }
            }
        )
    }

    if ( -not $return.user.groups ) { $return.user.Remove('groups') }
    if ( -not $return.apt.sources ) { $return.apt.Remove('apt') }
    if ( -not $return.packages ) { $return.Remove('packages') }
    if ( -not $return.runcmd ) { $return.Remove('runcmd') }
    if ( -not $return.write_files ) { $return.Remove('write_files') }

    [System.IO.File]::WriteAllLines(
        "$Path/$Name.user-data",
        $("#cloud-config`n$( ( $return | ConvertTo-Json -Depth 5 ) -replace "`r`n", "`n" )"),
        $(New-Object System.Text.UTF8Encoding($False))
    )

    if ( $SshPort ) {
        Set-Content -Path "$HOME/.ssh/config_$Name" -Value $(
            @(
                "Host $Name"
                "  HostName localhost"
                "  User $Username"
                "  Port $SshPort"
                if ( $SshAuthorizedKeys ) {
                    $FirstPublicKey = Get-Item -Path $SshAuthorizedKeys[0]
                    "  IdentityFile $( ( Join-Path -Path $FirstPublicKey.DirectoryName -ChildPath $FirstPublicKey.BaseName ) )"
                }
                ""
            ) -join "`n"
        ) -Encoding utf8NoBOM
    }
}

<#
.SYNOPSIS
    Creates a custom WSL distro.

.DESCRIPTION
    Creates a custom WSL distro. It uses a cloud-init user data file to configure the distro. The user data file can be created using New-WslCloudInitUserData.

.EXAMPLE
    New-WslCustomDistro --Name 'MyDistro' --UserDataFile 'C:\path\to\MyDistro.user-data'

    Creates a custom distro named MyDistro using the user data file MyDistro.user-data.
#>
function New-WslCustomDistro {
    [CmdletBinding()]
    param (
        # Name of the distro.
        [Parameter(Position = 0, Mandatory = $true)]
        [Alias('Distro')]
        [string] $Name,

        # User data file to configure the distro.
        [Parameter(Position = 1)]
        [Alias('UserData')]
        [string] $UserDataFile = "$HOME/.cloud-init/$Name.user-data",

        # Root filesystem archive file to use for the distro.
        [Parameter(Position = 2)]
        [Alias('Rootfs')]
        [string] $RootfsFile =
            'https://cloud-images.ubuntu.com/wsl/releases/noble/current/ubuntu-noble-wsl-amd64-wsl.rootfs.tar.gz'
    )

    # $HOME/.cloud-init should exist. If not create it.
    if ( -not ( Test-Path -Path "$HOME/.cloud-init" -PathType Container ) ) {
        $null = New-Item -Path "$HOME/.cloud-init" -ItemType Directory -ErrorAction Stop
    }

    # If User data file starts with http(s) download it to $HOME/.cloud-init/$Name.user-data.
    # If User data file is a valid file copy it to $HOME/.cloud-init/$Name.
    # If $HOME/.cloud-init/$Name.user-data exists no action required.
    # else throw error.
    $Outfile = "$HOME/.cloud-init/$Name.user-data"
    if ( $UserDataFile -like 'http*' ) {
        Invoke-WebRequest -Uri $UserDataFile -OutFile $Outfile -ErrorAction Stop
    } elseif ( ( Test-Path -Path $UserDataFile ) -and ( $UserDataFile -ne $Outfile ) ) {
        Copy-Item -Path $UserDataFile -Destination $Outfile -ErrorAction Stop
    } elseif ( ( Test-Path -Path $UserDataFile ) -and ( $UserDataFile -eq $Outfile ) ) {
        # Do nothing
    } else {
        throw "$UserDataFile is not a valid file or URL"
    }

    # if Rootfs file starts with http(s) cmd is cmd /c "curl -s $RootfsFile | wsl.exe --install --from-file - $Name"
    # if RootFs file is valid path cmd is wsl.exe --install --from-file $RootfsFile $Name
    # else throw error.
    if ( $RootfsFile -like 'http*' ) {
        &"cmd" "/c" "`"curl -s $RootfsFile | wsl.exe --install --from-file - --name $Name`""
        if ( $LASTEXITCODE -ne 0 ) {
            throw "Failed to install distro $Name"
        }
    } elseif ( Test-Path -Path $RootfsFile ) {
        Invoke-WslExe -OutputEncoding UnicodeEncoding --install --from-file $RootfsFile --name $Name -ErrorAction Stop
    } else {
        throw "$RootfsFile is not a valid file or URL"
    }

    # Wait for cloud-init to finish
    Invoke-WslCommand -DistributionName $Name -User root -ErrorAction Stop cloud-init status --wait

    # Stop the distro
    Stop-WslDistro -Distro $Name
}