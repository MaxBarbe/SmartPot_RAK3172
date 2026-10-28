Option Explicit
Dim app, model, fso, expected
Set fso = CreateObject("Scripting.FileSystemObject")
Set app = CreateObject("CSTStudio.Application.2019")
Set model = app.OpenFile(WScript.Arguments(0))
If model Is Nothing Then Set model = app.Active3D
If model Is Nothing Then WScript.Quit 10
expected = fso.BuildPath(fso.GetParentFolderName(fso.GetAbsolutePathName(WScript.Arguments(0))), fso.GetBaseName(WScript.Arguments(0)))
If StrComp(model.GetProjectPath("Project"), expected, vbTextCompare) <> 0 Then WScript.Quit 11
If model.Solid.GetNumberOfShapes <> 558 Then WScript.Quit 12
WScript.Echo "PROJECT=" & model.GetProjectPath("Project")
model.RunScript WScript.Arguments(1)
WScript.Echo "MACRO_RETURNED"
