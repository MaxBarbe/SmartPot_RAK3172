' * Calcul S11 du projet actif - CST 2019
Sub Main
    Dim result As Boolean
    Dim prefix As String, errorMessage As String
    prefix = GetProjectPath("Project")
    On Error GoTo Failed
    Open prefix & "_simulation.log" For Append As #1
    Print #1, "START " & CStr(Now)
    Close #1
    Mesh.SetParallelMesherMode "Hex", "none"
    Mesh.SetMaxParallelMesherThreads "Hex", 1
    Solver.MaximumNumberOfThreads 1
    result = Solver.Start
    Open prefix & "_simulation.log" For Append As #1
    Print #1, "SOLVER_RETURN=" & CStr(result) & " " & CStr(Now)
    Close #1
    Save
    If result And SelectTreeItem("1D Results\S-Parameters\S1,1") Then
        Plot1D.PlotView "magnitudedb"
        Plot1D.Plot
        With ASCIIExport
            .Reset
            .FileName prefix & "_S11.txt"
            .Execute
        End With
        Plot1D.ExportBitmap 1600, 900, prefix & "_S11.bmp"
    End If
    Exit Sub
Failed:
    errorMessage = CStr(Err.Number) & " " & Err.Description
    Open prefix & "_simulation.log" For Append As #1
    Print #1, "ERROR=" & errorMessage
    Close #1
End Sub
