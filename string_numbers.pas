unit string_numbers;

interface

uses
    System.SysUtils, System.Math;

type
    StringNumber = class
    public type
        TError = (NO_ERRORS = 0, WRONG_BASE = 1, WRONG_SYMB = 2);
    private
        procedure checkBase();
        procedure checkValue(del_bad: boolean);
        procedure convertToDec();
        procedure basicCreateFun(num_val: string; base: byte;
          del_bad: boolean = TRUE);
    public
        constructor create(); overload;
        constructor create(num_val: string; base: byte;
          del_bad: boolean = TRUE); overload;
        procedure setNewVal(num_val: string; del_bad: boolean = TRUE); overload;
        procedure setNewVal(num_val: string; new_base: byte;
          del_bad: boolean = TRUE); overload;
        procedure convert(new_base: byte; num_of_digits: integer = 1);
        function getInBase(new_base: byte; num_of_digits: integer = 1): string;
        function getValue(): string;
        function getBase(): byte;
        function getError(): TError;
        function getDecimalRepresent(): integer;
    private
        last_error: TError;
        value: string;
        decimal_repr: integer;
        base: byte;
    end;

function log(num: integer; base: integer): extended;

implementation

function log(num: integer; base: integer): extended;
begin
    result := ln(num) / ln(base);
end;

procedure StringNumber.checkBase();
begin
    if (base < 2) then
    begin
        last_error := WRONG_BASE;
        base := 2;
    end;

    if (base > 36) then
    begin
        last_error := WRONG_BASE;
        base := 36;
    end;
end;

procedure StringNumber.checkValue(del_bad: boolean);
var
    appropriate_chars: set of ansiChar;
    new_val: string;
    i: integer;
begin
    checkBase();

    if (base < 11) then
    begin
        appropriate_chars := ['0' .. chr(47 + base)];
    end
    else
    begin
        appropriate_chars := ['0' .. '9'];
        appropriate_chars := appropriate_chars + ['A' .. chr(54 + base)];
    end;

    value := ansiUpperCase(value);
    new_val := value;

    if (del_bad) then
    begin
        new_val := '';
    end;

    for i := 1 to length(value) do
    begin
        if ((del_bad) and (charInSet(value[i], appropriate_chars))) then
        begin
            new_val := new_val + value[i];
        end;
        if ((not del_bad) and (not charInSet(value[i], appropriate_chars))) then
        begin
            last_error := WRONG_SYMB;
            value := '0';
            exit();
        end;
    end;

    if (del_bad) then
    begin
        value := new_val;
    end;

    if (value = '') then
    begin
        value := '0';
    end;
end;

procedure StringNumber.convertToDec();
var
    all_nums: string;
    i: integer;
begin
    all_nums := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    decimal_repr := 0;

    for i := 1 to length(value) do
    begin
        decimal_repr := decimal_repr + (pos(value[i], all_nums) - 1) *
          round(power(base, length(value) - i));
    end;
end;

procedure StringNumber.basicCreateFun(num_val: string; base: byte;
  del_bad: boolean = TRUE);
begin
    last_error := NO_ERRORS;
    self.base := base;
    value := num_val;

    checkValue(del_bad);

    convertToDec();
end;

constructor StringNumber.create();
begin
    inherited;
    basicCreateFun('0', 10);
end;

constructor StringNumber.create(num_val: string; base: byte;
  del_bad: boolean = TRUE);
begin
    basicCreateFun(num_val, base, del_bad);
end;

procedure StringNumber.setNewVal(num_val: string; del_bad: boolean = TRUE);
begin
    basicCreateFun(num_val, self.base, del_bad);
end;

procedure StringNumber.setNewVal(num_val: string; new_base: byte;
  del_bad: boolean = TRUE);
begin
    basicCreateFun(num_val, new_base, del_bad);
end;

procedure StringNumber.convert(new_base: byte; num_of_digits: integer = 1);
begin
    base := new_base;
    value := getInBase(new_base, num_of_digits);
end;

function StringNumber.getInBase(new_base: byte;
  num_of_digits: integer = 1): string;
var
    all_nums, new_val: string;
    pow_val: extended;
    i, num, pow: integer;
    old_base: byte;
begin
    old_base := base;
    base := new_base;
    checkBase();
    new_base := base;
    base := old_base;

    all_nums := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    if (num_of_digits < 1) then
    begin
        num_of_digits := 1;
    end;

    new_val := '';
    num := decimal_repr;

    if (num > 1) then
    begin
        pow := floor(log(num, new_base));
        for i := pow downto 0 do
        begin
            pow_val := power(new_base, i);
            new_val := new_val + all_nums[floor(num / pow_val) + 1];
            num := num - floor(pow_val) * floor(num / pow_val);
        end;
    end;

    if (num > 0) then
    begin
        new_val := new_val + chr(num + 48);
    end;

    for i := length(new_val) to num_of_digits - 1 do
    begin
        new_val := '0' + new_val;
    end;

    result := new_val;
end;

function StringNumber.getValue(): string;
begin
    result := value;
end;

function StringNumber.getBase(): byte;
begin
    result := base;
end;

function StringNumber.getError(): TError;
begin
    result := last_error;
end;

function StringNumber.getDecimalRepresent(): integer;
begin
    result := decimal_repr;
end;

end.
