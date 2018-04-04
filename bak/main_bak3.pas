unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  StdCtrls, ExtCtrls, CPort, CPortCtl, Vcl.Grids, convertation;

type
  TForm1 = class(TForm)
    com_settings_block: TPanel;
    com_port: TComPort;
    com_set_btn: TButton;
    com_chg_state_btn: TButton;
    receive_data_block: TPanel;
    send_data_block: TPanel;
    received_data: TStringGrid;
    sended_data: TStringGrid;
    data_params_block: TPanel;
    send_package_btn: TButton;
    service_cmd: TLabeledEdit;
    data_cmd_pack: TStringGrid;
    Button1: TButton;
    procedure com_set_btnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure com_chg_state_btnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure send_package_btnClick(Sender: TObject);
    procedure com_portRxChar(Sender: TObject; Count: Integer);
    procedure Button1Click(Sender: TObject);
    procedure received_dataClick(Sender: TObject);
    procedure sended_dataClick(Sender: TObject);
    procedure data_cmd_packKeyPress(Sender: TObject; var Key: Char);
    procedure data_cmd_packSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure service_cmdKeyPress(Sender: TObject; var Key: Char);
    procedure service_cmdChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  START_BYTE  = '55';
  PACKAGE_LEN = 64;
var
  Form1: TForm1;
  received_data_num, sended_data_num: integer;
  received_chars_num: integer;
  received_string: string;

implementation

{$R *.dfm}

procedure clear_data_cmd_pack();
var
  i, j: integer;
begin
  Form1.service_cmd.Text := '0000';
  with Form1.data_cmd_pack do
  begin
    for i := 1 to ColCount - 1 do
    begin
      for j := 0 to RowCount - 1 do
      begin
        if (j mod 2 = 0) then
        begin
          Cells[i, j] := '00';
        end else begin
          Cells[i, j] := '00000000';
        end;
      end;
    end;
  end;
end;

procedure analyze_and_display(data_str: string);
var
  i, j, str_pos: integer;
  str1: string;
begin
  str1 := chars_to_hex(data_str);
  if (length(data_str) <> PACKAGE_LEN) then
  begin
    showMessage('ERROR: wrong package length');
    exit;
  end;
  if (str1[1] + str1[2] <> START_BYTE) then
  begin
    showMessage('ERROR: start byte doesn''t match the protocol');
    exit;
  end else begin
    with Form1 do
    begin
      service_cmd.Text := str1[3] + str1[4] + str1[5] + str1[6];
      with data_cmd_pack do
      begin
        str_pos := 7;
        for i := 1 to 6 do
        begin
          Cells[i, 0] := str1[str_pos] + str1[str_pos + 1];
          Cells[i, 2] := str1[12 + str_pos] + str1[13 + str_pos];
          str_pos := str_pos + 2;
        end;
        str_pos := str_pos + 12;
        for i := 1 to 6 do
        begin
          Cells[i, 1] := '';
          Cells[i, 3] := '';
          for j := 0 to 7 do
          begin
            Cells[i, 1] := Cells[i, 1] + str1[str_pos + j];
            Cells[i, 3] := Cells[i, 3] + str1[48 + str_pos + j];
          end;
          str_pos := str_pos + 8;
        end;
      end;
    end;
  end;
end;

procedure display_received_data(str1: string);
begin
  with Form1.received_data do
  begin
    received_data_num := received_data_num + 1;
    if (received_data_num = RowCount) then
    begin
      RowCount := RowCount + 1;
      Cells[0, RowCount - 1] := '';
    end;
    Cells[0, received_data_num] := str1;
    Cells[1, received_data_num] := intToStr(received_data_num);
  end;
end;

procedure send_command(str1: String; no_delay: boolean = FALSE);
begin
  //str1 := str1 + #13#10;
  Form1.com_port.WriteStr(str1);
  if (Not no_delay) then Sleep(150);
