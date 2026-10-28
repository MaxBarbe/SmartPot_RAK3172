Sub Main
    Dim p As String, msg As String
    On Error GoTo Failed
    p = GetProjectPath("Project")
    If Not SelectTreeItem("Farfields\farfield (f=0.868) [1]") Then Err.Raise 5020, , "868 MHz farfield missing"
    With FarfieldPlot
        .Reset
        .Plottype "3d"
        .Step 2
        .Step2 2
        .SetPlotMode "realized gain"
        .SetScaleLinear False
        .SelectComponent "Abs"
        .Plot
    End With
    Open p & "_radiation.txt" For Output As #1
    Print #1, "FREQUENCY_GHZ=0.868"
    Print #1, "EFFICIENCIES_ARE_DB=1"
    Print #1, "RADIATION_EFFICIENCY_NATIVE=" & CStr(FarfieldPlot.GetRadiationEfficiency)
    Print #1, "TOTAL_EFFICIENCY_NATIVE=" & CStr(FarfieldPlot.GetTotalEfficiency)
    Print #1, "REALIZED_GAIN_MAX_DB=" & CStr(FarfieldPlot.Getmax)
    Print #1, "RADIATED_POWER_W=" & CStr(FarfieldPlot.GetTRP)
    FarfieldPlot.SetPlotMode "directivity"
    FarfieldPlot.Plot
    Print #1, "DIRECTIVITY_MAX_DBI=" & CStr(FarfieldPlot.Getmax)
    FarfieldPlot.SetPlotMode "gain"
    FarfieldPlot.Plot
    Print #1, "GAIN_MAX_DBI=" & CStr(FarfieldPlot.Getmax)
    Close #1
    FarfieldPlot.SetPlotMode "realized gain"
    FarfieldPlot.Plot
    With ASCIIExport
        .Reset
        .FileName p & "_farfield_realized_gain.txt"
        .Execute
    End With
    Save
    Exit Sub
Failed:
    msg = CStr(Err.Number) & " " & Err.Description
    Open p & "_radiation_error.log" For Append As #2
    Print #2, msg
    Close #2
End Sub
