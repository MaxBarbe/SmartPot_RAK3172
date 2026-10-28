Option Explicit
Dim app, model, fso, input, title, code, line, ok, expected
Set fso = CreateObject("Scripting.FileSystemObject")
If fso.FileExists(WScript.Arguments(1)) Then WScript.Quit 10
Set app = CreateObject("CSTStudio.Application.2019")
Set model = app.OpenFile(WScript.Arguments(0))
If model Is Nothing Then Set model = app.Active3D
If model Is Nothing Then WScript.Quit 11
expected = fso.BuildPath(fso.GetParentFolderName(fso.GetAbsolutePathName(WScript.Arguments(0))), fso.GetBaseName(WScript.Arguments(0)))
If StrComp(model.GetProjectPath("Project"), expected, vbTextCompare) <> 0 Then WScript.Quit 12
If model.Solid.GetNumberOfShapes <> 557 And model.Solid.GetNumberOfShapes <> 559 Then WScript.Quit 13
model.SaveAs WScript.Arguments(1), False
model.DeleteResults
WScript.Sleep 5000
If WScript.Arguments.Count > 3 Then
    Set input = fso.OpenTextFile(WScript.Arguments(3), 1, False, -1)
    title = ""
    code = ""
    Do Until input.AtEndOfStream
        line = input.ReadLine
        If Left(line, 12) = "@@CST_JOB@@ " Then
            If title <> "" Then RunBlock
            title = Mid(line, 13)
            code = ""
        Else
            code = code & line & vbCrLf
        End If
    Loop
    If title <> "" Then RunBlock
    input.Close
    If model.Solid.GetNumberOfShapes <> 559 Then WScript.Quit 15
    model.Save
End If
model.RunScript WScript.Arguments(2)
model.Save
WScript.Echo "VARIANT_SAVED=" & model.GetProjectPath("Project")

Sub RunBlock
    ok = model.AddToHistory(title, code)
    If Not ok Then
        WScript.Echo "HISTORY_FAILED=" & title
        WScript.Quit 14
    End If
End Sub
