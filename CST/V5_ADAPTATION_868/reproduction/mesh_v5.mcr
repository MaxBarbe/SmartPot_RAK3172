Sub Main
Dim p As String, msg As String
On Error GoTo Failed
p=GetProjectPath("Project")
If InStr(p,"SmartPot_V5_")=0 Then Err.Raise 5120,,"Wrong project"
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
.Set "MinStepGeometryZ", "0.015"
With .ItemMeshSettings("solid$Cuivre_f_cu:region_019")
.SetMeshType "Hex"
.Set "UseForRefinement", "1"
.Set "UseStepAndExtend", "1"
.Set "UseSameStepWidthXYZ", "0"
.Set "Step", "0.18", "0.18", "0"
End With
With .ItemMeshSettings("solid$Cuivre_f_cu:region_021")
.SetMeshType "Hex"
.Set "UseForRefinement", "1"
.Set "UseStepAndExtend", "1"
.Set "UseSameStepWidthXYZ", "0"
.Set "Step", "0.18", "0.18", "0"
End With
With .ItemMeshSettings("solid$Cuivre_f_cu:RF_V4_lower_0")
.SetMeshType "Hex"
.Set "UseForRefinement", "1"
.Set "UseStepAndExtend", "1"
.Set "UseSameStepWidthXYZ", "0"
.Set "Step", "0.18", "0.18", "0"
End With
With .ItemMeshSettings("solid$Cuivre_f_cu:RF_V4_lower_1")
.SetMeshType "Hex"
.Set "UseForRefinement", "1"
.Set "UseStepAndExtend", "1"
.Set "UseSameStepWidthXYZ", "0"
.Set "Step", "0.18", "0.18", "0"
End With
With .ItemMeshSettings("solid$RF_Components:R4_contact_1")
.SetMeshType "Hex"
.Set "UseForRefinement", "1"
.Set "UseStepAndExtend", "1"
.Set "UseSameStepWidthXYZ", "0"
.Set "Step", "0.18", "0.18", "0"
End With
With .ItemMeshSettings("solid$RF_Components:R4_contact_2")
.SetMeshType "Hex"
.Set "UseForRefinement", "1"
.Set "UseStepAndExtend", "1"
.Set "UseSameStepWidthXYZ", "0"
.Set "Step", "0.18", "0.18", "0"
End With
With .ItemMeshSettings("solid$RF_Components:R6_contact_1")
.SetMeshType "Hex"
.Set "UseForRefinement", "1"
.Set "UseStepAndExtend", "1"
.Set "UseSameStepWidthXYZ", "0"
.Set "Step", "0.18", "0.18", "0"
End With
With .ItemMeshSettings("solid$RF_Components:R6_contact_2")
.SetMeshType "Hex"
.Set "UseForRefinement", "1"
.Set "UseStepAndExtend", "1"
.Set "UseSameStepWidthXYZ", "0"
.Set "Step", "0.18", "0.18", "0"
End With
With .ItemMeshSettings("solid$RF_Components:R4_zero_ohm_link")
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
With .ItemMeshSettings("solid$Substrat:FR4")
.SetMeshType "Hex"
.Set "UseForRefinement", "1"
.Set "UseStepAndExtend", "1"
.Set "UseSameStepWidthXYZ", "0"
.Set "Step", "0", "0", "0.05"
End With
End With
Mesh.SetParallelMesherMode "Hex", "none"
Mesh.SetMaxParallelMesherThreads "Hex", 1
Mesh.Automesh True
Mesh.UseRatioLimit False
Mesh.MergeThinPECLayerFixpoints True
Mesh.AddAutomeshFixpoint True,True,False,57.925,-71.965,0.8
Mesh.Update
Save
Open p & "_mesh.log" For Append As #1
Print #1,"CELLS=" & CStr(Mesh.GetNumberOfMeshCells)
Print #1,"PORT_GRID_LENGTH_MM=" & CStr(DiscretePort.GetGridLength(1))
Close #1
If Mesh.GetNumberOfMeshCells>1000000 Then Err.Raise 5121,,"Licence limit"
If Abs(DiscretePort.GetGridLength(1)-0.127)>0.000001 Then Err.Raise 5122,,"Port gap invalid"
Exit Sub
Failed:
msg=CStr(Err.Number) & " " & Err.Description
Open p & "_mesh.log" For Append As #2
Print #2,"ERROR=" & msg
Close #2
End Sub
