Sub Main
    Dim p As String, msg As String, code As String, ok As Boolean
    On Error GoTo Failed
    p = GetProjectPath("Project")
    If InStr(p, "SmartPot_V5_R6L4p3_C6C3p9_TD_M2_2019") = 0 Then Err.Raise 5100, , "Wrong V5 project"
    If Solid.GetNumberOfShapes <> 559 Then Err.Raise 5101, , "Unexpected input geometry"
    If LumpedElement.StartLumpedElementNameIteration() <> 0 Then Err.Raise 5102, , "Unexpected existing matching elements"
    StoreParameter "V5_L_nH", 4.3
    StoreParameter "V5_C_pF", 3.9
    code = "Solid.Delete ""RF_Components:R6_zero_ohm_link""" & vbCrLf
    code = code & "Pick.ClearAllPicks" & vbCrLf
    code = code & "With LumpedElement" & vbCrLf
    code = code & ".Reset" & vbCrLf
    code = code & ".SetName ""R6_SERIES_L""" & vbCrLf
    code = code & ".Folder ""V5_matching""" & vbCrLf
    code = code & ".SetType ""rlcserial""" & vbCrLf
    code = code & ".SetR 0" & vbCrLf
    code = code & ".SetL ""V5_L_nH*1e-9""" & vbCrLf
    code = code & ".SetC 0" & vbCrLf
    code = code & ".SetP1 False, 53.175, -63.3, 0.975" & vbCrLf
    code = code & ".SetP2 False, 54.825, -63.3, 0.975" & vbCrLf
    code = code & ".SetRadius 0" & vbCrLf
    code = code & ".SetMonitor True" & vbCrLf
    code = code & ".Create" & vbCrLf
    code = code & "End With" & vbCrLf
    code = code & "With LumpedElement" & vbCrLf
    code = code & ".Reset" & vbCrLf
    code = code & ".SetName ""C6_SHUNT_C""" & vbCrLf
    code = code & ".Folder ""V5_matching""" & vbCrLf
    code = code & ".SetType ""rlcserial""" & vbCrLf
    code = code & ".SetR 0" & vbCrLf
    code = code & ".SetL 0" & vbCrLf
    code = code & ".SetC ""V5_C_pF*1e-12""" & vbCrLf
    code = code & ".SetP1 False, 56.25, -63.3, 0.8" & vbCrLf
    code = code & ".SetP2 False, 56.25, -64.85, 0.8" & vbCrLf
    code = code & ".SetRadius 0" & vbCrLf
    code = code & ".SetMonitor True" & vbCrLf
    code = code & ".Create" & vbCrLf
    code = code & "End With" & vbCrLf
    ok = AddToHistory("V5 assembly proposal: R6 series 4.3nH and C6 shunt 3.9pF", code)
    If Not ok Then Err.Raise 5103, , "V5 matching history failed"
    If Solid.GetNumberOfShapes <> 558 Then Err.Raise 5104, , "R6 conductor was not removed correctly"
    If LumpedElement.StartLumpedElementNameIteration() <> 2 Then Err.Raise 5105, , "V5 requires two matching elements"
    ChangeSolverType "HF Time Domain"
    Solver.MaximumNumberOfThreads 4
    Solver.FrequencyRange "0.7", "1"
    Solver.SteadyStateLimit "-50"
    Mesh.Update
    Save
    Open p & "_construction.log" For Append As #1
    Print #1, "SHAPES=" & CStr(Solid.GetNumberOfShapes)
    Print #1, "LUMPED_ELEMENTS=" & CStr(LumpedElement.StartLumpedElementNameIteration())
    Print #1, "CELLS=" & CStr(Mesh.GetNumberOfMeshCells)
    Print #1, "PORT_GRID_LENGTH_MM=" & CStr(DiscretePort.GetGridLength(1))
    Close #1
    If Mesh.GetNumberOfMeshCells > 1000000 Then Err.Raise 5106, , "Teaching licence mesh limit"
    Exit Sub
Failed:
    msg = CStr(Err.Number) & " " & Err.Description
    Open p & "_construction.log" For Append As #2
    Print #2, "ERROR=" & msg
    Close #2
End Sub
