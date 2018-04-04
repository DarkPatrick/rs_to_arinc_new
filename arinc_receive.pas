unit arinc_receive;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, convertation, string_numbers;

type
  Tarinc_rec = class(TForm)
    arinc_chnl: TLabeledEdit;
    arinc_addr: TLabeledEdit;
    data_grid: TStringGrid;
    apply_btn: TButton;
    data_s_grid: TStringGrid;
    get_data_label: TLabel;
    send_data_label: TLabel;
    arinc_send_addr: TLabeledEdit;
    interval_val: TLabeledEdit;
    stop_send_btn: TButton;
    cont_send_btn: TButton;
    clr_snd_btn: TButton;
    clr_rcv_btn: TButton;
    procedure FormCreate(sender: TObject);
    procedure arinc_chnlKeyPress(sender: TObject; var key: char);
    procedure arinc_addrKeyPress(sender: TObject; var key: char);
    procedure apply_btnClick(Sender: TObject);
    procedure data_gridDrawCell(sender: TObject; ACol, ARow: integer;
      rect: TRect; state: TGridDrawState);
    procedure interval_valKeyPress(sender: TObject; var key: char);
    procedure arinc_send_addrKeyPress(Sender: TObject; var Key: Char);
    procedure stop_send_btnClick(Sender: TObject);
    procedure cont_send_btnClick(Sender: TObject);
    procedure clr_snd_btnClick(Sender: TObject);
    procedure clr_rcv_btnClick(Sender: TObject);
    procedure data_s_gridKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  arinc_rec: Tarinc_rec;
  global_chnl, global_addrs: integer;
  interval: integer;
  global_addr: array[1..256] of integer;
  time_passed: array[1..256] of byte;
  new_addr_str: string;
  sending_proc: boolean;

procedure send_calibr();
procedure receiveStringCmd(rec_str: string);

implementation

{$R *.dfm}

procedure send_calibr();
var
  i, new_row_cnt: integer;
begin
  with arinc_rec do
  begin
    if ((arinc_send_addr.text = '') or (arinc_send_addr.text = '0')) then
    begin
      new_row_cnt := 2;
    end else begin
      new_row_cnt := strToInt(arinc_send_addr.text) + 1;
    end;
    arinc_send_addr.text := intToStr(new_row_cnt - 1);
    for i := data_s_grid.rowCount to new_row_cnt - 1 do
    begin
      data_s_grid.rows[i].clear;
    end;
    data_s_grid.rowCount := new_row_cnt;
    if (interval_val.text = '') then
    begin
      interval := 0;
    end else begin
      interval := strToInt(interval_val.text);
    end;
    if (interval < 20) then
    begin
      interval := 20;
    end;
    if (interval > 2000) then
    begin
      interval := 2000;
    end;
    interval_val.text := intToStr(interval);
  end;
end;

procedure Tarinc_rec.apply_btnClick(Sender: TObject);
var
  i, j, tmp: integer;
  left_num_str, right_num_str: string;
  left_num, right_num: integer;
  left_gone, repeated: boolean;
  str_num: StringNumber;
