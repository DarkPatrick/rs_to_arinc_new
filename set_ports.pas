unit set_ports;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TForm4 = class(TForm)
    port_num1: TComboBox;
    port_num2: TComboBox;
    set_control: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure set_controlClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure port_num1Click(Sender: TObject);
    procedure port_num2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form4: TForm4;
  setup_this: boolean;
  ready_to_launch: boolean;
  cancel_main, cancel_extra, cancel_extra2: boolean;

implementation

{$R *.dfm}

procedure closeAll();
begin
  if (form4.port_num1.itemIndex > -1) then
  begin
    cancel_main := FALSE;
  end else begin
    cancel_main := TRUE;
  end;
  setup_this := FALSE;
end;

procedure TForm4.Button1Click(sender: TObject);
begin
  ready_to_launch := TRUE;
  form4.close();
end;

procedure TForm4.Button2Click(sender: TObject);
begin
  form4.close();
end;

procedure TForm4.FormClose(sender: TObject; var action: TCloseAction);
begin
  closeAll();
end;

procedure TForm4.FormCreate(sender: TObject);
begin
  setup_this      := FALSE;
  ready_to_launch := FALSE;
  cancel_main     := TRUE;
  cancel_extra    := TRUE;
  cancel_extra2   := TRUE;
end;

procedure TForm4.port_num1Click(sender: TObject);
begin
  cancel_main := FALSE;
end;

procedure TForm4.port_num2Change(sender: TObject);
begin
  cancel_extra2 := FALSE;
end;

procedure TForm4.set_controlClick(sender: TObject);
begin
  if (set_control.checked = TRUE) then
  begin
    port_num2.visible := TRUE;
    cancel_extra := FALSE;
  end else begin
    port_num2.visible := FALSE;
    cancel_extra := TRUE;
    cancel_extra2 := TRUE;
  end;
end;

end.
