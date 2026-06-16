unit hiMailRead;

interface

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

uses
  Kol, Share, Debug, HiMailNativeShared;

type
  THIMailRead = class(THIMailNativeBase)
  private
    FSubject: string;
    FFrom: string;
    FTo: string;
    FBodyText: string;
    FBodyHtml: string;
    function BuildRequest(var _Data: TData): AnsiString;
    procedure ApplyMessage;
  public
    _prop_Handle: Integer;
    _prop_Folder: string;
    _prop_Index: Integer;
    _prop_Uid: string;
    _prop_SaveAttachmentsDir: string;

    _data_Handle: THI_Event;
    _data_Folder: THI_Event;
    _data_Index: THI_Event;
    _data_Uid: THI_Event;
    _data_SaveAttachmentsDir: THI_Event;

    _event_onRead: THI_Event;

    procedure _work_doRead(var _Data: TData; Index: Word);
    procedure _var_SubjectOut(var _Data: TData; Index: Word);
    procedure _var_FromOut(var _Data: TData; Index: Word);
    procedure _var_ToOut(var _Data: TData; Index: Word);
    procedure _var_BodyText(var _Data: TData; Index: Word);
    procedure _var_BodyHtml(var _Data: TData; Index: Word);
  end;

implementation

function THIMailRead.BuildRequest(var _Data: TData): AnsiString;
var
  D: TData;
begin
  D.Data_type := data_null;
  Result :=
    '{' +
    MailJsonString('operation', 'get') +
    ',' + MailJsonString('folder', ReadString(D, _data_Folder, _prop_Folder)) +
    ',' + MailJsonInt('index', ReadInteger(D, _data_Index, _prop_Index)) +
    ',' + MailJsonString('uid', ReadString(D, _data_Uid, _prop_Uid)) +
    ',' + MailJsonString('saveAttachmentsDir', ReadString(D, _data_SaveAttachmentsDir, _prop_SaveAttachmentsDir)) +
    '}';
end;

procedure THIMailRead.ApplyMessage;
begin
  FSubject := MailJsonGetString(FLastResult, 'subject');
  FFrom := MailJsonGetString(FLastResult, 'from');
  FTo := MailJsonGetString(FLastResult, 'to');
  FBodyText := MailJsonGetString(FLastResult, 'bodyText');
  FBodyHtml := MailJsonGetString(FLastResult, 'bodyHtml');
end;

procedure THIMailRead._work_doRead(var _Data: TData; Index: Word);
var
  H: Integer;
begin
  FLastError := '';
  H := ReadInteger(_Data, _data_Handle, _prop_Handle);
  if H <= 0 then
    FLastResult := MailLocalErrorJson('Session handle is empty')
  else
    FLastResult := MailNativeSessionJson(H, BuildRequest(_Data));
  if FireJsonResult(_event_onRead) then
    ApplyMessage;
end;

procedure THIMailRead._var_SubjectOut(var _Data: TData; Index: Word);
begin
  dtString(_Data, FSubject);
end;

procedure THIMailRead._var_FromOut(var _Data: TData; Index: Word);
begin
  dtString(_Data, FFrom);
end;

procedure THIMailRead._var_ToOut(var _Data: TData; Index: Word);
begin
  dtString(_Data, FTo);
end;

procedure THIMailRead._var_BodyText(var _Data: TData; Index: Word);
begin
  dtString(_Data, FBodyText);
end;

procedure THIMailRead._var_BodyHtml(var _Data: TData; Index: Word);
begin
  dtString(_Data, FBodyHtml);
end;

end.
