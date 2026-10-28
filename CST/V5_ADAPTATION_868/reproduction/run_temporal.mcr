' * Temporal antenna sweep, preliminary mesh
Sub Main
    Dim prefix As String, result As Boolean, v As Variant, msg As String
    prefix = GetProjectPath("Project")
    On Error GoTo Failed
    If GetSolverType() <> "HF Time Domain" Then Err.Raise 5001, , "Expected HF Time Domain solver"
    If Mesh.GetNumberOfMeshCells > 1000000 Then Err.Raise 5002, , "Mesh exceeds teaching-license cell limit"
    If Abs(DiscretePort.GetGridLength(1) - 0.127) > 0.000001 Then Err.Raise 5003, , "Unexpected V5 port length in mm"
    Open prefix & "_td.log" For Append As #1
    Print #1, "TD_START=" & CStr(Now)
    Print #1, "CELLS=" & CStr(Mesh.GetNumberOfMeshCells)
    Close #1
    result = Solver.Start
    Open prefix & "_td.log" For Append As #1
    Print #1, "TD_RETURN=" & CStr(result) & " " & CStr(Now)
    Close #1
    Save
    If result And SelectTreeItem("1D Results\S-Parameters\S1,1") Then
        For Each v In Array("real", "imaginary", "magnitudedb")
            Plot1D.PlotView v
            Plot1D.Plot
            With ASCIIExport
                .Reset
                .FileName prefix & "_S11_" & CStr(v) & ".txt"
                .Execute
            End With
        Next
        Plot1D.ExportBitmap 1600, 900, prefix & "_S11.bmp"
    End If
    Exit Sub
Failed:
    msg = CStr(Err.Number) & " " & Err.Description
    Open prefix & "_td.log" For Append As #1
    Print #1, "ERROR=" & msg
    Close #1
End Sub
