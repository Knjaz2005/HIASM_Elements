unit hiXMLNativeAOTEditor;

interface

{$IFDEF FPC}
  {$MODE DELPHI}
  {$H+}
{$ENDIF}

uses
  Windows, Kol, Share, Debug;

type
  THIXMLNativeAOTEditor = class(TDebug)
  private
    FSessionID: Integer;

    FLoadedXml: string;
    FQueryResult: string;
    FNodeValue: string;
    FAttributeName: string;
    FAttributeValue: string;
    FAttributeListJson: string;
    FSavedXml: string;
    FErrorMsg: string;
    FErrorCode: string;
    FNodeInfoJson: string;
    FBridgeInfo: string;
    FNodeXml: string;
    FCurrentNodePath: string;
    FResolvedNodePath: string;
    FSelectedCount: Integer;
    FCurrentIndex: Integer;
    FAttributeCount: Integer;
    FAttributeIndex: Integer;
    FPathExists: Integer;

    function StrToUtf8Z(const S: string): AnsiString;
    function Utf8ZToStr(const P: PAnsiChar): string;
    function TakeUtf8Result(P: PAnsiChar): string;
    function EnsureBridge: Boolean;
    function EnsureSession: Boolean;
    function ReadFormatting(var _Data: TData): Integer;
    function ReadDtdProcessing(var _Data: TData): Integer;
    function ReadMaxCharacters(var _Data: TData): Int64;
    function IsOk(const S: string): Boolean;
    function ParseErrorCode(const Msg: string): string;
    procedure ClearVars(const ClearError: Boolean);
    procedure Done(const Ok: Boolean);
    procedure SetErrorAndFire(const Msg: string);
    function RefreshNodeInfo(const FireEvent: Boolean): Boolean;
    procedure AutoUpdateNodeInfo;
    procedure UpdateCurrentNodePath;
    procedure FireChanged;
  public
    _prop_Formatting: Integer;
    _prop_PreserveWhitespace: Boolean;
    _prop_DtdProcessing: Integer;
    _prop_MaxCharactersInDocument: Integer;
    _prop_AutoNodeInfo: Boolean;

    _data_XmlStringIn: THI_Event;
    _data_FilePathIn: THI_Event;
    _data_RootNameIn: THI_Event;
    _data_XPathIn: THI_Event;
    _data_NodePathIn: THI_Event;
    _data_IndexIn: THI_Event;
    _data_NewValueIn: THI_Event;
    _data_AttributeNameIn: THI_Event;
    _data_AttributeValueIn: THI_Event;
    _data_ChildNameIn: THI_Event;
    _data_ChildXmlIn: THI_Event;
    _data_NodeXmlIn: THI_Event;
    _data_NamespacePrefixIn: THI_Event;
    _data_NamespaceUriIn: THI_Event;
    _data_NamespacesJsonIn: THI_Event;
    _data_FormattingIn: THI_Event;
    _data_DtdProcessingIn: THI_Event;
    _data_MaxCharactersInDocumentIn: THI_Event;

    _event_OnXmlLoaded: THI_Event;
    _event_OnQueryExecuted: THI_Event;
    _event_OnCurrentNodeChanged: THI_Event;
    _event_OnPathResolved: THI_Event;
    _event_OnNode: THI_Event;
    _event_OnValueRetrieved: THI_Event;
    _event_OnValueSet: THI_Event;
    _event_OnAttributeRetrieved: THI_Event;
    _event_OnAttributeSet: THI_Event;
    _event_OnAttributeRemoved: THI_Event;
    _event_OnAttributeList: THI_Event;
    _event_OnAttribute: THI_Event;
    _event_OnNodeAdded: THI_Event;
    _event_OnNodeDeleted: THI_Event;
    _event_OnXmlSaved: THI_Event;
    _event_OnNodeXmlRetrieved: THI_Event;
    _event_OnNodeXmlSet: THI_Event;
    _event_OnNamespacesChanged: THI_Event;
    _event_OnBridgeInfo: THI_Event;
    _event_OnError: THI_Event;
    _event_OnNodeInfoRetrieved: THI_Event;
    _event_OnChanged: THI_Event;
    _event_OnDone: THI_Event;

    procedure _var_LoadedXml(var _Data: TData; Index: Word);
    procedure _var_QueryResult(var _Data: TData; Index: Word);
    procedure _var_NodeValue(var _Data: TData; Index: Word);
    procedure _var_AttributeName(var _Data: TData; Index: Word);
    procedure _var_AttributeValue(var _Data: TData; Index: Word);
    procedure _var_AttributeListJson(var _Data: TData; Index: Word);
    procedure _var_SavedXmlString(var _Data: TData; Index: Word);
    procedure _var_ErrorMessage(var _Data: TData; Index: Word);
    procedure _var_ErrorCode(var _Data: TData; Index: Word);
    procedure _var_NodeInfoJson(var _Data: TData; Index: Word);
    procedure _var_BridgeInfo(var _Data: TData; Index: Word);
    procedure _var_NodeXml(var _Data: TData; Index: Word);
    procedure _var_CurrentNodePath(var _Data: TData; Index: Word);
    procedure _var_ResolvedNodePath(var _Data: TData; Index: Word);
    procedure _var_SelectedCount(var _Data: TData; Index: Word);
    procedure _var_CurrentIndex(var _Data: TData; Index: Word);
    procedure _var_AttributeCount(var _Data: TData; Index: Word);
    procedure _var_AttributeIndex(var _Data: TData; Index: Word);
    procedure _var_PathExists(var _Data: TData; Index: Word);
    procedure _var_SessionIDOut(var _Data: TData; Index: Word);

    procedure _work_doLoadXmlString(var _Data: TData; Index: Word);
    procedure _work_doLoadXmlFile(var _Data: TData; Index: Word);
    procedure _work_doCreateNewXml(var _Data: TData; Index: Word);
    procedure _work_doSelectNodes(var _Data: TData; Index: Word);
    procedure _work_doSelectSingleNode(var _Data: TData; Index: Word);
    procedure _work_doSetCurrentNode(var _Data: TData; Index: Word);
    procedure _work_doSelectByIndex(var _Data: TData; Index: Word);
    procedure _work_doSelectNodePath(var _Data: TData; Index: Word);
    procedure _work_doPathExists(var _Data: TData; Index: Word);
    procedure _work_doEnsureNodePath(var _Data: TData; Index: Word);
    procedure _work_doEnumSelectedNodes(var _Data: TData; Index: Word);
    procedure _work_doGetValue(var _Data: TData; Index: Word);
    procedure _work_doSetValue(var _Data: TData; Index: Word);
    procedure _work_doGetPathValue(var _Data: TData; Index: Word);
    procedure _work_doSetPathValue(var _Data: TData; Index: Word);
    procedure _work_doGetAttributeValue(var _Data: TData; Index: Word);
    procedure _work_doSetAttributeValue(var _Data: TData; Index: Word);
    procedure _work_doGetAttributeList(var _Data: TData; Index: Word);
    procedure _work_doEnumAttributes(var _Data: TData; Index: Word);
    procedure _work_doRemoveAttribute(var _Data: TData; Index: Word);
    procedure _work_doAddChildNode(var _Data: TData; Index: Word);
    procedure _work_doAddChildXml(var _Data: TData; Index: Word);
    procedure _work_doDeleteNode(var _Data: TData; Index: Word);
    procedure _work_doGetNodeXml(var _Data: TData; Index: Word);
    procedure _work_doSetNodeXml(var _Data: TData; Index: Word);
    procedure _work_doGetPathXml(var _Data: TData; Index: Word);
    procedure _work_doSetPathXml(var _Data: TData; Index: Word);
    procedure _work_doDeletePath(var _Data: TData; Index: Word);
    procedure _work_doSaveXmlToString(var _Data: TData; Index: Word);
    procedure _work_doSaveXmlToFile(var _Data: TData; Index: Word);
    procedure _work_doSetNamespacePrefix(var _Data: TData; Index: Word);
    procedure _work_doSetNamespacesJson(var _Data: TData; Index: Word);
    procedure _work_doClearNamespaces(var _Data: TData; Index: Word);
    procedure _work_doGetBridgeInfo(var _Data: TData; Index: Word);
    procedure _work_doGetNodeInfo(var _Data: TData; Index: Word);
    procedure _work_doClose(var _Data: TData; Index: Word);

    destructor Destroy; override;
  end;

