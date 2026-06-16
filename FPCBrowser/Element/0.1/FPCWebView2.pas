unit FPCWebView2;

interface

{$IFDEF FPC}
  {$IFDEF UNICODE}
    {$MODE DELPHIUNICODE}
  {$ELSE}
    {$MODE DELPHI}
  {$ENDIF}
  {$H+}
{$ENDIF}

uses
  Windows, ActiveX;

type
  UINT32 = LongWord;
  {$IFDEF FPC}
  UINT64 = QWord;
  {$ELSE}
  UINT64 = Int64;
  {$ENDIF}

  TEventRegistrationToken = record
    value: Int64;
  end;

  ICoreWebView2 = interface;
  ICoreWebView2_13 = interface;
  ICoreWebView2Controller = interface;
  ICoreWebView2Environment = interface;
  ICoreWebView2Profile = interface;
  ICoreWebView2Settings = interface;
  ICoreWebView2NavigationStartingEventArgs = interface;
  ICoreWebView2NavigationCompletedEventArgs = interface;
  ICoreWebView2NewWindowRequestedEventArgs = interface;
  ICoreWebView2ProcessFailedEventArgs = interface;

  IFPCWebView2Detachable = interface(IUnknown)
    ['{1D5D711F-B28B-47E6-8F0C-69E4F37E20D8}']
    procedure Detach; stdcall;
  end;

  ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler = interface(IUnknown)
    ['{4E8A3389-C9D8-4BD2-B6B5-124FEE6CC14D}']
    function Invoke(errorCode: HRESULT; environment: ICoreWebView2Environment): HRESULT; stdcall;
  end;

  ICoreWebView2CreateCoreWebView2ControllerCompletedHandler = interface(IUnknown)
    ['{6C4819F3-C9B7-4260-8127-C9F5BDE7F68C}']
    function Invoke(errorCode: HRESULT; controller: ICoreWebView2Controller): HRESULT; stdcall;
  end;

  ICoreWebView2NavigationStartingEventHandler = interface(IUnknown)
    ['{9ADBE429-F36D-432B-9DDC-F8881FBD76E3}']
    function Invoke(sender: ICoreWebView2; args: ICoreWebView2NavigationStartingEventArgs): HRESULT; stdcall;
  end;

  ICoreWebView2NavigationCompletedEventHandler = interface(IUnknown)
    ['{D33A35BF-1C49-4F98-93AB-006E0533FE1C}']
    function Invoke(sender: ICoreWebView2; args: ICoreWebView2NavigationCompletedEventArgs): HRESULT; stdcall;
  end;

  ICoreWebView2SourceChangedEventHandler = interface(IUnknown)
    ['{3C067F9F-5388-4772-8B48-79F7EF1AB37C}']
    function Invoke(sender: ICoreWebView2; args: IUnknown): HRESULT; stdcall;
  end;

  ICoreWebView2DocumentTitleChangedEventHandler = interface(IUnknown)
    ['{F5F2B923-953E-4042-9F95-F3A118E1AFD4}']
    function Invoke(sender: ICoreWebView2; args: IUnknown): HRESULT; stdcall;
  end;

  ICoreWebView2NewWindowRequestedEventHandler = interface(IUnknown)
    ['{D4C185FE-C81C-4989-97AF-2D3FA7AB5651}']
    function Invoke(sender: ICoreWebView2; args: ICoreWebView2NewWindowRequestedEventArgs): HRESULT; stdcall;
  end;

  ICoreWebView2ExecuteScriptCompletedHandler = interface(IUnknown)
    ['{49511172-CC67-4BCA-9923-137112F4C4CC}']
    function Invoke(errorCode: HRESULT; scriptResult: PWideChar): HRESULT; stdcall;
  end;

  ICoreWebView2ProcessFailedEventHandler = interface(IUnknown)
    ['{79E0AEA4-990B-42D9-AA1D-0FCC2E5BC7F1}']
    function Invoke(sender: ICoreWebView2; args: ICoreWebView2ProcessFailedEventArgs): HRESULT; stdcall;
  end;

  ICoreWebView2Settings = interface(IUnknown)
    ['{E562E4F0-D7FA-43AC-8D71-C05150499F00}']
    function get_IsScriptEnabled(out isScriptEnabled: BOOL): HRESULT; stdcall;
    function put_IsScriptEnabled(isScriptEnabled: BOOL): HRESULT; stdcall;
    function get_IsWebMessageEnabled(out isWebMessageEnabled: BOOL): HRESULT; stdcall;
    function put_IsWebMessageEnabled(isWebMessageEnabled: BOOL): HRESULT; stdcall;
    function get_AreDefaultScriptDialogsEnabled(out areDefaultScriptDialogsEnabled: BOOL): HRESULT; stdcall;
    function put_AreDefaultScriptDialogsEnabled(areDefaultScriptDialogsEnabled: BOOL): HRESULT; stdcall;
    function get_IsStatusBarEnabled(out isStatusBarEnabled: BOOL): HRESULT; stdcall;
    function put_IsStatusBarEnabled(isStatusBarEnabled: BOOL): HRESULT; stdcall;
    function get_AreDevToolsEnabled(out areDevToolsEnabled: BOOL): HRESULT; stdcall;
    function put_AreDevToolsEnabled(areDevToolsEnabled: BOOL): HRESULT; stdcall;
    function get_AreDefaultContextMenusEnabled(out enabled: BOOL): HRESULT; stdcall;
    function put_AreDefaultContextMenusEnabled(enabled: BOOL): HRESULT; stdcall;
    function get_AreHostObjectsAllowed(out allowed: BOOL): HRESULT; stdcall;
    function put_AreHostObjectsAllowed(allowed: BOOL): HRESULT; stdcall;
    function get_IsZoomControlEnabled(out enabled: BOOL): HRESULT; stdcall;
    function put_IsZoomControlEnabled(enabled: BOOL): HRESULT; stdcall;
    function get_IsBuiltInErrorPageEnabled(out enabled: BOOL): HRESULT; stdcall;
    function put_IsBuiltInErrorPageEnabled(enabled: BOOL): HRESULT; stdcall;
  end;

  ICoreWebView2NavigationStartingEventArgs = interface(IUnknown)
    ['{5B495469-E119-438A-9B18-7604F25F2E49}']
    function get_Uri(out uri: PWideChar): HRESULT; stdcall;
    function get_IsUserInitiated(out isUserInitiated: BOOL): HRESULT; stdcall;
    function get_IsRedirected(out isRedirected: BOOL): HRESULT; stdcall;
    function get_RequestHeaders(out requestHeaders: IUnknown): HRESULT; stdcall;
    function get_Cancel(out cancel: BOOL): HRESULT; stdcall;
    function put_Cancel(cancel: BOOL): HRESULT; stdcall;
    function get_NavigationId(out navigationId: UINT64): HRESULT; stdcall;
  end;

  ICoreWebView2NavigationCompletedEventArgs = interface(IUnknown)
    ['{30D68B7D-20D9-4752-A9CA-EC8448FBB5C1}']
    function get_IsSuccess(out isSuccess: BOOL): HRESULT; stdcall;
    function get_WebErrorStatus(out webErrorStatus: Integer): HRESULT; stdcall;
    function get_NavigationId(out navigationId: UINT64): HRESULT; stdcall;
  end;

  ICoreWebView2NewWindowRequestedEventArgs = interface(IUnknown)
    ['{34ACB11C-FC37-4418-9132-F9C21D1EAFB9}']
    function get_Uri(out uri: PWideChar): HRESULT; stdcall;
    function put_NewWindow(newWindow: ICoreWebView2): HRESULT; stdcall;
    function get_NewWindow(out newWindow: ICoreWebView2): HRESULT; stdcall;
    function put_Handled(handled: BOOL): HRESULT; stdcall;
    function get_Handled(out handled: BOOL): HRESULT; stdcall;
    function get_IsUserInitiated(out isUserInitiated: BOOL): HRESULT; stdcall;
    function GetDeferral(out deferral: IUnknown): HRESULT; stdcall;
    function get_WindowFeatures(out value: IUnknown): HRESULT; stdcall;
  end;

  ICoreWebView2ProcessFailedEventArgs = interface(IUnknown)
    ['{8155A9A4-1474-4A86-8CAE-151B0FA6B8CA}']
    function get_ProcessFailedKind(out value: Integer): HRESULT; stdcall;
  end;

  ICoreWebView2ProcessFailedEventArgs2 = interface(ICoreWebView2ProcessFailedEventArgs)
    ['{4DAB9422-46FA-4C3E-A5D2-41D2071D3680}']
    function get_Reason(out reason: Integer): HRESULT; stdcall;
    function get_ExitCode(out exitCode: Integer): HRESULT; stdcall;
    function get_ProcessDescription(out processDescription: PWideChar): HRESULT; stdcall;
    function get_FrameInfosForFailedProcess(out frames: IUnknown): HRESULT; stdcall;
  end;

  ICoreWebView2Environment = interface(IUnknown)
    ['{B96D755E-0319-4E92-A296-23436F46A1FC}']
    function CreateCoreWebView2Controller(parentWindow: HWND;
      handler: ICoreWebView2CreateCoreWebView2ControllerCompletedHandler): HRESULT; stdcall;
    function CreateWebResourceResponse(content: IStream; statusCode: Integer;
      reasonPhrase: PWideChar; headers: PWideChar; out response: IUnknown): HRESULT; stdcall;
    function get_BrowserVersionString(out versionInfo: PWideChar): HRESULT; stdcall;
    function add_NewBrowserVersionAvailable(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_NewBrowserVersionAvailable(token: TEventRegistrationToken): HRESULT; stdcall;
  end;

  ICoreWebView2Controller = interface(IUnknown)
    ['{4D00C0D1-9434-4EB6-8078-8697A560334F}']
    function get_IsVisible(out isVisible: BOOL): HRESULT; stdcall;
    function put_IsVisible(isVisible: BOOL): HRESULT; stdcall;
    function get_Bounds(out bounds: TRect): HRESULT; stdcall;
    {$IFDEF WIN64}
    function put_Bounds(bounds: TRect): HRESULT; stdcall;
    {$ELSE}
    function put_Bounds(left, top, right, bottom: Integer): HRESULT; stdcall;
    {$ENDIF}
    function get_ZoomFactor(out zoomFactor: Double): HRESULT; stdcall;
    function put_ZoomFactor(zoomFactor: Double): HRESULT; stdcall;
    function add_ZoomFactorChanged(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_ZoomFactorChanged(token: TEventRegistrationToken): HRESULT; stdcall;
    {$IFDEF WIN64}
    function SetBoundsAndZoomFactor(bounds: TRect; zoomFactor: Double): HRESULT; stdcall;
    {$ELSE}
    function SetBoundsAndZoomFactor(left, top, right, bottom: Integer;
      zoomFactor: Double): HRESULT; stdcall;
    {$ENDIF}
    function MoveFocus(reason: Integer): HRESULT; stdcall;
    function add_MoveFocusRequested(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_MoveFocusRequested(token: TEventRegistrationToken): HRESULT; stdcall;
    function add_GotFocus(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_GotFocus(token: TEventRegistrationToken): HRESULT; stdcall;
    function add_LostFocus(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_LostFocus(token: TEventRegistrationToken): HRESULT; stdcall;
    function add_AcceleratorKeyPressed(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_AcceleratorKeyPressed(token: TEventRegistrationToken): HRESULT; stdcall;
    function get_ParentWindow(out parentWindow: HWND): HRESULT; stdcall;
    function put_ParentWindow(parentWindow: HWND): HRESULT; stdcall;
    function NotifyParentWindowPositionChanged: HRESULT; stdcall;
    function Close: HRESULT; stdcall;
    function get_CoreWebView2(out coreWebView2: ICoreWebView2): HRESULT; stdcall;
  end;

  ICoreWebView2 = interface(IUnknown)
    ['{76ECEACB-0462-4D94-AC83-423A6793775E}']
    function get_Settings(out settings: ICoreWebView2Settings): HRESULT; stdcall;
    function get_Source(out uri: PWideChar): HRESULT; stdcall;
    function Navigate(uri: PWideChar): HRESULT; stdcall;
    function NavigateToString(htmlContent: PWideChar): HRESULT; stdcall;
    function add_NavigationStarting(eventHandler: ICoreWebView2NavigationStartingEventHandler;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_NavigationStarting(token: TEventRegistrationToken): HRESULT; stdcall;
    function add_ContentLoading(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_ContentLoading(token: TEventRegistrationToken): HRESULT; stdcall;
    function add_SourceChanged(eventHandler: ICoreWebView2SourceChangedEventHandler;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_SourceChanged(token: TEventRegistrationToken): HRESULT; stdcall;
    function add_HistoryChanged(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_HistoryChanged(token: TEventRegistrationToken): HRESULT; stdcall;
    function add_NavigationCompleted(eventHandler: ICoreWebView2NavigationCompletedEventHandler;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_NavigationCompleted(token: TEventRegistrationToken): HRESULT; stdcall;
    function add_FrameNavigationStarting(eventHandler: ICoreWebView2NavigationStartingEventHandler;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_FrameNavigationStarting(token: TEventRegistrationToken): HRESULT; stdcall;
    function add_FrameNavigationCompleted(eventHandler: ICoreWebView2NavigationCompletedEventHandler;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_FrameNavigationCompleted(token: TEventRegistrationToken): HRESULT; stdcall;
    function add_ScriptDialogOpening(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_ScriptDialogOpening(token: TEventRegistrationToken): HRESULT; stdcall;
    function add_PermissionRequested(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_PermissionRequested(token: TEventRegistrationToken): HRESULT; stdcall;
    function add_ProcessFailed(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_ProcessFailed(token: TEventRegistrationToken): HRESULT; stdcall;
    function AddScriptToExecuteOnDocumentCreated(javaScript: PWideChar; handler: IUnknown): HRESULT; stdcall;
    function RemoveScriptToExecuteOnDocumentCreated(id: PWideChar): HRESULT; stdcall;
    function ExecuteScript(javaScript: PWideChar;
      handler: ICoreWebView2ExecuteScriptCompletedHandler): HRESULT; stdcall;
    function CapturePreview(imageFormat: Integer; imageStream: IStream; handler: IUnknown): HRESULT; stdcall;
    function Reload: HRESULT; stdcall;
    function PostWebMessageAsJson(webMessageAsJson: PWideChar): HRESULT; stdcall;
    function PostWebMessageAsString(webMessageAsString: PWideChar): HRESULT; stdcall;
    function add_WebMessageReceived(handler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_WebMessageReceived(token: TEventRegistrationToken): HRESULT; stdcall;
    function CallDevToolsProtocolMethod(methodName: PWideChar; parametersAsJson: PWideChar;
      handler: IUnknown): HRESULT; stdcall;
    function get_BrowserProcessId(out value: UINT32): HRESULT; stdcall;
    function get_CanGoBack(out canGoBack: BOOL): HRESULT; stdcall;
    function get_CanGoForward(out canGoForward: BOOL): HRESULT; stdcall;
    function GoBack: HRESULT; stdcall;
    function GoForward: HRESULT; stdcall;
    function GetDevToolsProtocolEventReceiver(eventName: PWideChar; out receiver: IUnknown): HRESULT; stdcall;
    function Stop: HRESULT; stdcall;
    function add_NewWindowRequested(eventHandler: ICoreWebView2NewWindowRequestedEventHandler;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_NewWindowRequested(token: TEventRegistrationToken): HRESULT; stdcall;
    function add_DocumentTitleChanged(eventHandler: ICoreWebView2DocumentTitleChangedEventHandler;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_DocumentTitleChanged(token: TEventRegistrationToken): HRESULT; stdcall;
    function get_DocumentTitle(out title: PWideChar): HRESULT; stdcall;
    function AddHostObjectToScript(name: PWideChar; object_: Pointer): HRESULT; stdcall;
    function RemoveHostObjectFromScript(name: PWideChar): HRESULT; stdcall;
    function OpenDevToolsWindow: HRESULT; stdcall;
    function add_ContainsFullScreenElementChanged(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_ContainsFullScreenElementChanged(token: TEventRegistrationToken): HRESULT; stdcall;
    function get_ContainsFullScreenElement(out containsFullScreenElement: BOOL): HRESULT; stdcall;
    function add_WebResourceRequested(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_WebResourceRequested(token: TEventRegistrationToken): HRESULT; stdcall;
    function AddWebResourceRequestedFilter(uri: PWideChar; resourceContext: Integer): HRESULT; stdcall;
    function RemoveWebResourceRequestedFilter(uri: PWideChar; resourceContext: Integer): HRESULT; stdcall;
    function add_WindowCloseRequested(eventHandler: IUnknown;
      out token: TEventRegistrationToken): HRESULT; stdcall;
    function remove_WindowCloseRequested(token: TEventRegistrationToken): HRESULT; stdcall;
  end;

  // 2026-06-18: WebView2 theme control uses ICoreWebView2_13.Profile.
  // Reserved methods preserve the exact vtable order between ICoreWebView2 and get_Profile.
  ICoreWebView2_13 = interface(ICoreWebView2)
    ['{F75F09A8-667E-4983-88D6-C8773F315E84}']
    function _ReservedWebView2_13_58: HRESULT; stdcall; // add_WebResourceResponseReceived
    function _ReservedWebView2_13_59: HRESULT; stdcall; // remove_WebResourceResponseReceived
    function _ReservedWebView2_13_60: HRESULT; stdcall; // NavigateWithWebResourceRequest
    function _ReservedWebView2_13_61: HRESULT; stdcall; // add_DOMContentLoaded
    function _ReservedWebView2_13_62: HRESULT; stdcall; // remove_DOMContentLoaded
    function _ReservedWebView2_13_63: HRESULT; stdcall; // get_CookieManager
    function _ReservedWebView2_13_64: HRESULT; stdcall; // get_Environment
    function _ReservedWebView2_13_65: HRESULT; stdcall; // TrySuspend
    function _ReservedWebView2_13_66: HRESULT; stdcall; // Resume
    function _ReservedWebView2_13_67: HRESULT; stdcall; // get_IsSuspended
    function _ReservedWebView2_13_68: HRESULT; stdcall; // SetVirtualHostNameToFolderMapping
    function _ReservedWebView2_13_69: HRESULT; stdcall; // ClearVirtualHostNameToFolderMapping
    function _ReservedWebView2_13_70: HRESULT; stdcall; // add_FrameCreated
    function _ReservedWebView2_13_71: HRESULT; stdcall; // remove_FrameCreated
    function _ReservedWebView2_13_72: HRESULT; stdcall; // add_DownloadStarting
    function _ReservedWebView2_13_73: HRESULT; stdcall; // remove_DownloadStarting
    function _ReservedWebView2_13_74: HRESULT; stdcall; // add_ClientCertificateRequested
    function _ReservedWebView2_13_75: HRESULT; stdcall; // remove_ClientCertificateRequested
    function _ReservedWebView2_13_76: HRESULT; stdcall; // OpenTaskManagerWindow
    function _ReservedWebView2_13_77: HRESULT; stdcall; // PrintToPdf
    function _ReservedWebView2_13_78: HRESULT; stdcall; // add_IsMutedChanged
    function _ReservedWebView2_13_79: HRESULT; stdcall; // remove_IsMutedChanged
    function _ReservedWebView2_13_80: HRESULT; stdcall; // get_IsMuted
    function _ReservedWebView2_13_81: HRESULT; stdcall; // put_IsMuted
    function _ReservedWebView2_13_82: HRESULT; stdcall; // add_IsDocumentPlayingAudioChanged
    function _ReservedWebView2_13_83: HRESULT; stdcall; // remove_IsDocumentPlayingAudioChanged
    function _ReservedWebView2_13_84: HRESULT; stdcall; // get_IsDocumentPlayingAudio
    function _ReservedWebView2_13_85: HRESULT; stdcall; // add_IsDefaultDownloadDialogOpenChanged
    function _ReservedWebView2_13_86: HRESULT; stdcall; // remove_IsDefaultDownloadDialogOpenChanged
    function _ReservedWebView2_13_87: HRESULT; stdcall; // get_IsDefaultDownloadDialogOpen
    function _ReservedWebView2_13_88: HRESULT; stdcall; // OpenDefaultDownloadDialog
    function _ReservedWebView2_13_89: HRESULT; stdcall; // CloseDefaultDownloadDialog
    function _ReservedWebView2_13_90: HRESULT; stdcall; // get_DefaultDownloadDialogCornerAlignment
    function _ReservedWebView2_13_91: HRESULT; stdcall; // put_DefaultDownloadDialogCornerAlignment
    function _ReservedWebView2_13_92: HRESULT; stdcall; // get_DefaultDownloadDialogMargin
    function _ReservedWebView2_13_93: HRESULT; stdcall; // put_DefaultDownloadDialogMargin
    function _ReservedWebView2_13_94: HRESULT; stdcall; // add_BasicAuthenticationRequested
    function _ReservedWebView2_13_95: HRESULT; stdcall; // remove_BasicAuthenticationRequested
    function _ReservedWebView2_13_96: HRESULT; stdcall; // CallDevToolsProtocolMethodForSession
    function _ReservedWebView2_13_97: HRESULT; stdcall; // add_ContextMenuRequested
    function _ReservedWebView2_13_98: HRESULT; stdcall; // remove_ContextMenuRequested
    function _ReservedWebView2_13_99: HRESULT; stdcall; // add_StatusBarTextChanged
    function _ReservedWebView2_13_100: HRESULT; stdcall; // remove_StatusBarTextChanged
    function _ReservedWebView2_13_101: HRESULT; stdcall; // get_StatusBarText
    function get_Profile(out value: ICoreWebView2Profile): HRESULT; stdcall;
  end;

  ICoreWebView2Profile = interface(IUnknown)
    ['{79110AD3-CD5D-4373-8BC3-C60658F17A5F}']
    function get_ProfileName(out value: PWideChar): HRESULT; stdcall;
    function get_IsInPrivateModeEnabled(out value: BOOL): HRESULT; stdcall;
    function get_ProfilePath(out value: PWideChar): HRESULT; stdcall;
    function get_DefaultDownloadFolderPath(out value: PWideChar): HRESULT; stdcall;
    function put_DefaultDownloadFolderPath(value: PWideChar): HRESULT; stdcall;
    function get_PreferredColorScheme(out value: Integer): HRESULT; stdcall;
    function put_PreferredColorScheme(value: Integer): HRESULT; stdcall;
  end;

  TFPCWebView2ErrorEvent = procedure(Sender: TObject; const Message: string; ErrorCode: HRESULT) of object;
  TFPCWebView2StringEvent = procedure(Sender: TObject; const Value: string) of object;
  TFPCWebView2ProgressEvent = procedure(Sender: TObject; Value: Integer) of object;
  TFPCWebView2BoolStringEvent = procedure(Sender: TObject; const Value: string; var Cancel: Boolean) of object;
  TFPCWebView2LoadEvent = procedure(Sender: TObject; Loading: Boolean) of object;

  TFPCWebView2Host = class;

  TFPCWebView2Host = class(TObject)
  private
    FParentWindow: HWND;
    FLoaderDll: string;
    FBrowserExecutableFolder: string;
    FUserDataFolder: string;
    FDefaultUrl: string;
    FContextMenu: Boolean;
    FDevTools: Boolean;
    FSilent: Boolean;
    FPopupWindow: Boolean;
    FZoom: Integer;
    FTheme: Integer;
    FCurrentUrl: string;
    FTitle: string;
    FPageSource: string;
    FBrowserVersion: string;
    FLastError: string;
    FLoadedLoaderDll: string;
    FLibHandle: HMODULE;
    FComInitialized: Boolean;
    FStarted: Boolean;
    FReady: Boolean;
    FPendingUrl: string;
    FPendingHtml: string;
    FPendingFileName: string;
    FTempHtmlFileName: string;
    FRenderProcessRecoveryAttempted: Boolean;
    FLastBoundsWidth: Integer;
    FLastBoundsHeight: Integer;
    FPageRequestPending: Boolean;
    FEnv: ICoreWebView2Environment;
    FController: ICoreWebView2Controller;
    FWebView: ICoreWebView2;
    FEnvHandler: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler;
    FControllerHandler: ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;
    FNavigationStartingHandler: ICoreWebView2NavigationStartingEventHandler;
    FNavigationCompletedHandler: ICoreWebView2NavigationCompletedEventHandler;
    FSourceChangedHandler: ICoreWebView2SourceChangedEventHandler;
    FTitleChangedHandler: ICoreWebView2DocumentTitleChangedEventHandler;
    FNewWindowHandler: ICoreWebView2NewWindowRequestedEventHandler;
    FProcessFailedHandler: ICoreWebView2ProcessFailedEventHandler;
    FPageScriptHandler: ICoreWebView2ExecuteScriptCompletedHandler;
    FNavigationStartingToken: TEventRegistrationToken;
    FNavigationCompletedToken: TEventRegistrationToken;
    FSourceChangedToken: TEventRegistrationToken;
    FTitleChangedToken: TEventRegistrationToken;
    FNewWindowToken: TEventRegistrationToken;
    FProcessFailedToken: TEventRegistrationToken;
    FOnError: TFPCWebView2ErrorEvent;
    FOnNavigate: TFPCWebView2StringEvent;
    FOnTitle: TFPCWebView2StringEvent;
    FOnProgress: TFPCWebView2ProgressEvent;
    FOnLoad: TFPCWebView2LoadEvent;
    FOnPage: TFPCWebView2StringEvent;
    FOnStatus: TFPCWebView2StringEvent;
    FOnBeforeNavigate: TFPCWebView2BoolStringEvent;
    FOnNewWindow: TFPCWebView2BoolStringEvent;
    procedure ClearHandlers;
    procedure DetachHandlers;
    procedure DoError(const Message: string; ErrorCode: HRESULT);
    procedure DoStatus(const Message: string);
    function EnsureLoader(out CreateEnvironment: Pointer): Boolean;
    function GetWideStringAndFree(P: PWideChar): string;
    function BoolToWinBool(Value: Boolean): BOOL;
    procedure ApplySettings;
    procedure ApplyTheme;
    procedure ApplyBounds;
    procedure FlushPendingNavigation;
    procedure ClearTempHtmlFile(const KeepFileName: string);
    procedure HandleEnvironmentCreated(errorCode: HRESULT; const Env: ICoreWebView2Environment);
    procedure HandleControllerCreated(errorCode: HRESULT; const Controller: ICoreWebView2Controller);
    procedure HandleNavigationStarting(const Args: ICoreWebView2NavigationStartingEventArgs);
    procedure HandleNavigationCompleted(const Args: ICoreWebView2NavigationCompletedEventArgs);
    procedure HandleSourceChanged;
    procedure HandleTitleChanged;
    procedure HandleNewWindowRequested(const Args: ICoreWebView2NewWindowRequestedEventArgs);
    procedure HandleProcessFailed(const Args: ICoreWebView2ProcessFailedEventArgs);
    procedure HandlePageScriptCompleted(errorCode: HRESULT; result: PWideChar; EmitEvent: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start(ParentWindow: HWND);
    procedure Shutdown;
    procedure Resize;
    procedure Navigate(const Url: string);
    procedure NavigateToString(const Html: string);
    procedure NavigateFile(const FileName: string);
    procedure Reload;
    procedure Stop;
    procedure GoBack;
    procedure GoForward;
    procedure RequestPage(EmitEvent: Boolean);
    procedure OpenDevTools;
    procedure SetZoom(Percent: Integer);
    procedure SetTheme(Value: Integer);
    procedure SetVisible(Value: Boolean);
    procedure Focus;
    property LoaderDll: string read FLoaderDll write FLoaderDll;
    property BrowserExecutableFolder: string read FBrowserExecutableFolder write FBrowserExecutableFolder;
    property UserDataFolder: string read FUserDataFolder write FUserDataFolder;
    property DefaultUrl: string read FDefaultUrl write FDefaultUrl;
    property ContextMenu: Boolean read FContextMenu write FContextMenu;
    property DevTools: Boolean read FDevTools write FDevTools;
    property Silent: Boolean read FSilent write FSilent;
    property PopupWindow: Boolean read FPopupWindow write FPopupWindow;
    property Theme: Integer read FTheme write SetTheme;
    property CurrentUrl: string read FCurrentUrl;
    property Title: string read FTitle;
    property PageSource: string read FPageSource;
    property BrowserVersion: string read FBrowserVersion;
    property LastError: string read FLastError;
    property Ready: Boolean read FReady;
    property OnError: TFPCWebView2ErrorEvent read FOnError write FOnError;
    property OnNavigate: TFPCWebView2StringEvent read FOnNavigate write FOnNavigate;
    property OnTitle: TFPCWebView2StringEvent read FOnTitle write FOnTitle;
    property OnProgress: TFPCWebView2ProgressEvent read FOnProgress write FOnProgress;
    property OnLoad: TFPCWebView2LoadEvent read FOnLoad write FOnLoad;
    property OnPage: TFPCWebView2StringEvent read FOnPage write FOnPage;
    property OnStatus: TFPCWebView2StringEvent read FOnStatus write FOnStatus;
    property OnBeforeNavigate: TFPCWebView2BoolStringEvent read FOnBeforeNavigate write FOnBeforeNavigate;
    property OnNewWindow: TFPCWebView2BoolStringEvent read FOnNewWindow write FOnNewWindow;
  end;

implementation

const
  S_OK = HRESULT($00000000);
  COINIT_APARTMENTTHREADED = $2;
  WEBVIEW2_NAVIGATE_TO_STRING_LIMIT_BYTES = 2 * 1024 * 1024;
  WEBVIEW2_NAVIGATE_TO_STRING_MARGIN_BYTES = 64 * 1024;
  WEBVIEW2_UTF8_CODEPAGE = 65001;
  IID_IFPCWebView2Detachable: TGUID = '{1D5D711F-B28B-47E6-8F0C-69E4F37E20D8}';
  IID_ICoreWebView2ProcessFailedEventArgs2: TGUID = '{4DAB9422-46FA-4C3E-A5D2-41D2071D3680}';
  IID_ICoreWebView2_13: TGUID = '{F75F09A8-667E-4983-88D6-C8773F315E84}';
  COREWEBVIEW2_PREFERRED_COLOR_SCHEME_AUTO = 0;
  COREWEBVIEW2_PREFERRED_COLOR_SCHEME_LIGHT = 1;
  COREWEBVIEW2_PREFERRED_COLOR_SCHEME_DARK = 2;

type
  TCreateCoreWebView2EnvironmentWithOptions = function(
    browserExecutableFolder: PWideChar;
    userDataFolder: PWideChar;
    environmentOptions: IUnknown;
    environmentCreatedHandler: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler): HRESULT; stdcall;

  TWebView2EnvironmentHandler = class(TInterfacedObject,
    ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler, IFPCWebView2Detachable)
  private
    FOwner: TFPCWebView2Host;
  public
    constructor Create(AOwner: TFPCWebView2Host);
    procedure Detach; stdcall;
    function Invoke(errorCode: HRESULT; environment: ICoreWebView2Environment): HRESULT; stdcall;
  end;

  TWebView2ControllerHandler = class(TInterfacedObject,
    ICoreWebView2CreateCoreWebView2ControllerCompletedHandler, IFPCWebView2Detachable)
  private
    FOwner: TFPCWebView2Host;
  public
    constructor Create(AOwner: TFPCWebView2Host);
    procedure Detach; stdcall;
    function Invoke(errorCode: HRESULT; controller: ICoreWebView2Controller): HRESULT; stdcall;
  end;

  TNavigationStartingHandler = class(TInterfacedObject,
    ICoreWebView2NavigationStartingEventHandler, IFPCWebView2Detachable)
  private
    FOwner: TFPCWebView2Host;
  public
    constructor Create(AOwner: TFPCWebView2Host);
    procedure Detach; stdcall;
    function Invoke(sender: ICoreWebView2; args: ICoreWebView2NavigationStartingEventArgs): HRESULT; stdcall;
  end;

  TNavigationCompletedHandler = class(TInterfacedObject,
    ICoreWebView2NavigationCompletedEventHandler, IFPCWebView2Detachable)
  private
    FOwner: TFPCWebView2Host;
  public
    constructor Create(AOwner: TFPCWebView2Host);
    procedure Detach; stdcall;
    function Invoke(sender: ICoreWebView2; args: ICoreWebView2NavigationCompletedEventArgs): HRESULT; stdcall;
  end;

  TSourceChangedHandler = class(TInterfacedObject,
    ICoreWebView2SourceChangedEventHandler, IFPCWebView2Detachable)
  private
    FOwner: TFPCWebView2Host;
  public
    constructor Create(AOwner: TFPCWebView2Host);
    procedure Detach; stdcall;
    function Invoke(sender: ICoreWebView2; args: IUnknown): HRESULT; stdcall;
  end;

  TTitleChangedHandler = class(TInterfacedObject,
    ICoreWebView2DocumentTitleChangedEventHandler, IFPCWebView2Detachable)
  private
    FOwner: TFPCWebView2Host;
  public
    constructor Create(AOwner: TFPCWebView2Host);
    procedure Detach; stdcall;
    function Invoke(sender: ICoreWebView2; args: IUnknown): HRESULT; stdcall;
  end;

  TNewWindowHandler = class(TInterfacedObject,
    ICoreWebView2NewWindowRequestedEventHandler, IFPCWebView2Detachable)
  private
    FOwner: TFPCWebView2Host;
  public
    constructor Create(AOwner: TFPCWebView2Host);
    procedure Detach; stdcall;
    function Invoke(sender: ICoreWebView2; args: ICoreWebView2NewWindowRequestedEventArgs): HRESULT; stdcall;
  end;

  TProcessFailedHandler = class(TInterfacedObject,
    ICoreWebView2ProcessFailedEventHandler, IFPCWebView2Detachable)
  private
    FOwner: TFPCWebView2Host;
  public
    constructor Create(AOwner: TFPCWebView2Host);
    procedure Detach; stdcall;
    function Invoke(sender: ICoreWebView2; args: ICoreWebView2ProcessFailedEventArgs): HRESULT; stdcall;
  end;

  TPageScriptHandler = class(TInterfacedObject,
    ICoreWebView2ExecuteScriptCompletedHandler, IFPCWebView2Detachable)
  private
    FOwner: TFPCWebView2Host;
    FEmitEvent: Boolean;
  public
    constructor Create(AOwner: TFPCWebView2Host; EmitEvent: Boolean);
    procedure Detach; stdcall;
    function Invoke(errorCode: HRESULT; scriptResult: PWideChar): HRESULT; stdcall;
  end;

procedure CoTaskMemFree(pv: Pointer); stdcall; external 'ole32.dll' name 'CoTaskMemFree';

procedure DetachHandler(const Handler: IUnknown);
var
  Detachable: IFPCWebView2Detachable;
begin
  if (Handler <> nil) and (Handler.QueryInterface(IID_IFPCWebView2Detachable, Detachable) = S_OK) then
    Detachable.Detach;
end;

function FailedHR(hr: HRESULT): Boolean;
begin
  Result := hr < 0;
end;

function HResultText(hr: HRESULT): string;
const
  HexDigits: PChar = '0123456789ABCDEF';
var
  Value: DWORD;
  I: Integer;
  S: string;
begin
  Value := DWORD(hr);
  SetLength(S, 8);
  for I := 8 downto 1 do
  begin
    S[I] := HexDigits[(Value and $F) + 1];
    Value := Value shr 4;
  end;
  Result := 'HRESULT $' + S;
end;

function IntToString(Value: Integer): string;
var
  Negative: Boolean;
  Number: DWORD;
  Digit: Integer;
  S: string;
begin
  if Value = 0 then
  begin
    Result := '0';
    Exit;
  end;

  Negative := Value < 0;
  if Negative then
    Number := DWORD(-(Value + 1)) + 1
  else
    Number := DWORD(Value);

  S := '';
  while Number <> 0 do
  begin
    Digit := Number mod 10;
    S := Chr(Ord('0') + Digit) + S;
    Number := Number div 10;
  end;

  if Negative then
    Result := '-' + S
  else
    Result := S;
end;

function HResultFromWin32(ErrorCode: DWORD): HRESULT;
begin
  if ErrorCode <= 0 then
    Result := HRESULT(ErrorCode)
  else
    Result := HRESULT((ErrorCode and $0000FFFF) or ($7 shl 16) or $80000000);
end;

function GetFileAttributesForCompilerString(const FileName: string): DWORD;
{$IFDEF UNICODE}
var
  W: WideString;
{$ENDIF}
begin
  {$IFDEF UNICODE}
  W := WideString(FileName);
  Result := GetFileAttributesW(PWideChar(W));
  {$ELSE}
  Result := GetFileAttributesA(PChar(FileName));
  {$ENDIF}
end;

function DeleteFileForCompilerString(const FileName: string): Boolean;
{$IFDEF UNICODE}
var
  W: WideString;
{$ENDIF}
begin
  {$IFDEF UNICODE}
  W := WideString(FileName);
  Result := DeleteFileW(PWideChar(W));
  {$ELSE}
  Result := DeleteFileA(PChar(FileName));
  {$ENDIF}
end;

function CreateFileForCompilerString(const FileName: string; DesiredAccess, ShareMode: DWORD;
  CreationDisposition, FlagsAndAttributes: DWORD): THandle;
{$IFDEF UNICODE}
var
  W: WideString;
{$ENDIF}
begin
  {$IFDEF UNICODE}
  W := WideString(FileName);
  Result := CreateFileW(PWideChar(W), DesiredAccess, ShareMode, nil,
    CreationDisposition, FlagsAndAttributes, 0);
  {$ELSE}
  Result := CreateFileA(PChar(FileName), DesiredAccess, ShareMode, nil,
    CreationDisposition, FlagsAndAttributes, 0);
  {$ENDIF}
end;

function FileExistsForNavigation(const FileName: string): Boolean;
var
  Attr: DWORD;
begin
  Attr := GetFileAttributesForCompilerString(FileName);
  Result := (Attr <> DWORD($FFFFFFFF)) and ((Attr and FILE_ATTRIBUTE_DIRECTORY) = 0);
end;

function FullPathForCompilerString(const FileName: string): string;
{$IFDEF UNICODE}
var
  W: WideString;
  Buffer: array[0..4095] of WideChar;
  FilePart: PWideChar;
  Len: DWORD;
begin
  W := WideString(FileName);
  FilePart := nil;
  Len := GetFullPathNameW(PWideChar(W), SizeOf(Buffer) div SizeOf(Buffer[0]), @Buffer[0], FilePart);
  if (Len > 0) and (Len < SizeOf(Buffer) div SizeOf(Buffer[0])) then
    Result := string(WideString(PWideChar(@Buffer[0])))
  else
    Result := FileName;
end;
{$ELSE}
var
  Buffer: array[0..4095] of Char;
  FilePart: PChar;
  Len: DWORD;
begin
  FilePart := nil;
  Len := GetFullPathNameA(PChar(FileName), SizeOf(Buffer) div SizeOf(Buffer[0]), @Buffer[0], FilePart);
  if (Len > 0) and (Len < SizeOf(Buffer) div SizeOf(Buffer[0])) then
    Result := string(PChar(@Buffer[0]))
  else
    Result := FileName;
end;
{$ENDIF}

function WideStringToUtf8Bytes(const Value: WideString): AnsiString;
var
  Len: Integer;
begin
  Result := '';
  if Value = '' then Exit;
  Len := WideCharToMultiByte(WEBVIEW2_UTF8_CODEPAGE, 0, PWideChar(Value),
    Length(Value), nil, 0, nil, nil);
  if Len <= 0 then Exit;
  SetLength(Result, Len);
  if WideCharToMultiByte(WEBVIEW2_UTF8_CODEPAGE, 0, PWideChar(Value),
    Length(Value), PAnsiChar(Result), Len, nil, nil) = 0 then
    Result := '';
end;

function UriHexByte(Value: Byte): string;
const
  HexDigits: PChar = '0123456789ABCDEF';
begin
  SetLength(Result, 3);
  Result[1] := '%';
  Result[2] := HexDigits[(Value shr 4) + 1];
  Result[3] := HexDigits[(Value and $F) + 1];
end;

function EscapeFileUriPath(const Value: string): string;
var
  Utf8: AnsiString;
  I: Integer;
  B: Byte;
begin
  Result := '';
  Utf8 := WideStringToUtf8Bytes(WideString(Value));
  for I := 1 to Length(Utf8) do
  begin
    B := Byte(Utf8[I]);
    if ((B >= Ord('A')) and (B <= Ord('Z'))) or
      ((B >= Ord('a')) and (B <= Ord('z'))) or
      ((B >= Ord('0')) and (B <= Ord('9'))) or
      (B = Ord('-')) or (B = Ord('_')) or (B = Ord('.')) or
      (B = Ord('~')) or (B = Ord('/')) or (B = Ord(':')) then
      Result := Result + Chr(B)
    else
      Result := Result + UriHexByte(B);
  end;
end;

function FileNameToFileUri(const FileName: string): string;
var
  FullName, UriPath: string;
  I: Integer;
begin
  FullName := FullPathForCompilerString(FileName);
  for I := 1 to Length(FullName) do
    if FullName[I] = '\' then
      FullName[I] := '/';

  if (Length(FullName) >= 2) and (FullName[1] = '/') and (FullName[2] = '/') then
    UriPath := Copy(FullName, 3, Length(FullName) - 2)
  else
    UriPath := FullName;

  if (Length(FullName) >= 2) and (FullName[1] = '/') and (FullName[2] = '/') then
    Result := 'file://' + EscapeFileUriPath(UriPath)
  else
    Result := 'file:///' + EscapeFileUriPath(UriPath);
end;

function GetTempHtmlFileName(out FileName: string): Boolean;
{$IFDEF UNICODE}
var
  TempPath: array[0..MAX_PATH] of WideChar;
  TempFile: array[0..MAX_PATH] of WideChar;
  Len: DWORD;
  S: string;
begin
  Result := False;
  FileName := '';
  Len := GetTempPathW(SizeOf(TempPath) div SizeOf(TempPath[0]), @TempPath[0]);
  if (Len = 0) or (Len >= SizeOf(TempPath) div SizeOf(TempPath[0])) then Exit;
  if GetTempFileNameW(@TempPath[0], 'wv2', 0, @TempFile[0]) = 0 then Exit;
  S := string(WideString(PWideChar(@TempFile[0])));
  DeleteFileForCompilerString(S);
  if Length(S) > 4 then
    FileName := Copy(S, 1, Length(S) - 4) + '.html'
  else
    FileName := S + '.html';
  Result := True;
end;
{$ELSE}
var
  TempPath: array[0..MAX_PATH] of Char;
  TempFile: array[0..MAX_PATH] of Char;
  Len: DWORD;
  S: string;
begin
  Result := False;
  FileName := '';
  Len := GetTempPathA(SizeOf(TempPath) div SizeOf(TempPath[0]), @TempPath[0]);
  if (Len = 0) or (Len >= SizeOf(TempPath) div SizeOf(TempPath[0])) then Exit;
  if GetTempFileNameA(@TempPath[0], 'wv2', 0, @TempFile[0]) = 0 then Exit;
  S := string(PChar(@TempFile[0]));
  DeleteFileForCompilerString(S);
  if Length(S) > 4 then
    FileName := Copy(S, 1, Length(S) - 4) + '.html'
  else
    FileName := S + '.html';
  Result := True;
end;
{$ENDIF}

function WriteUtf8HtmlFile(const FileName, Html: string): Boolean;
const
  Utf8Bom: array[0..2] of Byte = ($EF, $BB, $BF);
var
  Handle: THandle;
  Bytes: AnsiString;
  Written: DWORD;
begin
  Result := False;
  Handle := CreateFileForCompilerString(FileName, GENERIC_WRITE, 0, CREATE_ALWAYS,
    FILE_ATTRIBUTE_TEMPORARY or FILE_ATTRIBUTE_NOT_CONTENT_INDEXED);
  if Handle = INVALID_HANDLE_VALUE then Exit;
  try
    if (not WriteFile(Handle, Utf8Bom, SizeOf(Utf8Bom), Written, nil)) or
      (Written <> SizeOf(Utf8Bom)) then Exit;
    Bytes := WideStringToUtf8Bytes(WideString(Html));
    if Bytes <> '' then
      if (not WriteFile(Handle, PAnsiChar(Bytes)^, Length(Bytes), Written, nil)) or
        (Written <> DWORD(Length(Bytes))) then Exit;
    Result := True;
  finally
    CloseHandle(Handle);
  end;
end;

function NavigateToStringSizeBytes(const Html: string): Integer;
var
  W: WideString;
begin
  W := WideString(Html);
  Result := (Length(W) + 1) * SizeOf(WideChar);
end;

function LoadLibraryForCompilerString(const FileName: string): HMODULE;
{$IFDEF UNICODE}
var
  W: WideString;
{$ENDIF}
begin
  {$IFDEF UNICODE}
  W := WideString(FileName);
  Result := LoadLibraryW(PWideChar(W));
  {$ELSE}
  Result := LoadLibraryA(PChar(FileName));
  {$ENDIF}
end;

function SameDefaultLoaderName(const FileName: string): Boolean;
begin
  Result := (FileName = '') or
    (FileName = 'WebView2Loader.dll') or
    (FileName = 'webview2loader.dll') or
    (FileName = 'WEBVIEW2LOADER.DLL');
end;

function JoinPath(const Path, Name: string): string;
begin
  if Path = '' then
    Result := Name
  else if (Path[Length(Path)] = '\') or (Path[Length(Path)] = '/') then
    Result := Path + Name
  else
    Result := Path + '\' + Name;
end;

function ProgramDirectory: string;
var
  FileName: string;
  I: Integer;
begin
  Result := '';
  FileName := ParamStr(0);
  for I := Length(FileName) downto 1 do
    if (FileName[I] = '\') or (FileName[I] = '/') then
    begin
      Result := Copy(FileName, 1, I - 1);
      Exit;
    end;
end;

function WebView2LoaderArchText: string;
begin
  {$IFDEF WIN64}
  Result := 'x64';
  {$ELSE}
  Result := 'x86';
  {$ENDIF}
end;

function WebView2LoaderDirectory: string;
begin
  {$IFDEF WIN64}
  Result := 'win-x64';
  {$ELSE}
  Result := 'win-x32';
  {$ENDIF}
end;

function WebView2DefaultLoaderPath: string;
begin
  Result := JoinPath(JoinPath(ProgramDirectory, WebView2LoaderDirectory), 'WebView2Loader.dll');
end;

function TryLoadWebView2Loader(const FileName: string; out LibHandle: HMODULE;
  out LoadedName: string; var LastErrorCode: DWORD): Boolean;
begin
  Result := False;
  LibHandle := LoadLibraryForCompilerString(FileName);
  if LibHandle = 0 then
  begin
    LastErrorCode := GetLastError;
    Exit;
  end;
  LoadedName := FileName;
  Result := True;
end;

function ProcessFailedKindText(Kind: Integer): string;
begin
  case Kind of
    0: Result := 'BrowserProcessExited';
    1: Result := 'RenderProcessExited';
    2: Result := 'RenderProcessUnresponsive';
    3: Result := 'FrameRenderProcessExited';
    4: Result := 'UtilityProcessExited';
    5: Result := 'SandboxHelperProcessExited';
    6: Result := 'GpuProcessExited';
    7: Result := 'PpapiPluginProcessExited';
    8: Result := 'PpapiBrokerProcessExited';
    9: Result := 'UnknownProcessExited';
  else
    Result := 'UnknownKind';
  end;
end;

function ProcessFailedReasonText(Reason: Integer): string;
begin
  case Reason of
    0: Result := 'Unexpected';
    1: Result := 'Unresponsive';
    2: Result := 'Terminated';
    3: Result := 'Crashed';
    4: Result := 'LaunchFailed';
    5: Result := 'OutOfMemory';
    6: Result := 'ProfileDeleted';
    7: Result := 'NormalExit';
    8: Result := 'AbnormalExit';
    9: Result := 'IntegrityFailure';
  else
    Result := 'UnknownReason';
  end;
end;

function WideJsonStringToString(const Json: WideString): string;
var
  I, Code: Integer;
  W: Word;
  Hex: string;
  OutText: WideString;
begin
  OutText := '';
  I := 1;
  if (Length(Json) >= 2) and (Json[1] = '"') and (Json[Length(Json)] = '"') then
  begin
    I := 2;
    while I < Length(Json) do
    begin
      if Json[I] <> '\' then
      begin
        OutText := OutText + Json[I];
        Inc(I);
        Continue;
      end;
      Inc(I);
      if I >= Length(Json) then Break;
      case Json[I] of
        '"': OutText := OutText + '"';
        '\': OutText := OutText + '\';
        '/': OutText := OutText + '/';
        'b': OutText := OutText + #8;
        'f': OutText := OutText + #12;
        'n': OutText := OutText + #10;
        'r': OutText := OutText + #13;
        't': OutText := OutText + #9;
        'u':
          begin
            if I + 4 <= Length(Json) then
            begin
              Hex := Copy(string(Json), I + 1, 4);
              Val('$' + Hex, W, Code);
              if Code = 0 then
              begin
                OutText := OutText + WideChar(W);
                Inc(I, 4);
              end;
            end;
          end;
      else
        OutText := OutText + Json[I];
      end;
      Inc(I);
    end;
  end
  else
    OutText := Json;
  Result := string(OutText);
end;

{ TWebView2EnvironmentHandler }

constructor TWebView2EnvironmentHandler.Create(AOwner: TFPCWebView2Host);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TWebView2EnvironmentHandler.Detach;
begin
  FOwner := nil;
end;

function TWebView2EnvironmentHandler.Invoke(errorCode: HRESULT; environment: ICoreWebView2Environment): HRESULT;
begin
  if FOwner <> nil then
    FOwner.HandleEnvironmentCreated(errorCode, environment);
  Result := S_OK;
end;

{ TWebView2ControllerHandler }

constructor TWebView2ControllerHandler.Create(AOwner: TFPCWebView2Host);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TWebView2ControllerHandler.Detach;
begin
  FOwner := nil;
end;

function TWebView2ControllerHandler.Invoke(errorCode: HRESULT; controller: ICoreWebView2Controller): HRESULT;
begin
  if FOwner <> nil then
    FOwner.HandleControllerCreated(errorCode, controller);
  Result := S_OK;
end;

{ TNavigationStartingHandler }

constructor TNavigationStartingHandler.Create(AOwner: TFPCWebView2Host);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TNavigationStartingHandler.Detach;
begin
  FOwner := nil;
end;

function TNavigationStartingHandler.Invoke(sender: ICoreWebView2;
  args: ICoreWebView2NavigationStartingEventArgs): HRESULT;
begin
  if FOwner <> nil then
    FOwner.HandleNavigationStarting(args);
  Result := S_OK;
end;

{ TNavigationCompletedHandler }

constructor TNavigationCompletedHandler.Create(AOwner: TFPCWebView2Host);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TNavigationCompletedHandler.Detach;
begin
  FOwner := nil;
end;

function TNavigationCompletedHandler.Invoke(sender: ICoreWebView2;
  args: ICoreWebView2NavigationCompletedEventArgs): HRESULT;
begin
  if FOwner <> nil then
    FOwner.HandleNavigationCompleted(args);
  Result := S_OK;
end;

{ TSourceChangedHandler }

constructor TSourceChangedHandler.Create(AOwner: TFPCWebView2Host);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TSourceChangedHandler.Detach;
begin
  FOwner := nil;
end;

function TSourceChangedHandler.Invoke(sender: ICoreWebView2; args: IUnknown): HRESULT;
begin
  if FOwner <> nil then
    FOwner.HandleSourceChanged;
  Result := S_OK;
end;

{ TTitleChangedHandler }

constructor TTitleChangedHandler.Create(AOwner: TFPCWebView2Host);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TTitleChangedHandler.Detach;
begin
  FOwner := nil;
end;

function TTitleChangedHandler.Invoke(sender: ICoreWebView2; args: IUnknown): HRESULT;
begin
  if FOwner <> nil then
    FOwner.HandleTitleChanged;
  Result := S_OK;
end;

{ TNewWindowHandler }

constructor TNewWindowHandler.Create(AOwner: TFPCWebView2Host);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TNewWindowHandler.Detach;
begin
  FOwner := nil;
end;

function TNewWindowHandler.Invoke(sender: ICoreWebView2;
  args: ICoreWebView2NewWindowRequestedEventArgs): HRESULT;
begin
  if FOwner <> nil then
    FOwner.HandleNewWindowRequested(args);
  Result := S_OK;
end;

{ TProcessFailedHandler }

constructor TProcessFailedHandler.Create(AOwner: TFPCWebView2Host);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TProcessFailedHandler.Detach;
begin
  FOwner := nil;
end;

function TProcessFailedHandler.Invoke(sender: ICoreWebView2;
  args: ICoreWebView2ProcessFailedEventArgs): HRESULT;
begin
  if FOwner <> nil then
    FOwner.HandleProcessFailed(args);
  Result := S_OK;
end;

{ TPageScriptHandler }

constructor TPageScriptHandler.Create(AOwner: TFPCWebView2Host; EmitEvent: Boolean);
begin
  inherited Create;
  FOwner := AOwner;
  FEmitEvent := EmitEvent;
end;

procedure TPageScriptHandler.Detach;
begin
  FOwner := nil;
end;

function TPageScriptHandler.Invoke(errorCode: HRESULT; scriptResult: PWideChar): HRESULT;
begin
  if FOwner <> nil then
    FOwner.HandlePageScriptCompleted(errorCode, scriptResult, FEmitEvent);
  Result := S_OK;
end;

{ TFPCWebView2Host }

constructor TFPCWebView2Host.Create;
begin
  inherited Create;
  FLoaderDll := '';
  FContextMenu := True;
  FDevTools := True;
  FPopupWindow := False;
  FZoom := 100;
  FTheme := COREWEBVIEW2_PREFERRED_COLOR_SCHEME_AUTO;
end;

destructor TFPCWebView2Host.Destroy;
begin
  Shutdown;
  inherited Destroy;
end;

function TFPCWebView2Host.BoolToWinBool(Value: Boolean): BOOL;
begin
  Result := Value;
end;

procedure TFPCWebView2Host.DoError(const Message: string; ErrorCode: HRESULT);
begin
  FLastError := Message;
  if ErrorCode <> S_OK then
    FLastError := FLastError + ' (' + HResultText(ErrorCode) + ')';
  if Assigned(FOnError) then
    FOnError(Self, FLastError, ErrorCode);
end;

procedure TFPCWebView2Host.DoStatus(const Message: string);
begin
  if Assigned(FOnStatus) then
    FOnStatus(Self, Message);
end;

function TFPCWebView2Host.GetWideStringAndFree(P: PWideChar): string;
begin
  if P = nil then
    Result := ''
  else
  begin
    Result := string(WideString(P));
    CoTaskMemFree(P);
  end;
end;

function TFPCWebView2Host.EnsureLoader(out CreateEnvironment: Pointer): Boolean;
var
  LastErrorCode: DWORD;
begin
  Result := False;
  CreateEnvironment := nil;
  LastErrorCode := 0;
  DoStatus('WebView2: loading ' + WebView2DefaultLoaderPath);
  if FLibHandle = 0 then
  begin
    if SameDefaultLoaderName(FLoaderDll) then
      TryLoadWebView2Loader(WebView2DefaultLoaderPath, FLibHandle, FLoadedLoaderDll, LastErrorCode)
    else
      TryLoadWebView2Loader(FLoaderDll, FLibHandle, FLoadedLoaderDll, LastErrorCode);
  end;
  if FLibHandle = 0 then
  begin
    if LastErrorCode = 0 then
      LastErrorCode := GetLastError;
    DoError('WebView2Loader.dll is not available for ' + WebView2LoaderArchText +
      ': expected ' + WebView2DefaultLoaderPath + '. Put the matching loader in ' +
      WebView2LoaderDirectory + ' near the EXE or set LoaderDLL', HResultFromWin32(LastErrorCode));
    Exit;
  end;
  CreateEnvironment := GetProcAddress(FLibHandle, 'CreateCoreWebView2EnvironmentWithOptions');
  if CreateEnvironment = nil then
  begin
    DoError('CreateCoreWebView2EnvironmentWithOptions was not found in ' + FLoadedLoaderDll,
      HResultFromWin32(GetLastError));
    Exit;
  end;
  DoStatus('WebView2: loader ready ' + FLoadedLoaderDll);
  Result := True;
end;

procedure TFPCWebView2Host.Start(ParentWindow: HWND);
var
  hr: HRESULT;
  CreateEnvironmentPtr: Pointer;
  CreateEnvironment: TCreateCoreWebView2EnvironmentWithOptions;
  BrowserFolderW, UserDataW: WideString;
  BrowserFolderP, UserDataP: PWideChar;
begin
  if FStarted then Exit;
  FStarted := True;
  FParentWindow := ParentWindow;
  DoStatus('WebView2: start');
  if FParentWindow = 0 then
  begin
    DoError('Parent window handle is empty', E_INVALIDARG);
    Exit;
  end;

  hr := CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
  if FailedHR(hr) then
  begin
    DoError('COM STA initialization failed', hr);
    Exit;
  end;
  FComInitialized := not FailedHR(hr);

  if not EnsureLoader(CreateEnvironmentPtr) then Exit;
  CreateEnvironment := TCreateCoreWebView2EnvironmentWithOptions(CreateEnvironmentPtr);

  BrowserFolderW := WideString(FBrowserExecutableFolder);
  UserDataW := WideString(FUserDataFolder);
  if FBrowserExecutableFolder = '' then
    BrowserFolderP := nil
  else
    BrowserFolderP := PWideChar(BrowserFolderW);
  if FUserDataFolder = '' then
    UserDataP := nil
  else
    UserDataP := PWideChar(UserDataW);

  FEnvHandler := TWebView2EnvironmentHandler.Create(Self);
  DoStatus('WebView2: environment creation requested');
  hr := CreateEnvironment(BrowserFolderP, UserDataP, nil, FEnvHandler);
  if FailedHR(hr) then
    DoError('WebView2 environment creation failed', hr);
end;

procedure TFPCWebView2Host.ClearHandlers;
begin
  FEnvHandler := nil;
  FControllerHandler := nil;
  FNavigationStartingHandler := nil;
  FNavigationCompletedHandler := nil;
  FSourceChangedHandler := nil;
  FTitleChangedHandler := nil;
  FNewWindowHandler := nil;
  FProcessFailedHandler := nil;
  FPageScriptHandler := nil;
end;

procedure TFPCWebView2Host.DetachHandlers;
begin
  DetachHandler(FEnvHandler);
  DetachHandler(FControllerHandler);
  DetachHandler(FNavigationStartingHandler);
  DetachHandler(FNavigationCompletedHandler);
  DetachHandler(FSourceChangedHandler);
  DetachHandler(FTitleChangedHandler);
  DetachHandler(FNewWindowHandler);
  DetachHandler(FProcessFailedHandler);
  DetachHandler(FPageScriptHandler);
end;

procedure TFPCWebView2Host.Shutdown;
begin
  DetachHandlers;
  if FWebView <> nil then
  begin
    if FNavigationStartingToken.value <> 0 then
      FWebView.remove_NavigationStarting(FNavigationStartingToken);
    if FNavigationCompletedToken.value <> 0 then
      FWebView.remove_NavigationCompleted(FNavigationCompletedToken);
    if FSourceChangedToken.value <> 0 then
      FWebView.remove_SourceChanged(FSourceChangedToken);
    if FTitleChangedToken.value <> 0 then
      FWebView.remove_DocumentTitleChanged(FTitleChangedToken);
    if FNewWindowToken.value <> 0 then
      FWebView.remove_NewWindowRequested(FNewWindowToken);
    if FProcessFailedToken.value <> 0 then
      FWebView.remove_ProcessFailed(FProcessFailedToken);
  end;
  FNavigationStartingToken.value := 0;
  FNavigationCompletedToken.value := 0;
  FSourceChangedToken.value := 0;
  FTitleChangedToken.value := 0;
  FNewWindowToken.value := 0;
  FProcessFailedToken.value := 0;

  if FController <> nil then
    FController.Close;
  FWebView := nil;
  FController := nil;
  FEnv := nil;
  ClearHandlers;
  FReady := False;
  FStarted := False;
  if FLibHandle <> 0 then
  begin
    FreeLibrary(FLibHandle);
    FLibHandle := 0;
  end;
  if FComInitialized then
  begin
    CoUninitialize;
    FComInitialized := False;
  end;
  ClearTempHtmlFile('');
end;

procedure TFPCWebView2Host.HandleEnvironmentCreated(errorCode: HRESULT;
  const Env: ICoreWebView2Environment);
var
  hr: HRESULT;
  VersionPtr: PWideChar;
begin
  DoStatus('WebView2: environment callback');
  if FailedHR(errorCode) then
  begin
    DoError('WebView2 environment callback failed', errorCode);
    Exit;
  end;
  if Env = nil then
  begin
    DoError('WebView2 environment is nil', E_POINTER);
    Exit;
  end;
  FEnv := Env;
  VersionPtr := nil;
  if not FailedHR(FEnv.get_BrowserVersionString(VersionPtr)) then
    FBrowserVersion := GetWideStringAndFree(VersionPtr);
  FControllerHandler := TWebView2ControllerHandler.Create(Self);
  DoStatus('WebView2: controller creation requested');
  hr := FEnv.CreateCoreWebView2Controller(FParentWindow, FControllerHandler);
  if FailedHR(hr) then
    DoError('WebView2 controller creation failed', hr);
end;

procedure TFPCWebView2Host.HandleControllerCreated(errorCode: HRESULT;
  const Controller: ICoreWebView2Controller);
var
  hr: HRESULT;
begin
  DoStatus('WebView2: controller callback');
  if FailedHR(errorCode) then
  begin
    DoError('WebView2 controller callback failed', errorCode);
    Exit;
  end;
  if Controller = nil then
  begin
    DoError('WebView2 controller is nil', E_POINTER);
    Exit;
  end;
  FController := Controller;
  hr := FController.get_CoreWebView2(FWebView);
  if FailedHR(hr) or (FWebView = nil) then
  begin
    DoError('ICoreWebView2 retrieval failed', hr);
    Exit;
  end;

  FNavigationStartingHandler := TNavigationStartingHandler.Create(Self);
  FNavigationCompletedHandler := TNavigationCompletedHandler.Create(Self);
  FSourceChangedHandler := TSourceChangedHandler.Create(Self);
  FTitleChangedHandler := TTitleChangedHandler.Create(Self);
  FNewWindowHandler := TNewWindowHandler.Create(Self);
  FProcessFailedHandler := TProcessFailedHandler.Create(Self);

  FWebView.add_NavigationStarting(FNavigationStartingHandler, FNavigationStartingToken);
  FWebView.add_NavigationCompleted(FNavigationCompletedHandler, FNavigationCompletedToken);
  FWebView.add_SourceChanged(FSourceChangedHandler, FSourceChangedToken);
  FWebView.add_DocumentTitleChanged(FTitleChangedHandler, FTitleChangedToken);
  FWebView.add_NewWindowRequested(FNewWindowHandler, FNewWindowToken);
  FWebView.add_ProcessFailed(FProcessFailedHandler, FProcessFailedToken);

  ApplySettings;
  ApplyTheme;
  ApplyBounds;
  SetVisible(True);
  ApplyBounds;
  SetZoom(FZoom);
  FReady := True;
  DoStatus('WebView2: controller ready');
  FlushPendingNavigation;
end;

procedure TFPCWebView2Host.ApplySettings;
var
  Settings: ICoreWebView2Settings;
begin
  if FWebView = nil then Exit;
  if FailedHR(FWebView.get_Settings(Settings)) or (Settings = nil) then Exit;
  Settings.put_AreDefaultContextMenusEnabled(BoolToWinBool(FContextMenu));
  Settings.put_AreDefaultScriptDialogsEnabled(BoolToWinBool(not FSilent));
  Settings.put_AreDevToolsEnabled(BoolToWinBool(FDevTools));
  Settings.put_IsZoomControlEnabled(BoolToWinBool(True));
end;

procedure TFPCWebView2Host.ApplyTheme;
var
  WebView13: ICoreWebView2_13;
  Profile: ICoreWebView2Profile;
  hr: HRESULT;
begin
  if FWebView = nil then Exit;

  // 2026-06-18: Apply host-selected Auto/Light/Dark through the WebView2 profile.
  // Expected result: WebView2 UI and prefers-color-scheme follow FTheme; risk: old runtimes lack ICoreWebView2_13.
  WebView13 := nil;
  hr := FWebView.QueryInterface(IID_ICoreWebView2_13, WebView13);
  if FailedHR(hr) or (WebView13 = nil) then
  begin
    if FTheme <> COREWEBVIEW2_PREFERRED_COLOR_SCHEME_AUTO then
      DoError('WebView2 theme control requires ICoreWebView2_13', hr);
    Exit;
  end;

  Profile := nil;
  hr := WebView13.get_Profile(Profile);
  if FailedHR(hr) or (Profile = nil) then
  begin
    DoError('WebView2 profile retrieval failed for theme control', hr);
    Exit;
  end;

  hr := Profile.put_PreferredColorScheme(FTheme);
  if FailedHR(hr) then
    DoError('WebView2 preferred color scheme failed', hr);
end;

procedure TFPCWebView2Host.ApplyBounds;
var
  R: TRect;
  W, H: Integer;
  hr: HRESULT;
begin
  if (FController = nil) or (FParentWindow = 0) then Exit;
  GetClientRect(FParentWindow, R);
  W := R.Right - R.Left;
  H := R.Bottom - R.Top;
  if (W <> FLastBoundsWidth) or (H <> FLastBoundsHeight) then
  begin
    FLastBoundsWidth := W;
    FLastBoundsHeight := H;
    DoStatus('WebView2: bounds ' + IntToString(W) + 'x' + IntToString(H));
  end;
  {$IFDEF WIN64}
  hr := FController.put_Bounds(R);
  {$ELSE}
  hr := FController.put_Bounds(R.Left, R.Top, R.Right, R.Bottom);
  {$ENDIF}
  if FailedHR(hr) then
    DoError('WebView2 bounds failed', hr);
  hr := FController.NotifyParentWindowPositionChanged;
  if FailedHR(hr) then
    DoError('WebView2 parent position notify failed', hr);
end;

procedure TFPCWebView2Host.Resize;
begin
  ApplyBounds;
end;

procedure TFPCWebView2Host.FlushPendingNavigation;
var
  Url, Html, FileName: string;
begin
  if not FReady then Exit;
  Html := FPendingHtml;
  FileName := FPendingFileName;
  Url := FPendingUrl;
  FPendingHtml := '';
  FPendingFileName := '';
  FPendingUrl := '';
  if Html <> '' then
    NavigateToString(Html)
  else if FileName <> '' then
    NavigateFile(FileName)
  else if Url <> '' then
    Navigate(Url)
  else if FDefaultUrl <> '' then
    Navigate(FDefaultUrl);
end;

procedure TFPCWebView2Host.Navigate(const Url: string);
var
  W: WideString;
  hr: HRESULT;
begin
  if Url = '' then Exit;
  FRenderProcessRecoveryAttempted := False;
  ClearTempHtmlFile('');
  DoStatus('WebView2: navigate ' + Url);
  if not FReady then
  begin
    FPendingUrl := Url;
    FPendingHtml := '';
    FPendingFileName := '';
    Exit;
  end;
  W := WideString(Url);
  hr := FWebView.Navigate(PWideChar(W));
  if FailedHR(hr) then
  begin
    DoError('Navigate failed: ' + Url, hr);
  end
  else
  begin
    DoStatus('WebView2: navigate returned S_OK');
    ApplyBounds;
  end;
end;

procedure TFPCWebView2Host.NavigateToString(const Html: string);
var
  W: WideString;
  FileName: string;
  hr: HRESULT;
begin
  FRenderProcessRecoveryAttempted := False;
  DoStatus('WebView2: navigate HTML');
  if NavigateToStringSizeBytes(Html) >
    WEBVIEW2_NAVIGATE_TO_STRING_LIMIT_BYTES - WEBVIEW2_NAVIGATE_TO_STRING_MARGIN_BYTES then
  begin
    // 2026-06-24: WebView2 NavigateToString has a 2 MB input limit. Large HiAsm HTML
    // is written to a UTF-8 temp file and opened as file:// so reports do not freeze the host.
    if not GetTempHtmlFileName(FileName) then
    begin
      DoError('Temporary HTML file name creation failed', HResultFromWin32(GetLastError));
      Exit;
    end;
    ClearTempHtmlFile('');
    if not WriteUtf8HtmlFile(FileName, Html) then
    begin
      DoError('Temporary HTML file write failed: ' + FileName, HResultFromWin32(GetLastError));
      DeleteFileForCompilerString(FileName);
      Exit;
    end;
    FTempHtmlFileName := FileName;
    DoStatus('WebView2: large HTML saved to temporary file');
    NavigateFile(FileName);
    Exit;
  end;
  ClearTempHtmlFile('');
  if not FReady then
  begin
    FPendingHtml := Html;
    FPendingUrl := '';
    FPendingFileName := '';
    Exit;
  end;
  W := WideString(Html);
  hr := FWebView.NavigateToString(PWideChar(W));
  if FailedHR(hr) then
  begin
    DoError('NavigateToString failed', hr);
  end
  else
  begin
    DoStatus('WebView2: navigate HTML returned S_OK');
    ApplyBounds;
  end;
end;

procedure TFPCWebView2Host.NavigateFile(const FileName: string);
var
  Uri: string;
  W: WideString;
  hr: HRESULT;
begin
  if FileName = '' then Exit;
  FRenderProcessRecoveryAttempted := False;
  ClearTempHtmlFile(FileName);
  if not FileExistsForNavigation(FileName) then
  begin
    DoError('HTML file was not found: ' + FileName, HResultFromWin32(GetLastError));
    Exit;
  end;
  DoStatus('WebView2: navigate file ' + FileName);
  if not FReady then
  begin
    FPendingFileName := FileName;
    FPendingHtml := '';
    FPendingUrl := '';
    Exit;
  end;
  Uri := FileNameToFileUri(FileName);
  W := WideString(Uri);
  hr := FWebView.Navigate(PWideChar(W));
  if FailedHR(hr) then
  begin
    DoError('Navigate file failed: ' + FileName, hr);
  end
  else
  begin
    DoStatus('WebView2: navigate file returned S_OK');
    ApplyBounds;
  end;
end;

procedure TFPCWebView2Host.ClearTempHtmlFile(const KeepFileName: string);
begin
  if (FTempHtmlFileName <> '') and (FTempHtmlFileName <> KeepFileName) then
    DeleteFileForCompilerString(FTempHtmlFileName);
  if FTempHtmlFileName <> KeepFileName then
    FTempHtmlFileName := '';
end;

procedure TFPCWebView2Host.Reload;
begin
  FRenderProcessRecoveryAttempted := False;
  if FWebView <> nil then
    FWebView.Reload;
end;

procedure TFPCWebView2Host.Stop;
begin
  if FWebView <> nil then
    FWebView.Stop;
end;

procedure TFPCWebView2Host.GoBack;
var
  CanGo: BOOL;
begin
  if FWebView = nil then Exit;
  FRenderProcessRecoveryAttempted := False;
  CanGo := False;
  FWebView.get_CanGoBack(CanGo);
  if CanGo then
    FWebView.GoBack;
end;

procedure TFPCWebView2Host.GoForward;
var
  CanGo: BOOL;
begin
  if FWebView = nil then Exit;
  FRenderProcessRecoveryAttempted := False;
  CanGo := False;
  FWebView.get_CanGoForward(CanGo);
  if CanGo then
    FWebView.GoForward;
end;

procedure TFPCWebView2Host.RequestPage(EmitEvent: Boolean);
var
  Script: WideString;
  HandlerObj: TPageScriptHandler;
  hr: HRESULT;
begin
  if (FWebView = nil) or FPageRequestPending then Exit;
  FPageRequestPending := True;
  HandlerObj := TPageScriptHandler.Create(Self, EmitEvent);
  FPageScriptHandler := HandlerObj;
  Script := 'document.documentElement ? document.documentElement.outerHTML : document.body.outerHTML';
  hr := FWebView.ExecuteScript(PWideChar(Script), FPageScriptHandler);
  if FailedHR(hr) then
  begin
    FPageRequestPending := False;
    FPageScriptHandler := nil;
    DoError('ExecuteScript for page source failed', hr);
  end;
end;

procedure TFPCWebView2Host.OpenDevTools;
begin
  if FWebView <> nil then
    FWebView.OpenDevToolsWindow;
end;

procedure TFPCWebView2Host.SetZoom(Percent: Integer);
var
  Factor: Double;
begin
  if Percent < 25 then Percent := 25;
  if Percent > 500 then Percent := 500;
  FZoom := Percent;
  if FController = nil then Exit;
  Factor := Percent / 100.0;
  FController.put_ZoomFactor(Factor);
end;

procedure TFPCWebView2Host.SetTheme(Value: Integer);
begin
  if Value < COREWEBVIEW2_PREFERRED_COLOR_SCHEME_AUTO then
    Value := COREWEBVIEW2_PREFERRED_COLOR_SCHEME_AUTO;
  if Value > COREWEBVIEW2_PREFERRED_COLOR_SCHEME_DARK then
    Value := COREWEBVIEW2_PREFERRED_COLOR_SCHEME_DARK;
  FTheme := Value;
  ApplyTheme;
end;

procedure TFPCWebView2Host.SetVisible(Value: Boolean);
begin
  if FController <> nil then
    FController.put_IsVisible(BoolToWinBool(Value));
end;

procedure TFPCWebView2Host.Focus;
begin
  if FController <> nil then
    FController.MoveFocus(0);
end;

procedure TFPCWebView2Host.HandleNavigationStarting(
  const Args: ICoreWebView2NavigationStartingEventArgs);
var
  UriPtr: PWideChar;
  Uri: string;
  Cancel: Boolean;
begin
  UriPtr := nil;
  Uri := '';
  if (Args <> nil) and not FailedHR(Args.get_Uri(UriPtr)) then
    Uri := GetWideStringAndFree(UriPtr);
  DoStatus('WebView2: navigation starting ' + Uri);
  FCurrentUrl := Uri;
  FPageSource := '';
  Cancel := False;
  if Assigned(FOnBeforeNavigate) then
    FOnBeforeNavigate(Self, Uri, Cancel);
  if Cancel and (Args <> nil) then
    Args.put_Cancel(BoolToWinBool(True));
  if Assigned(FOnProgress) then
    FOnProgress(Self, 0);
  if Assigned(FOnLoad) then
    FOnLoad(Self, True);
end;

procedure TFPCWebView2Host.HandleNavigationCompleted(
  const Args: ICoreWebView2NavigationCompletedEventArgs);
var
  IsSuccess: BOOL;
  WebError: Integer;
begin
  IsSuccess := True;
  WebError := 0;
  if Args <> nil then
  begin
    Args.get_IsSuccess(IsSuccess);
    Args.get_WebErrorStatus(WebError);
  end;
  if IsSuccess then
    DoStatus('WebView2: navigation completed success')
  else
    DoStatus('WebView2: navigation completed error ' + IntToString(WebError));
  if Assigned(FOnProgress) then
    FOnProgress(Self, 65535);
  if Assigned(FOnLoad) then
    FOnLoad(Self, False);
  if not IsSuccess then
    DoError('Navigation failed, WebView2 status=' + IntToString(WebError), HRESULT(WebError));
  ApplyBounds;
end;

procedure TFPCWebView2Host.HandleSourceChanged;
var
  UriPtr: PWideChar;
begin
  if FWebView = nil then Exit;
  UriPtr := nil;
  if not FailedHR(FWebView.get_Source(UriPtr)) then
    FCurrentUrl := GetWideStringAndFree(UriPtr);
  DoStatus('WebView2: source changed ' + FCurrentUrl);
  if Assigned(FOnNavigate) then
    FOnNavigate(Self, FCurrentUrl);
end;

procedure TFPCWebView2Host.HandleTitleChanged;
var
  TitlePtr: PWideChar;
begin
  if FWebView = nil then Exit;
  TitlePtr := nil;
  if not FailedHR(FWebView.get_DocumentTitle(TitlePtr)) then
    FTitle := GetWideStringAndFree(TitlePtr);
  DoStatus('WebView2: title changed ' + FTitle);
  if Assigned(FOnTitle) then
    FOnTitle(Self, FTitle);
end;

procedure TFPCWebView2Host.HandleNewWindowRequested(
  const Args: ICoreWebView2NewWindowRequestedEventArgs);
var
  UriPtr: PWideChar;
  Uri: string;
  Cancel: Boolean;
begin
  UriPtr := nil;
  Uri := '';
  if (Args <> nil) and not FailedHR(Args.get_Uri(UriPtr)) then
    Uri := GetWideStringAndFree(UriPtr);
  Cancel := False;
  if Assigned(FOnNewWindow) then
    FOnNewWindow(Self, Uri, Cancel);
  if Args = nil then Exit;
  if Cancel then
    Args.put_Handled(BoolToWinBool(True))
  else if not FPopupWindow then
  begin
    Args.put_Handled(BoolToWinBool(True));
    if Uri <> '' then
      Navigate(Uri);
  end;
end;

procedure TFPCWebView2Host.HandleProcessFailed(
  const Args: ICoreWebView2ProcessFailedEventArgs);
var
  Kind: Integer;
  Reason: Integer;
  ExitCode: Integer;
  Args2: ICoreWebView2ProcessFailedEventArgs2;
  DescriptionPtr: PWideChar;
  Description: string;
  Msg: string;
  hr: HRESULT;
begin
  Kind := -1;
  Reason := -1;
  ExitCode := 0;
  Description := '';
  DescriptionPtr := nil;

  if Args <> nil then
  begin
    Args.get_ProcessFailedKind(Kind);
    if (Args <> nil) and (Args.QueryInterface(IID_ICoreWebView2ProcessFailedEventArgs2, Args2) = S_OK) then
    begin
      Args2.get_Reason(Reason);
      Args2.get_ExitCode(ExitCode);
      if not FailedHR(Args2.get_ProcessDescription(DescriptionPtr)) then
        Description := GetWideStringAndFree(DescriptionPtr);
    end;
  end;

  if (Kind = 1) and (FWebView <> nil) and not FRenderProcessRecoveryAttempted then
  begin
    FRenderProcessRecoveryAttempted := True;
    DoStatus('WebView2: render process exited, reloading current page');
    hr := FWebView.Reload;
    if FailedHR(hr) then
      DoError('Render process recovery reload failed', hr);
    Exit;
  end;

  Msg := 'WebView2 process failed: kind=' + ProcessFailedKindText(Kind) +
    '(' + IntToString(Kind) + ')';
  if Reason >= 0 then
    Msg := Msg + ', reason=' + ProcessFailedReasonText(Reason) +
      '(' + IntToString(Reason) + ')';
  Msg := Msg + ', exitCode=' + IntToString(ExitCode);
  if Description <> '' then
    Msg := Msg + ', process=' + Description;
  DoError(Msg, S_OK);
end;

procedure TFPCWebView2Host.HandlePageScriptCompleted(errorCode: HRESULT;
  result: PWideChar; EmitEvent: Boolean);
var
  Json: WideString;
begin
  FPageRequestPending := False;
  FPageScriptHandler := nil;
  if FailedHR(errorCode) then
  begin
    DoError('Page source script failed', errorCode);
    Exit;
  end;
  if result = nil then
    Json := ''
  else
    Json := WideString(result);
  FPageSource := WideJsonStringToString(Json);
  if EmitEvent and Assigned(FOnPage) then
    FOnPage(Self, FPageSource);
end;

end.
