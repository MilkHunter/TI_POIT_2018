program TI4_lab;

uses
  Vcl.Forms,
  TI4 in 'TI4.pas' {Form3},
  Desicion in 'Desicion.pas' {frmDecision};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TfrmDecision, frmDecision);
  Application.Run;
end.
