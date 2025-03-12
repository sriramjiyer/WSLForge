# WSLForge

This module is a collection of functions to manage WSL system and distros. It utilizes Ubuntu cloud images and cloud-init to create and manage WSL distros.

Most functions are wrapper to wsl.exe. Some wsl.exe commands return Unicode (UTF16) encoded strings and others return UTF8 encoded strings. These functions convert output appropriately. These wrapper functions also provide tab expansion with psreadline.

This module also facilitates creating custom distros. This is done by first creating a cloud init user data file in users windows home folder. This file is read by Ubuntu distro on first boot and configures the distro as specified in it. Ubuntu WSL root filesystem image is then fetched from Ubuntu cloud image repository and installed using wsl.exe. New distro is then started and status of cloud-init is monitored till completion. Upon successful completion of cloud-init the distro is terminated so that the new configuration will go into effect when the user logins to the newly configured distro. Please see [help for New-WslCloudInitUserData function](https://github.com/sriramjiyer/WSLForge/tree/main/docs/New-WslCloudInitUserData.md) for all the customization that can be done.

If customization not implemented by this function is required then the generated cloud-init file can be edited to add those customizations. Please refer to [cloud-init documentation](https://cloudinit.readthedocs.io/en/24.1/index.html) for details. Please note these modifications have to be done before creating the distro. Most, if not all the configuration are done at time of first boot.

## Quick Start

Install module from PSGallery.

```powershell
Install-Module -Scope CurrentUser -Name WSLForge -Force
```

Install WSL system without default distro. Accept elevation if prompted.

```powershell
Install-WslSystem
```

Update WSL system to latest version.

```powershell
Update-WslSystem
```

Create a cloud-init file for a new Custom distro with pwsh as login shell and prerequisite powershell installed.

```powershell
New-WslCloudInitUserData -UserShell /usr/bin/pwsh
```

Create the distribution.

```powershell
New-WslCustomDistro
```

Connect to the newly installed distro

```powershell
Enter-WslDistro -Name 'CustomDistro'
```

## Next Steps

Documentation of each funtion can be accessed using standard powershell methods.

```powershell
Import-Module -Name WSLForge
Get-Command -Module WSLForge

Get-Help -Full -Name Install-WSLSystem # Or any other command 
```

It is also available [online](https://github.com/sriramjiyer/WSLForge/tree/main/docs/WSLForge.md).
