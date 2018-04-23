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
    Width = 89
    Height = 21
    EditLabel.Width = 57
    EditLabel.Height = 13
    EditLabel.Caption = #1042#1077#1088#1089#1080#1103' '#1055#1054':'
    TabOrder = 0
    OnContextPopup = dev_numContextPopup
    OnKeyDown = dev_numKeyDown
    OnKeyPress = dev_numKeyPress
  end
  object board_num: TLabeledEdit
    Left = 116
    Top = 24
    Width = 89
    Height = 21
    EditLabel.Width = 70
    EditLabel.Height = 13
    EditLabel.Caption = #1053#1086#1084#1077#1088' '#1087#1083#1072#1090#1099':'
    TabOrder = 1
  end
  object pins_state: TLabeledEdit
    Left = 16
    Top = 80
    Width = 121
    Height = 21
    EditLabel.Width = 98
    EditLabel.Height = 13
    EditLabel.Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1074#1093#1086#1076#1086#1074':'
    TabOrder = 2
  end
end
