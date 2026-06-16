unit hiMailSession;

interface

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

uses
  Kol, Share, Debug, HiMailNativeShared;

type
  THIMailSession = class(THIMailNativeBase)
  private
    FHandle: Integer;
    function BuildConfig(var _Data: TData): AnsiString;
    procedure CloseSilent;
  public
    _prop_SmtpServer: string;
    _prop_SmtpPort: Integer;
    _prop_MailServer: string;
    _prop_MailPort: Integer;
    _prop_ReceiveProtocol: Integer;
    _prop_Security: Integer;
    _prop_Auth: Integer;
    _prop_AuthMechanism: Integer;
    _prop_Login: string;
    _prop_Password: string;
    _prop_AccessToken: string;
    _prop_Timeout: Integer;
    _prop_IgnoreCertificateErrors: Boolean;
    _prop_Folder: string;
    _prop_Limit: Integer;
    _prop_Expunge: Boolean;

    _data_SmtpServer: THI_Event;
    _data_SmtpPort: THI_Event;
    _data_MailServer: THI_Event;
    _data_MailPort: THI_Event;
    _data_Login: THI_Event;
    _data_Password: THI_Event;
    _data_AccessToken: THI_Event;
    _data_Folder: THI_Event;
    _data_Limit: THI_Event;
    _event_onOpen: THI_Event;
    _event_onClose: THI_Event;

    destructor Destroy; override;
    procedure _work_doOpen(var _Data: TData; Index: Word);
    procedure _work_doClose(var _Data: TData; Index: Word);
    procedure _var_Handle(var _Data: TData; Index: Word);
  end;

implementation

function THIMailSession.BuildConfig(var _Data: TData): AnsiString;
var
  D: TData;
begin
  D.Data_type := data_null;
  Result :=
    '{' +
    MailJsonString('smtpServer', ReadString(D, _data_SmtpServer, _prop_SmtpServer)) +
    ',' + MailJsonInt('smtpPort', ReadInteger(D, _data_SmtpPort, _prop_SmtpPort)) +
    ',' + MailJsonString('mailServer', ReadString(D, _data_MailServer, _prop_MailServer)) +
    ',' + MailJsonInt('mailPort', ReadInteger(D, _data_MailPort, _prop_MailPort)) +
    ',' + MailJsonString('protocol', MailProtocolName(_prop_ReceiveProtocol)) +
    ',' + MailJsonString('security', MailSecurityName(_prop_Security)) +
    ',' + MailJsonString('auth', MailAuthName(_prop_Auth)) +
    ',' + MailJsonString('authMechanism', MailAuthMechanismName(_prop_AuthMechanism)) +
    ',' + MailJsonString('login', ReadString(D, _data_Login, _prop_Login)) +
    ',' + MailJsonString('password', ReadString(D, _data_Password, _prop_Password)) +
    ',' + MailJsonString('accessToken', ReadString(D, _data_AccessToken, _prop_AccessToken)) +
    ',' + MailJsonInt('timeoutMs', _prop_Timeout) +
    ',' + MailJsonBool('ignoreCertificateErrors', _prop_IgnoreCertificateErrors) +
    ',' + MailJsonString('folder', ReadString(D, _data_Folder, _prop_Folder)) +
    ',' + MailJsonInt('limit', ReadInteger(D, _data_Limit, _prop_Limit)) +
    ',' + MailJsonBool('expunge', _prop_Expunge) +
    '}';
end;

procedure THIMailSession.CloseSilent;
begin
  if FHandle > 0 then
  begin
    MailNativeCloseSession(FHandle);
    FHandle := 0;
  end;
end;

destructor THIMailSession.Destroy;
begin
  CloseSilent;
  inherited;
end;

procedure THIMailSession._work_doOpen(var _Data: TData; Index: Word);
begin
  CloseSilent;
  FLastError := '';
  FLastResult := MailNativeOpenSession(BuildConfig(_Data));
  if MailJsonIsOk(FLastResult) then
  begin
    FHandle := MailJsonGetInt(FLastResult, 'handle', 0);
    _hi_OnEvent(_event_onOpen, FHandle);
  end
  else
  begin
    FLastError := MailJsonGetString(FLastResult, 'error');
    if FLastError = '' then
      FLastError := FLastResult;
    _hi_OnEvent(_event_onError, FLastError);
  end;
end;

procedure THIMailSession._work_doClose(var _Data: TData; Index: Word);
var
  H: Integer;
begin
  FLastError := '';
  H := FHandle;
  if H <= 0 then
  begin
    FLastResult := MailLocalErrorJson('Session handle is empty');
    FireJsonResult(_event_onClose);
    Exit;
  end;

  FLastResult := MailNativeCloseSession(H);
  if H = FHandle then
    FHandle := 0;

  if MailJsonIsOk(FLastResult) then
    _hi_OnEvent(_event_onClose, H)
  else
  begin
    FLastError := MailJsonGetString(FLastResult, 'error');
    if FLastError = '' then
      FLastError := FLastResult;
    _hi_OnEvent(_event_onError, FLastError);
  end;
end;

procedure THIMailSession._var_Handle(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, FHandle);
end;

end.
