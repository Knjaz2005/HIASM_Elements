unit hiMailSend;

interface

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

uses
  Kol, Share, Debug, HiMailNativeShared;

type
  THIMailSend = class(THIMailNativeBase)
  private
    function BuildRequest(var _Data: TData): AnsiString;
  public
    _prop_Handle: Integer;
    _prop_From: string;
    _prop_To: string;
    _prop_Cc: string;
    _prop_Bcc: string;
    _prop_Subject: string;
    _prop_Html: Boolean;

    _data_Handle: THI_Event;
    _data_From: THI_Event;
    _data_To: THI_Event;
    _data_Cc: THI_Event;
    _data_Bcc: THI_Event;
    _data_Subject: THI_Event;
    _data_Body: THI_Event;
    _data_Attachments: THI_Event;

    _event_onSend: THI_Event;

    procedure _work_doSend(var _Data: TData; Index: Word);
  end;

implementation

function THIMailSend.BuildRequest(var _Data: TData): AnsiString;
var
  D: TData;
begin
  D.Data_type := data_null;
  Result :=
    '{' +
    MailJsonString('operation', 'send') +
    ',' + MailJsonString('from', ReadString(D, _data_From, _prop_From)) +
    ',' + '"to":' + MailJsonArrayFromList(ReadString(D, _data_To, _prop_To)) +
    ',' + '"cc":' + MailJsonArrayFromList(ReadString(D, _data_Cc, _prop_Cc)) +
    ',' + '"bcc":' + MailJsonArrayFromList(ReadString(D, _data_Bcc, _prop_Bcc)) +
    ',' + MailJsonString('subject', ReadString(D, _data_Subject, _prop_Subject)) +
    ',' + MailJsonString('body', ReadString(D, _data_Body, '')) +
    ',' + MailJsonBool('html', _prop_Html) +
    ',' + '"attachments":' + MailJsonArrayFromEvent(D, _data_Attachments) +
    '}';
end;

procedure THIMailSend._work_doSend(var _Data: TData; Index: Word);
var
  H: Integer;
begin
  FLastError := '';
  H := ReadInteger(_Data, _data_Handle, _prop_Handle);
  if H <= 0 then
    FLastResult := MailLocalErrorJson('Session handle is empty')
  else
    FLastResult := MailNativeSessionJson(H, BuildRequest(_Data));
  FireJsonResult(_event_onSend);
end;

end.