implementation

const
  BRIDGE_DLL = 'XMLNativeAOTEditor.dll';
{$IFDEF WIN64}
  BRIDGE_ARCH_DIR = 'win-x64';
  BRIDGE_ARCH_DIR_ALT = '';
{$ELSE}
  {$IFDEF CPU64}
  BRIDGE_ARCH_DIR = 'win-x64';
  BRIDGE_ARCH_DIR_ALT = '';
  {$ELSE}
  BRIDGE_ARCH_DIR = 'win-x86';
  { 2026-06-18: win-x86 is the canonical 32-bit package directory.
    Keep win-x32 only as an undocumented fallback for old local packages; do not publish or document it. }
  BRIDGE_ARCH_DIR_ALT = 'win-x32';
  {$ENDIF}
{$ENDIF}

type
  TNativeCreateSession = function: Integer; stdcall;
  TNativeDestroySession = procedure(SessionId: Integer); stdcall;
  TNativeFreeString = procedure(Value: PAnsiChar); stdcall;
  TNativeGetBridgeInfo = function: PAnsiChar; stdcall;
  TNativeLoadXml = function(SessionId: Integer; ValueUtf8: PAnsiChar; PreserveWhitespace, DtdProcessing: Integer; MaxCharacters: Int64): PAnsiChar; stdcall;
  TNativeOneString = function(SessionId: Integer; ValueUtf8: PAnsiChar): PAnsiChar; stdcall;
  TNativeTwoStrings = function(SessionId: Integer; Value1Utf8, Value2Utf8: PAnsiChar): PAnsiChar; stdcall;
  TNativeNoArgString = function(SessionId: Integer): PAnsiChar; stdcall;
  TNativeSaveString = function(SessionId: Integer; Formatting: Integer): PAnsiChar; stdcall;
  TNativeSaveFile = function(SessionId: Integer; PathUtf8: PAnsiChar; Formatting: Integer): PAnsiChar; stdcall;
  TNativeSelectByIndex = function(SessionId, Index: Integer): PAnsiChar; stdcall;
  TNativeGetInt = function(SessionId: Integer): Integer; stdcall;
  TNativeGetAttrByIndex = function(SessionId, Index: Integer): PAnsiChar; stdcall;
  TNativePathFormat = function(SessionId: Integer; PathUtf8: PAnsiChar; Formatting: Integer): PAnsiChar; stdcall;

var
  BridgeModule: HMODULE = 0;
  BridgePath: string = '';
  BridgeLoadError: string = '';

  NativeCreateSession: TNativeCreateSession = nil;
  NativeDestroySession: TNativeDestroySession = nil;
  NativeFreeString: TNativeFreeString = nil;
  NativeGetBridgeInfo: TNativeGetBridgeInfo = nil;
  NativeLoadXmlString: TNativeLoadXml = nil;
  NativeLoadXmlFile: TNativeLoadXml = nil;
  NativeCreateNewXml: TNativeOneString = nil;
  NativeSaveXmlToString: TNativeSaveString = nil;
  NativeSaveXmlToFile: TNativeSaveFile = nil;
  NativeSetNamespacePrefix: TNativeTwoStrings = nil;
  NativeSetNamespacesJson: TNativeOneString = nil;
  NativeClearNamespaces: TNativeNoArgString = nil;
  NativeSelectNodes: TNativeOneString = nil;
  NativeSelectSingleNode: TNativeOneString = nil;
  NativeSetCurrentNode: TNativeOneString = nil;
  NativeSelectByIndex: TNativeSelectByIndex = nil;
  NativeSelectNodePath: TNativeOneString = nil;
  NativePathExists: TNativeOneString = nil;
  NativeResolveNodePath: TNativeOneString = nil;
  NativeEnsureNodePath: TNativeOneString = nil;
  NativeGetPathValue: TNativeOneString = nil;
  NativeSetPathValue: TNativeTwoStrings = nil;
  NativeGetPathXml: TNativePathFormat = nil;
  NativeSetPathXml: TNativeTwoStrings = nil;
  NativeDeletePath: TNativeOneString = nil;
  NativeGetSelectedCount: TNativeGetInt = nil;
  NativeGetValue: TNativeNoArgString = nil;
  NativeSetValue: TNativeOneString = nil;
  NativeGetAttributeValue: TNativeOneString = nil;
  NativeSetAttributeValue: TNativeTwoStrings = nil;
  NativeRemoveAttribute: TNativeOneString = nil;
  NativeGetAttributeListJson: TNativeNoArgString = nil;
  NativeGetAttributeCount: TNativeGetInt = nil;
  NativeGetAttributeNameByIndex: TNativeGetAttrByIndex = nil;
  NativeGetAttributeValueByIndex: TNativeGetAttrByIndex = nil;
  NativeAddChildNode: TNativeOneString = nil;
  NativeAddChildXml: TNativeOneString = nil;
  NativeDeleteNode: TNativeNoArgString = nil;
  NativeGetNodeXml: TNativeSaveString = nil;
  NativeSetNodeXml: TNativeOneString = nil;
  NativeGetNodeOutlineJson: TNativeNoArgString = nil;
  NativeGetCurrentNodePath: TNativeNoArgString = nil;

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

function ModuleFileName(Module: HMODULE): string;
{$IFDEF UNICODE}
var
  Buf: array[0..MAX_PATH - 1] of WideChar;
  Len: DWORD;
begin
  Len := GetModuleFileNameW(Module, @Buf[0], MAX_PATH);
  if Len = 0 then
    Result := ''
  else
  begin
    if Len >= MAX_PATH then
      Len := MAX_PATH - 1;
    Buf[Len] := #0;
    Result := string(PWideChar(@Buf[0]));
  end;
