function Enable-DiskCleanup {
<#
	.SYNOPSIS
		Enable the Disk Cleanup tool.

	.DESCRIPTION
		Enable the Disk Cleanup tool by copying files from WinSxS folder.
		Works for 
			Windows Server 2008 (32 and 64 bit)
			Windows Server 2008 R2
			Windows Server 2012
#>

	if ((test-path $env:SystemRoot\System32\cleanmgr.exe) -and (test-path $env:SystemRoot\System32\en-US\Cleanmgr.exe.mui)){
	    Write-Verbose "Files are already present. Run Disk Cleanup - Cleanmgr.exe"
	    break
	}
	$wmiOS = Get-WmiObject -Class Win32_OperatingSystem
	Write-Verbose $wmiOS.caption	
	Switch ($wmiOS){
	    ({([version]$_.version).Major -eq 6 -and ([version]$_.version).Minor -eq 1 -and $_ }) { 
	        $Version = "Windows Server 2008 R2"
	        break
	    }
	    ({([version]$_.version).Major -eq 6 -and ([version]$_.version).Minor -eq 1}) { 
	        $Version = "Windows 7"
	        break
	    }
	    ({([version]$_.version).Major -eq 6 -and ([version]$_.version).Minor -eq 0}) { 
	        $Version = "Windows Server 2008"
	        break
	    }
	    ({([version]$_.version).Major -eq 6 -and ([version]$_.version).Minor -eq 0}) { 
	        $Version = "Windows Vista"
	        break
	    }
	    ({([version]$_.version).Major -eq 6 -and ([version]$_.version).Minor -eq 2}) { 
	        $Version = "Windows Server 2012"
	        break
	    }
	    ({([version]$_.version).Major -eq 6 -and ([version]$_.version).Minor -eq 2}) { 
	        $Version = "Windows 8"
	        break
	    }
	    ({([version]$_.version).Major -eq 6 -and ([version]$_.version).Minor -eq 3}) { 
	        $Version = "Windows 8.1"
	        break
	    }
	    ({([version]$_.version).Major -eq 6 -and ([version]$_.version).Minor -eq 3}) { 
	        $Version = "Windows Server 2012 R2"
	        break
	    }
	    ({([version]$_.version).Major -eq 10 -and ([version]$_.version).Minor -eq 0}) { 
	        $Version = "Windows Server 2016"
	        break
	    }
	    ({([version]$_.version).Major -eq 10 -and ([version]$_.version).Minor -eq 0}) { 
	        $Version = "Windows 10"
	        break
	    }
	    ({([version]$_.version).Major -eq 5 -and ([version]$_.version).Minor -eq 2}) { 
	        $Version = "Windows Server 2003 R2"
	        break
	    }
	    ({([version]$_.version).Major -eq 5 -and ([version]$_.version).Minor -eq 2}) { 
	        $Version = "Windows XP 64-Bit"
	        break
	    }
	    ({([version]$_.version).Major -eq 5 -and ([version]$_.version).Minor -eq 1}) { 
	        $Version = "Windows XP"
	        break
	    }
	}
	$bitVersion = $wmios.OSArchitecture
	$Server = $wmios.Caption -like "*Windows*Server*"
	if ($server){    
	    switch ($version){
	        "Windows Server 2008 R2" {
	            $path_exe = "$env:SystemRoot\winsxs\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.1.7600.16385_none_c9392808773cd7da\cleanmgr.exe"
	            $path_mui = "$env:SystemRoot\winsxs\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.1.7600.16385_en-us_b9cb6194b257cc63\cleanmgr.exe.mui"
	            break
	        }
	        "Windows Server 2008" {
	            if ($bitVersion = '64-bit'){
	                $path_exe = "$env:SystemRoot\winsxs\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.0.6001.18000_none_c962d1e515e94269\cleanmgr.exe.mui"
	                $path_mui = "$env:SystemRoot\winsxs\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.0.6001.18000_en-us_b9f50b71510436f2\cleanmgr.exe.mui"
	            }
	            else{            
	                $path_exe = "$env:SystemRoot\winsxs\x86_microsoft-windows-cleanmgr_31bf3856ad364e35_6.0.6001.18000_none_6d4436615d8bd133\cleanmgr.exe"
	                $path_mui = "$env:SystemRoot\winsxs\x86_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.0.6001.18000_en-us_5dd66fed98a6c5bc\cleanmgr.exe.mui"
	            }
	            break
	        }    
	        "Windows Server 2012" {
	            $path_exe = "$env:SystemRoot\winsxs\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.2.9200.16384_none_c60dddc5e750072a\cleanmgr.exe"
	            $path_mui = "$env:SystemRoot\winsxs\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.2.9200.16384_en-us_b6a01752226afbb3\cleanmgr.exe.mui"
	            break
	        }
	        "Windows Server 2012 R2" {
	            Write-Warning "Must install Desktop Experience. Use Powershell command: Install-WindowsFeature Desktop-Experience"
	        }
	    }
	    if ($path_exe){        
	        try {
	            Copy-Item $path_exe $env:SystemRoot\System32\ -Force -ErrorAction Stop
	            Copy-Item $path_mui $env:SystemRoot\System32\en-US\ -Force -ErrorAction Stop
	        }
	        catch [System.UnauthorizedAccessException] {
	            Write-Warning "Run as administrator."
	            throw
	        }
	        catch {            
	            throw           
	        }
	        Write-Verbose "Run Disk Cleanup - Cleanmgr.exe"
	        return
	    }
	    else {
	        Write-Warning "OS $($wmiOS.caption) not supported"
	        return
	    }
	}
	else {
	    Write-Warning "Works only with Windows Server."
	}
}
