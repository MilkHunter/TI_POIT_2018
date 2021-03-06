{$ifndef Operations}
{$define Operations}
unit Operations;

interface
Type
  TIndex = Integer;
  TRegister = array[0..127] of String;
  function CheckSize(var str: String; const regsize: Integer): Boolean;
  function CheckStr(const str: String): Boolean;
  function Pow(const x, grade: Integer): Integer;
  function SubString(const Mainstr: String; const point, Count: TIndex; var ind: Tindex): String;
  function ShiftReg(var reg: String; const bit: Char): Char;
  function FormKey(const KeySize: Integer; var RegValue: String;
    const pararr: array of TIndex): String;
  procedure DecToBin(const decarr: array of Byte; const size: Integer; var binarr: String);
  procedure BinToDec(const str: String; var num: Integer);
  procedure Crypt(var arr: array of Byte; const bits: array of Integer; var reg: Integer);
  procedure Swaping(var arr: array of Byte; const U: String);

implementation
uses
  SysUtils;

  function Pow(const x, grade: Integer): Integer;
  var
    i: Integer;
  begin
    Result := 1;
    i := 1;
    for i := 1 to grade do
      Result := Result * x;
  end;

  function GetBit(const reg: String; const nessbits: array of TIndex): Byte;
  var
    i: TIndex;
    len: Integer;
  begin
    Result := StrToInt(reg[1]);
    Result := Result xor StrToInt(reg[26]);
    Result := Result + 48;
  end;

  function CheckSize;  // (var str: String; const regsize: Integer): Boolean
  var
    i: TIndex;
  begin
    Result := False;
    i := 1;
    while i <= length(str) do
    begin
      if (str[i] = '0') or (str[i] = '1') then
        inc(i)
      else
        Delete(str,i,1);
    end;
    if length(str) < regsize then
      Result := False
    else
    begin
      i := regsize + 1;
      while i <= length(str) do
        Delete(str,i,1);
      Result := True;
    end;
  end;

  function ShiftReg;  // (var reg: String; const bit: Char): Char
  var
    i, len: TIndex;
  begin
    len := length(reg);
    i := 1;
    Result := reg[1];
    while i < len do
    begin
      reg[i] := reg[i+1];
      inc(i);
    end;
    reg[len] := bit;
  end;

  function FormKey; // (const KeySize: Integer; var RegValue: String; const pararr: array of TIndex): String
  var
    i: TIndex;
    bit: Char;
  begin
    for i := 1 to KeySize do
    begin
      bit := Chr(GetBit(RegValue,pararr));
      bit := ShiftReg(RegValue,bit);
      Result := Result + bit;
    end;
  end;

  procedure DecToBin;
  var
    i, j: Integer;
    temp: String;
    symb: Char;
    temparr: array of String;
    num: Byte;
  begin
    for i := 0 to size-1 do
    begin
      num := decarr[i];
      for j := 1 to 8 do
      begin
        asm
            mov   dl,   num
            test  dl,    10000000b
            jz    @Zero
            mov   symb,   '1'
            jmp   @NextIter
            @Zero:
            mov   symb,   '0'
            @NextIter:
            rol   num,   1
        end;
        binarr := binarr + symb;
      end;
    end;
  end;

  procedure BinToDec;
  var
    i, temp, len: Integer;
  begin
    len := length(str);
    for i := 1 to len do
      begin
        temp := Ord(str[len+1-i]) - 48;
        num := num + temp*pow(2,i-1);
      end;
  end;

  procedure Crypt(var arr: array of Byte; const bits: array of Integer; var reg: Integer);
  var
    i, j: Integer;
    num: Byte;
    key: Integer;
    ch: Char;
  begin
    for i := 0 to length(arr)-1 do
    begin
      key := 0;
      asm
        //  edx >> pushed bit
        //  eax >> register
        //  ebx >> pulled out bit
        push  ebx
        mov   eax,    dword[reg];
        mov   ecx,    8
        @MainLoop:
          mov   edx,    0
          test  eax,    00001000000000000000000000000000b
          jz    @NextBit
          mov   edx,    1
          mov   ebx,    1
        @NextBit:
          test  eax,    00000000000000000000000000000100b
          jz    @EndOfLoop
          xor   edx,    1
        @EndOfLoop:
          shl   eax,    1
          or    eax,    edx
          mov   [reg],  eax
          add   [key],    ebx
          shl   [key],    1
        loop  @MainLoop
        pop   ebx
      end;
      arr[i] := arr[i] xor key;
//      word := arr[i];
//      for j := 1 to 8 do
//      begin
//        ch := Chr((StrToInt(word[j]) xor StrToInt(key[j]))+48);
//        word[j] := ch;
//      end;
//      arr[i] := word;
    end;
  end;

  function SubString(const Mainstr: String; const point, Count: TIndex; var ind: Tindex): String;
  var
    i, j: TIndex;
  begin
    j := 1;
    i := point;
    while (j <= Count) do
    begin
      Result := Result + Mainstr[i];
      if i = length(Mainstr) then
        i := 0;
      inc(j);
      inc(i);
    end;
    ind := i;
  end;

  function CheckStr(const str: String): Boolean;
  var
    i: TIndex;
  begin
    i := 1;
    Result := False;
    while i <= length(str) do
    begin
      if str[i] in ['0'..'9'] then
      begin
        Result := True;
      end
      else
      begin
        Result := False;
        break;
      end;
      inc(i);
    end;
  end;

  procedure Swaping(var arr: array of Byte; const U: String);
  var
    temp, j, i: Integer;
  begin
    j := 0;
    for i := 0 to 255 do
    begin
      j := (j + arr[i] + ord(U[i mod length(U)])) mod 256;
      temp := arr[i];
      arr[i] := arr[j];
      arr[j] := temp
    end;

  end;

end.

{$endif}
