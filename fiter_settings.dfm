object Form3: TForm3
  Left = 0
  Top = 0
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1092#1080#1083#1100#1090#1088#1072
  ClientHeight = 91
  ClientWidth = 366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object filter_col: TComboBox
    Left = 0
    Top = 10
    Width = 100
    Height = 21
    TabOrder = 0
    Text = #1074#1099#1073#1086#1088' '#1089#1090#1086#1083#1073#1094#1072
    Items.Strings = (
      #1053#1086#1084#1077#1088' '#1082#1072#1085#1072#1083#1072
      #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
      #1048#1089#1090#1086#1095#1085#1080#1082
      #1044#1072#1085#1085#1099#1077
      #1052#1072#1090#1088#1080#1094#1072' '#1087#1088#1080#1079#1085#1072#1082#1072)
  end
  object filter_typ: TComboBox
    Left = 110
    Top = 10
    Width = 125
    Height = 21
    TabOrder = 1
    Text = #1074#1099#1073#1086#1088' '#1092#1080#1083#1100#1090#1088#1072
    Items.Strings = (
      #1073#1086#1083#1100#1096#1077
      #1084#1077#1085#1100#1096#1077
      #1088#1072#1074#1085#1086
      #1085#1077' '#1088#1072#1074#1085#1086
      #1089#1086#1076#1077#1088#1078#1080#1090
      #1085#1077' '#1089#1086#1076#1077#1088#1078#1080#1090
      #1085#1086#1084#1077#1088' '#1073#1080#1090#1072' '#1088#1072#1074#1077#1085' 0'
      #1085#1086#1084#1077#1088' '#1073#1080#1090#1072' '#1088#1072#1074#1077#1085' 1')
  end
  object filter_val: TEdit
    Left = 245
    Top = 10
    Width = 120
    Height = 21
    TabOrder = 2
  end
  object ok_btn: TButton
    Left = 0
    Top = 64
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = ok_btnClick
  end
  object cancel_btn: TButton
    Left = 290
    Top = 64
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
    OnClick = cancel_btnClick
  end
end
