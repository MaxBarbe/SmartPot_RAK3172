Sub Main
    Dim p As String, z As Variant, c As Long, msg As String
    On Error GoTo Failed
    p = GetProjectPath("Project")
    If InStr(p, "SmartPot_V4_U112_TD_M1_2019") = 0 Then Err.Raise 5010, , "Wrong V4 project"
    ChangeSolverType "HF Time Domain"
    Solver.FrequencyRange "0.7", "1"
    Solver.MaximumNumberOfThreads 4
    Solver.StimulationPort "1"
    Solver.StimulationMode "All"
    Solver.SteadyStateLimit "-50"
    With Monitor
        .Reset
        .Name "farfield (f=0.868)"
        .Domain "frequency"
        .FieldType "Farfield"
        .Frequency "0.868"
        .Create
    End With
    With Monitor
        .Reset
        .Name "h-field (f=0.868)"
        .Domain "frequency"
        .FieldType "Hfield"
        .Frequency "0.868"
        .Create
    End With
    With MeshSettings
        .SetMeshType "Hex"
        .Set "Version", 1
        .Set "StepsPerWaveNear", "10"
        .Set "StepsPerWaveFar", "4"
        .Set "StepsPerBoxNear", "10"
        .Set "StepsPerBoxFar", "4"
        .Set "UseRatioLimitGeometry", "0"
        .Set "UseSameMinStepGeometryXYZ", "0"
        .Set "MinStepGeometryX", "0.5"
        .Set "MinStepGeometryY", "0.5"
        .Set "MinStepGeometryZ", "0.02"
        With .ItemMeshSettings("solid$Substrat:FR4")
            .SetMeshType "Hex"
            .Set "UseForRefinement", "1"
            .Set "UseStepAndExtend", "1"
            .Set "UseSameStepWidthXYZ", "0"
            .Set "Step", "0", "0", "0.0635"
        End With
    End With
    Mesh.SetParallelMesherMode "Hex", "none"
    Mesh.SetMaxParallelMesherThreads "Hex", 1
    Mesh.Automesh True
    Mesh.UseRatioLimit False
    Mesh.MergeThinPECLayerFixpoints True
    For Each z In Array(0, 0.197, 0.638, 0.7015, 0.765, 0.8, 1)
        Mesh.AddAutomeshFixpoint False, False, True, 57.925, -71.965, CDbl(z)
    Next
    Mesh.AddAutomeshFixpoint True, True, False, 57.925, -71.965, 0.8
    Mesh.Update
    c = Mesh.GetNumberOfMeshCells
    Save
    Open p & "_mesh.log" For Append As #1
    Print #1, "CELLS=" & CStr(c)
    Print #1, "PORT_LENGTH_MM=" & CStr(DiscretePort.GetLength(1))
    Print #1, "PORT_GRID_LENGTH=" & CStr(DiscretePort.GetGridLength(1))
    Close #1
    If c > 1000000 Then Err.Raise 5011, , "Teaching license mesh limit exceeded"
    If Abs(DiscretePort.GetGridLength(1) - 0.127) > 0.000001 Then Err.Raise 5012, , "Unexpected short-port grid length in mm"
    Exit Sub
Failed:
    msg = CStr(Err.Number) & " " & Err.Description
    Open p & "_mesh.log" For Append As #1
    Print #1, "ERROR=" & msg
    Close #1
End Sub
