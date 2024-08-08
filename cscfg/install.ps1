# In order to be able to run scripts, you need to run "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"

$cfgPath = 'C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\core\cfg'

Write-Output "`nCopying crosshairs files...`n"
Copy-Item -Verbose -Force -Path "$PWD" -Filter ch*cfg -Destination $cfgPath

Write-Output "`nCopying practices files...`n"
Copy-Item -Verbose -Force -Path -Filter practice*.cfg $cfgPath

Write-Output "`nCopying autoexec file...`n"
Copy-Item -Verbose -Force -Path autoexec.cfg $cfgPath