begin
  str_num := StringNumber.create('0', 8);
  new_addr_str := '';
  for i := 1 to length(arinc_addr.text) do
  begin
    if (arinc_addr.text[i] <> ' ') then
    begin
      if (charInSet(arinc_addr.text[i],
        ['0', '1', '2', '3', '4', '5', '6', '7', '-', ','])) then
      begin
        new_addr_str := new_addr_str + arinc_addr.text[i];
      end;
    end;
  end;
  if (arinc_chnl.text <> '') then
  begin
    global_chnl := hex_to_int(ansiUpperCase(arinc_chnl.text));
  end else begin
    global_chnl := 0;
  end;
  left_num  := -1;
  right_num := -1;
  left_num_str  := '';
  right_num_str := '';
  left_gone := FALSE;
  for i := 1 to length(new_addr_str) do
  begin
    if (charInSet(new_addr_str[i],
      ['0', '1', '2', '3', '4', '5', '6', '7'])) then
    begin
      if (left_gone = FALSE) then
      begin
        left_num_str  := left_num_str  + new_addr_str[i];
      end else begin
        right_num_str := right_num_str + new_addr_str[i];
      end;
    end else if (new_addr_str[i] = '-') then
    begin
      left_gone := TRUE;
    end else begin
      if (left_num_str <> '') then
      begin
        str_num.setNewVal(left_num_str);
        left_num := str_num.getDecimalRepresent();
      end;
      if (right_num_str <> '') then
      begin
        str_num.setNewVal(right_num_str);
        right_num := str_num.getDecimalRepresent();
      end;
      left_num_str  := '';
      right_num_str := '';
      if (left_num >= 0) then
      begin
        repeated := FALSE;
        for j := 1 to global_addrs do
        begin
          if (global_addr[j] = left_num) then
          begin
            repeated := TRUE;
            break;
          end;
        end;
        if (not repeated) then
        begin
          inc(global_addrs);
          global_addr[global_addrs] := left_num;
        end;
        if (right_num > left_num) then
        begin
          for j := left_num + 1 to right_num do
          begin
            repeated := FALSE;
            for tmp := 1 to global_addrs do
            begin
              if (global_addr[tmp] = j) then
              begin
                repeated := TRUE;
                break;
              end;
            end;
            if (not repeated) then
            begin
              inc(global_addrs);
              global_addr[global_addrs] := j;
            end;
          end;
        end;
      end;
      left_num  := -1;
      right_num := -1;
      left_gone := FALSE;
    end;
  end;
  if (left_num_str <> '') then
  begin
    str_num.setNewVal(left_num_str);
    left_num  := str_num.getDecimalRepresent();
  end;
  if (right_num_str <> '') then
  begin
    str_num.setNewVal(right_num_str);
    right_num := str_num.getDecimalRepresent();
  end;
  left_num_str  := '';
  right_num_str := '';
  if (left_num >= 0) then
  begin
    repeated := FALSE;
    for j := 1 to global_addrs do
    begin
      if (global_addr[j] = left_num) then
      begin
        repeated := TRUE;
        break;
      end;
    end;
    if (not repeated) then
    begin
      inc(global_addrs);
      global_addr[global_addrs] := left_num;
    end;
    if (right_num > left_num) then
    begin
      for j := left_num + 1 to right_num do
      begin
        repeated := FALSE;
        for tmp := 1 to global_addrs do
        begin
          if (global_addr[tmp] = j) then
          begin
            repeated := TRUE;
            break;
          end;
        end;
        if (not repeated) then
        begin
          inc(global_addrs);
          global_addr[global_addrs] := j;
        end;
      end;
    end;
  end;
  new_addr_str := '';
  arinc_addr.text := '';
  for i := 1 to global_addrs do
  begin
    for j := i + 1 to global_addrs do
    begin
      if (global_addr[i] > global_addr[j]) then
      begin
        tmp := global_addr[i];
        global_addr[i] := global_addr[j];
        global_addr[j] := tmp;
      end;
    end;
  end;
  data_grid.rowCount := global_addrs + 1;
  for i := data_grid.fixedRows to data_grid.rowCount - 1 do
  begin
    data_grid.rows[i].clear;
  end;
  for i := 1 to global_addrs do
  begin
    time_passed[i] := 0;
    str_num.setNewVal(intToStr(global_addr[i]), 10);
    data_grid.cells[0, i] := ' ' + str_num.getInBase(8, 2);
    arinc_addr.text := arinc_addr.text + str_num.getInBase(8, 1);
    if (i <> global_addrs) then
    begin
      arinc_addr.text := arinc_addr.text + ', ';
    end;
  end;
  data_grid.cells[0, 0] := ' адрес';
  data_grid.cells[1, 0] := ' признак';
  data_grid.cells[2, 0] := ' данные';
  data_grid.Invalidate();

  send_calibr();
end;

