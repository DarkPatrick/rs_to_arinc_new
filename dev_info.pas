unit dev_info;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
    Vcl.StdCtrls, Vcl.ExtCtrls;

type
    Tinfo_form = class(TForm)
        dev_num: TLabeledEdit;
    board_num: TLabeledEdit;
    pins_state: TLabeledEdit;
        procedure FormCreate(Sender: TObject);
        procedure dev_numKeyPress(Sender: TObject; var Key: Char);
        procedure dev_numKeyDown(Sender: TObject; var Key: Word;
          Shift: TShiftState);
        procedure dev_numContextPopup(Sender: TObject; MousePos: TPoint;
          var Handled: Boolean);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    info_form: Tinfo_form;

implementation

{$R *.dfm}

procedure Tinfo_form.dev_numContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
    abort();
end;

procedure Tinfo_form.dev_numKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    abort();
end;

procedure Tinfo_form.dev_numKeyPress(Sender: TObject; var Key: Char);
begin
    abort();
end;

procedure Tinfo_form.FormCreate(Sender: TObject);
begin
    dev_num.clear();
end;

end.
