unit detect_ports;

interface

uses
    Windows, SysUtils, Classes, StrUtils;

procedure get_com_ports(list: TStrings; name_start: string);

implementation

function get_next_substring(buf: string; var start_pos: integer): string;
var
    last_pos: integer;
begin
    if (start_pos < 1) then
    begin
        raise ERangeError.create('aStartPos должен быть больше 0');
    end;

    if (start_pos > length(buf)) then
    begin
        result := '';
        exit;
    end;

    last_pos := posEx(#0, buf, start_pos);
    result := copy(buf, start_pos, last_pos - start_pos);
    start_pos := start_pos + (last_pos - start_pos) + 1;
end;

procedure get_com_ports(list: TStrings; name_start: string);
var
    buf: string;
    res: integer;
    err: integer;
    buf_size: integer;
    name_start_pos: integer;
    name: string;
begin
    buf_size := 1024 * 5;
    res := 0;

    while (res = 0) do
    begin
        setLength(buf, buf_size);
        setLastError(ERROR_SUCCESS);
        res := queryDosDevice(nil, @buf[1], buf_size);
        err := getLastError();
        if ((res <> 0) and (err = ERROR_INSUFFICIENT_BUFFER)) then
        begin
            buf_size := res;
            res := 0;
        end;

        if ((res = 0) and (err = ERROR_INSUFFICIENT_BUFFER)) then
        begin
            buf_size := buf_size + 1024;
        end;

        if ((err <> ERROR_SUCCESS) and (err <> ERROR_INSUFFICIENT_BUFFER)) then
        begin
            raise exception.create(sysErrorMessage(err));
        end;
    end;
    setLength(buf, res);

    name_start_pos := 1;
    name := get_next_substring(buf, name_start_pos);

    list.beginUpdate();
    try
        list.clear();
        while (name <> '') do
        begin
            if (startsStr(name_start, name)) then
            begin
                list.add(name);
            end;
            name := get_next_substring(buf, name_start_pos);
        end;
    finally
        list.endUpdate();
    end;
end;

end.
