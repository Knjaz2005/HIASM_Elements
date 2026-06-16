unit hiFPCWebBrowser;

interface

{$I share.inc}

uses
  Windows, Messages, Kol, Share, Win, FPCWebView2;

type
  THIFPCWebBrowser = class(THIWin)
  private
    FBrowser: TFPCWebView2Host;
    FStatusLabel: PControl;
    FWebViewActive: Boolean;
    function _OnMessage(var Msg: TMsg; var Rslt: LRESULT): Boolean; override;
    procedure PrepareHostWindow;
    procedure ResizeStatusLabel;
    procedure ShowStatus(const Value: string);
    procedure HideStatus;
    procedure BrowserStatus(Sender: TObject; const Value: string);
    procedure BrowserError(Sender: TObject; const Message: string; ErrorCode: HRESULT);
    procedure BrowserNavigate(Sender: TObject; const Value: string);
    procedure BrowserTitle(Sender: TObject; const Value: string);
    procedure BrowserProgress(Sender: TObject; Value: Integer);
    procedure BrowserLoad(Sender: TObject; Loading: Boolean);
    procedure BrowserPage(Sender: TObject; const Value: string);
    procedure BrowserBeforeNavigate(Sender: TObject; const Value: string; var Cancel: Boolean);
    procedure BrowserNewWindow(Sender: TObject; const Value: string; var Cancel: Boolean);
  public
    _prop_URL: string;
    _prop_LoaderDLL: string;
    _prop_BrowserExecutableFolder: string;
    _prop_UserDataFolder: string;
    _prop_Silent: Boolean;
    _prop_ContextMenu: Boolean;
    _prop_DevTools: Boolean;
    _prop_PopupWindow: Boolean;
    _prop_Zoom: Integer;
    _prop_Theme: Integer;

    _event_onNavigate: THI_Event;
    _event_onTitle: THI_Event;
    _event_onStatus: THI_Event;
    _event_onProgress: THI_Event;
    _event_onLoad: THI_Event;
    _event_onError: THI_Event;
    _event_onPage: THI_Event;
    _event_onNewWindow: THI_Event;

    _data_URL: THI_Event;
    _data_Text: THI_Event;
    _data_FileName: THI_Event;
    _data_Navigate: THI_Event;
    _data_NewWindow: THI_Event;
    _data_Zoom: THI_Event;
    _data_Theme: THI_Event;

    constructor Create(Parent: PControl);
    destructor Destroy; override;
    procedure Init; override;

    procedure _work_doNavigate(var _Data: TData; Index: word);
    procedure _work_doRefresh(var _Data: TData; Index: word);
    procedure _work_doBack(var _Data: TData; Index: word);
    procedure _work_doForward(var _Data: TData; Index: word);
    procedure _work_doFromText(var _Data: TData; Index: word);
    procedure _work_doFromFile(var _Data: TData; Index: word);
    procedure _work_doGetPage(var _Data: TData; Index: word);
    procedure _work_doOpenDevTools(var _Data: TData; Index: word);
    procedure _work_doZoom(var _Data: TData; Index: word);
    procedure _work_doTheme(var _Data: TData; Index: word);
    procedure _work_doStop(var _Data: TData; Index: word);

    procedure _var_CurrentURL(var _Data: TData; Index: word);
    procedure _var_Page(var _Data: TData; Index: word);
    procedure _var_Title(var _Data: TData; Index: word);
    procedure _var_BrowserVersion(var _Data: TData; Index: word);
    procedure _var_LastError(var _Data: TData; Index: word);
  end;

implementation

constructor THIFPCWebBrowser.Create(Parent: PControl);
begin
  inherited Create(Parent);
  _prop_LoaderDLL := '';
  _prop_ContextMenu := True;
  _prop_DevTools := True;
  _prop_PopupWindow := False;
  _prop_Zoom := 100;
  _prop_Theme := 0;
  FWebViewActive := False;
  FBrowser := TFPCWebView2Host.Create;
end;

destructor THIFPCWebBrowser.Destroy;
begin
  if FBrowser <> nil then
  begin
    FBrowser.Shutdown;
    FBrowser.Free;
    FBrowser := nil;
  end;
  inherited Destroy;
end;

