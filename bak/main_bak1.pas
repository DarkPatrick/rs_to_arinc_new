unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  StdCtrls, ExtCtrls, CPort, CPortCtl, Vcl.Grids, Math;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  START_BYTE = '55';
var
  Form1: TForm1;
  received_data_num, sended_data_num: integer;
  hex: array[0 .. 15] of string = ('0', '1', '2', '3', '4', '5', '6', '7', '8',
  '9', 'A', 'B', 'C', 'D', 'E', 'F');

implementation

{$R *.dfm}

procedure clear_data_cmd_pack();
var
  i, j: integer;
begin
  with Form1 do
  begin
    service_cmd.Text := '00';

    for i := 1 to data_cmd_pack.ColCount - 1 do
    begin
      for j := 0 to data_cmd_pack.RowCount - 1 do
      begin
        if (j mod 2 = 0) then
        begin
          data_cmd_pack.Cells[i, j] := '0';
        end else begin
          data_cmd_pack.Cells[i, j] := '0000';
        end;
      end;
    end;
  end;
end;

function int_to_bin(num: integer; num_of_digits: integer = 0): string;
var
  res: string;
  i, len: integer;
begin
  res := '';
  while (num > 0) do
  begin
    if (num mod 2 = 0) then
    begin
      res := '0' + res;
      num := round(num / 2);
    end else begin
      res := '1' + res;
      num := round((num - 1) / 2);
    end;
  end;
  if (res = '') then
  begin
    res := '0';
  end;
  len := length(res);
  if (num_of_digits > len) then
  begin
    for i := 1 to num_of_digits - len do
    begin
      res := '0' + res;
    end;
  end;
  result := res;
end;

function hex_to_bin(hex_num: string): string;
var
  i, num: integer;
  res: string;
begin
  res := '';
  for i := 1 to length(hex_num) do
  begin
    num := pos(hex_num[i], '0123456789ABCDEF');
    if (num = 0) then
    begin
      showmessage('ERROR: wrong hex num: ' + hex_num);
      res := '0';
      break;
    end else begin
      num := num - 1;
      res := res + int_to_bin(num, 4);
    end;
  end;
  Form1.Caption := res;
  result := res;
end;

function bin_to_hex(bin_num: string; num_of_digits: integer = 0): string;
var
  res: string;
  i, j, len, num, hex_num: integer;
begin
  i := 1;
  res := '';
  while (i < length(bin_num)) do
  begin
    hex_num := 0;
    for j := 0 to 3 do
    begin
      num := 0;
      if (bin_num[i + j] = '1') then
      begin
        num := 1;
      end;
      hex_num := hex_num + round(power(2, 3 - j) * num);
    end;
    res := res + hex[hex_num];
    i := i + 4;
  end;
  len := length(res);
  if (num_of_digits > len) then
  begin
    for i := 1 to num_of_digits - len do
    begin
      res := '0' + res;
    end;
  end;
  result := res;
end;

procedure recognize_and_display(str1: string);
var
  i, j: integer;
  sub_str, res: string;
begin
  i := 1;
  res := '';
  while (i < length(str1)) do
  begin
    sub_str := '';
    for j := 0 to 7 do
    begin
      sub_str := sub_str + str1[i + j];
    end;
    case i of
      1:
        if (hex_to_bin(START_BYTE) <> sub_str) then
        begin
          showmessage('ERROR: wrong start byte. ' + sub_str
            + ' received instead ' + hex_to_bin(START_BYTE));
          exit;
        end;
    end;
    res := res + sub_str;
    i := i + 8;
  end;
  res := bin_to_hex(res);
  with Form1 do
  begin
    received_data_num := received_data_num + 1;
    if (received_data_num = received_data.RowCount) then
    begin
      received_data.RowCount := received_data.RowCount + 1;
      received_data.Cells[0, received_data.RowCount - 1] := '';
    end;
    received_data.Cells[0, received_data_num] := res;
    received_data.Cells[1, received_data_num] := inttostr(received_data_num);
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
  if (Form1.com_port.Connected) then
  begin
    Form1.com_chg_state_btn.Caption := 'Закрыть порт';
    Form1.send_package_btn.Enabled  := TRUE;
  end else begin
    Form1.com_chg_state_btn.Caption := 'Открыть порт';
    Form1.send_package_btn.Enabled  := FALSE;
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
  str1, res: string;
  i: integer;
begin
  com_port.ReadStr(str1, Count);
  res := '';
  for i := 1 to Count do
  begin
    if ((str1[i] <> '0') and (str1[i] <> '1')) then
    begin
      break;
    end;
    res := res + str1[i];
  end;
  recognize_and_display(res);
end;

procedure TForm1.com_set_btnClick(Sender: TObject);
begin
  com_port.ShowSetupDialog;
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
  //
  Form1.Caption := inttostr(received_data.Row);

end;

procedure TForm1.send_package_btnClick(Sender: TObject);
var
  str1: string;
  i: integer;
begin
  str1 := hex_to_bin(START_BYTE);
  str1 := str1 + hex_to_bin(service_cmd.Text);
  for i := 1 to data_cmd_pack.ColCount - 1 do
  begin
    str1 := str1 + hex_to_bin(data_cmd_pack.Cells[i, 0]);
  end;
  for i := 1 to data_cmd_pack.ColCount - 1 do
  begin
    str1 := str1 + hex_to_bin(data_cmd_pack.Cells[i, 2]);
  end;
  for i := 1 to data_cmd_pack.ColCount - 1 do
  begin
    str1 := str1 + hex_to_bin(data_cmd_pack.Cells[i, 1]);
  end;
  for i := 1 to data_cmd_pack.ColCount - 1 do
  begin
    str1 := str1 + hex_to_bin(data_cmd_pack.Cells[i, 3]);
  end;
  str1 := str1 + hex_to_bin('00000000'); //CRC-byte
  send_command(str1);
  sended_data_num := sended_data_num + 1;
  if (sended_data_num = sended_data.RowCount) then
  begin
    sended_data.RowCount := sended_data.RowCount + 1;
    sended_data.Cells[0, sended_data.RowCount - 1] := '';
  end;
  sended_data.Cells[0, sended_data_num] := bin_to_hex(str1);
  sended_data.Cells[1, sended_data_num] := inttostr(sended_data_num);
end;

end.