end;
{$ELSE}
var
  Buf: array[0..MAX_PATH - 1] of AnsiChar;
  Len: DWORD;
begin
  Len := GetModuleFileNameA(Module, @Buf[0], MAX_PATH);
  if Len = 0 then
    Result := ''
  else
  begin
    if Len >= MAX_PATH then
      Len := MAX_PATH - 1;
    Buf[Len] := #0;
    Result := string(PAnsiChar(@Buf[0]));
  end;
end;
{$ENDIF}

function AppDir: string;
begin
  Result := FileDirWithSlash(ModuleFileName(0));
end;

function ModulePath(Module: HMODULE): string;
begin
  Result := ModuleFileName(Module);
  if Result = '' then
    Result := BridgePath;
end;

function LoadLibraryCompat(const FileName: string): HMODULE;
{$IFDEF UNICODE}
var
  W: WideString;
begin
  W := WideString(FileName);
  Result := LoadLibraryW(PWideChar(W));
end;
{$ELSE}
begin
  Result := LoadLibraryA(PChar(FileName));
end;
{$ENDIF}

function LoadBridge: Boolean;
var
  ArchPath: string;
  AltArchPath: string;
  LocalPath: string;
begin
  Result := False;
  BridgeLoadError := '';

  if BridgeModule = 0 then
  begin
    ArchPath := AppDir + BRIDGE_ARCH_DIR + '\' + BRIDGE_DLL;
    AltArchPath := '';
    LocalPath := AppDir + BRIDGE_DLL;

    BridgeModule := LoadLibraryCompat(ArchPath);
    BridgePath := ArchPath;
    if (BridgeModule = 0) and (BRIDGE_ARCH_DIR_ALT <> '') then
    begin
      AltArchPath := AppDir + BRIDGE_ARCH_DIR_ALT + '\' + BRIDGE_DLL;
      BridgeModule := LoadLibraryCompat(AltArchPath);
      BridgePath := AltArchPath;
    end;

    if BridgeModule = 0 then
    begin
      BridgeModule := LoadLibraryCompat(LocalPath);
      BridgePath := LocalPath;
    end;

    if BridgeModule = 0 then
    begin
      BridgeModule := LoadLibraryCompat(BRIDGE_DLL);
      BridgePath := BRIDGE_DLL;
    end;

    if BridgeModule = 0 then
    begin
      BridgeLoadError := 'Cannot load ' + BRIDGE_DLL + ' from ' + ArchPath + ' or ' + LocalPath;
      if AltArchPath <> '' then
        BridgeLoadError := 'Cannot load ' + BRIDGE_DLL + ' from ' + ArchPath + ' or ' + AltArchPath + ' or ' + LocalPath;
      Exit;
    end;

    BridgePath := ModulePath(BridgeModule);
    @NativeCreateSession := GetProcAny(BridgeModule, 'XMLNativeAOT_CreateSession', '_XMLNativeAOT_CreateSession@0');
    @NativeDestroySession := GetProcAny(BridgeModule, 'XMLNativeAOT_DestroySession', '_XMLNativeAOT_DestroySession@4');
    @NativeFreeString := GetProcAny(BridgeModule, 'XMLNativeAOT_FreeString', '_XMLNativeAOT_FreeString@4');
    @NativeGetBridgeInfo := GetProcAny(BridgeModule, 'XMLNativeAOT_GetBridgeInfo', '_XMLNativeAOT_GetBridgeInfo@0');
    @NativeLoadXmlString := GetProcAny(BridgeModule, 'XMLNativeAOT_LoadXmlString', '_XMLNativeAOT_LoadXmlString@24');
    @NativeLoadXmlFile := GetProcAny(BridgeModule, 'XMLNativeAOT_LoadXmlFile', '_XMLNativeAOT_LoadXmlFile@24');
    @NativeCreateNewXml := GetProcAny(BridgeModule, 'XMLNativeAOT_CreateNewXml', '_XMLNativeAOT_CreateNewXml@8');
    @NativeSaveXmlToString := GetProcAny(BridgeModule, 'XMLNativeAOT_SaveXmlToString', '_XMLNativeAOT_SaveXmlToString@8');
    @NativeSaveXmlToFile := GetProcAny(BridgeModule, 'XMLNativeAOT_SaveXmlToFile', '_XMLNativeAOT_SaveXmlToFile@12');
    @NativeSetNamespacePrefix := GetProcAny(BridgeModule, 'XMLNativeAOT_SetNamespacePrefix', '_XMLNativeAOT_SetNamespacePrefix@12');
    @NativeSetNamespacesJson := GetProcAny(BridgeModule, 'XMLNativeAOT_SetNamespacesJson', '_XMLNativeAOT_SetNamespacesJson@8');
    @NativeClearNamespaces := GetProcAny(BridgeModule, 'XMLNativeAOT_ClearNamespaces', '_XMLNativeAOT_ClearNamespaces@4');
    @NativeSelectNodes := GetProcAny(BridgeModule, 'XMLNativeAOT_SelectNodes', '_XMLNativeAOT_SelectNodes@8');
    @NativeSelectSingleNode := GetProcAny(BridgeModule, 'XMLNativeAOT_SelectSingleNode', '_XMLNativeAOT_SelectSingleNode@8');
    @NativeSetCurrentNode := GetProcAny(BridgeModule, 'XMLNativeAOT_SetCurrentNode', '_XMLNativeAOT_SetCurrentNode@8');
    @NativeSelectByIndex := GetProcAny(BridgeModule, 'XMLNativeAOT_SelectByIndex', '_XMLNativeAOT_SelectByIndex@8');
    @NativeSelectNodePath := GetProcAny(BridgeModule, 'XMLNativeAOT_SelectNodePath', '_XMLNativeAOT_SelectNodePath@8');
    @NativePathExists := GetProcAny(BridgeModule, 'XMLNativeAOT_PathExists', '_XMLNativeAOT_PathExists@8');
    @NativeResolveNodePath := GetProcAny(BridgeModule, 'XMLNativeAOT_ResolveNodePath', '_XMLNativeAOT_ResolveNodePath@8');
    @NativeEnsureNodePath := GetProcAny(BridgeModule, 'XMLNativeAOT_EnsureNodePath', '_XMLNativeAOT_EnsureNodePath@8');
    @NativeGetPathValue := GetProcAny(BridgeModule, 'XMLNativeAOT_GetPathValue', '_XMLNativeAOT_GetPathValue@8');
    @NativeSetPathValue := GetProcAny(BridgeModule, 'XMLNativeAOT_SetPathValue', '_XMLNativeAOT_SetPathValue@12');
    @NativeGetPathXml := GetProcAny(BridgeModule, 'XMLNativeAOT_GetPathXml', '_XMLNativeAOT_GetPathXml@12');
    @NativeSetPathXml := GetProcAny(BridgeModule, 'XMLNativeAOT_SetPathXml', '_XMLNativeAOT_SetPathXml@12');
    @NativeDeletePath := GetProcAny(BridgeModule, 'XMLNativeAOT_DeletePath', '_XMLNativeAOT_DeletePath@8');
    @NativeGetSelectedCount := GetProcAny(BridgeModule, 'XMLNativeAOT_GetSelectedCount', '_XMLNativeAOT_GetSelectedCount@4');
    @NativeGetValue := GetProcAny(BridgeModule, 'XMLNativeAOT_GetValue', '_XMLNativeAOT_GetValue@4');
    @NativeSetValue := GetProcAny(BridgeModule, 'XMLNativeAOT_SetValue', '_XMLNativeAOT_SetValue@8');
    @NativeGetAttributeValue := GetProcAny(BridgeModule, 'XMLNativeAOT_GetAttributeValue', '_XMLNativeAOT_GetAttributeValue@8');
    @NativeSetAttributeValue := GetProcAny(BridgeModule, 'XMLNativeAOT_SetAttributeValue', '_XMLNativeAOT_SetAttributeValue@12');
    @NativeRemoveAttribute := GetProcAny(BridgeModule, 'XMLNativeAOT_RemoveAttribute', '_XMLNativeAOT_RemoveAttribute@8');
    @NativeGetAttributeListJson := GetProcAny(BridgeModule, 'XMLNativeAOT_GetAttributeListJson', '_XMLNativeAOT_GetAttributeListJson@4');
    @NativeGetAttributeCount := GetProcAny(BridgeModule, 'XMLNativeAOT_GetAttributeCount', '_XMLNativeAOT_GetAttributeCount@4');
    @NativeGetAttributeNameByIndex := GetProcAny(BridgeModule, 'XMLNativeAOT_GetAttributeNameByIndex', '_XMLNativeAOT_GetAttributeNameByIndex@8');
    @NativeGetAttributeValueByIndex := GetProcAny(BridgeModule, 'XMLNativeAOT_GetAttributeValueByIndex', '_XMLNativeAOT_GetAttributeValueByIndex@8');
    @NativeAddChildNode := GetProcAny(BridgeModule, 'XMLNativeAOT_AddChildNode', '_XMLNativeAOT_AddChildNode@8');
    @NativeAddChildXml := GetProcAny(BridgeModule, 'XMLNativeAOT_AddChildXml', '_XMLNativeAOT_AddChildXml@8');
    @NativeDeleteNode := GetProcAny(BridgeModule, 'XMLNativeAOT_DeleteNode', '_XMLNativeAOT_DeleteNode@4');
    @NativeGetNodeXml := GetProcAny(BridgeModule, 'XMLNativeAOT_GetNodeXml', '_XMLNativeAOT_GetNodeXml@8');
    @NativeSetNodeXml := GetProcAny(BridgeModule, 'XMLNativeAOT_SetNodeXml', '_XMLNativeAOT_SetNodeXml@8');
    @NativeGetNodeOutlineJson := GetProcAny(BridgeModule, 'XMLNativeAOT_GetNodeOutlineJson', '_XMLNativeAOT_GetNodeOutlineJson@4');
    @NativeGetCurrentNodePath := GetProcAny(BridgeModule, 'XMLNativeAOT_GetCurrentNodePath', '_XMLNativeAOT_GetCurrentNodePath@4');
  end;

  if not Assigned(NativeFreeString) then
    BridgeLoadError := BridgePath + ' does not export XMLNativeAOT_FreeString'
  else if not Assigned(NativeCreateSession) then
    BridgeLoadError := BridgePath + ' does not export XMLNativeAOT_CreateSession'
  else if not Assigned(NativeDestroySession) then
    BridgeLoadError := BridgePath + ' does not export XMLNativeAOT_DestroySession'
  else
    Result := True;
