program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {frmMain},
  Operations in 'Operations.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
