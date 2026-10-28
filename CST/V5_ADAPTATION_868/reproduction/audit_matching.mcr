Sub Main
    Dim p As String, item As String, typ As String, r As Double, l As Double, c As Double
    Dim gs As Double, io As Double, t As Double, rad As Double
    Dim x0 As Double, y0 As Double, z0 As Double, x1 As Double, y1 As Double, z1 As Double
    Dim n As Long, msg As String
    On Error GoTo Failed
    p=GetProjectPath("Project")
    If InStr(p,"SmartPot_V5_")=0 Then Err.Raise 5140,,"Wrong project"
    Open p & "_matching_audit.txt" For Output As #1
    n=LumpedElement.StartLumpedElementNameIteration()
    Print #1,"ELEMENT_COUNT=" & CStr(n)
    If n<>2 Then Err.Raise 5141,,"Expected two elements"
    Do While LumpedElement.GetNextLumpedElementName(item)
        If Not LumpedElement.GetProperties(item,typ,r,l,c,gs,io,t,rad) Then Err.Raise 5142,,"Properties unavailable"
        If Not LumpedElement.GetCoordinates(item,x0,y0,z0,x1,y1,z1) Then Err.Raise 5143,,"Coordinates unavailable"
        Print #1,"NAME=" & item
        Print #1,"TYPE=" & typ
        Print #1,"R_OHM=" & CStr(r)
        Print #1,"L_H=" & CStr(l)
        Print #1,"C_F=" & CStr(c)
        Print #1,"P1_MM=" & CStr(x0) & "," & CStr(y0) & "," & CStr(z0)
        Print #1,"P2_MM=" & CStr(x1) & "," & CStr(y1) & "," & CStr(z1)
        If InStr(item,"R6_SERIES_L")>0 Then
            If Abs(l-4.3e-9)>1e-18 Or c<>0 Or r<>0 Then Err.Raise 5144,,"Wrong series inductor"
        ElseIf InStr(item,"C6_SHUNT_C")>0 Then
            If Abs(c-3.9e-12)>1e-21 Or l<>0 Or r<>0 Then Err.Raise 5145,,"Wrong shunt capacitor"
        Else
            Err.Raise 5146,,"Unexpected element"
        End If
    Loop
    Print #1,"AUDIT_OK=1"
    Close #1
    Exit Sub
Failed:
    msg=CStr(Err.Number) & " " & Err.Description
    On Error Resume Next
    Close #1
    Open p & "_matching_error.txt" For Append As #2
    Print #2,msg
    Close #2
End Sub