end;

{$IFDEF UNICODE}
function THIXMLNativeAOTEditor.StrToUtf8Z(const S: string): AnsiString;
begin
  Result := UTF8Encode(S);
end;
{$ELSE}
function THIXMLNativeAOTEditor.StrToUtf8Z(const S: string): AnsiString;
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
function THIXMLNativeAOTEditor.Utf8ZToStr(const P: PAnsiChar): string;
begin
  if P = nil then
    Result := ''
  else
    Result := UTF8ToString(AnsiString(P));
end;
{$ELSE}
function THIXMLNativeAOTEditor.Utf8ZToStr(const P: PAnsiChar): string;
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

function THIXMLNativeAOTEditor.TakeUtf8Result(P: PAnsiChar): string;
begin
  Result := Utf8ZToStr(P);
  if (P <> nil) and Assigned(NativeFreeString) then
    NativeFreeString(P);
end;

function THIXMLNativeAOTEditor.EnsureBridge: Boolean;
begin
  Result := LoadBridge;
  if not Result then
    SetErrorAndFire('ERROR: BRIDGE_LOAD: ' + BridgeLoadError);
end;

function THIXMLNativeAOTEditor.EnsureSession: Boolean;
begin
  Result := False;
  if not EnsureBridge then
    Exit;

  if FSessionID = 0 then
    FSessionID := NativeCreateSession;

  Result := FSessionID <> 0;
  if not Result then
    SetErrorAndFire('ERROR: SESSION: Native session was not created');
end;

function THIXMLNativeAOTEditor.ReadFormatting(var _Data: TData): Integer;
begin
  Result := ReadInteger(_Data, _data_FormattingIn, _prop_Formatting);
  if Result < 0 then
    Result := 0
  else if Result > 1 then
    Result := 1;
end;

function THIXMLNativeAOTEditor.ReadDtdProcessing(var _Data: TData): Integer;
begin
  Result := ReadInteger(_Data, _data_DtdProcessingIn, _prop_DtdProcessing);
  if Result < 0 then
    Result := 0
  else if Result > 2 then
    Result := 2;
end;

function THIXMLNativeAOTEditor.ReadMaxCharacters(var _Data: TData): Int64;
begin
  Result := ReadInteger(_Data, _data_MaxCharactersInDocumentIn, _prop_MaxCharactersInDocument);
  if Result < 0 then
    Result := 0;
end;

function THIXMLNativeAOTEditor.IsOk(const S: string): Boolean;
begin
  Result := Copy(S, 1, 6) <> 'ERROR:';
end;

function THIXMLNativeAOTEditor.ParseErrorCode(const Msg: string): string;
var
  P, E: Integer;
begin
  Result := '';
  if Copy(Msg, 1, 6) <> 'ERROR:' then
    Exit;

  P := 8;
  while (P <= Length(Msg)) and (Msg[P] = ' ') do
    Inc(P);
  E := P;
  while (E <= Length(Msg)) and (Msg[E] <> ':') do
    Inc(E);
  Result := Copy(Msg, P, E - P);
end;

procedure THIXMLNativeAOTEditor.ClearVars(const ClearError: Boolean);
begin
  FQueryResult := '';
  FNodeValue := '';
  FAttributeName := '';
  FAttributeValue := '';
  FAttributeListJson := '';
  FSavedXml := '';
  FNodeInfoJson := '';
  FBridgeInfo := '';
  FNodeXml := '';
  FCurrentNodePath := '';
  FResolvedNodePath := '';
  FSelectedCount := 0;
  FCurrentIndex := -1;
  FAttributeCount := 0;
  FAttributeIndex := -1;
  FPathExists := 0;
  if ClearError then
  begin
    FErrorMsg := '';
    FErrorCode := '';
  end;
