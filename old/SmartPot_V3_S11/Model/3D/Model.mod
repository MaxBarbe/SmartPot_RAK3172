'# MWS Version: Version 2019.0 - Sep 20 2018 - ACIS 28.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0.75 fmax = 1
'# created = '[VERSION]2019.0|28.0.2|20180920[/VERSION]


'@ use template: Antenna - Mobile Phone_3.cfg

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "H"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "F"
End With

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "0.75", "1"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AutoMeshNumberOfShapeFaces "300"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

Solver.PrepareFarfields "False"

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "0.75;0.868;1"
Dim sDefineAtName As String
sDefineAtName = "0.75;0.868;1"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------




'@ import odbpp file: C:\Users\Etudiant_EEA_2026\Downloads\SmartPot_V3_CST_ODB.zip

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With LayoutDB
     .Reset 
     .SourceFileName "C:\Users\Etudiant_EEA_2026\Downloads\SmartPot_V3_CST_ODB.zip" 
     .LdbFileName "*SmartPot_V3_CST_ODB.ldb" 
     .PcbType "odbpp" 
     .KeepSynchronized "True" 
     .CreateDB 
     .LoadDB 
End With


'@ pick end point

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickEndpointFromId "SmartPot_V3_CST_ODB(PCB1)/Nets/GND:02_F.CU", "69" 


'@ pick end point

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickEndpointFromId "SmartPot_V3_CST_ODB(PCB1)/Nets/GND:02_F.CU", "68" 


