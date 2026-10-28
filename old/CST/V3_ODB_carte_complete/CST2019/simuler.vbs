Option Explicit
Dim app, model, fso, macroPath
If WScript.Arguments.Count <> 1 Then
    WScript.Echo "Usage: cscript //nologo simuler.vbs chemin_absolu_du_projet.cst"
    WScript.Quit 1
End If
Set fso = CreateObject("Scripting.FileSystemObject")
macroPath = fso.BuildPath(fso.GetParentFolderName(WScript.ScriptFullName), "lancer_S11.mcr")
Set app = CreateObject("CSTStudio.Application.2019")
Set model = app.OpenFile(fso.GetAbsolutePathName(WScript.Arguments(0)))
If model Is Nothing Then WScript.Quit 2
model.RunScript macroPath