end;

procedure check_for_connection();
begin
  with Form1 do
  begin
    if (com_port.Connected) then
    begin
      com_chg_state_btn.Caption := 'Закрыть порт';
      send_package_btn.Enabled  := TRUE;
    end else begin
      com_chg_state_btn.Caption := 'Открыть порт';
      send_package_btn.Enabled  := FALSE;
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  clear_data_cmd_pack();
end;

procedure TForm1.com_chg_state_btnClick(Sender: TObject);
var
  path: string;
begin
  if (com_port.Connected) then
  begin
    path := 'HKEY_CURRENT_USER\rs_to_other\com_settings';
    com_port.StoreSettings(stRegistry, path);
    com_port.Close;
  end else begin
    com_port.Open;
  end;
  check_for_connection();
end;

procedure TForm1.com_portRxChar(Sender: TObject; Count: Integer);
var
  str1: string;
  i: integer;
begin
  com_port.ReadStr(str1, Count);
  for i := 1 to Count do
  begin
    received_string := received_string + str1[i];
    received_chars_num := received_chars_num + 1;
    if (received_chars_num = PACKAGE_LEN) then
    begin
      display_received_data(received_string);
      received_chars_num := 0;
    end;
  end;
end;

procedure TForm1.com_set_btnClick(Sender: TObject);
begin
  com_port.ShowSetupDialog;
end;

procedure check_for_hex(Sender: TObject; var Key: Char);
var
  letter: string;
begin
  if ((not CharInSet(Key,
  [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    'A', 'B', 'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f'
  ])) and (Key <> char(VK_DELETE)) and (Key <> char(VK_BACK))
    and (Key <> char(VK_RETURN)) and (Key <> char(VK_TAB))
       and (Key <> char(VK_LEFT))  and (Key <> char(VK_RIGHT))) then
  begin
    Key := chr(0);
  end;
  letter := Key;
  if (letter <> '') then
  begin
    if (CharInSet(letter[1], ['a', 'b', 'c', 'd', 'e', 'f'])) then
    begin
      letter := upperCase(letter);
      Key := letter[1];
    end;
  end;
end;

procedure TForm1.data_cmd_packKeyPress(Sender: TObject; var Key: Char);

begin
  check_for_hex(Sender, Key);
end;

procedure TForm1.data_cmd_packSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
var
  cut: boolean;
  temp_str: string;
