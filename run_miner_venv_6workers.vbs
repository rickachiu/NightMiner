Set WshShell = CreateObject("WScript.Shell")
ScriptDir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
WshShell.Run "powershell -ExecutionPolicy Bypass -File """ & ScriptDir & "\stop_miner.ps1""", 0, True
WScript.Sleep 2000
WshShell.Run "cmd /c cd /d """ & ScriptDir & """ && .venv\Scripts\python.exe miner.py --workers 6", 0, False
Set WshShell = Nothing
