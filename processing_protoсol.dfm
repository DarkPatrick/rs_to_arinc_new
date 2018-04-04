object Form2: TForm2
  Left = 0
  Top = 0
  Caption = #1060#1080#1083#1100#1090#1088#1072#1094#1080#1103' '#1087#1088#1080#1085#1103#1090#1099#1093' '#1087#1072#1082#1077#1090#1086#1074
  ClientHeight = 547
  ClientWidth = 528
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
  object arinc_protocol: TStringGrid
    Left = 0
    Top = 0
    Width = 525
    Height = 250
    FixedColor = clGradientActiveCaption
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
    ScrollBars = ssVertical
    TabOrder = 0
    ColWidths = (
      84
      94
      75
      143
      103)
    RowHeights = (
      24
      24)
  end
  object add_filter_btn: TButton
    Left = 0
    Top = 256
    Width = 100
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
    TabOrder = 1
    OnClick = add_filter_btnClick
  end
  object filter_param: TStringGrid
    Left = 0
    Top = 287
    Width = 525
    Height = 250
    ColCount = 2
    FixedColor = clGradientActiveCaption
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
    ScrollBars = ssVertical
    TabOrder = 2
    ColWidths = (
      258
      245)
    RowHeights = (
      24
      24)
  end
  object del_filter_btn: TButton
    Left = 367
    Top = 256
    Width = 100
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
    TabOrder = 3
    OnClick = del_filter_btnClick
  end
  object filters_info: TStringGrid
    Left = 168
    Top = 256
    Width = 100
    Height = 25
    ColCount = 1
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    ScrollBars = ssNone
    TabOrder = 4
    Visible = False
    ColWidths = (
      64)
    RowHeights = (
      24)
  end
end