end;

procedure THIXMLNativeAOTEditor.Done(const Ok: Boolean);
begin
  _hi_OnEvent(_event_OnDone, Integer(Ord(Ok)));
end;

procedure THIXMLNativeAOTEditor.SetErrorAndFire(const Msg: string);
begin
  FErrorMsg := Msg;
  FErrorCode := ParseErrorCode(Msg);
  _hi_OnEvent(_event_OnError, FErrorMsg);
  Done(False);
end;

function THIXMLNativeAOTEditor.RefreshNodeInfo(const FireEvent: Boolean): Boolean;
var
  R: string;
begin
  Result := False;
  if (FSessionID = 0) or not Assigned(NativeGetNodeOutlineJson) then
    Exit;

  R := TakeUtf8Result(NativeGetNodeOutlineJson(FSessionID));
  if IsOk(R) then
  begin
    FNodeInfoJson := R;
    if FireEvent then
      _hi_OnEvent(_event_OnNodeInfoRetrieved, FNodeInfoJson);
    Result := True;
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor.AutoUpdateNodeInfo;
begin
  if _prop_AutoNodeInfo then
    RefreshNodeInfo(True);
end;

procedure THIXMLNativeAOTEditor.UpdateCurrentNodePath;
var
  R: string;
begin
  if (FSessionID = 0) or not Assigned(NativeGetCurrentNodePath) then
    Exit;

  R := TakeUtf8Result(NativeGetCurrentNodePath(FSessionID));
  if IsOk(R) then
    FCurrentNodePath := R;
end;

procedure THIXMLNativeAOTEditor.FireChanged;
begin
  _hi_OnEvent(_event_OnChanged);
end;

procedure THIXMLNativeAOTEditor._var_LoadedXml(var _Data: TData; Index: Word);
begin
  dtString(_Data, FLoadedXml);
end;

procedure THIXMLNativeAOTEditor._var_QueryResult(var _Data: TData; Index: Word);
begin
  dtString(_Data, FQueryResult);
end;

procedure THIXMLNativeAOTEditor._var_NodeValue(var _Data: TData; Index: Word);
begin
  dtString(_Data, FNodeValue);
end;

procedure THIXMLNativeAOTEditor._var_AttributeName(var _Data: TData; Index: Word);
begin
  dtString(_Data, FAttributeName);
end;

procedure THIXMLNativeAOTEditor._var_AttributeValue(var _Data: TData; Index: Word);
begin
  dtString(_Data, FAttributeValue);
end;

procedure THIXMLNativeAOTEditor._var_AttributeListJson(var _Data: TData; Index: Word);
begin
  dtString(_Data, FAttributeListJson);
end;

procedure THIXMLNativeAOTEditor._var_SavedXmlString(var _Data: TData; Index: Word);
begin
  dtString(_Data, FSavedXml);
end;

procedure THIXMLNativeAOTEditor._var_ErrorMessage(var _Data: TData; Index: Word);
begin
  dtString(_Data, FErrorMsg);
end;

procedure THIXMLNativeAOTEditor._var_ErrorCode(var _Data: TData; Index: Word);
begin
  dtString(_Data, FErrorCode);
end;

procedure THIXMLNativeAOTEditor._var_NodeInfoJson(var _Data: TData; Index: Word);
begin
  dtString(_Data, FNodeInfoJson);
end;

procedure THIXMLNativeAOTEditor._var_BridgeInfo(var _Data: TData; Index: Word);
begin
  dtString(_Data, FBridgeInfo);
end;

procedure THIXMLNativeAOTEditor._var_NodeXml(var _Data: TData; Index: Word);
begin
  dtString(_Data, FNodeXml);
end;

procedure THIXMLNativeAOTEditor._var_CurrentNodePath(var _Data: TData; Index: Word);
begin
  dtString(_Data, FCurrentNodePath);
end;

procedure THIXMLNativeAOTEditor._var_ResolvedNodePath(var _Data: TData; Index: Word);
begin
  dtString(_Data, FResolvedNodePath);
end;

procedure THIXMLNativeAOTEditor._var_SelectedCount(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, FSelectedCount);
end;

procedure THIXMLNativeAOTEditor._var_CurrentIndex(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, FCurrentIndex);
end;

procedure THIXMLNativeAOTEditor._var_AttributeCount(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, FAttributeCount);
end;

procedure THIXMLNativeAOTEditor._var_AttributeIndex(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, FAttributeIndex);
end;

procedure THIXMLNativeAOTEditor._var_PathExists(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, FPathExists);
end;

procedure THIXMLNativeAOTEditor._var_SessionIDOut(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, FSessionID);
end;

procedure THIXMLNativeAOTEditor._work_doLoadXmlString(var _Data: TData; Index: Word);
var
  S, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  S := ReadString(_Data, _data_XmlStringIn, '');
  A := StrToUtf8Z(S);
  R := TakeUtf8Result(NativeLoadXmlString(FSessionID, PAnsiChar(A), Integer(Ord(_prop_PreserveWhitespace)), ReadDtdProcessing(_Data), ReadMaxCharacters(_Data)));
  if IsOk(R) then
  begin
    FLoadedXml := S;
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    UpdateCurrentNodePath;
    _hi_OnEvent(_event_OnXmlLoaded);
    AutoUpdateNodeInfo;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doLoadXmlFile(var _Data: TData; Index: Word);
var
  Path, R, Snapshot: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Path := ReadString(_Data, _data_FilePathIn, '');
  A := StrToUtf8Z(Path);
  R := TakeUtf8Result(NativeLoadXmlFile(FSessionID, PAnsiChar(A), Integer(Ord(_prop_PreserveWhitespace)), ReadDtdProcessing(_Data), ReadMaxCharacters(_Data)));
  if IsOk(R) then
  begin
    Snapshot := TakeUtf8Result(NativeSaveXmlToString(FSessionID, ReadFormatting(_Data)));
    if IsOk(Snapshot) then
      FLoadedXml := Snapshot
    else
      FLoadedXml := '';
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    UpdateCurrentNodePath;
    _hi_OnEvent(_event_OnXmlLoaded);
    AutoUpdateNodeInfo;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doCreateNewXml(var _Data: TData; Index: Word);
