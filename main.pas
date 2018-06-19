unit main;

interface

uses
    set_mutex, Winapi.Windows, Winapi.Messages, System.SysUtils,
    System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
    Vcl.Dialogs, StdCtrls, ExtCtrls, CPort, CPortCtl, Vcl.Grids, convertation,
    Vcl.MPlayer, System.Win.Registry, detect_ports, processing_protoсol,
    set_ports, arinc_receive, dev_info, string_numbers, crc, ShellAPI, StrUtils;

type
    TForm1 = class(TForm)
        com_port: TComPort;
        receive_data_block: TPanel;
        send_data_block: TPanel;
        received_data: TStringGrid;
        sended_data: TStringGrid;
        rcv_dat_info: TStringGrid;
        trm_dat_info: TStringGrid;
        cl_trm_btn: TButton;
        send_pack_btn: TButton;
        cp_data_btn: TButton;
        rcv_dat_lbl: TLabel;
        trm_dat_lbl: TLabel;
        rcv_serv_cmd: TLabeledEdit;
        trm_serv_cmd: TLabeledEdit;
        rcv_dat_str: TStringGrid;
        trm_dat_str: TStringGrid;
        com_settings_block: TPanel;
        com_open_btn: TButton;
        Timer1: TTimer;
        com_close_btn: TButton;
        stop_reading_btn: TButton;
        cont_reading_btn: TButton;
        clr_rcv_hist_btn: TButton;
        clr_trm_hist_btn: TButton;
        speed_select: TRadioGroup;
        mem_log: TMemo;
        arinc_set_block: TPanel;
        arinc_ch_num: TComboBox;
        arinc_ch_en: TRadioGroup;
        arinc_ch_freq: TRadioGroup;
        send_arinc_set_btn: TButton;
        load_data_btn: TButton;
        open_dialog: TOpenDialog;
        show_filter_btn: TButton;
        arinc_parity_en: TRadioGroup;
        arinc_parity_type: TRadioGroup;
        chose_ports: TButton;
        Timer2: TTimer;
        get_arinc_btn: TButton;
        Timer3: TTimer;
        info_btn: TButton;
        lbl_crc_errors: TLabel;
        lbl_lost_packets: TLabel;
        procedure formCreate(sender: TObject);
        procedure com_open_btnClick(sender: TObject);
        procedure com_portRxChar(sender: TObject; count: integer);
        procedure received_dataClick(sender: TObject);
        procedure sended_dataClick(sender: TObject);
        procedure rcv_serv_cmdChange(sender: TObject);
        procedure rcv_serv_cmdKeyPress(sender: TObject; var key: char);
        procedure trm_serv_cmdKeyPress(sender: TObject; var key: char);
        procedure trm_serv_cmdChange(sender: TObject);
        procedure cl_trm_btnClick(sender: TObject);
        procedure send_pack_btnClick(sender: TObject);
        procedure rcv_dat_infoKeyPress(sender: TObject; var key: char);
        procedure trm_dat_infoKeyPress(sender: TObject; var key: char);
        procedure rcv_dat_infoSetEditText(sender: TObject; ACol, ARow: integer;
          const value: string);
        procedure trm_dat_infoSetEditText(sender: TObject; ACol, ARow: integer;
          const value: string);
        procedure cp_data_btnClick(sender: TObject);
        procedure Timer1Timer(sender: TObject);
        procedure com_close_btnClick(sender: TObject);
        procedure stop_reading_btnClick(sender: TObject);
        procedure cont_reading_btnClick(sender: TObject);
        procedure clr_rcv_hist_btnClick(sender: TObject);
        procedure clr_trm_hist_btnClick(sender: TObject);
        procedure FormClose(sender: TObject; var action: TCloseAction);
        procedure received_dataKeyPress(sender: TObject; var key: char);
        procedure sended_dataKeyPress(sender: TObject; var key: char);
        procedure send_arinc_set_btnClick(sender: TObject);
        procedure load_data_btnClick(sender: TObject);
        procedure show_filter_btnClick(sender: TObject);
        procedure chose_portsClick(sender: TObject);
        procedure Timer2Timer(sender: TObject);
        procedure get_arinc_btnClick(sender: TObject);
        procedure com_portException(sender: TObject;
          TComException: TComExceptions; comportMessage: string;
          winError: Int64; winMessage: string);
        procedure info_btnClick(sender: TObject);
        procedure Timer3Timer(sender: TObject);
        procedure trm_serv_cmdContextPopup(sender: TObject; MousePos: TPoint;
          var Handled: Boolean);
        procedure rcv_serv_cmdContextPopup(sender: TObject; MousePos: TPoint;
          var Handled: Boolean);
        procedure rcv_serv_cmdKeyDown(sender: TObject; var key: Word;
          Shift: TShiftState);
        procedure trm_serv_cmdKeyDown(sender: TObject; var key: Word;
          Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure com_portError(Sender: TObject; Errors: TComErrors);
    procedure com_portRx80Full(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

const
    START_BYTE = '55';
    START_BYTES: array [0 .. 3] of String = ('76', '70', 'D4', '8B');
    PACKAGE_LEN = 64;
    VERSION = '1.1.15';

var
    form1: TForm1;
    received_data_num, sended_data_num, rec_send_num: integer;
    received_data_num_img: integer;
    received_chars_num: integer;
    received_string: string;
    prev_cell: TPoint;
    rcv_error, wait, reading_paused: Boolean;
    extra_com: string;
    first_time: integer;
    cnctd: integer;
    able_to_change_port, no_programming: Boolean;
    last_ms: Word;
    tim3_cnt: integer;
    left_for_success: integer;
    crc_errors, lost_packets: Integer;
    synchronization: Integer;

procedure clearHist(grid: integer);
procedure checkReadingStatus();
function countCrc(data_str: string): char;
procedure clear_data_cmd_pack(grid: byte);
procedure setStringGridsNames();
procedure simplePreparation(clear_history: Boolean = TRUE);
function checkCorrectness(data_str: string; grid: byte): Boolean;
procedure updateDevInfo(info_str: string);
procedure analyzeAndDisplay(data_str: string; grid: byte);
procedure displayReceivedData(str1: string; time_saved: TDateTime = 0);
procedure displaySendedData(str1: string);
procedure sendCommand(str1: String);
procedure checkForConnection();
procedure refreshPorts(show_this: Boolean);
function prepareFirstPackPart(): string;
procedure checkForHex(sender: TObject; var key: char);
procedure watchForFields(grid: byte; ACol, ARow: integer);

implementation

{$R *.dfm}

procedure clearHist(grid: integer);
var
    temp_grid: TStringGrid;
begin
    if (grid = 0) then
    begin
        received_data_num := 0;
        temp_grid := form1.received_data;
        form1.rcv_dat_str.rowCount := 1;
        form1.rcv_dat_str.cells[0, 0] := '';
        crc_errors := 0;
        lost_packets := 0;
        form1.lbl_crc_errors.caption := 'Ошибки CRC: ' + crc_errors.toString();
        form1.lbl_lost_packets.caption := 'Потеряно пакетов: ' + lost_packets.toString();
    end
    else
    begin
        sended_data_num := 0;
        temp_grid := form1.sended_data;
        form1.trm_dat_str.rowCount := 1;
        form1.trm_dat_str.cells[0, 0] := '';
    end;

    with temp_grid do
    begin
        rowCount := 2;
        cells[0, 1] := '';
        cells[1, 1] := '';
        cells[2, 1] := '';
    end;
end;

procedure checkReadingStatus();
begin
    if (reading_paused) then
    begin
        form1.stop_reading_btn.enabled := FALSE;
        form1.cont_reading_btn.enabled := TRUE;
    end
    else
    begin
        form1.stop_reading_btn.enabled := TRUE;
        form1.cont_reading_btn.enabled := FALSE;
    end;
end;

function countCrc(data_str: string): char;
var
    i: integer;
    res: byte;
begin
    res := 0;
    for i := 1 to length(data_str) do
    begin
        res := res xor ord(data_str[i]);
    end;
    result := chr(res);
end;

procedure clear_data_cmd_pack(grid: byte);
var
    i, j: integer;
    temp_grid: TStringGrid;
begin
    if (grid = 0) then
    begin
        temp_grid := form1.rcv_dat_info;
        form1.rcv_serv_cmd.Text := '0000';
    end
    else
    begin
        temp_grid := form1.trm_dat_info;
        form1.trm_serv_cmd.Text := '0000';
    end;

    with temp_grid do
    begin
        for i := 0 to colCount - 1 do
        begin
            for j := 1 to rowCount - 1 do
            begin
                if (i = 0) then
                begin
                    cells[i, j] := '00';
                end
                else
                begin
                    cells[i, j] := '00000000';
                end;
            end;
        end;
    end;
end;

procedure setStringGridsNames();
begin
    with form1 do
    begin
        with received_data do
        begin
            cells[0, 0] := 'Номер пакета';
            cells[1, 0] := 'Время приёма';
            cells[2, 0] := 'Комментарий';
            colWidths[0] := 80;
            colWidths[1] := 80;
            colWidths[2] := 185;
        end;

        with sended_data do
        begin
            cells[0, 0] := 'Номер пакета';
            cells[1, 0] := 'Время передачи';
            cells[2, 0] := 'Комментарий';
            colWidths[0] := 80;
            colWidths[1] := 90;
            colWidths[2] := 175;
        end;

        with rcv_dat_info do
        begin
            cells[0, 0] := 'Команда';
            cells[1, 0] := 'Данные';
            colWidths[0] := 55;
            colWidths[1] := 75;
        end;

        with trm_dat_info do
        begin
            cells[0, 0] := 'Команда';
            cells[1, 0] := 'Данные';
            colWidths[0] := 55;
            colWidths[1] := 75;
        end;
    end;
end;

procedure simplePreparation(clear_history: Boolean = TRUE);
begin
    setStringGridsNames();
    with form1 do
    begin
        clear_data_cmd_pack(0);
        clear_data_cmd_pack(1);

        if (clear_history) then
        begin
            received_data_num := 0;
            sended_data_num := 0;
        end;

        received_chars_num := 0;
        received_string := '';

        rcv_error := FALSE;
        wait := FALSE;

        reading_paused := FALSE;
        checkReadingStatus();

        if (clear_history) then
        begin
            clearHist(0);
            clearHist(1);
        end;
    end;
end;

function checkCorrectness(data_str: string; grid: byte): Boolean;
var
    str1: string;
    i: integer;
begin
    i := received_data_num;
    if (i = 0) then
    begin
        i := 1;
    end;
    if (length(data_str) <> PACKAGE_LEN) then
    begin
        form1.received_data.cells[2, i] := 'ERROR: wrong package length - ' +
          intToStr(length(data_str)) + ' (must be ' +
          intToStr(PACKAGE_LEN) + ')';
        clear_data_cmd_pack(grid);
        rcv_error := TRUE;
        exit(FALSE);
    end;
    if (crcCheckSum(data_str, PACKAGE_LEN - 1) <> ord(data_str[PACKAGE_LEN]))
    then
    begin
        form1.received_data.cells[2, i] := 'ERROR: wrong CRC - ' +
          ord(data_str[PACKAGE_LEN]).toString() + ' (must be ' +
          crcCheckSum(data_str, PACKAGE_LEN - 1).toString() + ')';
        clear_data_cmd_pack(grid);
        rcv_error := TRUE;
        inc(crc_errors);
        form1.lbl_crc_errors.caption := 'Ошибки CRC: ' + crc_errors.ToString();
        synchronization := 0;
        exit(FALSE);
    end;
    str1 := chars_to_hex(data_str);
    if ((str1[1] + str1[2] <> START_BYTES[3]) or
      (str1[3] + str1[4] <> START_BYTES[2]) or
      (str1[5] + str1[6] <> START_BYTES[1]) or
      (str1[7] + str1[8] <> START_BYTES[0])) then
    begin
        form1.received_data.cells[2, i] := 'ERROR: start bytes "' + str1[1] +
          str1[2] + str1[3] + str1[4] + str1[5] + str1[6] + str1[7] + str1[8] +
          '" don''t match the protocol (' + START_BYTES[3] + START_BYTES[2] +
          START_BYTES[1] + START_BYTES[0] + ')';
        clear_data_cmd_pack(grid);
        rcv_error := TRUE;
        synchronization := 0;
        exit(FALSE);
    end;
    result := TRUE;
end;

procedure updateDevInfo(info_str: string);
var
    pins: string;
    i: Integer;
begin
    if (info_str[1] + info_str[2] = '01') then
    begin
        dev_info.info_form.dev_num.text := info_str[3] + info_str[4] +
          info_str[5] + info_str[6] + info_str[7] + info_str[8];
    end
    else if (info_str[1] + info_str[2] = '02') then
    begin
        dev_info.info_form.board_num.text := info_str[3] + info_str[4] +
          info_str[5] + info_str[6] + info_str[7] + info_str[8];
    end
    else if (info_str[1] + info_str[2] = '03') then
    begin
        pins := hex_to_bin(info_str[3] + info_str[4] +
          info_str[5] + info_str[6] + info_str[7] + info_str[8]);
        with (dev_info.info_form.pins_state) do
        begin
            text := '';
            for i := 9 downto 0 do
            begin
                text := text + pins[length(pins) - i];
            end;
        end;
    end;
end;

procedure analyzeAndDisplay(data_str: string; grid: byte);
var
    i, j, str_pos: integer;
    str1: string;
    temp_grid: TStringGrid;
    old_cnt, new_cnt: Byte;
    //find_info_num: integer;
begin
    //find_info_num := 0;
    if (checkCorrectness(data_str, grid)) then
    begin
        str1 := chars_to_hex(data_str);
        with form1 do
        begin
            if (grid = 0) then
            begin
                temp_grid := rcv_dat_info;
                old_cnt := hex_to_int(rcv_serv_cmd.Text[1] + rcv_serv_cmd.Text[2]);
                new_cnt := hex_to_int(str1[9] + str1[10]);
                if (Byte(new_cnt - old_cnt) > 1) then
                begin
                    lost_packets := lost_packets + new_cnt - old_cnt - 1;
                end;
                lbl_lost_packets.caption := 'Потеряно пакетов: ' + lost_packets.toString();
                rcv_serv_cmd.Text := str1[9] + str1[10] + str1[11] + str1[12];
            end
            else
            begin
                temp_grid := trm_dat_info;
                // received_data_num := hex_to_int(str1[9] + str1[10]);
                trm_serv_cmd.Text := str1[9] + str1[10] + str1[11] + str1[12];
            end;
            with temp_grid do
            begin
                str_pos := 17;
                for i := 1 to 11 do
                begin
                    cells[0, i] := str1[str_pos] + str1[str_pos + 1];
                    {
                    if (cells[0, i] = '0F') then
                    begin
                        find_info_num := i;
                    end;
                    }
                    str_pos := str_pos + 2;
                end;
                for i := 1 to 11 do
                begin
                    cells[1, i] := '';
                    for j := 0 to 7 do
                    begin
                        cells[1, i] := cells[1, i] + str1[str_pos + j];
                    end;
                    cells[1, i] := chars_to_hex(ansiReverseString(hex_to_chars(cells[1, i])));
                    //if (find_info_num = i) then
                    if (cells[0, i]  = '0F') then
                    begin
                        updateDevInfo(cells[1, i]);
                    end;
                    str_pos := str_pos + 8;
                end;
            end;
        end;
    end;
end;

procedure displayReceivedData(str1: string; time_saved: TDateTime = 0);
var
    pack: TPackage;
    i: integer;
begin
    with form1.rcv_dat_str do
    begin
        cells[0, received_data_num] := str1;
        received_data_num := received_data_num + 1;
        if (received_data_num = rowCount) then
        begin
            rowCount := rowCount + 1;
            cells[0, rowCount - 1] := '';
        end;
    end;

    with form1.received_data do
    begin
        if (received_data_num = rowCount) then
        begin
            rowCount := rowCount + 1;
            cells[0, rowCount - 1] := '';
            cells[1, rowCount - 1] := '';
            cells[2, rowCount - 1] := '';
            row := rowCount - 1;
        end;
        cells[0, received_data_num] := intToStr(received_data_num);
        if (time_saved = 0) then
        begin
            cells[1, received_data_num] := timeToStr(getTime());
            for i := 0 to 63 do
            begin
                pack.str_data[i] := str1[i + 1];
            end;
            pack.pack_num := strToInt(cells[0, received_data_num]);
            pack.time := strToTime(cells[1, received_data_num]);
            write_pack_to_file(pack);
        end
        else
        begin
            cells[1, received_data_num] := timeToStr(time_saved);
        end;
        analyzeAndDisplay(form1.rcv_dat_str.cells[0, row - 1], 0);
    end;
end;

procedure displaySendedData(str1: string);
begin
    with form1.trm_dat_str do
    begin
        cells[0, sended_data_num] := str1;
        sended_data_num := sended_data_num + 1;
        if (sended_data_num = rowCount) then
        begin
            rowCount := rowCount + 1;
            cells[0, rowCount - 1] := '';
        end;
    end;

    with form1.sended_data do
    begin
        if (sended_data_num = rowCount) then
        begin
            rowCount := rowCount + 1;
            cells[0, rowCount - 1] := '';
            cells[1, rowCount - 1] := '';
            cells[2, rowCount - 1] := '';
            row := rowCount - 1;
        end;
        cells[0, sended_data_num] := intToStr(sended_data_num);
        cells[1, sended_data_num] := timeToStr(getTime());
    end;
end;

procedure sendCommand(str1: String);
begin
    if (cnctd = 1) then
    begin
        form1.com_port.writeStr(str1);
    end;
end;

procedure checkForConnection();
begin
    with form1 do
    begin
        if (com_port.connected) then
        begin
            com_open_btn.enabled := FALSE;
            chose_ports.enabled := FALSE;
            com_close_btn.enabled := TRUE;
            send_pack_btn.enabled := TRUE;
            // speed_select.enabled := FALSE;
            send_arinc_set_btn.enabled := TRUE;
        end
        else
        begin
            com_open_btn.enabled := TRUE;
            chose_ports.enabled := TRUE;
            com_close_btn.enabled := FALSE;
            send_pack_btn.enabled := FALSE;
            // speed_select.enabled := TRUE;
            send_arinc_set_btn.enabled := FALSE;
        end;
    end;
end;

procedure refreshPorts(show_this: Boolean);
var
    i, tp1idx, tp2idx: integer;
    find1, find2: Boolean;
begin
    if ((set_ports.setup_this = FALSE) and (able_to_change_port = TRUE)) then
    begin
        get_com_ports(form1.mem_log.Lines, 'COM');
        with set_ports.Form4 do
        begin
            tp1idx := port_num1.itemIndex;
            port_num1.clear;
            if (cancel_main = TRUE) then
            begin
                port_num1.Text := '№ порта';
                port_num1.itemIndex := -1;
            end;
            tp2idx := port_num2.itemIndex;
            port_num2.clear;
            if (cancel_extra = TRUE) then
            begin
                port_num2.Text := '№ порта';
                port_num2.itemIndex := -1;
                set_control.checked := FALSE;
            end;
            for i := 0 to form1.mem_log.Lines.count - 1 do
            begin
                port_num1.addItem(form1.mem_log.Lines.strings[i], port_num1);
                port_num2.addItem(form1.mem_log.Lines.strings[i], port_num2);
            end;
            if (cancel_extra2 = FALSE) then
            begin
                port_num2.itemIndex := tp2idx;
                extra_com := port_num2.Items[tp2idx];
                set_control.checked := TRUE;
            end;
            if (cancel_main = FALSE) then
            begin
                port_num1.itemIndex := tp1idx;
                form1.com_port.port := port_num1.Items.strings[tp1idx];
            end;
            find1 := FALSE;
            find2 := FALSE;
            for i := 0 to port_num1.Items.count - 1 do
            begin
                if (port_num1.Items[i] = form1.com_port.port) then
                begin
                    if (port_num1.itemIndex = -1) then
                    begin
                        port_num1.itemIndex := i;
                    end;
                    find1 := TRUE;
                end;
                if ((port_num2.Items[i] = extra_com) and (cancel_extra = FALSE))
                then
                begin
                    if (port_num2.itemIndex = -1) then
                    begin
                        port_num2.itemIndex := i;
                        set_control.checked := TRUE;
                        port_num2.visible := TRUE;
                    end;
                    find2 := TRUE;
                end;
            end;
            if (find1 = FALSE) then
            begin
                port_num1.Text := '№ порта';
                port_num1.itemIndex := -1;
            end;
            if (find2 = FALSE) then
            begin
                port_num2.Text := '№ порта';
                port_num2.itemIndex := -1;
                set_control.checked := FALSE;
            end;
        end;
        if (show_this = TRUE) then
        begin
            set_ports.setup_this := TRUE;
            set_ports.Form4.show();
        end;
    end;
    if (show_this = TRUE) then
    begin
        set_ports.Form4.show();
    end;
end;

function prepareFirstPackPart(): string;
var
    str1: string;
begin
    str1 := START_BYTES[3] + START_BYTES[2] + START_BYTES[1] + START_BYTES[0];
    form1.trm_serv_cmd.Text := intToHex((sended_data_num + 1) mod 256, 2) +
      form1.rcv_serv_cmd.Text[1] + form1.rcv_serv_cmd.Text[2];
    // intToHex(received_data_num mod 256, 2);
    str1 := str1 + form1.trm_serv_cmd.Text;
    // два резервных байта
    str1 := str1 + '0000';
    result := str1;
end;

procedure checkForHex(sender: TObject; var key: char);
var
    letter: string;
begin
    if ((not charInSet(key, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
      'A', 'B', 'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f'])) and
      (key <> char(VK_DELETE)) and (key <> char(VK_BACK)) and
      (key <> char(VK_RETURN)) and (key <> char(VK_TAB)) and
      (key <> char(VK_LEFT)) and (key <> char(VK_RIGHT))) then
    begin
        key := chr(0);
    end;
    letter := key;
    if (letter <> '') then
    begin
        if (charInSet(letter[1], ['a', 'b', 'c', 'd', 'e', 'f'])) then
        begin
            letter := upperCase(letter);
            key := letter[1];
        end;
    end;
end;

procedure watchForFields(grid: byte; ACol, ARow: integer);
var
    len: integer;
    cut: Boolean;
    temp_str: string;
    temp_grid: TStringGrid;
begin
    temp_grid := form1.rcv_dat_info;
    if (grid = 1) then
    begin
        temp_grid := form1.trm_dat_info;
    end;
    cut := FALSE;
    with temp_grid do
    begin
        len := length(cells[ACol, ARow]);
        if (((len > 2) and (ACol = 0)) or ((len > 8) and (ACol = 1))) then
        begin
            cut := TRUE;
        end;
        if (cut) then
        begin
            temp_str := cells[ACol, ARow];
            setLength(temp_str, length(temp_str) - 1);
            cells[ACol, ARow] := temp_str;
        end;

        if ((prev_cell.X <> ACol) or (prev_cell.Y <> ARow)) then
        begin
            len := 2 - length(cells[prev_cell.X, prev_cell.Y]);
            if (prev_cell.X = 1) then
            begin
                len := 8 - length(cells[prev_cell.X, prev_cell.Y]);
            end;
            while (len > 0) do
            begin
                cells[prev_cell.X, prev_cell.Y] :=
                  '0' + cells[prev_cell.X, prev_cell.Y];
                len := len - 1;
            end;
        end;
    end;
    prev_cell.X := ACol;
    prev_cell.Y := ARow;
end;

procedure TForm1.chose_portsClick(sender: TObject);
begin
    refreshPorts(TRUE);
end;

procedure TForm1.clr_rcv_hist_btnClick(sender: TObject);
begin
    clearHist(0);
end;

procedure TForm1.clr_trm_hist_btnClick(sender: TObject);
begin
    clearHist(1);
end;

procedure TForm1.cl_trm_btnClick(sender: TObject);
begin
    clear_data_cmd_pack(1);
end;

procedure TForm1.com_close_btnClick(sender: TObject);
var
    path, mutex_num: string;
    data_in_grid: string;
    i: integer;
    reg_ini_file: TRegIniFile;
begin
    if (com_port.connected) then
    begin
        mutex_num := intToStr(get_mutex_num());
        path := 'HKEY_CURRENT_USER\rs_to_other\com_settings\sample' + mutex_num;
        com_port.close;
        reg_ini_file := TRegIniFile.create('rs_to_other\global_settings\sample'
          + mutex_num);
        reg_ini_file.writeString('arinc_receive', 'channel',
          arinc_receive.arinc_rec.arinc_chnl.Text);
        reg_ini_file.writeString('arinc_receive', 'address',
          arinc_receive.arinc_rec.arinc_addr.Text);
        reg_ini_file.writeString('arinc_send', 'packs',
          intToStr(arinc_receive.arinc_rec.data_s_grid.rowCount - 1));
        reg_ini_file.writeString('arinc_send', 'interval',
          intToStr(arinc_receive.interval));
        data_in_grid := '';
        with arinc_receive.arinc_rec.data_s_grid do
        begin
            for i := fixedRows to rowCount - 1 do
            begin
                data_in_grid := data_in_grid + cells[0, i] + ' ' + cells[1, i] +
                  ' ' + cells[2, i] + ' ';
            end;
        end;
        reg_ini_file.writeString('arinc_send', 'grid_data', data_in_grid);
        with set_ports.Form4 do
        begin
            if (set_control.checked = TRUE) then
            begin
                com_port.port := port_num1.Items[port_num1.itemIndex] +
                  port_num2.Items[port_num2.itemIndex];
            end;
            com_port.storeSettings(stRegistry, path);
            close_file();
            if ((set_control.checked = TRUE) and (no_programming = FALSE)) then
            begin
                able_to_change_port := FALSE;
                com_port.port := port_num2.Items.strings[port_num2.itemIndex];
                com_port.baudRate := br115200;
                com_port.open;
                sleep(1000);
                sendCommand('P');
                sleep(1000);
                com_port.close;
                able_to_change_port := TRUE;
            end;
            com_port.port := port_num1.Items.strings[port_num1.itemIndex];
        end;
        cnctd := 0;
    end;
    checkForConnection();
end;

procedure TForm1.com_open_btnClick(sender: TObject);
begin
    if (not com_port.connected) then
    begin
        with set_ports.Form4 do
        begin
            if (set_control.checked = TRUE) then
            begin
                if (port_num2.itemIndex = -1) then
                begin
                    showMessage
                      ('ошибка: порт не настроен. измени конфигурацию');
                    abort();
                end
                else
                begin
                    able_to_change_port := FALSE;
                    com_port.port := port_num2.Items.strings
                      [port_num2.itemIndex];
                    com_port.baudRate := br115200;
                    com_port.open;
                    sleep(1000);
                    cnctd := 1;
                    sendCommand('W');
                    cnctd := 0;
                    sleep(1000);
                    com_port.close;
                    able_to_change_port := TRUE;
                end;
            end;
            com_port.baudRate :=
              strToBaudRate(speed_select.Items.strings[speed_select.itemIndex]);
            if (port_num1.itemIndex = -1) then
            begin
                showMessage('ошибка: порт не настроен. измени конфигурацию');
                abort();
            end
            else
            begin
                com_port.port := port_num1.Items.strings[port_num1.itemIndex];
                com_port.open();
                cnctd := 1;
                tim3_cnt := 0;
                last_ms := 0;
            end;
        end;
    end;
    checkForConnection();

    simplePreparation(FALSE);

    prepare_file();
end;

procedure TForm1.com_portError(Sender: TObject; Errors: TComErrors);
begin
    showMessage('shit happened');
end;

procedure TForm1.com_portException(sender: TObject;
  TComException: TComExceptions; comportMessage: string; winError: Int64;
  winMessage: string);
begin
    showMessage('Закрытие порта после аварийного завершения...');
    abort();
end;

procedure TForm1.com_portRx80Full(Sender: TObject);
begin
    showMessage('error: buffer is almost full');
end;

procedure TForm1.com_portRxChar(sender: TObject; count: integer);
var
    str1: string;
    i: integer;
begin
    if (not reading_paused) then
    begin
        if (synchronization = 0) then
        begin
            if (left_for_success > 0) then
            begin
                com_port.readStr(str1, 1);
                if (ord(str1[1]) = hex_to_int(START_BYTES[left_for_success - 1]))
                then
                begin
                    dec(left_for_success);
                    received_string := received_string + str1[1];
                    inc(received_chars_num);
                    rcv_dat_lbl.caption := 'all good: ' + ord(str1[1]).toString() + '; ' + timeToStr(getTime());
                end
                else
                begin
                    left_for_success := length(START_BYTES);
                    received_chars_num := 0;
                    received_string := '';
                    rcv_dat_lbl.caption := 'it''s fubar: ' + ord(str1[1]).toString() + '; ' + timeToStr(getTime());
                    if (ord(str1[1]) = hex_to_int(START_BYTES[left_for_success - 1]))
                    then
                    begin
                        dec(left_for_success);
                        received_string := received_string + str1[1];
                        inc(received_chars_num);
                    end;
                end;
            end
            else
            begin
                if (count >= PACKAGE_LEN - 4) then
                begin
                    synchronization := 1;
                    com_port.readStr(str1, PACKAGE_LEN - 4);
                    received_string := received_string + str1;
                    receiveStringCmd(received_string);
                    displayReceivedData(received_string);
                    gl_grid := rcv_dat_str;
                    received_chars_num := 0;
                    received_string := '';
                    left_for_success := length(START_BYTES);
                end;
            end;
        end
        else
        begin
            if (count >= PACKAGE_LEN) then
            begin
                com_port.readStr(str1, PACKAGE_LEN);
                received_string := str1;
                receiveStringCmd(received_string);
                displayReceivedData(received_string);
                gl_grid := rcv_dat_str;
                received_chars_num := 0;
                received_string := '';
                left_for_success := length(START_BYTES);
            end;
        end;
    end;
    //com_port.readStr(str1, count);
    //trm_dat_lbl.caption := count.toString();
    {
    if ((not rcv_error) and (not reading_paused)) then
    begin
        for i := 1 to count do
        begin
            if ((received_string <> '') and (left_for_success = 0)) then
            begin
                rcv_dat_lbl.caption := 'received byte #' + received_chars_num.toString() + ': ' + ord(str1[i]).toString() + '; ' + timeToStr(getTime());
                received_string := received_string + str1[i];
                received_chars_num := received_chars_num + 1;
                if (received_chars_num = PACKAGE_LEN) then
                begin
                    receiveStringCmd(received_string);
                    displayReceivedData(received_string);
                    gl_grid := rcv_dat_str;
                    received_chars_num := 0;
                    received_string := '';
                    left_for_success := length(START_BYTES);
                    continue;
                end;
            end
            else if (left_for_success > 0) then
            begin
                if (ord(str1[i]) = hex_to_int(START_BYTES[left_for_success - 1]))
                then
                begin
                    dec(left_for_success);
                    received_string := received_string + str1[i];
                    inc(received_chars_num);
                    rcv_dat_lbl.caption := 'all good: ' + ord(str1[i]).toString() + '; ' + timeToStr(getTime());
                end
                else
                begin
                    left_for_success := length(START_BYTES);
                    received_chars_num := 0;
                    received_string := '';
                    rcv_dat_lbl.caption := 'it''s fubar: ' + ord(str1[i]).toString() + '; ' + timeToStr(getTime());
                    if (ord(str1[i]) = hex_to_int(START_BYTES[left_for_success - 1]))
                    then
                    begin
                        dec(left_for_success);
                        received_string := received_string + str1[i];
                        inc(received_chars_num);
                    end;
                end;
            end
        end;
    end;
    //}
end;

procedure TForm1.cont_reading_btnClick(sender: TObject);
begin
    reading_paused := FALSE;
    checkReadingStatus();
end;

procedure TForm1.cp_data_btnClick(sender: TObject);
var
    i, j: integer;
begin
    trm_serv_cmd.Text := rcv_serv_cmd.Text;
    for i := 0 to trm_dat_info.colCount - 1 do
    begin
        for j := 1 to rcv_dat_info.rowCount - 1 do
        begin
            trm_dat_info.cells[i, j] := rcv_dat_info.cells[i, j];
        end;
    end;
end;

procedure TForm1.FormClose(sender: TObject; var action: TCloseAction);
begin
    no_programming := TRUE;
    com_close_btnClick(sender);
    delete_mutex();
end;

procedure TForm1.formCreate(sender: TObject);
begin
    caption := caption + '(' + VERSION + ')';
    visible := FALSE;
    checkForConnection();
    first_time := 1;
    simplePreparation();
    cnctd := 0;
    able_to_change_port := TRUE;
    no_programming := FALSE;
    left_for_success := length(START_BYTES);
    form1.lbl_crc_errors.caption := 'Ошибки CRC: ' + crc_errors.toString();
    lbl_lost_packets.caption := 'Потеряно пакетов: ' + lost_packets.toString();
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    try
        if FileExists('updater.exe') then
        begin
            ShellExecute(0, 'open', 'updater.exe',
              PChar('DarkPatrick rs_to_arinc_new ' + VERSION + ' ' +
              ExtractFileName(GetModuleName(0))), nil, SW_SHOWNORMAL);
        end;
    finally
    end;
end;

procedure TForm1.get_arinc_btnClick(sender: TObject);
begin
    arinc_rec.show();
end;

procedure TForm1.info_btnClick(sender: TObject);
begin
    dev_info.info_form.show();
end;

procedure TForm1.load_data_btnClick(sender: TObject);
var
    pack: TPackage;
    data_file: file of TPackage;
    str1: string;
    i: integer;
begin
    if (open_dialog.execute()) then
    begin
        assignFile(data_file, open_dialog.fileName);
        reset(data_file);
        while (not eof(data_file)) do
        begin
            read(data_file, pack);
            str1 := '';
            for i := 1 to 64 do
            begin
                str1 := str1 + pack.str_data[i - 1];
            end;
            displayReceivedData(str1, pack.time);
            gl_grid := rcv_dat_str;
            get_all_data_from(rcv_dat_str);
        end;
        closeFile(data_file);
    end;
end;

procedure TForm1.rcv_dat_infoKeyPress(sender: TObject; var key: char);
begin
    checkForHex(sender, key);
end;

procedure TForm1.rcv_dat_infoSetEditText(sender: TObject; ACol, ARow: integer;
  const value: string);
begin
    watchForFields(0, ACol, ARow);
end;

procedure TForm1.rcv_serv_cmdChange(sender: TObject);
var
    temp_str: string;
begin
    if (length(rcv_serv_cmd.Text) > 4) then
    begin
        temp_str := rcv_serv_cmd.Text;
        setLength(temp_str, length(temp_str) - 1);
        rcv_serv_cmd.Text := temp_str;
    end;
end;

procedure TForm1.rcv_serv_cmdContextPopup(sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
    abort();
end;

procedure TForm1.rcv_serv_cmdKeyDown(sender: TObject; var key: Word;
  Shift: TShiftState);
begin
    abort();
end;

procedure TForm1.rcv_serv_cmdKeyPress(sender: TObject; var key: char);
begin
    abort();
end;

procedure TForm1.received_dataClick(sender: TObject);
begin
    if ((received_data.row > 0) and (rcv_dat_str.cells[0, received_data.row - 1]
      <> '')) then
    begin
        analyzeAndDisplay(rcv_dat_str.cells[0, received_data.row - 1], 0);
    end;
end;

procedure TForm1.received_dataKeyPress(sender: TObject; var key: char);
begin
    if (received_data.col <> 2) then
    begin
        abort();
    end;
end;

procedure TForm1.sended_dataClick(sender: TObject);
begin
    if ((sended_data.row > 0) and (trm_dat_str.cells[0, sended_data.row - 1]
      <> '')) then
    begin
        analyzeAndDisplay(trm_dat_str.cells[0, sended_data.row - 1], 1);
    end;
end;

procedure TForm1.sended_dataKeyPress(sender: TObject; var key: char);
begin
    if (sended_data.col <> 2) then
    begin
        abort();
    end;
end;

procedure TForm1.send_arinc_set_btnClick(sender: TObject);
var
    i: integer;
begin
    clear_data_cmd_pack(1);
    with trm_dat_info do
    begin
        for i := 1 to 13 do
        begin
            if (hex_to_int(cells[0, i]) = 0) then
            begin
                cells[0, i] := '0C';
                cells[1, i] := int_to_bin(arinc_ch_num.itemIndex + 1, 8) +
                  '000000000000000000' + int_to_bin(arinc_parity_type.itemIndex,
                  1) + int_to_bin(1 - arinc_parity_en.itemIndex, 1) +
                  int_to_bin(arinc_ch_freq.itemIndex, 3) +
                  int_to_bin(1 - arinc_ch_en.itemIndex, 1);
                cells[1, i] := bin_to_hex(cells[1, i]);
                break;
            end;
        end;
    end;
    send_pack_btnClick(sender);
end;

procedure TForm1.send_pack_btnClick(sender: TObject);
var
    str1: string;
    i: integer;
    crc_tmp: byte;
begin
    with trm_dat_info do
    begin
        i := 2 - length(cells[prev_cell.X, prev_cell.Y]);
        if (prev_cell.X = 1) then
        begin
            i := 8 - length(cells[prev_cell.X, prev_cell.Y]);
        end;
        while (i > 0) do
        begin
            cells[prev_cell.X, prev_cell.Y] :=
              '0' + cells[prev_cell.X, prev_cell.Y];
            i := i - 1;
        end;
    end;
    i := 4 - length(trm_serv_cmd.Text);
    while (i > 0) do
    begin
        trm_serv_cmd.Text := '0' + trm_serv_cmd.Text;
        i := i - 1;
    end;

    str1 := prepareFirstPackPart();
    with trm_dat_info do
    begin
        for i := 1 to rowCount - 1 do
        begin
            str1 := str1 + cells[0, i];
        end;
        for i := 1 to rowCount - 1 do
        begin
            str1 := str1 + chars_to_hex(ansiReverseString(hex_to_chars(cells[1, i])));
        end;
    end;
    crc_tmp := crcCheckSum(hex_to_chars(str1));
    str1 := hex_to_chars(str1) + chr(crc_tmp);
    sendCommand(str1);
    displaySendedData(str1);
end;

procedure TForm1.show_filter_btnClick(sender: TObject);
begin
    gl_grid := rcv_dat_str;
    get_all_data_from(rcv_dat_str);
    form2.show();
end;

procedure TForm1.stop_reading_btnClick(sender: TObject);
begin
    reading_paused := TRUE;
    checkReadingStatus();
end;

procedure TForm1.Timer1Timer(sender: TObject);
var
    reg: TRegistry;
    reg_ini_file: TRegIniFile;
    path, mutex_num, com_name: string;
    data_in_grid, data_in_cell: string;
    i, j, gr_ps_r, gr_ps_c: integer;
    stop_it: Boolean;
begin
    if (wait) then
    begin
        wait := FALSE;
        received_chars_num := 0;
        received_string := '';
        rcv_error := FALSE;
    end;
    if (rcv_error) then
    begin
        wait := TRUE;
    end;
    if (first_time = 1) then
    begin
        first_time := 2;
    end
    else if (first_time = 2) then
    begin
        if (form1.visible = FALSE) then
        begin
            form1.visible := TRUE;
            interval := 300;
        end;
        first_time := 0;
        mutex_num := intToStr(get_mutex_num());
        reg := TRegistry.create();
        reg.RootKey := HKEY_CURRENT_USER;
        refreshPorts(FALSE);
        if (reg.keyExists('\rs_to_other\com_settings\sample' + mutex_num)) then
        begin
            path := 'HKEY_CURRENT_USER\rs_to_other\com_settings\sample' +
              mutex_num;
            com_port.loadSettings(stRegistry, path);
            extra_com := '';
            com_name := com_port.port;
            if (pos('COM', com_name, 3) > 0) then
            begin
                set_ports.Form4.set_control.checked := TRUE;
                com_port.port := 'COM';
                stop_it := FALSE;
                for i := 4 to length(com_name) do
                begin
                    if (com_name[i] = 'C') then
                    begin
                        stop_it := TRUE;
                        with set_ports.Form4 do
                        begin
                            for j := 0 to port_num1.Items.count - 1 do
                            begin
                                if (port_num1.Items[i] = com_port.port) then
                                begin
                                    port_num1.itemIndex := j;
                                    break;
                                end;
                            end;
                        end;
                    end;
                    if (stop_it = FALSE) then
                    begin
                        com_port.port := com_port.port + com_name[i];
                    end
                    else
                    begin
                        extra_com := extra_com + com_name[i];
                    end;
                end;
                with set_ports.Form4 do
                begin
                    for i := 0 to port_num2.Items.count - 1 do
                    begin
                        if (port_num2.Items[i] = extra_com) then
                        begin
                            port_num2.itemIndex := i;
                            set_control.checked := TRUE;
                            cancel_extra := FALSE;
                            break;
                        end;
                    end;
                    if (port_num2.itemIndex < 0) then
                    begin
                        set_control.checked := FALSE;
                    end;
                end;
            end;
            for i := 0 to speed_select.Items.count - 1 do
            begin
                if (speed_select.Items.strings[i] = baudRateToStr
                  (com_port.baudRate)) then
                begin
                    speed_select.itemIndex := i;
                    break;
                end;
            end;
        end;
        reg.free;
        reg_ini_file := TRegIniFile.create('\rs_to_other\global_settings\sample'
          + mutex_num);
        reg_ini_file.RootKey := HKEY_CURRENT_USER;
        reg_ini_file.openKey('arinc_receive', FALSE);
        if (reg_ini_file.valueExists('channel')) then
        begin
            arinc_receive.arinc_rec.arinc_chnl.Text :=
              reg_ini_file.readString('', 'channel', '');
        end;
        if (reg_ini_file.valueExists('address')) then
        begin
            arinc_receive.arinc_rec.arinc_addr.Text :=
              reg_ini_file.readString('', 'address', '');
        end;
        reg_ini_file.free;
        reg_ini_file := TRegIniFile.create('\rs_to_other\global_settings\sample'
          + mutex_num);
        reg_ini_file.RootKey := HKEY_CURRENT_USER;
        reg_ini_file.openKey('arinc_send', FALSE);
        if (reg_ini_file.valueExists('packs')) then
        begin
            arinc_receive.arinc_rec.arinc_send_addr.Text :=
              reg_ini_file.readString('', 'packs', '0');
            send_calibr();
        end;
        if (reg_ini_file.valueExists('interval')) then
        begin
            arinc_receive.arinc_rec.interval_val.Text :=
              reg_ini_file.readString('', 'interval', '100');
        end;
        if (reg_ini_file.valueExists('grid_data')) then
        begin
            data_in_grid := reg_ini_file.readString('', 'grid_data', '');
            data_in_cell := '';
            gr_ps_r := arinc_receive.arinc_rec.data_s_grid.fixedRows;
            gr_ps_c := 0;
            for i := 1 to length(data_in_grid) do
            begin
                if (data_in_grid[i] <> ' ') then
                begin
                    data_in_cell := data_in_cell + data_in_grid[i];
                end
                else
                begin
                    arinc_receive.arinc_rec.data_s_grid.cells[gr_ps_c, gr_ps_r]
                      := data_in_cell;
                    data_in_cell := '';
                    inc(gr_ps_c);
                    if (gr_ps_c > 2) then
                    begin
                        gr_ps_c := 0;
                        inc(gr_ps_r);
                    end;
                end;
            end;
        end;
        reg_ini_file.free;
        arinc_receive.arinc_rec.apply_btnClick(sender);
    end;
end;

procedure TForm1.Timer2Timer(sender: TObject);
begin
    refreshPorts(FALSE);
    if (set_ports.Form4.port_num1.itemIndex = -1) then
    begin
        if (cnctd = 1) then
        begin
            cnctd := -1;
            showMessage('Соединение с портом ' + com_port.port +
              ' было разорвано.');
            com_open_btn.enabled := FALSE;
            chose_ports.enabled := FALSE;
            com_close_btn.enabled := FALSE;
            send_pack_btn.enabled := FALSE;
            send_arinc_set_btn.enabled := FALSE;
        end;
    end
    else
    begin
        if (cnctd = -1) then
        begin
            cnctd := 1;
            showMessage('Соединение с портом ' + com_port.port +
              ' было восстановлено.');
            com_open_btn.enabled := FALSE;
            chose_ports.enabled := FALSE;
            com_close_btn.enabled := TRUE;
        end;
    end;
end;

procedure TForm1.Timer3Timer(sender: TObject);
var
    i, j, ub: integer;
    str1, str2, str3, str4: string;
    h, m, s, ms: Word;
    str_num: StringNumber;
    crc_tmp: byte;
begin
    decodeTime(getTime(), h, m, s, ms);
    if ((arinc_receive.sending_proc) and (com_port.connected)) then
    begin
        if (ms > last_ms) then
        begin
            inc(tim3_cnt, ms - last_ms);
        end
        else
        begin
            inc(tim3_cnt, ms + 1000 - last_ms);
        end;
        if (tim3_cnt >= arinc_receive.interval) then
        begin
            tim3_cnt := (tim3_cnt - arinc_receive.interval)
              mod arinc_receive.interval;
            with arinc_receive.arinc_rec do
            begin
                str_num := StringNumber.create('0', 8);
                for i := data_s_grid.fixedRows to data_s_grid.rowCount - 1 do
                begin
                    data_s_grid.cells[1, i] :=
                      ansiUpperCase(data_s_grid.cells[1, i]);
                    data_s_grid.cells[2, i] :=
                      ansiUpperCase(data_s_grid.cells[2, i]);
                end;
                str1 := prepareFirstPackPart();
                ub := data_s_grid.rowCount - 1;
                if (ub > 11) then
                begin
                    ub := 11;
                end;
                for i := 1 to ub do
                begin
                    str1 := str1 + intToHex(global_chnl, 2);
                end;
                for i := ub + 1 to 11 do
                begin
                    str1 := str1 + intToHex(0, 2);
                end;
                for i := 1 to data_s_grid.rowCount - 1 do
                begin
                    str2 := data_s_grid.cells[1, i];
                    while (length(str2) < 2) do
                    begin
                        str2 := '0' + str2;
                    end;
                    str3 := data_s_grid.cells[2, i];
                    while (length(str3) < 6) do
                    begin
                        str3 := '0' + str3;
                    end;
                    str2 := '0' + str2 + str3[1];
                    //str1 := str1 + bin_to_hex(str2, 1);
                    str4 := bin_to_hex(str2, 1);
                    //str1 := str1 + ansiUpperCase(str3[2] + str3[3] + str3[4] +
                      //str3[5] + str3[6]);
                    str4 := str4 + ansiUpperCase(str3[2] + str3[3] + str3[4] +
                      str3[5] + str3[6]);
                    str_num.setNewVal(data_s_grid.cells[0, i]);
                    str2 := str_num.getInBase(16, 2);
                    while (length(str2) < 2) do
                    begin
                        str2 := '0' + str2;
                    end;
                    str4 := str4 + str2;
                    str1 := str1 + chars_to_hex(ansiReverseString(hex_to_chars(str4)));
                    if ((i mod 11 = 0) and (i < data_s_grid.rowCount - 1)) then
                    begin
                        crc_tmp := crcCheckSum(hex_to_chars(str1));
                        str1 := hex_to_chars(str1) + chr(crc_tmp);
                        sendCommand(str1);
                        displaySendedData(str1);
                        str1 := prepareFirstPackPart();
                        ub := data_s_grid.rowCount - 1 - i;
                        if (ub > 11) then
                        begin
                            ub := 11;
                        end;
                        for j := 1 to ub do
                        begin
                            str1 := str1 + intToHex(global_chnl, 2);
                        end;
                        for j := ub + 1 to 11 do
                        begin
                            str1 := str1 + intToHex(0, 2);
                        end;
                    end;
                end;
                while (length(str1) < 127) do
                begin
                    str1 := str1 + '0';
                end;
                crc_tmp := crcCheckSum(hex_to_chars(str1));
                str1 := hex_to_chars(str1) + chr(crc_tmp);
                sendCommand(str1);
                displaySendedData(str1);
                str_num.free();
            end;
        end;
    end;
    last_ms := ms;
end;

procedure TForm1.trm_dat_infoKeyPress(sender: TObject; var key: char);
begin
    checkForHex(sender, key);
end;

procedure TForm1.trm_dat_infoSetEditText(sender: TObject; ACol, ARow: integer;
  const value: string);
begin
    watchForFields(1, ACol, ARow);
end;

procedure TForm1.trm_serv_cmdChange(sender: TObject);
var
    temp_str: string;
begin
    if (length(trm_serv_cmd.Text) > 4) then
    begin
        temp_str := trm_serv_cmd.Text;
        setLength(temp_str, length(temp_str) - 1);
        trm_serv_cmd.Text := temp_str;
    end;
end;

procedure TForm1.trm_serv_cmdContextPopup(sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
    abort();
end;

procedure TForm1.trm_serv_cmdKeyDown(sender: TObject; var key: Word;
  Shift: TShiftState);
begin
    abort();
end;

procedure TForm1.trm_serv_cmdKeyPress(sender: TObject; var key: char);
begin
    abort();
end;

end.