procedure Tarinc_rec.arinc_addrKeyPress(sender: TObject; var key: char);
begin
  if ((not charInSet(key, ['0', '1', '2', '3', '4', '5', '6', '7',
    '-', ',', ' '])) and (key <> char(VK_DELETE))
      and (key <> char(VK_BACK)) and (key <> char(VK_RETURN))
        and (key <> char(VK_TAB)) and (key <> char(VK_LEFT))
          and (key <> char(VK_RIGHT)) and (key <> char(VK_ESCAPE))) then
  begin
    showMessage('адрес устройства должен содержать набор номеров или '
      + 'интервалов в восьмеричной системе, перечисленных через запятую');
    abort;
  end else begin
    global_addrs := 0;
  end;
end;

procedure Tarinc_rec.arinc_chnlKeyPress(sender: TObject; var key: char);
begin
  if ((not charInSet(key, [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
      'A', 'B', 'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f']))
        and (key <> char(VK_DELETE)) and (key <> char(VK_BACK))
          and (key <> char(VK_RETURN)) and (key <> char(VK_TAB))
            and (key <> char(VK_LEFT))  and (key <> char(VK_RIGHT))
              and (key <> char(VK_ESCAPE))) then
  begin
    showMessage('номер канала должен быть целым шестнадцатеричным числом');
    abort;
  end;
end;