var
  Root, R, Snapshot: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Root := ReadString(_Data, _data_RootNameIn, 'root');
  A := StrToUtf8Z(Root);
  R := TakeUtf8Result(NativeCreateNewXml(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    Snapshot := TakeUtf8Result(NativeSaveXmlToString(FSessionID, ReadFormatting(_Data)));
    if IsOk(Snapshot) then
      FLoadedXml := Snapshot
    else
      FLoadedXml := '';
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    UpdateCurrentNodePath;
    _hi_OnEvent(_event_OnXmlLoaded);
    AutoUpdateNodeInfo;
    FireChanged;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSelectNodes(var _Data: TData; Index: Word);
var
  Xp, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Xp := ReadString(_Data, _data_XPathIn, '');
  A := StrToUtf8Z(Xp);
  R := TakeUtf8Result(NativeSelectNodes(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    FQueryResult := R;
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    if FSelectedCount > 0 then
      FCurrentIndex := 0
    else
      FCurrentIndex := -1;
    if FSelectedCount > 0 then
      UpdateCurrentNodePath;
    _hi_OnEvent(_event_OnQueryExecuted, FQueryResult);
    if FSelectedCount > 0 then
      AutoUpdateNodeInfo;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSelectSingleNode(var _Data: TData; Index: Word);
var
  Xp, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Xp := ReadString(_Data, _data_XPathIn, '');
  A := StrToUtf8Z(Xp);
  R := TakeUtf8Result(NativeSelectSingleNode(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    FQueryResult := R;
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    if FSelectedCount > 0 then
      FCurrentIndex := 0
    else
      FCurrentIndex := -1;
    if FSelectedCount > 0 then
      UpdateCurrentNodePath;
    _hi_OnEvent(_event_OnQueryExecuted, FQueryResult);
    _hi_OnEvent(_event_OnCurrentNodeChanged, FCurrentNodePath);
    if FSelectedCount > 0 then
      AutoUpdateNodeInfo;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSetCurrentNode(var _Data: TData; Index: Word);
var
  Xp, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Xp := ReadString(_Data, _data_XPathIn, '');
  A := StrToUtf8Z(Xp);
  R := TakeUtf8Result(NativeSetCurrentNode(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    FQueryResult := R;
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    if FSelectedCount > 0 then
      FCurrentIndex := 0
    else
      FCurrentIndex := -1;
    if FSelectedCount > 0 then
    UpdateCurrentNodePath;
    _hi_OnEvent(_event_OnCurrentNodeChanged, FCurrentNodePath);
    if FSelectedCount > 0 then
      AutoUpdateNodeInfo;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSelectByIndex(var _Data: TData; Index: Word);
var
  Idx: Integer;
  R: string;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Idx := ReadInteger(_Data, _data_IndexIn, 0);
  R := TakeUtf8Result(NativeSelectByIndex(FSessionID, Idx));
  if IsOk(R) then
  begin
    FCurrentIndex := Idx;
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    UpdateCurrentNodePath;
    _hi_OnEvent(_event_OnCurrentNodeChanged, FCurrentNodePath);
    AutoUpdateNodeInfo;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSelectNodePath(var _Data: TData; Index: Word);
var
  Path, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  if not Assigned(NativeSelectNodePath) then
  begin
    SetErrorAndFire('ERROR: BRIDGE_EXPORT: ' + BridgePath + ' does not export XMLNativeAOT_SelectNodePath');
    Exit;
  end;

  Path := ReadString(_Data, _data_NodePathIn, '');
  A := StrToUtf8Z(Path);
  R := TakeUtf8Result(NativeSelectNodePath(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    FQueryResult := R;
    if R <> '0' then
      FPathExists := 1
    else
      FPathExists := 0;
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    if FPathExists <> 0 then
    begin
      FCurrentIndex := 0;
      UpdateCurrentNodePath;
      FResolvedNodePath := FCurrentNodePath;
    end
    else
      FCurrentIndex := -1;
    _hi_OnEvent(_event_OnPathResolved, FResolvedNodePath);
    _hi_OnEvent(_event_OnQueryExecuted, FQueryResult);
    _hi_OnEvent(_event_OnCurrentNodeChanged, FCurrentNodePath);
    if FPathExists <> 0 then
      AutoUpdateNodeInfo;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doPathExists(var _Data: TData; Index: Word);
var
  Path, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  if not Assigned(NativeResolveNodePath) then
  begin
    SetErrorAndFire('ERROR: BRIDGE_EXPORT: ' + BridgePath + ' does not export XMLNativeAOT_ResolveNodePath');
    Exit;
  end;

  Path := ReadString(_Data, _data_NodePathIn, '');
  A := StrToUtf8Z(Path);
  R := TakeUtf8Result(NativeResolveNodePath(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    FResolvedNodePath := R;
    if R <> '' then
      FPathExists := 1
    else
      FPathExists := 0;
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    if FSelectedCount > 0 then
      FCurrentIndex := 0
    else
      FCurrentIndex := -1;
    UpdateCurrentNodePath;
    _hi_OnEvent(_event_OnPathResolved, FResolvedNodePath);
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doEnsureNodePath(var _Data: TData; Index: Word);
var
  Path, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  if not Assigned(NativeEnsureNodePath) then
  begin
    SetErrorAndFire('ERROR: BRIDGE_EXPORT: ' + BridgePath + ' does not export XMLNativeAOT_EnsureNodePath');
    Exit;
  end;

  Path := ReadString(_Data, _data_NodePathIn, '');
  A := StrToUtf8Z(Path);
  R := TakeUtf8Result(NativeEnsureNodePath(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    FQueryResult := R;
    FPathExists := 1;
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    FCurrentIndex := 0;
    UpdateCurrentNodePath;
    FResolvedNodePath := FCurrentNodePath;
    _hi_OnEvent(_event_OnPathResolved, FResolvedNodePath);
    _hi_OnEvent(_event_OnCurrentNodeChanged, FCurrentNodePath);
    AutoUpdateNodeInfo;
    if R <> '0' then
    begin
      _hi_OnEvent(_event_OnNodeAdded);
      FireChanged;
    end;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doEnumSelectedNodes(var _Data: TData; Index: Word);
var
  I, Count: Integer;
  R, Xml: string;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Count := NativeGetSelectedCount(FSessionID);
  if Count < 0 then
  begin
    SetErrorAndFire('ERROR: STATE: Cannot read selected node count');
    Exit;
  end;

  FSelectedCount := Count;
  for I := 0 to Count - 1 do
  begin
    R := TakeUtf8Result(NativeSelectByIndex(FSessionID, I));
    if not IsOk(R) then
    begin
      SetErrorAndFire(R);
      Exit;
    end;

    FCurrentIndex := I;
    UpdateCurrentNodePath;
    Xml := TakeUtf8Result(NativeGetNodeXml(FSessionID, ReadFormatting(_Data)));
    if IsOk(Xml) then
      FNodeXml := Xml
    else
      FNodeXml := '';
    AutoUpdateNodeInfo;
    _hi_OnEvent(_event_OnNode, FNodeXml);
  end;
  Done(True);
end;

procedure THIXMLNativeAOTEditor._work_doGetValue(var _Data: TData; Index: Word);
var
  R: string;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  R := TakeUtf8Result(NativeGetValue(FSessionID));
  if IsOk(R) then
  begin
    FNodeValue := R;
    _hi_OnEvent(_event_OnValueRetrieved, FNodeValue);
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSetValue(var _Data: TData; Index: Word);
var
  V, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  V := ReadString(_Data, _data_NewValueIn, '');
  A := StrToUtf8Z(V);
  R := TakeUtf8Result(NativeSetValue(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    FNodeValue := V;
    _hi_OnEvent(_event_OnValueSet);
    AutoUpdateNodeInfo;
    FireChanged;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doGetPathValue(var _Data: TData; Index: Word);
var
  Path, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  if not Assigned(NativeGetPathValue) then
  begin
    SetErrorAndFire('ERROR: BRIDGE_EXPORT: ' + BridgePath + ' does not export XMLNativeAOT_GetPathValue');
    Exit;
  end;

  Path := ReadString(_Data, _data_NodePathIn, '');
  A := StrToUtf8Z(Path);
  R := TakeUtf8Result(NativeGetPathValue(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    FNodeValue := R;
    FPathExists := 1;
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    FCurrentIndex := 0;
    UpdateCurrentNodePath;
    FResolvedNodePath := FCurrentNodePath;
    _hi_OnEvent(_event_OnPathResolved, FResolvedNodePath);
    _hi_OnEvent(_event_OnCurrentNodeChanged, FCurrentNodePath);
    _hi_OnEvent(_event_OnValueRetrieved, FNodeValue);
    AutoUpdateNodeInfo;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSetPathValue(var _Data: TData; Index: Word);
var
  Path, V, R: string;
  AP, AV: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  if not Assigned(NativeSetPathValue) then
  begin
    SetErrorAndFire('ERROR: BRIDGE_EXPORT: ' + BridgePath + ' does not export XMLNativeAOT_SetPathValue');
    Exit;
  end;

  Path := ReadString(_Data, _data_NodePathIn, '');
  V := ReadString(_Data, _data_NewValueIn, '');
  AP := StrToUtf8Z(Path);
  AV := StrToUtf8Z(V);
  R := TakeUtf8Result(NativeSetPathValue(FSessionID, PAnsiChar(AP), PAnsiChar(AV)));
  if IsOk(R) then
  begin
    FNodeValue := V;
    FPathExists := 1;
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    FCurrentIndex := 0;
    UpdateCurrentNodePath;
    FResolvedNodePath := FCurrentNodePath;
    _hi_OnEvent(_event_OnPathResolved, FResolvedNodePath);
    _hi_OnEvent(_event_OnCurrentNodeChanged, FCurrentNodePath);
    _hi_OnEvent(_event_OnValueSet);
    AutoUpdateNodeInfo;
    FireChanged;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doGetAttributeValue(var _Data: TData; Index: Word);
var
  Nm, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Nm := ReadString(_Data, _data_AttributeNameIn, '');
  A := StrToUtf8Z(Nm);
  R := TakeUtf8Result(NativeGetAttributeValue(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    FAttributeName := Nm;
    FAttributeValue := R;
    _hi_OnEvent(_event_OnAttributeRetrieved, FAttributeValue);
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSetAttributeValue(var _Data: TData; Index: Word);
var
  Nm, V, R: string;
  AN, AV: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Nm := ReadString(_Data, _data_AttributeNameIn, '');
  V := ReadString(_Data, _data_AttributeValueIn, '');
  AN := StrToUtf8Z(Nm);
  AV := StrToUtf8Z(V);
  R := TakeUtf8Result(NativeSetAttributeValue(FSessionID, PAnsiChar(AN), PAnsiChar(AV)));
  if IsOk(R) then
  begin
    FAttributeName := Nm;
    FAttributeValue := V;
    _hi_OnEvent(_event_OnAttributeSet);
    AutoUpdateNodeInfo;
    FireChanged;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doGetAttributeList(var _Data: TData; Index: Word);
var
  R: string;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  R := TakeUtf8Result(NativeGetAttributeListJson(FSessionID));
  if IsOk(R) then
  begin
    FAttributeListJson := R;
    FAttributeCount := NativeGetAttributeCount(FSessionID);
    _hi_OnEvent(_event_OnAttributeList, FAttributeListJson);
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doEnumAttributes(var _Data: TData; Index: Word);
var
  I, Count: Integer;
  Nm, V: string;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Count := NativeGetAttributeCount(FSessionID);
  if Count < 0 then
  begin
    SetErrorAndFire('ERROR: STATE: Cannot read attribute count');
    Exit;
  end;

  FAttributeCount := Count;
  for I := 0 to Count - 1 do
  begin
    Nm := TakeUtf8Result(NativeGetAttributeNameByIndex(FSessionID, I));
    if not IsOk(Nm) then
    begin
      SetErrorAndFire(Nm);
      Exit;
    end;

    V := TakeUtf8Result(NativeGetAttributeValueByIndex(FSessionID, I));
    if not IsOk(V) then
    begin
      SetErrorAndFire(V);
      Exit;
    end;

    FAttributeIndex := I;
    FAttributeName := Nm;
    FAttributeValue := V;
    _hi_OnEvent(_event_OnAttribute, FAttributeValue);
  end;
  Done(True);
end;

procedure THIXMLNativeAOTEditor._work_doRemoveAttribute(var _Data: TData; Index: Word);
var
  Nm, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Nm := ReadString(_Data, _data_AttributeNameIn, '');
  A := StrToUtf8Z(Nm);
  R := TakeUtf8Result(NativeRemoveAttribute(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    FAttributeName := Nm;
    _hi_OnEvent(_event_OnAttributeRemoved);
    AutoUpdateNodeInfo;
    FireChanged;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doAddChildNode(var _Data: TData; Index: Word);
var
  Nm, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Nm := ReadString(_Data, _data_ChildNameIn, '');
  A := StrToUtf8Z(Nm);
  R := TakeUtf8Result(NativeAddChildNode(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    UpdateCurrentNodePath;
    _hi_OnEvent(_event_OnNodeAdded);
    AutoUpdateNodeInfo;
    FireChanged;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doAddChildXml(var _Data: TData; Index: Word);
var
  Xml, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Xml := ReadString(_Data, _data_ChildXmlIn, '');
  A := StrToUtf8Z(Xml);
  R := TakeUtf8Result(NativeAddChildXml(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    UpdateCurrentNodePath;
    _hi_OnEvent(_event_OnNodeAdded);
    AutoUpdateNodeInfo;
    FireChanged;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doDeleteNode(var _Data: TData; Index: Word);
var
  R: string;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  R := TakeUtf8Result(NativeDeleteNode(FSessionID));
  if IsOk(R) then
  begin
    UpdateCurrentNodePath;
    _hi_OnEvent(_event_OnNodeDeleted);
    FireChanged;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doGetNodeXml(var _Data: TData; Index: Word);
var
  R: string;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  R := TakeUtf8Result(NativeGetNodeXml(FSessionID, ReadFormatting(_Data)));
  if IsOk(R) then
  begin
    FNodeXml := R;
    _hi_OnEvent(_event_OnNodeXmlRetrieved, FNodeXml);
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSetNodeXml(var _Data: TData; Index: Word);
var
  Xml, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Xml := ReadString(_Data, _data_NodeXmlIn, '');
  A := StrToUtf8Z(Xml);
  R := TakeUtf8Result(NativeSetNodeXml(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    FNodeXml := Xml;
    UpdateCurrentNodePath;
    _hi_OnEvent(_event_OnNodeXmlSet);
    AutoUpdateNodeInfo;
    FireChanged;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doGetPathXml(var _Data: TData; Index: Word);
var
  Path, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  if not Assigned(NativeGetPathXml) then
  begin
    SetErrorAndFire('ERROR: BRIDGE_EXPORT: ' + BridgePath + ' does not export XMLNativeAOT_GetPathXml');
    Exit;
  end;

  Path := ReadString(_Data, _data_NodePathIn, '');
  A := StrToUtf8Z(Path);
  R := TakeUtf8Result(NativeGetPathXml(FSessionID, PAnsiChar(A), ReadFormatting(_Data)));
  if IsOk(R) then
  begin
    FNodeXml := R;
    FPathExists := 1;
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    FCurrentIndex := 0;
    UpdateCurrentNodePath;
    FResolvedNodePath := FCurrentNodePath;
    _hi_OnEvent(_event_OnPathResolved, FResolvedNodePath);
    _hi_OnEvent(_event_OnCurrentNodeChanged, FCurrentNodePath);
    _hi_OnEvent(_event_OnNodeXmlRetrieved, FNodeXml);
    AutoUpdateNodeInfo;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSetPathXml(var _Data: TData; Index: Word);
var
  Path, Xml, R: string;
  AP, AX: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  if not Assigned(NativeSetPathXml) then
  begin
    SetErrorAndFire('ERROR: BRIDGE_EXPORT: ' + BridgePath + ' does not export XMLNativeAOT_SetPathXml');
    Exit;
  end;

  Path := ReadString(_Data, _data_NodePathIn, '');
  Xml := ReadString(_Data, _data_NodeXmlIn, '');
  AP := StrToUtf8Z(Path);
  AX := StrToUtf8Z(Xml);
  R := TakeUtf8Result(NativeSetPathXml(FSessionID, PAnsiChar(AP), PAnsiChar(AX)));
  if IsOk(R) then
  begin
    FNodeXml := Xml;
    FPathExists := 1;
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    FCurrentIndex := 0;
    UpdateCurrentNodePath;
    FResolvedNodePath := FCurrentNodePath;
    _hi_OnEvent(_event_OnPathResolved, FResolvedNodePath);
    _hi_OnEvent(_event_OnCurrentNodeChanged, FCurrentNodePath);
    _hi_OnEvent(_event_OnNodeXmlSet);
    AutoUpdateNodeInfo;
    FireChanged;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doDeletePath(var _Data: TData; Index: Word);
var
  Path, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  if not Assigned(NativeDeletePath) then
  begin
    SetErrorAndFire('ERROR: BRIDGE_EXPORT: ' + BridgePath + ' does not export XMLNativeAOT_DeletePath');
    Exit;
  end;

  Path := ReadString(_Data, _data_NodePathIn, '');
  A := StrToUtf8Z(Path);
  R := TakeUtf8Result(NativeDeletePath(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    FPathExists := 0;
    FSelectedCount := NativeGetSelectedCount(FSessionID);
    if FSelectedCount > 0 then
    begin
      FCurrentIndex := 0;
      UpdateCurrentNodePath;
      FResolvedNodePath := FCurrentNodePath;
    end
    else
      FCurrentIndex := -1;
    _hi_OnEvent(_event_OnPathResolved, FResolvedNodePath);
    _hi_OnEvent(_event_OnCurrentNodeChanged, FCurrentNodePath);
    _hi_OnEvent(_event_OnNodeDeleted);
    FireChanged;
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSaveXmlToString(var _Data: TData; Index: Word);
var
  R: string;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  R := TakeUtf8Result(NativeSaveXmlToString(FSessionID, ReadFormatting(_Data)));
  if IsOk(R) then
  begin
    FSavedXml := R;
    _hi_OnEvent(_event_OnXmlSaved, FSavedXml);
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSaveXmlToFile(var _Data: TData; Index: Word);
var
  Path, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Path := ReadString(_Data, _data_FilePathIn, '');
  A := StrToUtf8Z(Path);
  R := TakeUtf8Result(NativeSaveXmlToFile(FSessionID, PAnsiChar(A), ReadFormatting(_Data)));
  if IsOk(R) then
  begin
    _hi_OnEvent(_event_OnXmlSaved);
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSetNamespacePrefix(var _Data: TData; Index: Word);
var
  Prefix, Uri, R: string;
  AP, AU: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Prefix := ReadString(_Data, _data_NamespacePrefixIn, '');
  Uri := ReadString(_Data, _data_NamespaceUriIn, '');
  AP := StrToUtf8Z(Prefix);
  AU := StrToUtf8Z(Uri);
  R := TakeUtf8Result(NativeSetNamespacePrefix(FSessionID, PAnsiChar(AP), PAnsiChar(AU)));
  if IsOk(R) then
  begin
    _hi_OnEvent(_event_OnNamespacesChanged);
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doSetNamespacesJson(var _Data: TData; Index: Word);
var
  Json, R: string;
  A: AnsiString;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  Json := ReadString(_Data, _data_NamespacesJsonIn, '');
  A := StrToUtf8Z(Json);
  R := TakeUtf8Result(NativeSetNamespacesJson(FSessionID, PAnsiChar(A)));
  if IsOk(R) then
  begin
    _hi_OnEvent(_event_OnNamespacesChanged);
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doClearNamespaces(var _Data: TData; Index: Word);
var
  R: string;
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  R := TakeUtf8Result(NativeClearNamespaces(FSessionID));
  if IsOk(R) then
  begin
    _hi_OnEvent(_event_OnNamespacesChanged);
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doGetBridgeInfo(var _Data: TData; Index: Word);
var
  R: string;
begin
  ClearVars(True);
  if not EnsureBridge then
    Exit;

  if not Assigned(NativeGetBridgeInfo) then
  begin
    SetErrorAndFire('ERROR: BRIDGE_EXPORT: ' + BridgePath + ' does not export XMLNativeAOT_GetBridgeInfo');
    Exit;
  end;

  R := TakeUtf8Result(NativeGetBridgeInfo());
  if IsOk(R) then
  begin
    FBridgeInfo := R;
    _hi_OnEvent(_event_OnBridgeInfo, FBridgeInfo);
    Done(True);
  end
  else
    SetErrorAndFire(R);
end;

procedure THIXMLNativeAOTEditor._work_doGetNodeInfo(var _Data: TData; Index: Word);
begin
  ClearVars(True);
  if not EnsureSession then
    Exit;

  if RefreshNodeInfo(True) then
    Done(True);
end;

procedure THIXMLNativeAOTEditor._work_doClose(var _Data: TData; Index: Word);
begin
  ClearVars(True);
  if FSessionID <> 0 then
  begin
    if EnsureBridge then
    begin
      NativeDestroySession(FSessionID);
      FSessionID := 0;
    end
    else
      Exit;
  end;
  FLoadedXml := '';
  Done(True);
end;

destructor THIXMLNativeAOTEditor.Destroy;
begin
  FSessionID := 0;
  inherited;
end;

end.
