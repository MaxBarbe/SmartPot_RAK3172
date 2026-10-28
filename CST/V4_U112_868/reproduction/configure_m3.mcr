Sub Main
    Dim p As String, msg As String
    On Error GoTo Failed
    p = GetProjectPath("Project")
    If InStr(p,"SmartPot_V4_U112_TD_M3_2019") = 0 Then Err.Raise 5040, , "Wrong V4 mesh variant"
    With MeshSettings
        .SetMeshType "Hex"
        With .ItemMeshSettings("group$V4_RF_path")
            .SetMeshType "Hex"
            .Set "Step", "0.15", "0.15", "0"
        End With
        With .ItemMeshSettings("group$V4_RF_contacts")
            .SetMeshType "Hex"
            .Set "Step", "0.15", "0.15", "0"
        End With
        With .ItemMeshSettings("solid$Substrat:FR4")
            .SetMeshType "Hex"
            .Set "Step", "0", "0", "0.043"
        End With
    End With
    Mesh.Update
    Save
    Open p & "_mesh.log" For Append As #1
    Print #1,"CELLS=" & CStr(Mesh.GetNumberOfMeshCells)
    Print #1,"PORT_GRID_LENGTH_MM=" & CStr(DiscretePort.GetGridLength(1))
    Close #1
    If Mesh.GetNumberOfMeshCells > 1000000 Then Err.Raise 5041, , "Teaching-license mesh limit exceeded"
    Exit Sub
Failed:
    msg = CStr(Err.Number) & " " & Err.Description
    Open p & "_mesh.log" For Append As #1
    Print #1,"ERROR=" & msg
    Close #1
End Sub
