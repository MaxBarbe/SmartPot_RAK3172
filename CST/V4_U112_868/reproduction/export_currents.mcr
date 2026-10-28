Sub Main
    Dim p As String
    p = GetProjectPath("Project")
    If Not SelectTreeItem("2D/3D Results\Surface Current\surface current (f=0.868) [1]") Then Exit Sub
    With ASCIIExport
        .Reset
        .FileName p & "_RF_surface_current.txt"
        .Mode "FixedWidth"
        .StepX 0.2
        .StepY 0.2
        .StepZ 0.035
        .SetSubvolume 50, 60, -73, -50, 0.765, 1
        .UseSubvolume True
        .Execute
    End With
End Sub
