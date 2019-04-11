unit Desicion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Buttons;

type
  TfrmDecision = class(TForm)
    imgDesicion: TImage;
    btnContinue: TBitBtn;
    lblDesicion: TLabel;
    procedure btnContinueClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    procedure AcceptDraw;
    procedure RejectDraw;
  end;

var
  frmDecision: TfrmDecision;

implementation

uses TI4;

procedure TfrmDecision.AcceptDraw;
var
  i, x, y: Integer;
begin
  with imgDesicion do
  begin
    Canvas.Pen.Color := clWhite;
    Canvas.Brush.Color := clWhite;
    Canvas.Rectangle(0, 0, imgDesicion.Height, imgDesicion.Width);
    Canvas.Pen.Color := clGreen;
    Canvas.Pen.Width := 3;
    x := imgDesicion.Width div 2 - 40;
    y := imgDesicion.Height div 2;
    Canvas.MoveTo(x, y);
    for i := 0 to 39 do
    begin
      x := x + 1;
      y := y + 1;
      Canvas.LineTo(x, y);
    end;

    for i := 0 to 89 do
    begin
      x := x + 1;
      y := y - 1;
      Canvas.LineTo(x, y);
    end;
    lblDesicion.Font.Color := clGreen;
    lblDesicion.Caption := 'Accept';
  end;
end;

procedure TfrmDecision.btnContinueClick(Sender: TObject);
begin
  frmDecision.Hide;
  TI4.Form3.Enabled := True;
end;

procedure TfrmDecision.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TI4.Form3.Enabled := True;
end;

procedure TfrmDecision.RejectDraw;
var
  i, x, y: Integer;
begin
  with imgDesicion do
  begin
    Canvas.Pen.Color := clWhite;
    Canvas.Brush.Color := clWhite;
    Canvas.Rectangle(0, 0, imgDesicion.Height, imgDesicion.Width);
    Rect(0, 0, imgDesicion.Height, imgDesicion.Width);
    Canvas.Pen.Color := clRed;
    Canvas.Pen.Width := 3;
    x := imgDesicion.Width div 2 - 80;
    y := imgDesicion.Height div 5;

    Canvas.MoveTo(x, y);
    Canvas.LineTo(x + 120, y + 120);

    x := imgDesicion.Width div 2 + 80;
    Canvas.MoveTo(x, y);
    Canvas.LineTo(x - 120, y + 120);

    lblDesicion.Font.Color := clRed;
    lblDesicion.Caption := 'Reject';
  end;
end;

{$R *.dfm}

end.
