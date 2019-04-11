unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg;

type
  TfrmMain = class(TForm)
    imgMain: TImage;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    edtPolinom: TEdit;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Timer1: TTimer;
    edtReg: TEdit;
    Label3: TLabel;
    Panel1: TPanel;
    Label4: TLabel;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
//    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public

  end;

  TTimerThread = class(TThread)
    private
    protected
      procedure Execute; override;
  end;

  TWriteThread = class(TThread)
    private
    protected
      //procedure Execute; override;
  end;

  TReadThread = class(TThread)
    private
    protected
      //procedure Execute; override;
  end;

var
  frmMain: TfrmMain;
  TimerThread: TTimerThread;
//  ReadThread: TReadThread;
  WriteThread: TWriteThread;

implementation
uses
  Operations;
const
  buffsize = 128;
  READ_BYTES = 268435456;
var
  bits: array [0..1] of Integer = (28,3);
  f_read, f_write: File;
  Count: Integer = 0;
  buffer: array[0..READ_BYTES-1] of Byte;
  SBox: array[0..255] of Byte;
  LastRegValue: String = '1111111111111111111111111111';
  RegValue: Integer;
  RegSize: Integer;
  t: Integer;

{$R *.dfm}

procedure TTimerThread.Execute;
begin
  while not(TimerThread.Terminated) do
  begin
    inc(t);
    sleep(1000);
  end;
  //BlockWrite(f_write,buffer,Count);
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
var
  temp: array of Byte;
  binarr: array of Byte;
  input, str_origin_bytes, str_key_bytes, str_crypt_bytes: String;
  error, key: Byte;
  i: Integer;
  begin
  str_origin_bytes := '';
  str_key_bytes := '';
  str_crypt_bytes := '';
  input := '';
  while input = '' do
    input := inputbox('LFSR','������� �������� ��������, ��� �� ������ ��������� '
    + IntToStr(RegSize) + ' ��������',LastRegValue);
  edtReg.Text := input;
  if CheckSize(input,RegSize) then
  begin
    edtReg.Text := input;
    LastRegValue := input;
    RegValue := 0;
    BinToDec(input,RegValue); // convert key into binary code
    if OpenDialog1.Execute then
    begin
      if SaveDialog1.Execute then
      begin
        AssignFile(f_write,SaveDialog1.FileName);  // kostyl
        ReWrite(f_write,1);                            // eto tozhe kostyl
      end;
      if (OpenDialog1.FileName <> '') and (SaveDialog1.FileName <> '') then
      begin
        {$I-}
        AssignFile(f_read,OpenDialog1.FileName);
        Reset(f_read,1);
        BlockRead(f_read,buffer,READ_BYTES,Count);
        if Count > 20 then
          Count := 20;
        DecToBin(buffer,Count,str_origin_bytes);
        str_key_bytes := FormKey(Count*8,input,[28,3]);
        Seek(f_read,0);
        error := IOResult;
        if error = 0 then
        begin
          i := 0;
          t := 0;
          Count := 0;

          WriteThread := TWriteThread.Create(True);  // thread for writing bytes to file
          WriteThread.FreeOnTerminate := True;
          WriteThread.Priority := tpNormal;

          TimerThread := TTimerThread.Create(True);  // threa for timer
          TimerThread.FreeOnTerminate := True;
          TimerThread.Priority := tpNormal;
          TimerThread.Resume;
          while not(EoF(f_read)) do
          begin
            BlockRead(f_read,buffer,READ_BYTES,Count);
            for i := 0 to Count-1 do
            begin
              key := 0;
              asm
                //  edx >> pushed bit
                //  eax >> register
                //  bl >> pulled out bit
                mov   eax,    [RegValue]
                  //shl   [key],  1
                  mov   edx,    0
                  mov   bl,     0
                  mov   ecx,    eax
                  and   ecx,    00001000000000000000000000000000b
                  shr   ecx,    27
                  mov   bl,     cl
                  mov   edx,    eax
                  and   edx,    00000000000000000000000000000100b
                  shr   edx,    2
                  xor   edx,    ecx
                  shl   eax,    1
                  or    eax,    edx
                  add   [key],  bl

                  shl   [key],  1
                  mov   edx,    0
                  mov   bl,     0
                  mov   ecx,    eax
                  and   ecx,    00001000000000000000000000000000b
                  shr   ecx,    27
                  mov   bl,     cl
                  mov   edx,    eax
                  and   edx,    00000000000000000000000000000100b
                  shr   edx,    2
                  xor   edx,    ecx
                  shl   eax,    1
                  or    eax,    edx
                  add   [key],  bl

                  shl   [key],  1
                  mov   edx,    0
                  mov   bl,     0
                  mov   ecx,    eax
                  and   ecx,    00001000000000000000000000000000b
                  shr   ecx,    27
                  mov   bl,     cl
                  mov   edx,    eax
                  and   edx,    00000000000000000000000000000100b
                  shr   edx,    2
                  xor   edx,    ecx
                  shl   eax,    1
                  or    eax,    edx
                  add   [key],  bl

                  shl   [key],  1
                  mov   edx,    0
                  mov   bl,     0
                  mov   ecx,    eax
                  and   ecx,    00001000000000000000000000000000b
                  shr   ecx,    27
                  mov   bl,     cl
                  mov   edx,    eax
                  and   edx,    00000000000000000000000000000100b
                  shr   edx,    2
                  xor   edx,    ecx
                  shl   eax,    1
                  or    eax,    edx
                  add   [key],  bl

                  shl   [key],  1
                  mov   edx,    0
                  mov   bl,     0
                  mov   ecx,    eax
                  and   ecx,    00001000000000000000000000000000b
                  shr   ecx,    27
                  mov   bl,     cl
                  mov   edx,    eax
                  and   edx,    00000000000000000000000000000100b
                  shr   edx,    2
                  xor   edx,    ecx
                  shl   eax,    1
                  or    eax,    edx
                  add   [key],  bl

                  shl   [key],  1
                  mov   edx,    0
                  mov   bl,     0
                  mov   ecx,    eax
                  and   ecx,    00001000000000000000000000000000b
                  shr   ecx,    27
                  mov   bl,     cl
                  mov   edx,    eax
                  and   edx,    00000000000000000000000000000100b
                  shr   edx,    2
                  xor   edx,    ecx
                  shl   eax,    1
                  or    eax,    edx
                  add   [key],  bl

                  shl   [key],  1
                  mov   edx,    0
                  mov   bl,     0
                  mov   ecx,    eax
                  and   ecx,    00001000000000000000000000000000b
                  shr   ecx,    27
                  mov   bl,     cl
                  mov   edx,    eax
                  and   edx,    00000000000000000000000000000100b
                  shr   edx,    2
                  xor   edx,    ecx
                  shl   eax,    1
                  or    eax,    edx
                  add   [key],  bl

                  shl   [key],  1
                  mov   edx,    0
                  mov   bl,     0
                  mov   ecx,    eax
                  and   ecx,    00001000000000000000000000000000b
                  shr   ecx,    27
                  mov   bl,     cl
                  mov   edx,    eax
                  and   edx,    00000000000000000000000000000100b
                  shr   edx,    2
                  xor   edx,    ecx
                  shl   eax,    1
                  or    eax,    edx
                  add   [key],  bl

                  mov   [RegValue], eax
              end;
              buffer[i] := buffer[i] xor key;
            end;
            BlockWrite(f_write,buffer,Count);
          end;
          TimerThread.Terminate;
          ShowMessage('�� �������� ���� ���������: '+ IntToStr(t) + ' ������');
          CloseFile(f_read);
          CloseFile(f_write);
          AssignFile(f_write,SaveDialog1.FileName);
          Reset(f_write,1);
          BlockRead(f_write,buffer,20,Count);
          DecToBin(buffer,Count,str_crypt_bytes);
          CloseFile(f_write);
          Edit1.Text := str_key_bytes;
          Edit2.Text := str_origin_bytes;
          Edit3.Text := str_crypt_bytes;
          ShowMessage('�������� ����: ' + str_origin_bytes + #13#10 +
            '���� �����:    ' + str_key_bytes +#13#10 + '������.����:   ' + str_crypt_bytes);
        end
        else
          ShowMessage('��� �������� ����� ��������� ������');
        {$I+}
      end
      else
        ShowMessage('������');
    end;
  end
  else
    ShowMessage('���-�� ����� �� ���');

end;

procedure TfrmMain.BitBtn2Click(Sender: TObject);
var
  input, U: String;
  temp, tmp, t, key: Byte;
  Count:  Integer;
  i, j: Int64;
  f1, f2: File;
begin
  input := '';
  while input = '' do
    input := inputbox('RC4','������� �������� �����',input);
  if CheckStr(input) then
  begin
    if OpenDialog1.Execute then
    begin
      if SaveDialog1.Execute then
      begin
        AssignFile(f2,SaveDialog1.FileName);
        Rewrite(f2,1);
      end;
      if (OpenDialog1.FileName <> '') and (SaveDialog1.FileName <> '') then
      begin
        AssignFile(f1,OpenDialog1.FileName);
        Reset(f1,1);
        U := input;
        for i := 0 to 255 do
          SBox[i] := i;
        Swaping(SBox,U);
        i := 0;
        j := 0;
        while not(EoF(f1)) do
        begin
          BlockRead(f1, buffer, READ_BYTES, Count);
          for t := 0 to Count-1 do
          begin
            i := (i + 1) mod 256;
            j := (j + Sbox[i]) mod 256;
            tmp := SBox[i];
            SBox[i] := SBox[j];
            SBox[j] := tmp;
            key := Sbox[(Sbox[i] + Sbox[j]) mod 256];
            buffer[t] := buffer[t] xor key;
          end;
          BlockWrite(f2, buffer, Count);
        end;
      end;
    end;
    CloseFile(f1);
    CloseFile(f2);
  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i: TIndex;
begin
  RegSize := 28;
  for i := 0 to 255 do
    SBox[i] := i;
end;

//procedure TfrmMain.Timer1Timer(Sender: TObject);
//begin
//  inc(t);
//end;

end.
