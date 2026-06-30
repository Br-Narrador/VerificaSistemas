Invoke-Command  {
        $LoadPercentage = Get-WmiObject win32_processor | Select-Object -exp LoadPercentage
        $freemem = Get-WmiObject -Class Win32_OperatingSystem

        $totalDisks = (Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object DriveType -eq 3).Count

        $totalSpace = Get-WmiObject win32_LogicalDisk | Select-Object Size, FreeSpace, DeviceID, VolumeName
        ""
        "System Name      : {0}" -f $freemem.csname
        "Total Memory (GB): {0}" -f ([math]::round($freemem.TotalVisibleMemorySize / 1mb))
        "Free Memory  (MB): {0}" -f ([math]::round($freemem.FreePhysicalMemory / 1024, 2))
        "CPU Load %       : {0}" -f $LoadPercentage
        ""
        for ($i = 0; $i -le $totalDisks - 1; $i++) {
            "Volume Name : {0}" -f $totalSpace.VolumeName[$i]
            "Total Space (GB) : {0}" -f ([math]::Round($totalSpace.Size[$i] / 1gb, 2))
            "Free Disk (GB)   : {0}" -f ([math]::Round($totalSpace.FreeSpace[$i] / 1gb, 2))     
            ""
        }

        ""    
}