unit Anim;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Gifimg;

type
  TfrmWait = class(TForm)
    imgAnim: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure imgAnimClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TWaitThread = class(TThread)
    private
    public
      procedure Execute; override;
  end;

const CRYPTING = True;

var
  frmWait: TfrmWait;
  GIF: TGIFImage;
  WaitThread: TWaitThread;

implementation

{$R *.dfm}


procedure TfrmWait.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  ShowMessage('Подождите!');
  CanClose := False;
end;

procedure TfrmWait.FormCreate(Sender: TObject);
begin
//  GIF := TGIFImage.Create;
//  GIF.LoadFromFile('D:\TI_2018\Задание №3_Крипт_с _открытым_ключом\delphi version\Мишка.gif');
//  imgAnim.Picture.Assign(GIF);
//  WaitThread := TWaitThread.Create(True);
//  WaitThread.Priority := tpNormal;
//  WaitThread.FreeOnTerminate := False;
end;

procedure TfrmWait.FormHide(Sender: TObject);
begin
  GIF.Animate := False;
//  WaitThread.Terminate;
end;

procedure TfrmWait.FormShow(Sender: TObject);
begin
//  WaitThread.Execute;
end;

procedure TfrmWait.imgAnimClick(Sender: TObject);
begin

end;

{ TWaitThread }

procedure TWaitThread.Execute;
begin
  inherited;
  GIF.Animate := True;
  while not(WaitThread.Terminated) do
  begin
  end;
  GIF.Animate := False;
end;

end.
