Set WshShell = CreateObject("WScript.Shell")
' Get the directory where this script is located
ScriptDir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
' Stop any existing miners first
WshShell.Run "powershell -ExecutionPolicy Bypass -File """ & ScriptDir & "\stop_miner.ps1""", 0, True
' Wait a moment for processes to fully terminate
WScript.Sleep 2000
' Change to the script directory and run python with 3 workers (BALANCED mode)
WshShell.Run "cmd /c cd /d """ & ScriptDir & """ && python miner.py --workers 3", 0, False
Set WshShell = Nothing
