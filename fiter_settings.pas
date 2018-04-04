unit fiter_settings;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
    TForm3 = class(TForm)
        filter_col: TComboBox;
        filter_typ: TComboBox;
        filter_val: TEdit;
        ok_btn: TButton;
        cancel_btn: TButton;
        procedure ok_btnClick(Sender: TObject);
        procedure cancel_btnClick(Sender: TObject);
        procedure FormActivate(Sender: TObject);
        procedure FormCreate(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    Form3: TForm3;
    ok_pressed: boolean;

implementation

{$R *.dfm}

procedure TForm3.cancel_btnClick(Sender: TObject);
begin
    ok_pressed := FALSE;
    Form3.Close;
end;

procedure TForm3.FormActivate(Sender: TObject);
begin
    ok_pressed := FALSE;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
    ok_pressed := FALSE;
end;

procedure TForm3.ok_btnClick(Sender: TObject);
begin
    ok_pressed := TRUE;
    Form3.Close;
end;

end.
