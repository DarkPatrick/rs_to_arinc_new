unit processing_protocol;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
    Vcl.Grids,
    Vcl.StdCtrls, convertation, fiter_settings;

type
    TForm2 = class(TForm)
        arinc_protocol: TStringGrid;
        add_filter_btn: TButton;
        filter_param: TStringGrid;
        del_filter_btn: TButton;
        filters_info: TStringGrid;
        procedure FormCreate(sender: TObject);
        procedure add_filter_btnClick(sender: TObject);
        procedure FormActivate(sender: TObject);
        procedure del_filter_btnClick(sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

type
    TPackage = record
        str_data: array [0 .. 63] of char;
        pack_num: integer;
        time: TDateTime;
    end;

var
    form2: TForm2;
    gl_grid: TStringGrid;

procedure prepare_file(file_name: string = '');
procedure write_pack_to_file(pack: TPackage);
function read_pack_to_file(): TPackage;
procedure close_file();
procedure get_all_data_from(grid: TStringGrid);

implementation

{$R *.dfm}

const
    NUM_BEFORE_FLUSH = 200;

var
    data_file: file of TPackage;
    writed_packs: integer;

procedure apply_filter();
var
    i, j, k, m, n, cmd_num, col_num: integer;
    cmd: string;
    single_cmd: array [1 .. 3] of string;
    del: boolean;
begin
    for i := 0 to form2.filters_info.rowCount - 2 do
    begin
        cmd_num := 1;
        cmd := form2.filters_info.cells[0, i];
        single_cmd[cmd_num] := '';
        for j := 1 to length(cmd) do
        begin
            if (cmd[j] <> ' ') then
            begin
                single_cmd[cmd_num] := single_cmd[cmd_num] + cmd[j];
            end
            else
            begin
                if (cmd_num = 3) then
                begin
                    break;
                end;
                cmd_num := cmd_num + 1;
                single_cmd[cmd_num] := '';
            end;
        end;
        if (cmd_num < 3) then
        begin
            exit;
        end;
        col_num := strToInt(single_cmd[1]);
        k := 1;
        with form2.arinc_protocol do
        begin
            while (k < rowCount - 1) do
            begin
                del := FALSE;
                if (single_cmd[2] = '2') then
                begin
                    if (single_cmd[3] <> cells[col_num, k]) then
                    begin
                        del := TRUE;
                    end;
                end;
                if (single_cmd[2] = '3') then
                begin
                    if (single_cmd[3] = cells[col_num, k]) then
                    begin
                        del := TRUE;
                    end;
                end;
                if (single_cmd[2] = '4') then
                begin
                    if (pos(single_cmd[3], cells[col_num, k]) = 0) then
                    begin
                        del := TRUE;
                    end;
                end;
                if (single_cmd[2] = '5') then
                begin
                    if (pos(single_cmd[3], cells[col_num, k]) <> 0) then
                    begin
                        del := TRUE;
                    end;
                end;
                if (del) then
                begin
                    cells[col_num, k] := '';
                    for m := k to rowCount - 2 do
                    begin
                        for n := 0 to 4 do
                        begin
                            cells[n, m] := cells[n, m + 1];
                        end;
                    end;
                    for n := 0 to 4 do
                    begin
                        cells[n, rowCount - 2] := '';
                    end;
                    rowCount := rowCount - 1;
                end
                else
                begin
                    k := k + 1;
                end;
            end;
        end;
    end;
end;

procedure prepare_file(file_name: string = '');
var
    i: integer;
begin
    if (file_name = '') then
    begin
        file_name := dateTimeToStr(now());
        for i := 1 to length(file_name) do
        begin
            if (file_name[i] = ' ') then
            begin
                file_name[i] := '_';
            end;
            if (charInSet(file_name[i], ['.', ':', '"', '\', '/', '|', '*', '?',
              '<', '>'])) then
            begin
                file_name[i] := '#';
            end;
        end;
        file_name := getCurrentDir() + '\saved_data\' + file_name + '.pac';
    end;

    if (not directoryExists(getCurrentDir() + '\saved_data\')) then
    begin
        mkDir(getCurrentDir() + '\saved_data\');
    end;

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

procedure get_all_data_from(grid: TStringGrid);
var
    i, j, k, l, str_pos, str_pos2, val: integer;
    str1, res: string;
begin
    j := 1;
    for i := 0 to grid.rowCount - 2 do
    begin
        str1 := grid.cells[0, i];
        str1 := hex_to_bin(chars_to_hex(str1));
        str_pos := 25;
        str_pos2 := 121;
        with form2.arinc_protocol do
        begin
            for k := 1 to 12 do
            begin
                res := '';
                for l := str_pos to str_pos + 7 do
                begin
                    res := res + str1[l];
                end;
                val := bin_to_int(res);
                if ((val > 0) and (val < 13)) then
                begin
                    cells[0, j] := bin_to_hex(res);
                    cells[1, j] := '';
                    for l := str_pos2 to str_pos2 + 8 do
                    begin
                        cells[1, j] := cells[1, j] + str1[l];
                    end;
                    cells[2, j] := '';
                    for l := str_pos2 + 9 to str_pos2 + 10 do
                    begin
                        cells[2, j] := cells[2, j] + str1[l];
                    end;
                    cells[3, j] := '';
                    for l := str_pos2 + 11 to str_pos2 + 29 do
                    begin
                        cells[3, j] := cells[3, j] + str1[l];
                    end;
                    cells[4, j] := '';
                    for l := str_pos2 + 30 to str_pos2 + 31 do
                    begin
                        cells[4, j] := cells[4, j] + str1[l];
                    end;
                    j := j + 1;
                    if (j = rowCount) then
                    begin
                        rowCount := rowCount + 1;
                    end;
                end;
                str_pos := str_pos + 8;
                str_pos2 := str_pos2 + 32;
            end;
        end;
    end;

    apply_filter();
end;

procedure TForm2.add_filter_btnClick(sender: TObject);
begin
    form3.show();
end;

procedure TForm2.del_filter_btnClick(sender: TObject);
var
    i, j: integer;
begin
    for i := 0 to 1 do
    begin
        for j := filter_param.row to filter_param.rowCount - 2 do
        begin
            filter_param.cells[i, j] := filter_param.cells[i, j + 1];
            filters_info.cells[i, j - 1] := filters_info.cells[i, j];
        end;
        filter_param.cells[i, filter_param.rowCount - 1] := '';
        filters_info.cells[i, filters_info.rowCount - 2] := '';
    end;
    filter_param.rowCount := filter_param.rowCount - 1;
    filters_info.rowCount := filters_info.rowCount - 1;

    get_all_data_from(gl_grid);
end;

procedure TForm2.FormActivate(sender: TObject);
begin
    if (ok_pressed) then
    begin
        filter_param.cells[0, filter_param.rowCount - 1] :=
          form3.filter_col.items[form3.filter_col.itemIndex];
        filter_param.cells[1, filter_param.rowCount - 1] :=
          form3.filter_typ.items[form3.filter_typ.itemIndex] +
          filter_param.cells[1, filter_param.rowCount - 1] + '   ' +
          form3.filter_val.text;
        filter_param.rowCount := filter_param.rowCount + 1;

        filters_info.cells[0, filters_info.rowCount - 1] :=
          intToStr(form3.filter_col.itemIndex) + ' ' +
          intToStr(form3.filter_typ.itemIndex) + ' ' +
          form3.filter_val.text + ' ';
        filters_info.rowCount := filters_info.rowCount + 1;

        get_all_data_from(gl_grid);
        ok_pressed := FALSE;
    end;
end;

procedure TForm2.FormCreate(sender: TObject);
begin
    writed_packs := 0;

    arinc_protocol.cells[0, 0] := 'Номер канала';
    arinc_protocol.cells[1, 0] := 'Идентификатор';
    arinc_protocol.cells[2, 0] := 'Источник';
    arinc_protocol.cells[3, 0] := 'Данные';
    arinc_protocol.cells[4, 0] := 'Матрица признака';

    filter_param.cells[0, 0] := 'Название столбца';
    filter_param.cells[1, 0] := 'Фильтр';
end;

end.
