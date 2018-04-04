object info_form: Tinfo_form
  Left = 0
  Top = 0
  Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
  ClientHeight = 165
  ClientWidth = 213
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object dev_num: TLabeledEdit
    Left = 16
    Top = 24
    Width = 121
    Height = 21
    EditLabel.Width = 92
    EditLabel.Height = 13
    EditLabel.Caption = #1053#1086#1084#1077#1088' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072
    TabOrder = 0
    OnContextPopup = dev_numContextPopup
    OnKeyDown = dev_numKeyDown
    OnKeyPress = dev_numKeyPress
  end
end
