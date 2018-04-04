program rs_to_other;

uses
  Vcl.Forms,
  main in 'main.pas' {Form1},
  convertation in 'convertation.pas',
  set_mutex in 'set_mutex.pas',
  detect_ports in 'detect_ports.pas',
  processing_protoñol in 'processing_protoñol.pas' {Form2},
  fiter_settings in 'fiter_settings.pas' {Form3},
  set_ports in 'set_ports.pas' {Form4},
  arinc_receive in 'arinc_receive.pas' {arinc_rec},
  dev_info in 'dev_info.pas' {info_form},
  string_numbers in 'string_numbers.pas',
  crc in 'crc.pas';

{$R *.res}

begin
  application.initialize;
  application.mainFormOnTaskbar := TRUE;
  //Application.HelpFile := '\help.chm';
  Application.CreateForm(Tform1, form1);
  Application.CreateForm(Tform2, form2);
  Application.CreateForm(Tform3, form3);
  Application.CreateForm(Tform4, form4);
  Application.CreateForm(Tarinc_rec, arinc_rec);
  Application.CreateForm(Tinfo_form, info_form);
  application.run;
end.
