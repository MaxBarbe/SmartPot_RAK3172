Sub Main
    Dim p As String, z As Variant, msg As String
    On Error GoTo Failed
    p = GetProjectPath("Project")
    If InStr(p, "SmartPot_V4_U112_TD_M2_2019") = 0 Then Err.Raise 5030, , "Wrong mesh variant"
    Group.Add "V4_RF_path", "mesh"
    Group.AddItem "solid$Cuivre_f_cu:region_019", "V4_RF_path"
    Group.AddItem "solid$Cuivre_f_cu:RF_V4_lower_0", "V4_RF_path"
    Group.AddItem "solid$Cuivre_f_cu:RF_V4_lower_1", "V4_RF_path"
    Group.AddItem "solid$Cuivre_f_cu:region_021", "V4_RF_path"
    Group.Add "V4_RF_contacts", "mesh"
    Group.AddItem "solid$RF_Components:R4_contact_1", "V4_RF_contacts"
    Group.AddItem "solid$RF_Components:R4_contact_2", "V4_RF_contacts"
    Group.AddItem "solid$RF_Components:R4_zero_ohm_link", "V4_RF_contacts"
    Group.AddItem "solid$RF_Components:R6_contact_1", "V4_RF_contacts"
    Group.AddItem "solid$RF_Components:R6_contact_2", "V4_RF_contacts"
    Group.AddItem "solid$RF_Components:R6_zero_ohm_link", "V4_RF_contacts"
    With MeshSettings
        .SetMeshType "Hex"
        .Set "MinStepGeometryX", "0.5"
        .Set "MinStepGeometryY", "0.5"
        .Set "MinStepGeometryZ", "0.015"
        .Set "StepsPerWaveNear", "10"
        .Set "StepsPerBoxNear", "10"
        With .ItemMeshSettings("solid$Substrat:FR4")
            .SetMeshType "Hex"
            .Set "UseForRefinement", "1"
            .Set "UseStepAndExtend", "1"
            .Set "UseSameStepWidthXYZ", "0"
            .Set "Step", "0", "0", "0.05"
        End With
        With .ItemMeshSettings("group$V4_RF_path")
            .SetMeshType "Hex"
            .Set "UseForRefinement", "1"
            .Set "UseStepAndExtend", "1"
            .Set "UseSameStepWidthXYZ", "0"
            .Set "Step", "0.18", "0.18", "0"
        End With
        With .ItemMeshSettings("group$V4_RF_contacts")
            .SetMeshType "Hex"
            .Set "UseForRefinement", "1"
            .Set "UseStepAndExtend", "1"
            .Set "UseSameStepWidthXYZ", "0"
            .Set "Step", "0.18", "0.18", "0"
        End With
        With .ItemMeshSettings("solid$Cuivre_f_cu:RF_V4_upper_0")
            .SetMeshType "Hex"
            .Set "UseForRefinement", "1"
            .Set "UseStepAndExtend", "1"
            .Set "UseSameStepWidthXYZ", "0"
            .Set "Step", "0.4", "0.4", "0"
        End With
    End With
    For Each z In Array(0.66975, 0.73325)
        Mesh.AddAutomeshFixpoint False, False, True, 57.925, -71.965, CDbl(z)
    Next
    Mesh.Update
    Save
    Open p & "_mesh.log" For Append As #1
    Print #1, "CELLS=" & CStr(Mesh.GetNumberOfMeshCells)
    Print #1, "PORT_GRID_LENGTH=" & CStr(DiscretePort.GetGridLength(1))
    Close #1
    If Mesh.GetNumberOfMeshCells > 1000000 Then Err.Raise 5031, , "Teaching license mesh limit exceeded"
    If Abs(DiscretePort.GetGridLength(1) - 0.127) > 0.000001 Then Err.Raise 5032, , "Unexpected port grid length in mm; inspect native mesh audit for cell count"
    Exit Sub
Failed:
    msg = CStr(Err.Number) & " " & Err.Description
    Open p & "_mesh.log" For Append As #1
    Print #1, "ERROR=" & msg
    Close #1
End Sub
