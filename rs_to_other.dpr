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
  string_numbers in 'string_numbers.pas';

{$R *.res}

begin
  application.initialize;
  application.mainFormOnTaskbar := TRUE;
  //Application.HelpFile := '\help.chm';
  application.createForm(TForm1, form1);
  application.createForm(TForm2, form2);
  application.createForm(TForm3, form3);
  application.createForm(TForm4, form4);
  application.createForm(Tarinc_rec, arinc_rec);
  application.createForm(Tinfo_form, info_form);
  application.run;
end.
