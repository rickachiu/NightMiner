Set WshShell = CreateObject("WScript.Shell")
' Get the directory where this script is located
ScriptDir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
' Change to the script directory and run python with 2 workers (MEDIUM mode)
WshShell.Run "cmd /c cd /d """ & ScriptDir & """ && python miner.py --workers 2", 0, False
Set WshShell = Nothing