procedure THIFPCWebBrowser.Init;
begin
  Control := NewPanel(FParent, esNone);
  inherited;
  if _prop_Visible then
    Control.Visible := True;
  PrepareHostWindow;
  FStatusLabel := NewLabel(Control, 'WebView2: initializing');
  FStatusLabel.AutoSize(False);
  FStatusLabel.TextAlign := taLeft;
  FStatusLabel.VerticalAlign := vaCenter;
  FStatusLabel.Color := Control.Color;
  ResizeStatusLabel;
  FStatusLabel.GetWindowHandle;
  FBrowser.LoaderDll := _prop_LoaderDLL;
  FBrowser.BrowserExecutableFolder := _prop_BrowserExecutableFolder;
  FBrowser.UserDataFolder := _prop_UserDataFolder;
  FBrowser.DefaultUrl := _prop_URL;
  FBrowser.Silent := _prop_Silent;
  FBrowser.ContextMenu := _prop_ContextMenu;
  FBrowser.DevTools := _prop_DevTools;
  FBrowser.PopupWindow := _prop_PopupWindow;
  // 2026-06-18: Initial WebView2 theme is set before Start so controller creation applies it immediately.
  // Expected result: Auto/Light/Dark maps to Profile.PreferredColorScheme; old runtimes report a theme error.
  FBrowser.Theme := _prop_Theme;
  FBrowser.OnError := BrowserError;
  FBrowser.OnNavigate := BrowserNavigate;
  FBrowser.OnTitle := BrowserTitle;
  FBrowser.OnProgress := BrowserProgress;
  FBrowser.OnLoad := BrowserLoad;
  FBrowser.OnPage := BrowserPage;
  FBrowser.OnStatus := BrowserStatus;
  FBrowser.OnBeforeNavigate := BrowserBeforeNavigate;
  FBrowser.OnNewWindow := BrowserNewWindow;
  FBrowser.SetZoom(_prop_Zoom);
  FBrowser.Start(Control.GetWindowHandle);
end;

function THIFPCWebBrowser._OnMessage(var Msg: TMsg; var Rslt: LRESULT): Boolean;
begin
  case Msg.message of
    WM_SIZE, WM_WINDOWPOSCHANGED:
    begin
      ResizeStatusLabel;
      if FBrowser <> nil then
        FBrowser.Resize;
    end;
    WM_SHOWWINDOW:
      if FBrowser <> nil then
        FBrowser.SetVisible(Msg.wParam <> 0);
    WM_SETFOCUS, WM_MOUSEACTIVATE, WM_LBUTTONDOWN, WM_LBUTTONDBLCLK,
    WM_RBUTTONDOWN, WM_MBUTTONDOWN:
      if FBrowser <> nil then
        FBrowser.Focus;
  end;
  Result := inherited _OnMessage(Msg, Rslt);
end;

procedure THIFPCWebBrowser.PrepareHostWindow;
var
  Style, RequiredStyle: Longint;
  H: HWND;
begin
  if Control = nil then Exit;
  RequiredStyle := WS_CLIPCHILDREN or WS_CLIPSIBLINGS or WS_TABSTOP;
  if _prop_Visible then
    RequiredStyle := RequiredStyle or WS_VISIBLE;
  Control.Style := Control.Style or RequiredStyle;
  H := Control.GetWindowHandle;
  if H = 0 then Exit;
  Style := GetWindowLong(H, GWL_STYLE);
  if (Style and RequiredStyle) <> RequiredStyle then
  begin
    SetWindowLong(H, GWL_STYLE, Style or RequiredStyle);
    SetWindowPos(H, 0, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or
      SWP_NOZORDER or SWP_NOACTIVATE or SWP_FRAMECHANGED);
  end;
  if _prop_Visible then
    ShowWindow(H, SW_SHOW);
end;

procedure THIFPCWebBrowser.ResizeStatusLabel;
var
  W, H: Integer;
begin
  if (Control = nil) or (FStatusLabel = nil) then Exit;
  W := Control.Width - 8;
  H := Control.Height - 8;
  if W < 0 then W := 0;
  if H < 0 then H := 0;
  FStatusLabel.SetPosition(4, 4);
  FStatusLabel.SetSize(W, H);
end;

procedure THIFPCWebBrowser.ShowStatus(const Value: string);
begin
  if FStatusLabel = nil then Exit;
  FStatusLabel.Caption := Value;
  ResizeStatusLabel;
  FStatusLabel.Visible := True;
  FStatusLabel.BringToFront;
  if FStatusLabel.Handle <> 0 then
    InvalidateRect(FStatusLabel.Handle, nil, True);
end;

procedure THIFPCWebBrowser.HideStatus;
begin
  if FStatusLabel <> nil then
    FStatusLabel.Visible := False;
end;

procedure THIFPCWebBrowser.BrowserStatus(Sender: TObject; const Value: string);
begin
  if (Pos('controller ready', Value) > 0) or
    (Pos('navigation ', Value) > 0) or
    (Pos('source changed', Value) > 0) or
    (Pos('title changed', Value) > 0) then
  begin
    FWebViewActive := True;
    HideStatus
  end
  else if FWebViewActive then
    HideStatus
  else
    ShowStatus(Value);
  _hi_OnEvent(_event_onStatus, Value);
