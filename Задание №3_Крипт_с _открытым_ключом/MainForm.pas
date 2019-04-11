unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Imaging.jpeg, Anim;

type
  TfrmMain = class(TForm)
    imgMain: TImage;
    btnCrypt: TBitBtn;
    edtP: TEdit;
    edtK: TEdit;
    edtX: TEdit;
    btnDecrypt: TBitBtn;
    ActionList1: TActionList;
    actChangeInfo: TAction;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    cmbG: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    pnlP: TPanel;
    pnlX: TPanel;
    pnlK: TPanel;
    pnlG: TPanel;
    mmoInput: TMemo;
    mmoResult: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    procedure actChangeInfoExecute(Sender: TObject);
    procedure btnCryptClick(Sender: TObject);
    procedure btnDecryptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  AllProc;

const _WORD  = 2;
const _BYTE  = 1;
const _256KB = 268435456;

var
  InFile: file;
  OutFile: file;
  Ready: Boolean;
  p: Integer = 0;
  k: Integer = 0;
  x: Integer = 0;
  g: Integer = 0;
  LastP: Integer = 0;
  InBuff : array[0.._256KB-1]   of Byte;
  OutBuff: array[0.._256KB*2-1] of Word;
  Filled: Boolean;

procedure TfrmMain.actChangeInfoExecute(Sender: TObject);
var
  i, j: Integer;
  str: String;
  FlagArr: BoolArr;
  DivArr: IntArr;
begin
  i := 0;
  str := trim(edtP.Text);
  if (str <> '') and (not(Check_Letters(str))) then
  begin
    p := StrToInt(edtP.Text);
    if LastP <> p then
    begin
      LastP := p;
      cmbG.Clear;
      Filled := False;
    end;
  end
  else
  begin
    btnCrypt.Enabled := False;
    pnlP.Color := clRed;
    Ready := False;
    p := 0;
  end;
  str := trim(edtK.Text);
  if (str <> '') and (not(Check_Letters(str))) then
    k := StrToInt(str)
  else
  begin
    btnCrypt.Enabled := False;
    pnlK.Color := clRed;
    Ready := False;
    k := 0;
  end;

  str := trim(edtX.Text);
  if (str <> '') and (not(Check_Letters(str))) then
    x := StrToInt(str)
  else
  begin
    btnCrypt.Enabled := False;
    pnlX.Color := clRed;
    Ready := False;
    x := 0;
  end;

  str := trim(cmbG.Text);
  if (str <> '') and (not(Check_Letters(str))) then
    g := StrToInt(str)
  else
  begin
    btnCrypt.Enabled := False;
    pnlG.Color := clRed;
    Ready := False;
    g := 0;
  end;

  FlagArr := Check_Info(p, k, x, g);
  if not(FlagArr[0]) then  // p's if
  begin
    pnlP.Color := clRed;
    Filled := False;
  end
  else
  begin
    if not(Filled) then
    begin
      DivArr := Protoplastic_Root(p);
      for j := 0 to length(DivArr)-1 do
        cmbG.Items.Add(IntToStr(DivArr[j]));
      Filled := True;
    end;
    inc(i);
    pnlP.Color := clGreen;
  end;
  if not(FlagArr[1]) then // k's if
  begin
    pnlK.Color := clRed;
  end
  else
  begin
    inc(i);
    pnlK.Color := clGreen;
  end;
  if not(FlagArr[2]) then // x's if
  begin
    pnlX.Color := clRed;
  end
  else
  begin
    inc(i);
    pnlX.Color := clGreen;
  end;
  if not(FlagArr[3]) then   // g's if
  begin
    pnlG.Color := clRed;
  end
  else
  begin
    inc(i);
    pnlG.Color := clGreen;
  end;
  if i = ArgCount then
  begin
    Ready := True;
    btnCrypt.Enabled := True;
    btnDecrypt.Enabled := True;
  end
  else
  begin
    Ready := False;
    btnCrypt.Enabled := False;
    btnDecrypt.Enabled := False;
  end;
end;

procedure TfrmMain.btnCryptClick(Sender: TObject);
var
  y, a, b: Integer;
  Count: Integer;
  i: Integer; // count of bytes that has been read
begin
  OpenDialog.Execute();
  SaveDialog.Execute();
  mmoResult.Clear;
  mmoInput.Clear;
  if OpenDialog.FileName <> '' then
  begin
    AssignFile(InFile, OpenDialog.FileName);
    AssignFile(OutFile, SaveDialog.FileName);
    {$I-}
    Reset  (InFile,  _BYTE);
    y := Fast_Exp(g, x, p);
    a := Fast_Exp(g, k, p);
    BlockRead(InFile, InBuff[i], 60, Count);
    for i := 0 to Count-1 do
    begin
      b := (Fast_Exp(y, k, p) * Fast_Exp(InBuff[i], 1, p)) mod p;
      mmoInput.Text := mmoInput.Text + IntToStr(InBuff[i]) + #13#10;
      mmoResult.Text := mmoResult.Text + IntToStr(a) + ' ' + IntToStr(b) + #13#10;
    end;
    CloseFile(InFile);
    Reset(InFile, _BYTE);
    ReWrite(OutFile, _WORD);
    {$I+}
    //Anim.frmWait.Show;
    //Anim.WaitThread.Execute;
    while not(EoF(InFile)) do
    begin
      BlockRead(InFile, InBuff, _256KB, Count);
      for i := 0 to Count-1 do
      begin
        b := (Fast_Exp(y, k, p) * Fast_Exp(InBuff[i], 1, p)) mod p;
        OutBuff[i*2] := a;
        OutBuff[i*2+1] := b;
      end;
      BlockWrite(OutFile, OutBuff, Count*2);
    end;
    //im.frmWait.Hide;
    //Anim.WaitThread.Terminate;
    CloseFile(InFile);
    CloseFile(OutFile);
  end;
end;

procedure TfrmMain.btnDecryptClick(Sender: TObject);
var
  m, a, b: Integer;
  Count: Integer;
  i: Integer; // count of bytesm that has been read
begin
  OpenDialog.Execute();
  SaveDialog.Execute();
  mmoResult.Clear;
  mmoInput.Clear;
  if OpenDialog.FileName <> '' then
  begin
    AssignFile(InFile , OpenDialog.FileName);
    AssignFile(OutFile, SaveDialog.FileName);
    {$I-}
    Reset  (InFile,  _WORD);
    BlockRead(InFile, OutBuff[i], 60, Count);
    for i := 0 to Count div 2 -1 do
    begin
      a := OutBuff[i*2];
      b := OutBuff[i*2+1];
      mmoInput.Text := mmoInput.Text + IntToStr(a) + ' ' + IntToStr(b) + #13#10;
      m := (Fast_Exp(a,p-1-x, p) * Fast_Exp(b, 1, p)) mod p;
      mmoResult.Text := mmoResult.Text + IntToStr(m) + #13#10;
    end;
    CloseFile(InFile);
    Reset  (InFile,  _WORD);
    ReWrite(OutFile, _BYTE);
    {$I+}
    while not(EoF(InFile)) do
    begin
      BlockRead(InFile, OutBuff, _256KB, Count);
      for i := 0 to Count div 2 -1 do
      begin
        a := OutBuff[i*2];
        b := OutBuff[i*2+1];
        m := (Fast_Exp(a,p-1-x, p) * Fast_Exp(b, 1, p)) mod p;
        InBuff[i] := m;
      end;
      BlockWrite(OutFile, InBuff, Count div 2, Count);
    end;
    CloseFile(InFile);
    CloseFile(OutFile);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Filled := False;
end;

end.
