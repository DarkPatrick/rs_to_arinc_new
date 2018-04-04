unit convertation;

interface

uses
  Vcl.Dialogs, Math, System.SysUtils;

var
  hex: array[0 .. 15] of string = ('0', '1', '2', '3', '4', '5', '6', '7', '8',
  '9', 'A', 'B', 'C', 'D', 'E', 'F');

function int_to_bin(num: integer; num_of_digits: integer = 0): string;
function bin_to_int(bin_num: string): integer;
function hex_to_bin(hex_num: string): string;
function bin_to_hex(bin_num: string; num_of_digits: integer = 0): string;
function hex_to_int(hex_num: string): integer;
function hex_to_chars(hex_num: string): string;
function chars_to_hex(chars: string): string;

implementation

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

function bin_to_int(bin_num: string): integer;
var
  res, i: integer;
begin
  res := 0;
  for i := 1 to length(bin_num) do
  begin
    if (bin_num[i] = '1') then
    begin
      res := res + round(power(2, length(bin_num) - i));
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
      showMessage('ERROR: wrong hex num: ' + hex_num);
      res := '0';
      break;
    end else begin
      num := num - 1;
      res := res + int_to_bin(num, 4);
    end;
  end;
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

function hex_to_int(hex_num: string): integer;
var
  i, num, res, len: integer;
begin
  res := 0;
  len := length(hex_num);
  for i := 1 to len do
  begin
    num := pos(hex_num[i], '0123456789ABCDEF');
    if (num = 0) then
    begin
      showMessage('ERROR: wrong hex num: ' + hex_num);
      res := 0;
      break;
    end else begin
      num := num - 1;
      res := res + round(power(16, len - i) * num);
    end;
  end;
  result := res;
end;

function hex_to_chars(hex_num: string): string;
var
  i, len, num: integer;
  sub_str, res: string;
begin
  i := 1;
  len := length(hex_num);
  res := '';
  while (i < len) do
  begin
    sub_str := hex_num[i] + hex_num[i + 1];
    num := hex_to_int(sub_str);
    res := res + chr(num);
    i := i + 2;
  end;
  result := res;
end;

function chars_to_hex(chars: string): string;
var
  i, num: integer;
  res: string;
begin
  res := '';
  for i := 1 to length(chars) do
  begin
    num := ord(chars[i]);
    res := res + intToHex(num, 2);
  end;
  result := res;
end;

end.