end;

procedure THIFPCWebBrowser.BrowserError(Sender: TObject; const Message: string; ErrorCode: HRESULT);
begin
  // 2026-06-24: Keep WebView2 errors as HiAsm events only; showing the diagnostic label here
  // hides the browser surface after navigation/runtime errors. Verified path: onError/onStatus still receive Message.
  HideStatus;
  _hi_OnEvent(_event_onError, Message);
  _hi_OnEvent(_event_onStatus, Message);
end;

procedure THIFPCWebBrowser.BrowserNavigate(Sender: TObject; const Value: string);
begin
  FWebViewActive := True;
  HideStatus;
  _hi_OnEvent(_event_onNavigate, Value);
end;

procedure THIFPCWebBrowser.BrowserTitle(Sender: TObject; const Value: string);
begin
  FWebViewActive := True;
  HideStatus;
  _hi_OnEvent(_event_onTitle, Value);
end;

procedure THIFPCWebBrowser.BrowserProgress(Sender: TObject; Value: Integer);
begin
  _hi_OnEvent(_event_onProgress, Value);
end;

procedure THIFPCWebBrowser.BrowserLoad(Sender: TObject; Loading: Boolean);
begin
  FWebViewActive := True;
  HideStatus;
  if Loading then
    _hi_OnEvent(_event_onLoad, 1)
  else
    _hi_OnEvent(_event_onLoad, 0);
end;

procedure THIFPCWebBrowser.BrowserPage(Sender: TObject; const Value: string);
begin
  _hi_OnEvent(_event_onPage, Value);
end;

procedure THIFPCWebBrowser.BrowserBeforeNavigate(Sender: TObject; const Value: string; var Cancel: Boolean);
var
  dt: TData;
begin
  dtString(dt, Value);
  _ReadData(dt, _data_Navigate);
  Cancel := ToInteger(dt) = 1;
end;

procedure THIFPCWebBrowser.BrowserNewWindow(Sender: TObject; const Value: string; var Cancel: Boolean);
var
  dt: TData;
begin
  _hi_OnEvent(_event_onNewWindow, Value);
  dtString(dt, Value);
  _ReadData(dt, _data_NewWindow);
  Cancel := ToInteger(dt) = 1;
end;

procedure THIFPCWebBrowser._work_doNavigate(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    FBrowser.Navigate(ReadString(_Data, _data_URL, _prop_URL));
end;

procedure THIFPCWebBrowser._work_doRefresh(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    FBrowser.Reload;
end;

procedure THIFPCWebBrowser._work_doBack(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    FBrowser.GoBack;
end;

procedure THIFPCWebBrowser._work_doForward(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    FBrowser.GoForward;
end;

procedure THIFPCWebBrowser._work_doFromText(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    FBrowser.NavigateToString(ReadString(_Data, _data_Text, ''));
end;

procedure THIFPCWebBrowser._work_doFromFile(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    FBrowser.NavigateFile(ReadString(_Data, _data_FileName, ''));
end;

procedure THIFPCWebBrowser._work_doGetPage(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    FBrowser.RequestPage(True);
end;

procedure THIFPCWebBrowser._work_doOpenDevTools(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    FBrowser.OpenDevTools;
end;

procedure THIFPCWebBrowser._work_doZoom(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    FBrowser.SetZoom(ReadInteger(_Data, _data_Zoom, _prop_Zoom));
end;

procedure THIFPCWebBrowser._work_doTheme(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    FBrowser.SetTheme(ReadInteger(_Data, _data_Theme, _prop_Theme));
end;

procedure THIFPCWebBrowser._work_doStop(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    FBrowser.Stop;
end;

procedure THIFPCWebBrowser._var_CurrentURL(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    dtString(_Data, FBrowser.CurrentUrl)
  else
    dtString(_Data, '');
end;

procedure THIFPCWebBrowser._var_Page(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    dtString(_Data, FBrowser.PageSource)
  else
    dtString(_Data, '');
end;

procedure THIFPCWebBrowser._var_Title(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    dtString(_Data, FBrowser.Title)
  else
    dtString(_Data, '');
end;

procedure THIFPCWebBrowser._var_BrowserVersion(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    dtString(_Data, FBrowser.BrowserVersion)
  else
    dtString(_Data, '');
end;

procedure THIFPCWebBrowser._var_LastError(var _Data: TData; Index: word);
begin
  if FBrowser <> nil then
    dtString(_Data, FBrowser.LastError)
  else
    dtString(_Data, '');
end;

end.
