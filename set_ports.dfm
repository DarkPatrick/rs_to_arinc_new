object Form4: TForm4
  Left = 0
  Top = 0
  Caption = #1042#1099#1073#1086#1088' '#1087#1086#1088#1090#1086#1074
  ClientHeight = 198
  ClientWidth = 202
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object port_num1: TComboBox
    Left = 47
    Top = 50
    Width = 100
    Height = 21
    TabOrder = 0
    Text = #8470' '#1087#1086#1088#1090#1072
    OnClick = port_num1Click
  end
  object port_num2: TComboBox
    Left = 47
    Top = 110
    Width = 100
    Height = 21
    TabOrder = 1
    Text = #8470' '#1087#1086#1088#1090#1072
    Visible = False
    OnChange = port_num2Change
  end
  object set_control: TCheckBox
    Left = 47
    Top = 80
    Width = 100
    Height = 17
    Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
    TabOrder = 2
    OnClick = set_controlClick
  end
  object Button1: TButton
    Left = 15
    Top = 150
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 110
    Top = 150
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
    OnClick = Button2Click
  end
end