procedure Tarinc_rec.arinc_send_addrKeyPress(Sender: TObject; var Key: Char);
begin
  if ((not charInSet(key, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']))
    and (key <> char(VK_DELETE)) and (key <> char(VK_BACK))
      and (key <> char(VK_RETURN)) and (key <> char(VK_TAB))
        and (key <> char(VK_LEFT))  and (key <> char(VK_RIGHT))
          and (key <> char(VK_ESCAPE))) then
  begin
    showMessage('количество посылок должно быть целым числом');
    abort;
  end;
end;

procedure Tarinc_rec.clr_rcv_btnClick(Sender: TObject);
var
  i: integer;
begin
  for i := data_grid.fixedRows to data_grid.rowCount - 1 do
  begin
    data_grid.rows[i].clear;
  end;
  for i := 1 to global_addrs do
  begin
    time_passed[i] := 0;
    data_grid.cells[0, i] := ' ' + intToHex(global_addr[i], 2);
  end;
  data_grid.cells[0, 0] := ' адрес';
  data_grid.cells[1, 0] := ' признак';
  data_grid.cells[2, 0] := ' данные';
  data_grid.Invalidate();
end;

procedure Tarinc_rec.clr_snd_btnClick(Sender: TObject);
var
  i: integer;
begin
  for i := data_s_grid.fixedRows to data_s_grid.rowCount - 1 do
  begin
    data_s_grid.rows[i].clear;
  end;
end;

procedure Tarinc_rec.cont_send_btnClick(Sender: TObject);
begin
  sending_proc          := TRUE;
  stop_send_btn.enabled := TRUE;
  cont_send_btn.enabled := FALSE;
end;

procedure Tarinc_rec.data_gridDrawCell(sender: TObject; ACol, ARow: integer;
  rect: TRect; state: TGridDrawState);
begin
  with data_grid do
  begin
    canvas.brush.color := clWhite;
    canvas.fillRect(rect);
    canvas.font.color := clBlack;
    if ((ARow > 0) and (ACol > 0) and (cells[ACol, ARow] <> '')) then
    begin
      canvas.font.color := rgb(time_passed[ARow], 0, 255 - time_passed[ARow]);
    end else begin
      canvas.font.color := clBlack;
    end;
    canvas.textOut(rect.left + 1, rect.top + 1, cells[ACol, ARow]);
  end;
end;

procedure Tarinc_rec.data_s_gridKeyPress(Sender: TObject; var Key: Char);
begin
  if (data_s_grid.col = 0) then
  begin
    if ((not charInSet(key, ['0', '1', '2', '3', '4', '5', '6', '7']))
      and (key <> char(VK_DELETE)) and (key <> char(VK_BACK))
        and (key <> char(VK_RETURN)) and (key <> char(VK_TAB))
          and (key <> char(VK_LEFT))  and (key <> char(VK_RIGHT))
            and (key <> char(VK_ESCAPE))) then
    begin
      showMessage('значение поля ''адрес'' должно быть '
        + 'восьмеричным числом');
      abort;
    end;
  end;
  if (data_s_grid.col = 1) then
  begin
    if ((not charInSet(key, ['0', '1']))
      and (key <> char(VK_DELETE)) and (key <> char(VK_BACK))
        and (key <> char(VK_RETURN)) and (key <> char(VK_TAB))
          and (key <> char(VK_LEFT)) and (key <> char(VK_RIGHT))
            and (key <> char(VK_ESCAPE))) then
    begin
      showMessage('значение матрицы признака должно быть двоичным числом');
      abort;
    end;
  end;
  if (data_s_grid.col = 2) then
  begin
    if ((not charInSet(key, [
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        'A', 'B', 'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f']))
          and (key <> char(VK_DELETE)) and (key <> char(VK_BACK))
            and (key <> char(VK_RETURN)) and (key <> char(VK_TAB))
              and (key <> char(VK_LEFT))  and (key <> char(VK_RIGHT))
                and (key <> char(VK_ESCAPE))) then
    begin
      showMessage('значение поля ''данные'' должно быть '
        + 'шестнадцатеричным числом');
      abort;
    end;
  end;
end;

procedure Tarinc_rec.FormCreate(sender: TObject);
begin
  data_grid.cells[0, 0]   := ' адрес';
  data_grid.cells[1, 0]   := ' признак';
  data_grid.cells[2, 0]   := ' данные';
  data_s_grid.cells[0, 0] := 'адрес';
  data_s_grid.cells[1, 0] := 'признак';
  data_s_grid.cells[2, 0] := 'данные';
  global_addrs   := 0;
  new_addr_str   := '';
  global_chnl    := 0;
  time_passed[1] := 0;
  sending_proc   := TRUE;
end;

procedure Tarinc_rec.interval_valKeyPress(sender: TObject; var key: char);
begin
  if ((not charInSet(key, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']))
    and (key <> char(VK_DELETE)) and (key <> char(VK_BACK))
      and (key <> char(VK_RETURN)) and (key <> char(VK_TAB))
        and (key <> char(VK_LEFT))  and (key <> char(VK_RIGHT))
          and (key <> char(VK_ESCAPE))) then
  begin
    showMessage('значение интервала должно быть целым числом');
    abort;
  end;
end;

procedure Tarinc_rec.stop_send_btnClick(Sender: TObject);
begin
  sending_proc          := FALSE;
  stop_send_btn.enabled := FALSE;
  cont_send_btn.enabled := TRUE;
end;

procedure receiveStringCmd(rec_str: string);
var
  i, j, k: integer;
  str1, str2, gl_cnt: string;
  one_found: boolean;
  str_num: StringNumber;
begin
  one_found := FALSE;
  str1 := chars_to_hex(rec_str);
  with arinc_rec do
  begin
    str_num := StringNumber.create('0', 16);
    for i := 1 to 11 do
    begin
      for j := 1 to data_grid.rowCount - 1 do
      begin
        gl_cnt := intToHex(global_chnl, 2);
        if (length(gl_cnt) = 1) then
        begin
          gl_cnt := '0' + gl_cnt;
        end;
        if (str1[15 + i * 2] + str1[16 + i * 2] = gl_cnt) then
        begin
          str_num.setNewVal(str1[45 + (i - 1) * 8] + str1[46 + (i - 1) * 8]);
          if (' ' + str_num.getInBase(8, 2) = data_grid.cells[0, j]) then
          begin
            time_passed[j] := 0;
            one_found := TRUE;
            str2 := hex_to_bin(str1[39 + (i - 1) * 8]);
            data_grid.cells[1, j] := str2[2] + str2[3];
            data_grid.cells[2, j] := '';
            for k := 1 to 5 do
            begin
              data_grid.cells[2, j] := data_grid.cells[2, j]
                + str1[39 + (i - 1) * 8 + k];
            end;
            data_grid.cells[2, j] := str2[4] + data_grid.cells[2, j];
            break;
          end;
        end;
      end;
    end;
    if (one_found = TRUE) then
    begin
      for i := 1 to data_grid.rowCount - 1 do
      begin
        if (time_passed[i] < 255) then
        begin
          inc(time_passed[i], 5);
        end;
      end;
      data_grid.Invalidate();
    end;
    str_num.free();
  end;
end;

end.
