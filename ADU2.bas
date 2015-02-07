'--------------------------------------------------------------
'                   Thomas Jensen | uCtrl.net
'--------------------------------------------------------------
'  file: ALARM_DISABLING_UNIT_2 v1.0
'  date: 19/05/2007
'--------------------------------------------------------------
$regfile = "attiny2313.dat"
$crystal = 8000000
Config Watchdog = 1024
Config Portb = Output
Config Portd = Input

'input D
'PD.0 Reset button
'PD.1 Stack lights signal

'output B
'PB.0 Red LED
'PB.1 Power LED
'PB.2 Stack lights relay N.O

Dim A As Byte
Dim Lifesignal As Integer
Dim Lystaarn_delay As Integer
Dim Reset_aktiv As Bit
Dim Led As Integer

Lifesignal = 11
Lystaarn_delay = 20
Reset_aktiv = 0
Led = 0

Portb = 0

Portb.1 = Not Portb.0                                       'boot
For A = 1 To 10
    Portb.0 = Not Portb.0
    Waitms 200
Next A

Portb = 0

Waitms 1000

Start Watchdog

Main:
'no longer alarm situation
If Lystaarn_delay = 0 Then
   Reset_aktiv = 0
   Portb.2 = 0
   End If

'stack light status
If Pind.1 = 0 Then Lystaarn_delay = 20
If Lystaarn_delay > 0 Then Decr Lystaarn_delay

'alarm triggered, reset possible
If Lystaarn_delay > 0 And Pind.0 = 1 Then Reset_aktiv = 1

'set red led
If Lystaarn_delay > 0 Then
   If Reset_aktiv = 0 And Led = 0 Then
      Led = 5
      Portb.2 = 0
   End If
   If Reset_aktiv = 1 Then
      Led = 5
      Portb.2 = 1
   End If
End If

'handle red led
If Led > 0 Then Decr Led
If Led = 4 Then Portb.0 = 1
If Led = 2 Then Portb.0 = 0

'lifesignal
If Lifesignal > 0 Then Lifesignal = Lifesignal - 1
If Lifesignal = 3 Then Portb.1 = 1
If Lifesignal = 1 Then Portb.1 = 0
If Lifesignal = 0 Then Lifesignal = 11

Reset Watchdog
Waitms 100
Goto Main
End