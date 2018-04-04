unit processing_protoсol;



interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids,
  Vcl.StdCtrls, convertation;

type
  TForm2 = class(TForm)
    arinc_protocol: TStringGrid;
    Button1: TButton;
    filter_param: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TPackage = record
    str_data: array[0..63] of char;
    pack_num: integer;
    time: TDateTime;
  end;

var
  Form2: TForm2;

procedure prepare_file(file_name: string = '');
procedure write_pack_to_file(pack: TPackage);
function read_pack_to_file(): TPackage;
procedure close_file();
procedure get_all_data_from(grid: TstringGrid);



implementation

{$R *.dfm}

const
  NUM_BEFORE_FLUSH = 2;//50;

var
  data_file: file of TPackage;
  writed_packs: integer;

procedure prepare_file(file_name: string = '');
var
  i: integer;
begin
  if (file_name = '') then
  begin
    file_name := dateTimeToStr(Now());
    for i := 1 to length(file_name) do
    begin
      if (file_name[i] = ' ') then
      begin
        file_name[i] := '_';
      end;
      if (charInSet(
        file_name[i], ['.', ':', '"', '\', '/', '|', '*', '?', '<', '>']
      )) then
      begin
        file_name[i] := '#';
      end;
    end;
    //file_name := GetCurrentDir() + '\saved_data\' + file_name + '_'
      //+ intToStr(round(GetTickCount() / 1000)) + '.pac';
    file_name := GetCurrentDir() + '\saved_data\' + file_name + '.pac';
  end;

  //assignFile(data_file, GetCurrentDir() + '\saved_data\' + file_name);
  assignFile(data_file, file_name);
  rewrite(data_file);

  writed_packs := 0;
end;

procedure write_pack_to_file(pack: TPackage);
begin
  write(data_file, pack);
  writed_packs := writed_packs + 1;
  if (writed_packs > NUM_BEFORE_FLUSH) then
  begin
    closeFile(data_file);
    reset(data_file);
    seek(data_file, fileSize(data_file));
    writed_packs := 0;
  end;
end;

function read_pack_to_file(): TPackage;
var
  pack: TPackage;
begin
  read(data_file, pack);
  result := pack;
end;

procedure close_file();
begin
  closeFile(data_file);
end;

procedure get_all_data_from(grid: TstringGrid);
var
  i, j, k, l, g, str_pos, val: integer;
  str1: string;
begin
  j := 1;
  //в одном пакете может быть несколько команд
  for i := 0 to grid.RowCount - 2 do
  begin
    str1 := grid.Cells[0, i];
    str1 := chars_to_hex(str1);
    str_pos := 7;
    with Form2.arinc_protocol do
    begin
      for k := 1 to 12 do
      begin
        val := hex_to_int(str1[str_pos] + str1[str_pos + 1]);
        if ((val > 0) and (val < 13)) then
        begin
          cells[0, j] := str1[str_pos] + str1[str_pos + 1];
          l := str_pos + 24;
          cells[1, j] := str1[l] + str1[l + 1];
          cells[2, j] := '';
          for g := l + 2 to l + 20 do
          begin
            cells[1, j] := cells[1, j] + str1[g];
          end;
          j := j + 1;
          if (j = rowCount) then
          begin
            rowCount := rowCount + 1;
          end;
        end;
        str_pos := str_pos + 2;
      end;
    end;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  writed_packs := 0;

  arinc_protocol.Cells[0, 0] := 'Идентификатор';
  arinc_protocol.Cells[1, 0] := 'Источник';
  arinc_protocol.Cells[2, 0] := 'Данные';
  arinc_protocol.Cells[3, 0] := 'Матрица признака';

  filter_param.Cells[0, 0] := 'Название столбца';
  filter_param.Cells[1, 0] := 'Фильтр';
end;

end.
