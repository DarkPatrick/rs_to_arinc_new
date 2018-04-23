unit crc;

interface

uses
    convertation;

function crcCheckSum(data: String; len: Integer = 0): Byte;

implementation

const
    crc_table: array [0 .. 255] of Byte = ($00, $07, $0E, $09, $1C, $1B, $12,
      $15, $38, $3F, $36, $31, $24, $23, $2A, $2D, $70, $77, $7E, $79, $6C, $6B,
      $62, $65, $48, $4F, $46, $41, $54, $53, $5A, $5D, $E0, $E7, $EE, $E9, $FC,
      $FB, $F2, $F5, $D8, $DF, $D6, $D1, $C4, $C3, $CA, $CD, $90, $97, $9E, $99,
      $8C, $8B, $82, $85, $A8, $AF, $A6, $A1, $B4, $B3, $BA, $BD, $C7, $C0, $C9,
      $CE, $DB, $DC, $D5, $D2, $FF, $F8, $F1, $F6, $E3, $E4, $ED, $EA, $B7, $B0,
      $B9, $BE, $AB, $AC, $A5, $A2, $8F, $88, $81, $86, $93, $94, $9D, $9A, $27,
      $20, $29, $2E, $3B, $3C, $35, $32, $1F, $18, $11, $16, $03, $04, $0D, $0A,
      $57, $50, $59, $5E, $4B, $4C, $45, $42, $6F, $68, $61, $66, $73, $74, $7D,
      $7A, $89, $8E, $87, $80, $95, $92, $9B, $9C, $B1, $B6, $BF, $B8, $AD, $AA,
      $A3, $A4, $F9, $FE, $F7, $F0, $E5, $E2, $EB, $EC, $C1, $C6, $CF, $C8, $DD,
      $DA, $D3, $D4, $69, $6E, $67, $60, $75, $72, $7B, $7C, $51, $56, $5F, $58,
      $4D, $4A, $43, $44, $19, $1E, $17, $10, $05, $02, $0B, $0C, $21, $26, $2F,
      $28, $3D, $3A, $33, $34, $4E, $49, $40, $47, $52, $55, $5C, $5B, $76, $71,
      $78, $7F, $6A, $6D, $64, $63, $3E, $39, $30, $37, $22, $25, $2C, $2B, $06,
      $01, $08, $0F, $1A, $1D, $14, $13, $AE, $A9, $A0, $A7, $B2, $B5, $BC, $BB,
      $96, $91, $98, $9F, $8A, $8D, $84, $83, $DE, $D9, $D0, $D7, $C2, $C5, $CC,
      $CB, $E6, $E1, $E8, $EF, $FA, $FD, $F4, $F3);

function crcCheckSum(data: String; len: Integer = 0): Byte;
var
    i: Integer;
    crc_val: Byte;
begin
    crc_val := 0;
    if (len = 0) then
    begin
        len := length(data);
    end;
    for i := 1 to len do
    begin
        crc_val := crc_table[crc_val xor ord(data[i])];
    end;

    Result := crc_val;
end;

end.
