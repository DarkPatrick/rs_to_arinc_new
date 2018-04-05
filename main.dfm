object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Transmitter (v1.1.0)'
  ClientHeight = 588
  ClientWidth = 792
  Color = clBtnFace
  Constraints.MaxHeight = 627
  Constraints.MaxWidth = 808
  Constraints.MinHeight = 627
  Constraints.MinWidth = 808
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object receive_data_block: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 600
    TabOrder = 0
    object rcv_dat_lbl: TLabel
      Left = 10
      Top = 1
      Width = 153
      Height = 19
      Caption = #1055#1088#1080#1085#1103#1090#1099#1077' '#1076#1072#1085#1085#1099#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object received_data: TStringGrid
      Left = 10
      Top = 380
      Width = 380
      Height = 210
      ColCount = 3
      FixedColor = clGradientActiveCaption
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goThumbTracking]
      ParentFont = False
      TabOrder = 0
      OnClick = received_dataClick
      OnKeyPress = received_dataKeyPress
      ColWidths = (
        64
        64
        64)
      RowHeights = (
        24
        24)
    end
    object rcv_dat_info: TStringGrid
      Left = 10
      Top = 40
      Width = 135
      Height = 330
      ColCount = 2
      FixedColor = clGradientActiveCaption
      FixedCols = 0
      RowCount = 12
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
      ScrollBars = ssNone
      TabOrder = 1
      OnKeyPress = rcv_dat_infoKeyPress
      OnSetEditText = rcv_dat_infoSetEditText
      ColWidths = (
        64
        64)
      RowHeights = (
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24)
    end
    object cp_data_btn: TButton
      Left = 155
      Top = 81
      Width = 80
      Height = 25
      Caption = #1055#1077#1088#1077#1073#1088#1086#1089#1080#1090#1100
      TabOrder = 2
      OnClick = cp_data_btnClick
    end
    object rcv_serv_cmd: TLabeledEdit
      Left = 155
      Top = 50
      Width = 80
      Height = 21
      EditLabel.Width = 89
      EditLabel.Height = 13
      EditLabel.Caption = #1057#1095#1105#1090#1095#1080#1082#1080' '#1082#1086#1084#1072#1085#1076
      TabOrder = 3
      OnChange = rcv_serv_cmdChange
      OnContextPopup = rcv_serv_cmdContextPopup
      OnKeyDown = rcv_serv_cmdKeyDown
      OnKeyPress = rcv_serv_cmdKeyPress
    end
    object rcv_dat_str: TStringGrid
      Left = 10
      Top = 500
      Width = 100
      Height = 35
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
    object com_settings_block: TPanel
      Left = 155
      Top = 112
      Width = 235
      Height = 118
      TabOrder = 5
      object com_open_btn: TButton
        Left = 145
        Top = 55
        Width = 80
        Height = 25
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1086#1088#1090
        TabOrder = 0
        OnClick = com_open_btnClick
      end
      object com_close_btn: TButton
        Left = 145
        Top = 85
        Width = 80
        Height = 25
        Caption = #1047#1072#1082#1088#1099#1090#1100' '#1087#1086#1088#1090
        TabOrder = 1
        OnClick = com_close_btnClick
      end
      object speed_select: TRadioGroup
        Left = 10
        Top = 38
        Width = 100
        Height = 80
        Caption = #1042#1099#1073#1086#1088' '#1089#1082#1086#1088#1086#1089#1090#1080
        Enabled = False
        ItemIndex = 1
        Items.Strings = (
          '115200'
          '921600')
        TabOrder = 2
      end
      object chose_ports: TButton
        Left = 145
        Top = 15
        Width = 80
        Height = 25
        Caption = #1055#1086#1088#1090#1099
        TabOrder = 3
        OnClick = chose_portsClick
      end
    end
    object stop_reading_btn: TButton
      Left = 155
      Top = 306
      Width = 110
      Height = 25
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1095#1090#1077#1085#1080#1077
      TabOrder = 6
      OnClick = stop_reading_btnClick
    end
    object cont_reading_btn: TButton
      Left = 155
      Top = 341
      Width = 110
      Height = 25
      Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100' '#1095#1090#1077#1085#1080#1077
      TabOrder = 7
      OnClick = cont_reading_btnClick
    end
    object clr_rcv_hist_btn: TButton
      Left = 280
      Top = 341
      Width = 110
      Height = 25
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1080#1089#1090#1086#1088#1080#1102
      TabOrder = 8
      OnClick = clr_rcv_hist_btnClick
    end
    object mem_log: TMemo
      Left = 300
      Top = 50
      Width = 90
      Height = 21
      TabOrder = 9
      Visible = False
    end
    object load_data_btn: TButton
      Left = 155
      Top = 236
      Width = 110
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      TabOrder = 10
      OnClick = load_data_btnClick
    end
    object show_filter_btn: TButton
      Left = 155
      Top = 271
      Width = 110
      Height = 25
      Caption = #1054#1090#1086#1073#1088#1072#1079#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
      TabOrder = 11
      OnClick = show_filter_btnClick
    end
    object get_arinc_btn: TButton
      Left = 271
      Top = 236
      Width = 119
      Height = 25
      Caption = #1087#1088#1080#1105#1084' '#1087#1072#1082#1077#1090#1086#1074' arinc'
      TabOrder = 12
      OnClick = get_arinc_btnClick
    end
    object info_btn: TButton
      Left = 300
      Top = 1
      Width = 90
      Height = 43
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1085#1086#1084' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1077
      TabOrder = 13
      WordWrap = True
      OnClick = info_btnClick
    end
  end
  object send_data_block: TPanel
    Left = 400
    Top = 0
    Width = 400
    Height = 600
    TabOrder = 1
    object trm_dat_lbl: TLabel
      Left = 10
      Top = 1
      Width = 175
      Height = 19
      Caption = #1055#1077#1088#1077#1076#1072#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object sended_data: TStringGrid
      Left = 10
      Top = 380
      Width = 380
      Height = 210
      ColCount = 3
      FixedColor = clSkyBlue
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goThumbTracking]
      ParentFont = False
      TabOrder = 0
      OnClick = sended_dataClick
      OnKeyPress = sended_dataKeyPress
      ColWidths = (
        64
        64
        64)
      RowHeights = (
        24
        24)
    end
    object trm_dat_info: TStringGrid
      Left = 10
      Top = 40
      Width = 135
      Height = 330
      ColCount = 2
      FixedColor = clGradientActiveCaption
      FixedCols = 0
      RowCount = 12
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      ScrollBars = ssNone
      TabOrder = 1
      OnKeyPress = trm_dat_infoKeyPress
      OnSetEditText = trm_dat_infoSetEditText
      ColWidths = (
        64
        64)
      RowHeights = (
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24)
    end
    object cl_trm_btn: TButton
      Left = 155
      Top = 341
      Width = 90
      Height = 25
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1083#1103
      TabOrder = 2
      OnClick = cl_trm_btnClick
    end
    object send_pack_btn: TButton
      Left = 304
      Top = 40
      Width = 86
      Height = 25
      Caption = #1055#1086#1089#1083#1072#1090#1100' '#1087#1072#1082#1077#1090
      TabOrder = 3
      OnClick = send_pack_btnClick
    end
    object trm_serv_cmd: TLabeledEdit
      Left = 155
      Top = 50
      Width = 100
      Height = 21
      EditLabel.Width = 89
      EditLabel.Height = 13
      EditLabel.Caption = #1057#1095#1105#1090#1095#1080#1082#1080' '#1082#1086#1084#1072#1085#1076
      TabOrder = 4
      OnChange = trm_serv_cmdChange
      OnContextPopup = trm_serv_cmdContextPopup
      OnKeyDown = trm_serv_cmdKeyDown
      OnKeyPress = trm_serv_cmdKeyPress
    end
    object trm_dat_str: TStringGrid
      Left = 10
      Top = 500
      Width = 100
      Height = 35
      ColCount = 1
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      TabOrder = 5
      Visible = False
      ColWidths = (
        64)
      RowHeights = (
        24)
    end
    object clr_trm_hist_btn: TButton
      Left = 280
      Top = 341
      Width = 110
      Height = 25
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1080#1089#1090#1086#1088#1080#1102
      TabOrder = 6
      OnClick = clr_trm_hist_btnClick
    end
    object arinc_set_block: TPanel
      Left = 155
      Top = 81
      Width = 235
      Height = 250
      TabOrder = 7
      object arinc_ch_num: TComboBox
        Left = 10
        Top = 10
        Width = 105
        Height = 21
        TabOrder = 0
        Text = #1074#1099#1073#1086#1088' '#1082#1072#1085#1072#1083#1072
        Items.Strings = (
          '1-'#1099#1081' ('#1074#1099#1093#1086#1076')'
          '2-'#1086#1081' ('#1074#1099#1093#1086#1076')'
          '3-'#1080#1081' ('#1074#1099#1093#1086#1076')'
          '4-'#1099#1081' ('#1074#1099#1093#1086#1076')'
          '1-'#1099#1081' ('#1074#1093#1086#1076')'
          '2-'#1086#1081' ('#1074#1093#1086#1076')'
          '3-'#1080#1081' ('#1074#1093#1086#1076')'
          '4-'#1099#1081' ('#1074#1093#1086#1076')'
          '5-'#1099#1081' ('#1074#1093#1086#1076')'
          '6-'#1086#1081' ('#1074#1093#1086#1076')'
          '7-'#1086#1081' ('#1074#1093#1086#1076')'
          '8-'#1086#1081' ('#1074#1093#1086#1076')')
      end
      object arinc_ch_en: TRadioGroup
        Left = 10
        Top = 41
        Width = 60
        Height = 75
        ItemIndex = 0
        Items.Strings = (
          #1074#1082#1083'.'
          #1074#1099#1082#1083'.')
        TabOrder = 1
      end
      object arinc_ch_freq: TRadioGroup
        Left = 80
        Top = 41
        Width = 110
        Height = 75
        Caption = #1042#1099#1073#1086#1088' '#1095#1072#1089#1090#1086#1090#1099', '#1082#1043#1094
        ItemIndex = 0
        Items.Strings = (
          '100'
          '50'
          '12,5')
        TabOrder = 2
      end
      object send_arinc_set_btn: TButton
        Left = 150
        Top = 10
        Width = 75
        Height = 25
        Caption = #1055#1086#1089#1083#1072#1090#1100
        TabOrder = 3
        OnClick = send_arinc_set_btnClick
      end
      object arinc_parity_en: TRadioGroup
        Left = 10
        Top = 126
        Width = 180
        Height = 40
        Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1073#1080#1090#1072' '#1095#1105#1090#1085#1086#1089#1090#1080
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          #1074#1082#1083'.'
          #1074#1099#1082#1083'.')
        TabOrder = 4
      end
      object arinc_parity_type: TRadioGroup
        Left = 10
        Top = 176
        Width = 180
        Height = 40
        Caption = #1058#1080#1087' '#1095#1105#1090#1085#1086#1089#1090#1080
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          #1095#1105#1090'.'
          #1085#1077#1095#1105#1090'.')
        TabOrder = 5
      end
    end
  end
  object com_port: TComPort
    BaudRate = br115200
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    StoredProps = [spBasic]
    TriggersOnRxChar = True
    OnRxChar = com_portRxChar
    OnException = com_portException
    Left = 8
    Top = 48
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
    Left = 8
    Top = 152
  end
  object open_dialog: TOpenDialog
    InitialDir = '.'
    Left = 8
    Top = 96
  end
  object Timer2: TTimer
    Interval = 511
    OnTimer = Timer2Timer
    Left = 8
    Top = 208
  end
  object Timer3: TTimer
    Interval = 1
    OnTimer = Timer3Timer
    Left = 8
    Top = 264
  end
end