begin
  cut := FALSE;
  with data_cmd_pack do
  begin
    {if (((length(Cells[ACol, ARow]) = 2) and (ARow mod 2 = 0)) or
      ((length(Cells[ACol, ARow]) = 8) and (ARow mod 2 = 1))) then
    begin
      Cells[ACol, ARow] := Cells[ACol, ARow];
      if (Col < ColCount - 1) then
      begin
        Col := Col + 1;
      end else begin
        Col := 1;
        if (Row < RowCount - 1) then
        begin
          Row := Row + 1;
        end else begin
          Row := 1;
        end;
      end;
    end;}
    if (((length(Cells[ACol, ARow]) > 2) and (ARow mod 2 = 0)) or
      ((length(Cells[ACol, ARow]) > 8) and (ARow mod 2 = 1))) then
    begin
      cut := TRUE;
    end;
    if (cut) then
    begin
      temp_str := Cells[ACol, ARow];
      setLength(temp_str, length(temp_str) - 1);
      Cells[ACol, ARow] := temp_str;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  check_for_connection();

  received_data.Cells[0, 0]  := 'Принятые данные';
  received_data.Cells[1, 0]  := 'Номер пакета';
  received_data.ColWidths[1] := 75;
  received_data.ColWidths[0] := received_data.Width
    - received_data.ColWidths[1] - 25;

  sended_data.Cells[0, 0]  := 'Переданные данные';
  sended_data.Cells[1, 0]  := 'Номер пакета';
  sended_data.ColWidths[1] := 75;
  sended_data.ColWidths[0] := sended_data.Width
    - sended_data.ColWidths[1] - 25;

  service_cmd.EditLabel.Caption := 'Служебная' + #13#10 + 'команда';

  data_cmd_pack.Cells[0, 0] := 'Команда';
  data_cmd_pack.Cells[0, 1] := 'Данные';
  data_cmd_pack.Cells[0, 2] := 'Команда';
  data_cmd_pack.Cells[0, 3] := 'Данные';
  clear_data_cmd_pack();

  received_data_num := 0;
  sended_data_num   := 0;

  received_chars_num := 0;
  received_string    := '';
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  receive_data_block.Width  := ClientWidth - receive_data_block.Left;
  receive_data_block.Height := round(
    (ClientHeight - receive_data_block.Top) / 2
  );

  send_data_block.Width  := ClientWidth - send_data_block.Left;
  send_data_block.Height := round((ClientHeight - receive_data_block.Top) / 2);
  send_data_block.Top := receive_data_block.Top + receive_data_block.Height;

  received_data.Width := receive_data_block.Width - 20;
  received_data.ColWidths[1] := 75;
  received_data.ColWidths[0] := received_data.Width
    - received_data.ColWidths[1] - 25;
  received_data.Height := receive_data_block.Height - 20;

  sended_data.Width := send_data_block.Width - 20;
  sended_data.ColWidths[1] := 75;
  sended_data.ColWidths[0] := sended_data.Width - sended_data.ColWidths[1] - 25;
  sended_data.Height := send_data_block.Height - 20;

  data_params_block.Width := ClientWidth - data_params_block.Left;

  send_package_btn.Left := received_data.Left + received_data.Width
    - send_package_btn.Width - data_params_block.Left;
end;

procedure TForm1.received_dataClick(Sender: TObject);
begin
  analyze_and_display(received_data.Cells[0, received_data.Row]);
end;

procedure TForm1.sended_dataClick(Sender: TObject);
begin
  analyze_and_display(sended_data.Cells[0, sended_data.Row]);
end;

procedure TForm1.send_package_btnClick(Sender: TObject);
var
  str1: string;
  i: integer;
begin
  str1 := START_BYTE;

  str1 := str1 + service_cmd.Text;
  for i := 1 to data_cmd_pack.ColCount - 1 do
  begin
    str1 := str1 + data_cmd_pack.Cells[i, 0];
  end;
  for i := 1 to data_cmd_pack.ColCount - 1 do
  begin
    str1 := str1 + data_cmd_pack.Cells[i, 2];
  end;
  for i := 1 to data_cmd_pack.ColCount - 1 do
  begin
    str1 := str1 + data_cmd_pack.Cells[i, 1];
  end;
  for i := 1 to data_cmd_pack.ColCount - 1 do
  begin
    str1 := str1 + data_cmd_pack.Cells[i, 3];
  end;
  str1 := str1 + '00'; //CRC-byte
  str1 := hex_to_chars(str1);
  send_command(str1);
  sended_data_num := sended_data_num + 1;
  if (sended_data_num = sended_data.RowCount) then
  begin
    sended_data.RowCount := sended_data.RowCount + 1;
    sended_data.Cells[0, sended_data.RowCount - 1] := '';
  end;
  sended_data.Cells[0, sended_data_num] := str1;
  sended_data.Cells[1, sended_data_num] := intToStr(sended_data_num);
end;

procedure TForm1.service_cmdChange(Sender: TObject);
var
  temp_str: string;
begin
  if (length(service_cmd.Text) > 4) then
  begin
    temp_str := service_cmd.Text;
    setLength(temp_str, length(temp_str) - 1);
    service_cmd.Text := temp_str;
  end;
end;

procedure TForm1.service_cmdKeyPress(Sender: TObject; var Key: Char);
begin
  check_for_hex(Sender, Key);
end;

end.
