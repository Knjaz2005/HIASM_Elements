unit HiMailNativeShared;

interface

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

uses
  Windows, Kol, Share, Debug;

type
  THIMailNativeBase = class(TDebug)
  protected
    FLastResult: string;
    FLastError: string;
    function FireJsonResult(var Event: THI_Event): Boolean;
  public
    _event_onError: THI_Event;
    procedure _var_Result(var _Data: TData; Index: Word);
    procedure _var_Error(var _Data: TData; Index: Word);
  end;

function MailNativeExecuteJson(const Request: AnsiString): string;
function MailNativeOpenSession(const Config: AnsiString): string;
function MailNativeSessionJson(Handle: Integer; const Request: AnsiString): string;
function MailNativeCloseSession(Handle: Integer): string;

function MailJsonString(const Name, Value: string): AnsiString;
function MailJsonInt(const Name: string; Value: Integer): AnsiString;
function MailJsonBool(const Name: string; Value: Boolean): AnsiString;
function MailJsonArrayFromList(const Value: string): AnsiString;
function MailJsonArrayFromEvent(var _Data: TData; const Event: THI_Event): AnsiString;
function MailSecurityName(Value: Integer): string;
function MailProtocolName(Value: Integer): string;
function MailAuthName(Value: Integer): string;
function MailAuthMechanismName(Value: Integer): string;

function MailJsonIsOk(const Json: string): Boolean;
function MailJsonGetString(const Json, Name: string): string;
function MailJsonGetInt(const Json, Name: string; Default: Integer): Integer;
function MailLocalErrorJson(const Msg: string): string;

implementation

const
  BRIDGE_DLL = 'HiMailNative.dll';
{$IFDEF WIN64}
  BRIDGE_ARCH_DIR = 'win-x64';
  BRIDGE_ARCH_DIR_ALT = '';
{$ELSE}
  {$IFDEF CPU64}
  BRIDGE_ARCH_DIR = 'win-x64';
  BRIDGE_ARCH_DIR_ALT = '';
  {$ELSE}
  BRIDGE_ARCH_DIR = 'win-x32';
  BRIDGE_ARCH_DIR_ALT = 'win-x86';
  {$ENDIF}
{$ENDIF}

type
  THiMailExecuteJson = function(RequestUtf8: PAnsiChar): PAnsiChar; stdcall;
  THiMailOpenSession = function(ConfigUtf8: PAnsiChar): PAnsiChar; stdcall;
  THiMailSessionJson = function(Handle: Integer; RequestUtf8: PAnsiChar): PAnsiChar; stdcall;
  THiMailCloseSession = function(Handle: Integer): PAnsiChar; stdcall;
  THiMailFreeString = procedure(Value: PAnsiChar); stdcall;

var
  BridgeModule: HMODULE = 0;
  BridgePath: string = '';
  HiMailExecuteJson: THiMailExecuteJson = nil;
  HiMailOpenSession: THiMailOpenSession = nil;
  HiMailSessionJson: THiMailSessionJson = nil;
  HiMailCloseSession: THiMailCloseSession = nil;
  HiMailFreeString: THiMailFreeString = nil;

type
{$IFDEF UNICODE}
  TMailPathChar = WideChar;
  PMailPathChar = PWideChar;
{$ELSE}
  TMailPathChar = Char;
  PMailPathChar = PChar;
{$ENDIF}

function MailGetModuleFileName(Module: HMODULE; Buffer: PMailPathChar; Count: DWORD): DWORD;
begin
{$IFDEF UNICODE}
  Result := GetModuleFileNameW(Module, Buffer, Count);
{$ELSE}
  Result := GetModuleFileNameA(Module, Buffer, Count);
{$ENDIF}
end;

{$IFDEF UNICODE}
function MailLoadLibrary(const FileName: string): HMODULE;
var
  W: WideString;
begin
  W := WideString(FileName);
  Result := LoadLibraryW(PWideChar(W));
end;
{$ELSE}
function MailLoadLibrary(const FileName: string): HMODULE;
begin
  Result := LoadLibraryA(PChar(FileName));
end;
{$ENDIF}

function MailPathToString(Buffer: PMailPathChar): string;
begin
  Result := string(Buffer);
end;

function GetProcAny(Module: HMODULE; const PlainName, StdCallName: PChar): Pointer;
begin
  Result := GetProcAddress(Module, PlainName);
  if (Result = nil) and (StdCallName <> nil) then
    Result := GetProcAddress(Module, StdCallName);
end;

function FileDirWithSlash(const FileName: string): string;
var
  I: Integer;
