unit AllProc;

interface

type
  IntArr = array of Integer;
  BoolArr = array of Boolean;
  StrIndex = Integer;

const
  ArgCount = 4; // count of function arguments
  H0 = 100;
  _WORD  = 2;
  _BYTE  = 1;
  _256KB = 268435456;

function Fast_Exp(a, z, n: Integer): Integer; overload;
function Fast_Exp(a, z, n: Byte): Integer; overload;
function Euclide_Extended(a, b: Integer): IntArr;
function Get_Prime_Dividers(const num: Integer): IntArr;
function IsPrime(const num: Integer): Boolean;
function Check_Letters(const str: String): Boolean;
function Check_Info(const p, k, x, g: Integer): BoolArr;
function Protoplastic_Root(const p: Integer): IntArr;
function SHA1(const str: String): String;
function Hash(const str: String; const n: Integer): Integer;
procedure push_back(var arr: IntArr; const num: Integer);
procedure Close_Files(var InFile, OutFile: file); inline;

implementation

procedure Close_Files(var InFile, OutFile: file);
begin
  CloseFile(InFile);
  CloseFile(OutFile);
end;

function Fast_Exp(a, z, n: Integer): Integer;
var
  x: Integer;
begin
  x := 1;
  while z <> 0 do
  begin
    while (z mod 2) = 0 do
    begin
      z := z div 2;
      a := (a * a) mod n;
    end;
    dec(z);
    x := (x * a) mod n;
  end;
  Result := x;
end;

function Fast_Exp(a, z, n: Byte): Integer;
var
  x: Integer;
begin
  x := 1;
  while z <> 0 do
  begin
    while (z mod 2) = 0 do
    begin
      z := z div 2;
      a := (a * a) mod n;
    end;
    dec(z);
    x := (x * a) mod n;
  end;
  Result := x;
end;

function Euclide_Extended(a, b: Integer): IntArr;
var
  x0, x1, y0, y1, q, d2, x2, y2: Integer;
begin
  x0 := 1;
  x1 := 0;
  y0 := 0;
  y1 := 1;
  while (b > 1) do
  begin
    q := a div b;
    d2 := a mod b;
    x2 := x0 - q * y1;
    y2 := y0 - q * y1;
    a := b;
    b := d2;
    x0 := x1;
    x1 := x2;
    y0 := y1;
    y1 := y2;
  end;
  SetLength(Result, 3);
  Result[0] := x1;
  Result[1] := y1;
  Result[2] := b;
end;

function Get_Prime_Dividers(const num: Integer): IntArr;
var
  i: Integer;
begin
  SetLength(Result, 0);
  for i := 2 to num div 2 do
  begin
    if ((num mod i) = 0) and (IsPrime(i)) then
      push_back(Result, i);
  end;
end;

function IsPrime(const num: Integer): Boolean;
var
  i: Integer;
begin
  i := 2;
  for i := i to num div 2 do
  begin
    if num mod i = 0 then
    begin
      Result := False;
      break;
    end;
  end;
  if (i > num div 2) and (num <> 1 ) and (num <> 0) then
    Result := True
  else
    Result := False;
end;

function Check_Letters(const str: String): Boolean;
var
  i: StrIndex;
  len: Integer;
begin
  Result := False;
  len := length(str);
  for i := 1 to len do
  begin
    if not(str[i] in ['0' .. '9']) then
    begin
      Result := True;
      break;
    end;
  end;
end;

function Check_Info(const p, k, x, g: Integer): BoolArr;
var
  EuclideArr: IntArr;
begin
  SetLength(Result, ArgCount);
  if (IsPrime(p)) and (p > 255) and (p < 65536) then
    Result[0] := True;
  SetLength(EuclideArr, 3);
  EuclideArr := Euclide_Extended(k, p - 1);
  if (k > 1) and (k <= (p - 1)) and (EuclideArr[2] = 1) then
    Result[1] := True;
  if (x > 1) and (x < (p - 1)) then
    Result[2] := True;
  if g <> 0 then
    Result[3] := True;
end;

function Protoplastic_Root(const p: Integer): IntArr;
var
  g, l: Integer;
  size: Integer;
  DividersArr: IntArr;
  flag: Boolean;
begin
  SetLength(Result, 0);
  DividersArr := Get_Prime_Dividers(p - 1);
  size := length(DividersArr);
  for g := 2 to p - 1 do
  begin
    flag := True;
    for l := 1 to size do
    begin
      if (Fast_Exp(g, (p - 1) div DividersArr[l - 1], p) = 1) then
      begin
        flag := False;
        break;
      end;
    end;
    if flag then
      push_back(Result, g);
  end;
end;

procedure push_back(var arr: IntArr; const num: Integer);
var
  len: Integer;
begin
  len := length(arr);
  SetLength(arr, len + 1);
  arr[len] := num;
end;

function SHA1(const str: String): String;
var
  H0, h1, h2, h3, h4: Integer;
  a, b, c, d, e: Integer;
begin
  H0 := $67452301;
  h1 := $EFCDAB89;
  h2 := $98BADCFE;
  h3 := $10325476;
  h4 := $C3D2E1F0;

  a := H0;
  b := h1;
  c := h2;
  d := h3;
  e := h4;
end;

function Hash(const str: String; const n: Integer): Integer;
var
  i, prevH: Integer;
  len: Integer;
begin
  prevH := H0;
  len := length(str);
  for i := 1 to len do
    prevH := Trunc(exp(ln(prevH + ord(str[i])) * 2)) mod n;
  Result := prevH;
end;

end.
