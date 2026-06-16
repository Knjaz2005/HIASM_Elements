unit hiMailDelete;

interface

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

uses
  Kol, Share, Debug, HiMailNativeShared;

type
  THIMailDelete = class(THIMailNativeBase)
  private
    function BuildRequest(var _Data: TData): AnsiString;
  public
    _prop_Handle: Integer;
    _prop_Folder: string;
    _prop_Index: Integer;
    _prop_Uid: string;
    _prop_Expunge: Boolean;

    _data_Handle: THI_Event;
    _data_Folder: THI_Event;
    _data_Index: THI_Event;
    _data_Uid: THI_Event;

    _event_onDelete: THI_Event;

    procedure _work_doDelete(var _Data: TData; Index: Word);
  end;

implementation

function THIMailDelete.BuildRequest(var _Data: TData): AnsiString;
var
  D: TData;
begin
  D.Data_type := data_null;
  Result :=
    '{' +
    MailJsonString('operation', 'delete') +
    ',' + MailJsonString('folder', ReadString(D, _data_Folder, _prop_Folder)) +
    ',' + MailJsonInt('index', ReadInteger(D, _data_Index, _prop_Index)) +
    ',' + MailJsonString('uid', ReadString(D, _data_Uid, _prop_Uid)) +
    ',' + MailJsonBool('expunge', _prop_Expunge) +
    '}';
end;

procedure THIMailDelete._work_doDelete(var _Data: TData; Index: Word);
var
  H: Integer;
begin
  FLastError := '';
  H := ReadInteger(_Data, _data_Handle, _prop_Handle);
  if H <= 0 then
    FLastResult := MailLocalErrorJson('Session handle is empty')
  else
    FLastResult := MailNativeSessionJson(H, BuildRequest(_Data));
  FireJsonResult(_event_onDelete);
end;

end.
