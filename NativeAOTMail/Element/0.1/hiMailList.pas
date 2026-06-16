unit hiMailList;

interface

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

uses
  Kol, Share, Debug, HiMailNativeShared;

type
  THIMailList = class(THIMailNativeBase)
  private
    FCount: Integer;
    function BuildRequest(var _Data: TData): AnsiString;
  public
    _prop_Handle: Integer;
    _prop_Folder: string;
    _prop_Limit: Integer;

    _data_Handle: THI_Event;
    _data_Folder: THI_Event;
    _data_Limit: THI_Event;

    _event_onList: THI_Event;

    procedure _work_doList(var _Data: TData; Index: Word);
    procedure _var_Count(var _Data: TData; Index: Word);
  end;

implementation

function THIMailList.BuildRequest(var _Data: TData): AnsiString;
var
  D: TData;
begin
  D.Data_type := data_null;
  Result :=
    '{' +
    MailJsonString('operation', 'list') +
    ',' + MailJsonString('folder', ReadString(D, _data_Folder, _prop_Folder)) +
    ',' + MailJsonInt('limit', ReadInteger(D, _data_Limit, _prop_Limit)) +
    '}';
end;

procedure THIMailList._work_doList(var _Data: TData; Index: Word);
var
  H: Integer;
begin
  FLastError := '';
  H := ReadInteger(_Data, _data_Handle, _prop_Handle);
  if H <= 0 then
    FLastResult := MailLocalErrorJson('Session handle is empty')
  else
    FLastResult := MailNativeSessionJson(H, BuildRequest(_Data));
  if FireJsonResult(_event_onList) then
    FCount := MailJsonGetInt(FLastResult, 'count', 0);
end;

procedure THIMailList._var_Count(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, FCount);
end;

end.