begin
  for I := Length(FileName) downto 1 do
    if FileName[I] in ['\', '/'] then
    begin
      Result := Copy(FileName, 1, I);
      Exit;
    end;
  Result := '';
end;

function AppDir: string;
var
  Buf: array[0..MAX_PATH] of TMailPathChar;
  Len: DWORD;
begin
  FillChar(Buf, SizeOf(Buf), 0);
  Len := MailGetModuleFileName(0, PMailPathChar(@Buf[0]), MAX_PATH);
  if Len = 0 then
    Result := ''
  else
  begin
    if Len > MAX_PATH then
      Len := MAX_PATH;
    Buf[Integer(Len)] := #0;
    Result := FileDirWithSlash(MailPathToString(PMailPathChar(@Buf[0])));
  end;
end;

function MailStrToIntDef(const S: string; Default: Integer): Integer;
var
  I, Base, Sign, Digit: Integer;
  C: Char;
begin
  Result := Default;
  if S = '' then
    Exit;

  I := 1;
  Sign := 1;
  if S[I] = '-' then
  begin
    Sign := -1;
    Inc(I);
  end;

  Base := 10;
  if (I <= Length(S)) and (S[I] = '$') then
  begin
    Base := 16;
    Inc(I);
  end;

  if I > Length(S) then
    Exit;

  Result := 0;
  while I <= Length(S) do
  begin
    Digit := -1;
    C := S[I];
    if (C >= '0') and (C <= '9') then
      Digit := Ord(C) - Ord('0')
    else if (Base = 16) and (C >= 'A') and (C <= 'F') then
      Digit := Ord(C) - Ord('A') + 10
    else if (Base = 16) and (C >= 'a') and (C <= 'f') then
      Digit := Ord(C) - Ord('a') + 10;

    if (Digit < 0) or (Digit >= Base) then
    begin
      Result := Default;
      Exit;
    end;

    Result := Result * Base + Digit;
    Inc(I);
  end;
  Result := Result * Sign;
end;

function ModulePath(Module: HMODULE): string;
var
  Buf: array[0..MAX_PATH] of TMailPathChar;
  Len: DWORD;
begin
  FillChar(Buf, SizeOf(Buf), 0);
  Len := MailGetModuleFileName(Module, PMailPathChar(@Buf[0]), MAX_PATH);
  if Len = 0 then
    Result := BridgePath
  else
  begin
    if Len > MAX_PATH then
      Len := MAX_PATH;
    Buf[Integer(Len)] := #0;
    Result := MailPathToString(PMailPathChar(@Buf[0]));
  end;
end;

function LoadBridge(var ErrorText: string): Boolean;
var
  ArchPath: string;
  AltArchPath: string;
  LocalPath: string;
begin
  Result := False;
  ErrorText := '';

  if BridgeModule = 0 then
  begin
    ArchPath := AppDir + BRIDGE_ARCH_DIR + '\' + BRIDGE_DLL;
    AltArchPath := '';
    LocalPath := AppDir + BRIDGE_DLL;
    BridgeModule := MailLoadLibrary(ArchPath);
    BridgePath := ArchPath;
    if (BridgeModule = 0) and (BRIDGE_ARCH_DIR_ALT <> '') then
    begin
      AltArchPath := AppDir + BRIDGE_ARCH_DIR_ALT + '\' + BRIDGE_DLL;
      BridgeModule := MailLoadLibrary(AltArchPath);
      BridgePath := AltArchPath;
    end;

    if BridgeModule = 0 then
    begin
      BridgeModule := MailLoadLibrary(LocalPath);
      BridgePath := LocalPath;
    end;

    if BridgeModule = 0 then
    begin
      BridgeModule := MailLoadLibrary(BRIDGE_DLL);
      BridgePath := BRIDGE_DLL;
    end;

    if BridgeModule = 0 then
    begin
      ErrorText := 'Cannot load HiMailNative.dll from ' + ArchPath + ' or ' + LocalPath;
      if AltArchPath <> '' then
        ErrorText := 'Cannot load HiMailNative.dll from ' + ArchPath + ' or ' + AltArchPath + ' or ' + LocalPath;
      Exit;
    end;

    BridgePath := ModulePath(BridgeModule);
    @HiMailExecuteJson := GetProcAny(BridgeModule, 'HiMail_ExecuteJson', '_HiMail_ExecuteJson@4');
    @HiMailOpenSession := GetProcAny(BridgeModule, 'HiMail_OpenSession', '_HiMail_OpenSession@4');
    @HiMailSessionJson := GetProcAny(BridgeModule, 'HiMail_SessionJson', '_HiMail_SessionJson@8');
    @HiMailCloseSession := GetProcAny(BridgeModule, 'HiMail_CloseSession', '_HiMail_CloseSession@4');
    @HiMailFreeString := GetProcAny(BridgeModule, 'HiMail_FreeString', '_HiMail_FreeString@4');
  end;

  if not Assigned(HiMailFreeString) then
    ErrorText := BridgePath + ' does not export HiMail_FreeString'
  else
    Result := True;
end;

{$IFDEF UNICODE}
function StrToUtf8Z(const S: string): AnsiString;
begin
  Result := UTF8Encode(S);
end;
{$ELSE}
function StrToUtf8Z(const S: string): AnsiString;
var
  WLen, U8Len: Integer;
  WS: WideString;
begin
  if S = '' then
  begin
    Result := '';
    Exit;
  end;

  WLen := MultiByteToWideChar(CP_ACP, 0, PChar(S), Length(S), nil, 0);
  SetLength(WS, WLen);
  if WLen > 0 then
    MultiByteToWideChar(CP_ACP, 0, PChar(S), Length(S), PWideChar(WS), WLen);

  U8Len := WideCharToMultiByte(65001, 0, PWideChar(WS), WLen, nil, 0, nil, nil);
  SetLength(Result, U8Len);
  if U8Len > 0 then
    WideCharToMultiByte(65001, 0, PWideChar(WS), WLen, PAnsiChar(Result), U8Len, nil, nil);
end;
{$ENDIF}

{$IFDEF UNICODE}
function Utf8ZToStr(const P: PAnsiChar): string;
begin
  if P = nil then
    Result := ''
  else
    Result := UTF8ToString(AnsiString(P));
end;
{$ELSE}
function Utf8ZToStr(const P: PAnsiChar): string;
var
  WS: WideString;
  WLen, ALen: Integer;
  Tmp: AnsiString;
begin
  if P = nil then
  begin
    Result := '';
    Exit;
  end;

  Tmp := AnsiString(P);
  ALen := Length(Tmp);
  if ALen = 0 then
  begin
    Result := '';
    Exit;
  end;

  WLen := MultiByteToWideChar(65001, 0, PAnsiChar(Tmp), ALen, nil, 0);
  SetLength(WS, WLen);
  if WLen > 0 then
    MultiByteToWideChar(65001, 0, PAnsiChar(Tmp), ALen, PWideChar(WS), WLen);

  SetLength(Result, WideCharToMultiByte(CP_ACP, 0, PWideChar(WS), WLen, nil, 0, nil, nil));
  if Length(Result) > 0 then
    WideCharToMultiByte(CP_ACP, 0, PWideChar(WS), WLen, PChar(Result), Length(Result), nil, nil);
end;
{$ENDIF}

function TakeUtf8Result(P: PAnsiChar): string;
begin
  Result := Utf8ZToStr(P);
  if (P <> nil) and Assigned(HiMailFreeString) then
    HiMailFreeString(P);
end;

function CallBridge1(Func: THiMailExecuteJson; const Request: AnsiString; const MissingExport: string): string;
var
  P: PAnsiChar;
  Err: string;
begin
  if not LoadBridge(Err) then
  begin
    Result := MailLocalErrorJson(Err);
    Exit;
  end;

  if not Assigned(Func) then
  begin
    Result := MailLocalErrorJson(MissingExport);
    Exit;
  end;

  P := Func(PAnsiChar(Request));
  Result := TakeUtf8Result(P);
  if Result = '' then
    Result := MailLocalErrorJson('HiMailNative.dll returned empty result');
end;

function MailNativeExecuteJson(const Request: AnsiString): string;
begin
  Result := CallBridge1(HiMailExecuteJson, Request, 'HiMailNative.dll does not export HiMail_ExecuteJson');
end;

function MailNativeOpenSession(const Config: AnsiString): string;
var
  P: PAnsiChar;
  Err: string;
begin
  if not LoadBridge(Err) then
  begin
    Result := MailLocalErrorJson(Err);
    Exit;
  end;

  if not Assigned(HiMailOpenSession) then
  begin
    Result := MailLocalErrorJson(BridgePath + ' does not export HiMail_OpenSession');
    Exit;
  end;

  P := HiMailOpenSession(PAnsiChar(Config));
  Result := TakeUtf8Result(P);
  if Result = '' then
    Result := MailLocalErrorJson('HiMailNative.dll returned empty result');
end;

function MailNativeSessionJson(Handle: Integer; const Request: AnsiString): string;
var
  P: PAnsiChar;
  Err: string;
begin
  if not LoadBridge(Err) then
  begin
    Result := MailLocalErrorJson(Err);
    Exit;
  end;

  if not Assigned(HiMailSessionJson) then
  begin
    Result := MailLocalErrorJson(BridgePath + ' does not export HiMail_SessionJson');
    Exit;
  end;

  P := HiMailSessionJson(Handle, PAnsiChar(Request));
  Result := TakeUtf8Result(P);
  if Result = '' then
    Result := MailLocalErrorJson('HiMailNative.dll returned empty result');
end;

function MailNativeCloseSession(Handle: Integer): string;
var
  P: PAnsiChar;
  Err: string;
begin
  if not LoadBridge(Err) then
  begin
    Result := MailLocalErrorJson(Err);
    Exit;
  end;

  if not Assigned(HiMailCloseSession) then
  begin
    Result := MailLocalErrorJson(BridgePath + ' does not export HiMail_CloseSession');
    Exit;
  end;

  P := HiMailCloseSession(Handle);
  Result := TakeUtf8Result(P);
  if Result = '' then
    Result := MailLocalErrorJson('HiMailNative.dll returned empty result');
end;

function BoolText(Value: Boolean): AnsiString;
begin
  if Value then
    Result := 'true'
  else
    Result := 'false';
end;

function JsonEscapeUtf8(const S: string): AnsiString;
var
  U: AnsiString;
  I, B: Integer;
begin
  U := StrToUtf8Z(S);
  Result := '';
  for I := 1 to Length(U) do
  begin
    B := Ord(U[I]);
    case B of
      8: Result := Result + '\b';
      9: Result := Result + '\t';
      10: Result := Result + '\n';
      12: Result := Result + '\f';
      13: Result := Result + '\r';
      34: Result := Result + '\"';
      92: Result := Result + '\\';
    else
      if B < 32 then
        Result := Result + '\u00' + AnsiString(Int2Hex(B, 2))
      else
        Result := Result + U[I];
    end;
  end;
end;

function MailJsonString(const Name, Value: string): AnsiString;
begin
  Result := '"' + AnsiString(Name) + '":"' + JsonEscapeUtf8(Value) + '"';
end;

function MailJsonInt(const Name: string; Value: Integer): AnsiString;
begin
  Result := '"' + AnsiString(Name) + '":' + AnsiString(Int2Str(Value));
end;

function MailJsonBool(const Name: string; Value: Boolean): AnsiString;
begin
  Result := '"' + AnsiString(Name) + '":' + BoolText(Value);
end;

function MailJsonArrayFromList(const Value: string): AnsiString;
var
  S, Item: string;
  P: Integer;
  First: Boolean;
begin
  Result := '[';
  S := Value;
  First := True;
  while S <> '' do
  begin
    P := Pos(';', S);
    if P > 0 then
    begin
      Item := Trim(Copy(S, 1, P - 1));
      Delete(S, 1, P);
    end
    else
    begin
      Item := Trim(S);
      S := '';
    end;

    if Item <> '' then
    begin
      if not First then
        Result := Result + ',';
      Result := Result + '"' + JsonEscapeUtf8(Item) + '"';
      First := False;
    end;
  end;
  Result := Result + ']';
end;

function MailJsonArrayFromEvent(var _Data: TData; const Event: THI_Event): AnsiString;
var
  Arr: PArray;
  I, Item: TData;
  S: string;
  First: Boolean;
begin
  Arr := ReadArray(Event);
  if Arr = nil then
  begin
    Result := MailJsonArrayFromList(ReadString(_Data, Event, ''));
    Exit;
  end;

  Result := '[';
  First := True;
  I.Data_type := data_int;
  I.idata := 0;
  while Arr._Get(I, Item) do
  begin
    S := Trim(Share.ToString(Item));
    if S <> '' then
    begin
      if not First then
        Result := Result + ',';
      Result := Result + '"' + JsonEscapeUtf8(S) + '"';
      First := False;
    end;
    Inc(I.idata);
  end;
  Result := Result + ']';
end;

function MailSecurityName(Value: Integer): string;
begin
  case Value of
    1: Result := 'none';
    2: Result := 'ssl';
    3: Result := 'starttls';
    4: Result := 'starttlsWhenAvailable';
  else
    Result := 'auto';
  end;
end;

function MailProtocolName(Value: Integer): string;
begin
  if Value = 1 then
    Result := 'pop3'
  else
    Result := 'imap';
end;

function MailAuthName(Value: Integer): string;
begin
  case Value of
    1: Result := 'oauth2';
    2: Result := 'none';
  else
    Result := 'password';
  end;
end;

function MailAuthMechanismName(Value: Integer): string;
begin
  case Value of
    1: Result := 'plain';
    2: Result := 'login';
  else
    Result := 'auto';
  end;
end;

function MailJsonIsOk(const Json: string): Boolean;
begin
  Result := Pos('"ok":true', Json) > 0;
end;

function DecodeJsonUnicode(Code: Integer): string;
var
  WC: WideChar;
  Len: Integer;
begin
  if Code = 0 then
  begin
    Result := '';
    Exit;
  end;

  WC := WideChar(Code);
  Len := WideCharToMultiByte(CP_ACP, 0, @WC, 1, nil, 0, nil, nil);
  SetLength(Result, Len);
  if Len > 0 then
    WideCharToMultiByte(CP_ACP, 0, @WC, 1, PChar(Result), Len, nil, nil);
end;

function MailJsonGetString(const Json, Name: string): string;
var
  P, L, Code: Integer;
  Ch, Esc: Char;
  Hex: string;
begin
  Result := '';
  L := Length(Json);
  P := Pos('"' + Name + '"', Json);
  if P = 0 then
    Exit;

  Inc(P, Length(Name) + 2);
  while (P <= L) and (Json[P] <> ':') do Inc(P);
  if P > L then Exit;
  Inc(P);
  while (P <= L) and (Json[P] in [' ', #9, #10, #13]) do Inc(P);
  if (P > L) or (Json[P] <> '"') then Exit;
  Inc(P);

  while P <= L do
  begin
    Ch := Json[P];
    if Ch = '"' then
      Break;

    if Ch = '\' then
    begin
      Inc(P);
      if P > L then Break;
      Esc := Json[P];
      case Esc of
        '"': Result := Result + '"';
        '\': Result := Result + '\';
        '/': Result := Result + '/';
        'b': Result := Result + #8;
        't': Result := Result + #9;
        'n': Result := Result + #10;
        'f': Result := Result + #12;
        'r': Result := Result + #13;
        'u':
          begin
            Hex := Copy(Json, P + 1, 4);
            Code := MailStrToIntDef('$' + Hex, 0);
            Result := Result + DecodeJsonUnicode(Code);
            Inc(P, 4);
          end;
      else
        Result := Result + Esc;
      end;
    end
    else
      Result := Result + Ch;
    Inc(P);
  end;
end;

function MailJsonGetInt(const Json, Name: string; Default: Integer): Integer;
var
  P, L, Sign: Integer;
  S: string;
begin
  Result := Default;
  L := Length(Json);
  P := Pos('"' + Name + '"', Json);
  if P = 0 then
    Exit;

  Inc(P, Length(Name) + 2);
  while (P <= L) and (Json[P] <> ':') do Inc(P);
  if P > L then Exit;
  Inc(P);
  while (P <= L) and (Json[P] in [' ', #9, #10, #13]) do Inc(P);

  Sign := 1;
  if (P <= L) and (Json[P] = '-') then
  begin
    Sign := -1;
    Inc(P);
  end;

  S := '';
  while (P <= L) and (Json[P] in ['0'..'9']) do
  begin
    S := S + Json[P];
    Inc(P);
  end;
  if S <> '' then
    Result := Sign * MailStrToIntDef(S, Default);
end;

function MailLocalErrorJson(const Msg: string): string;
begin
  Result := '{"ok":false,"code":"LOCAL","error":"' + string(JsonEscapeUtf8(Msg)) + '"}';
end;

function THIMailNativeBase.FireJsonResult(var Event: THI_Event): Boolean;
begin
  Result := MailJsonIsOk(FLastResult);
  if Result then
    _hi_OnEvent(Event, FLastResult)
  else
  begin
    FLastError := MailJsonGetString(FLastResult, 'error');
    if FLastError = '' then
      FLastError := FLastResult;
    if Assigned(_event_onError.Event) then
      _hi_OnEvent(_event_onError, FLastError)
    else
      _hi_OnEvent(Event, FLastResult);
  end;
end;

procedure THIMailNativeBase._var_Result(var _Data: TData; Index: Word);
begin
  dtString(_Data, FLastResult);
end;

procedure THIMailNativeBase._var_Error(var _Data: TData; Index: Word);
begin
  dtString(_Data, FLastError);
end;

end.
