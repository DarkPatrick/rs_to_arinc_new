unit set_mutex;



interface

uses
  Windows, System.SysUtils;

function get_mutex(): THandle;
function get_mutex_num(): integer;
procedure delete_mutex();



implementation

var
  mutex: THandle;
  i, str_len, mutex_num: integer;
  mutex_num_str: string;
  mutex_name: array[0..255] of char;
  good: boolean;

function get_mutex(): THandle;
begin
  result := mutex;
end;

function get_mutex_num(): integer;
begin
  result := mutex_num;
end;

procedure delete_mutex();
begin
  closeHandle(mutex);
end;

begin
  mutex_num := 0;
  str_len := getModuleFileName(mainInstance, mutex_name, sizeOf(mutex_name));
  for i := 0 to str_len - 1 do
  begin
    if (mutex_name[I] = '\') then
    begin
      mutex_name[I] := '/';
    end;
  end;
  mutex_num_str := intToStr(mutex_num);
  mutex_name[str_len] := mutex_num_str[1];

  repeat
    good := TRUE;
    mutex := createMutex(nil, FALSE, mutex_name);
    if (mutex = 0) then
    begin
      messageBox(0, 'Невозможно создать мьютекс', 'Ошибка',
        MB_OK or MB_ICONSTOP);
      good := FALSE;
      halt;
    end else begin
      if (getLastError = ERROR_ALREADY_EXISTS) then
      begin
        good := FALSE;
      end;
    end;
    mutex_num := mutex_num + 1;
    mutex_num_str := intToStr(mutex_num);
    for i := 1 to length(mutex_num_str) do
    begin
      mutex_name[str_len + i - 1] := mutex_num_str[i];
    end;
  until (good = TRUE);
end.

