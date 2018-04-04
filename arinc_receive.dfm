object arinc_rec: Tarinc_rec
  Left = 0
  Top = 0
  Caption = #1087#1088#1080#1105#1084'/'#1087#1077#1088#1077#1076#1072#1095#1072' '#1076#1072#1085#1085#1099#1093' '#1087#1086' arinc'
  ClientHeight = 573
  ClientWidth = 922
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
  object get_data_label: TLabel
    Left = 15
    Top = 8
    Width = 154
    Height = 24
    Caption = #1055#1088#1080#1105#1084' '#1076#1072#1085#1085#1099#1093
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object send_data_label: TLabel
    Left = 520
    Top = 8
    Width = 187
    Height = 24
    Caption = #1055#1077#1088#1077#1076#1072#1095#1072' '#1076#1072#1085#1085#1099#1093
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object arinc_chnl: TLabeledEdit
    Left = 423
    Top = 57
    Width = 80
    Height = 21
    EditLabel.Width = 70
    EditLabel.Height = 13
    EditLabel.Caption = #1053#1086#1084#1077#1088' '#1082#1072#1085#1072#1083#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnKeyPress = arinc_chnlKeyPress
  end
  object arinc_addr: TLabeledEdit
    Left = 301
    Top = 57
    Width = 100
    Height = 21
    EditLabel.Width = 92
    EditLabel.Height = 13
    EditLabel.Caption = #1040#1076#1088#1077#1089#1072' '#1091#1089#1090#1088#1086#1081#1089#1090#1074
    TabOrder = 1
    OnKeyPress = arinc_addrKeyPress
  end
  object data_grid: TStringGrid
    Left = 15
    Top = 96
    Width = 386
    Height = 400
    ColCount = 3
    DefaultColWidth = 120
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
    ParentFont = False
    TabOrder = 2
    OnDrawCell = data_gridDrawCell
    ColWidths = (
      120
      120
      120)
    RowHeights = (
      24
      24)
  end
  object apply_btn: TButton
    Left = 423
    Top = 103
    Width = 80
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    TabOrder = 3
    OnClick = apply_btnClick
  end
  object data_s_grid: TStringGrid
    Left = 520
    Top = 96
    Width = 386
    Height = 400
    ColCount = 3
    DefaultColWidth = 120
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goTabs, goThumbTracking]
    TabOrder = 4
    OnKeyPress = data_s_gridKeyPress
    ColWidths = (
      120
      120
      120)
    RowHeights = (
      24
      24)
  end
  object arinc_send_addr: TLabeledEdit
    Left = 520
    Top = 57
    Width = 105
    Height = 21
    EditLabel.Width = 106
    EditLabel.Height = 13
    EditLabel.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1089#1099#1083#1086#1082
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 5
    OnKeyPress = arinc_send_addrKeyPress
  end
  object interval_val: TLabeledEdit
    Left = 736
    Top = 57
    Width = 170
    Height = 21
    EditLabel.Width = 165
    EditLabel.Height = 13
    EditLabel.Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1084#1077#1078#1076#1091' '#1087#1086#1089#1099#1083#1082#1072#1084#1080' ('#1084#1089')'
    TabOrder = 6
    OnKeyPress = interval_valKeyPress
  end
  object stop_send_btn: TButton
    Left = 520
    Top = 502
    Width = 121
    Height = 25
    Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1077#1088#1077#1076#1072#1095#1080
    TabOrder = 7
    OnClick = stop_send_btnClick
  end
  object cont_send_btn: TButton
    Left = 784
    Top = 502
    Width = 122
    Height = 25
    Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100' '#1087#1077#1088#1077#1076#1072#1095#1080
    Enabled = False
    TabOrder = 8
    OnClick = cont_send_btnClick
  end
  object clr_snd_btn: TButton
    Left = 664
    Top = 502
    Width = 89
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1083#1077
    TabOrder = 9
    OnClick = clr_snd_btnClick
  end
  object clr_rcv_btn: TButton
    Left = 152
    Top = 502
    Width = 89
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1083#1077
    TabOrder = 10
    OnClick = clr_rcv_btnClick
  end
end
