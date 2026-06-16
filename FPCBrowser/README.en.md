# FPCBrowser

`FPCBrowser` is a HiAsm package with the visual `FPCWebBrowser` element for embedding Microsoft Edge WebView2. It replaces the IE-based `WebBrowser` where a modern browser engine is needed, while the project must build in a HiAsm environment with the FPC2 kit installed for x32/x64 ANSI/Unicode modes.

Russian documentation: [`README.md`](README.md).

## Features

- URL navigation, `Refresh`, `Stop`, `Back`, and `Forward`.
- HTML string loading through WebView2 `NavigateToString`.
- Asynchronous HTML reading from the current page.
- Events for URL, title, loading state, errors, and new-window requests.
- Control over JavaScript dialogs, context menu, DevTools, popup behavior, zoom, and the WebView2 theme.

## Layout

```text
FPCBrowser/
  README.md
  README.en.md
  THIRD-PARTY-NOTICES.txt
  THIRD-PARTY-NOTICES.ru.txt
  Browser64.sha
  Element/0.1/
    FPCWebBrowser.ini / hiFPCWebBrowser.pas / FPCWebBrowser.ico
    FPCWebView2.pas
  win-x32/WebView2Loader.dll
  win-x64/WebView2Loader.dll
```

`Browser64.sha` is a sample HiAsm scheme using the `FPCWebBrowser` element with basic navigation, HTML-from-text loading, and theme switching.

## Requirements

- Windows.
- WebView2 Runtime: system Evergreen Runtime or a Fixed Version Runtime selected through `BrowserExecutableFolder`.
- `WebView2Loader.dll` next to the generated EXE in an architecture subfolder:

```text
MyApp.exe
win-x32/WebView2Loader.dll
win-x64/WebView2Loader.dll
```

`LoaderDLL` can specify an explicit DLL path. If `LoaderDLL` is empty or equals `WebView2Loader.dll`, the element selects `win-x32` or `win-x64` according to the build architecture.

The `WebView2Loader.dll` binaries in this package come from the `Microsoft.Web.WebView2` NuGet package version `1.0.4022.49`. The WebView2 Runtime itself is not included in this directory.

Locally verified metadata for the included loaders:

| File | File/Product version | Size | SHA-256 |
| --- | --- | ---: | --- |
| `win-x32/WebView2Loader.dll` | `1.0.4022.49` | 124296 bytes | `9DDE881D0CB0685053DA9F2EBF7A27737882682D2F907D42AF1C029DC603A0DC` |
| `win-x64/WebView2Loader.dll` | `1.0.4022.49` | 163208 bytes | `12F7708910E1AAC5CC9AC43603D122F1D2E770AE2651830A07EF8B3117F28C55` |

## Compatibility

Minimum supported environment: `HiasmAltOriginal` with the FPC2 kit installed over it. Plain original D4 HiAsm and old FPC 1.9.x are no longer test targets for this element because they use different conditional-compilation settings and related runtime configuration.

Old FPC operation is treated as supported only with the FPC2 kit installed, because that kit overrides some conditional-compilation symbols. In a plain HiAsm installation with old FPC, the element will most likely not work. Mirrored FPC2 kit: <https://disk.yandex.ru/d/9nHdCgy8OygKmA>. Relevant HiAsm forum topic: <https://forum.hiasm.com/topic/61538/0>.

Checked build targets:

- FPC2 x32 ANSI/Unicode.
- FPC2 x64 ANSI/Unicode.

## Properties

| Property | Behavior |
| --- | --- |
| `URL` | Initial URL and default value for `doNavigate`. Used at startup if no pending `doNavigate` or `doFromText` was stored before WebView2 became ready. |
| `LoaderDLL` | Explicit path to `WebView2Loader.dll`; applied only when WebView2 starts. |
| `BrowserExecutableFolder` | Fixed Version Runtime folder; empty means the system Evergreen Runtime. Applied only when the environment is created. |
| `UserDataFolder` | WebView2 profile folder; empty means the default profile. Applied only when the environment is created. |
| `Silent` | Disables default JavaScript dialogs when the controller is created. |
| `ContextMenu` | Enables or disables the default WebView2 context menu when the controller is created. |
| `DevTools` | Enables or disables DevTools when the controller is created. |
| `PopupWindow` | If `False`, an uncanceled new-window request opens in the current browser. If `True`, the request is passed to WebView2. |
| `Zoom` | Initial zoom, clamped to `25..500`. |
| `Theme` | Initial WebView2 theme: `Auto`, `Light`, or `Dark`. In code, the values map to `0`, `1`, and `2`. |

## Work Points

| Point | Arguments and effect |
| --- | --- |
| `doNavigate` | Reads `URL`, otherwise the `URL` property. Empty strings are ignored. Before WebView2 is ready, stores the URL as a pending navigation; repeated calls overwrite the previous pending value. After navigation is sent, changing `URL` does not affect it. |
| `doFromText` | Reads HTML from `Text`. Before WebView2 is ready, stores the HTML as pending content; repeated calls overwrite the previous pending value. After the call, changing `Text` does not affect the stored or started navigation. |
| `doRefresh` | No arguments. Calls `Reload` if WebView2 is created; ignored before readiness. |
| `doBack` | No arguments. Checks `CanGoBack` at call time; does nothing before readiness or without history. |
| `doForward` | No arguments. Checks `CanGoForward` at call time; does nothing before readiness or without history. |
| `doGetPage` | No arguments. If WebView2 is ready and no page request is active, starts reading `document.documentElement.outerHTML`; the result is sent to `onPage` and `Page`. Repeated calls before completion are ignored. |
| `doOpenDevTools` | No arguments. Calls `OpenDevToolsWindow` if WebView2 is created; WebView2 may reject the request when `DevTools=False`. |
| `doZoom` | Reads `Zoom`, otherwise the `Zoom` property. The value is clamped to `25..500`. Before readiness, the value is stored and applied when the controller is created; after readiness, it is applied immediately. |
| `doTheme` | Reads `Theme`, otherwise the `Theme` property. The value is clamped to `0..2`: `0` Auto, `1` Light, `2` Dark. Before readiness, the value is stored and applied when the controller is created; after readiness, it is applied immediately. |
| `doStop` | No arguments. Stops the current load if WebView2 is created; ignored before readiness. |

## Events and Data

| Point | Data |
| --- | --- |
| `onNavigate` | Current URL on `SourceChanged`. |
| `onTitle` | Current document title. |
| `onStatus` | WebView2 diagnostics: loader, environment, controller, navigation, size, recovery, and errors. |
| `onProgress` | `0` on `NavigationStarting`, `65535` on `NavigationCompleted`. |
| `onLoad` | `1` when loading starts, `0` when loading completes. |
| `onError` | Last error text from the element or WebView2. |
| `onPage` | HTML after `doGetPage`. |
| `onNewWindow` | URI from a new-window request. |
| `URL` | Input data for `doNavigate`; the `URL` property is used when this data input is absent. |
| `Text` | HTML string for `doFromText`. |
| `Zoom` | Input data for `doZoom`; the `Zoom` property is used when this data input is absent. |
| `Theme` | Input data for `doTheme`: `0` Auto, `1` Light, `2` Dark. |
| `Navigate` | Control input for `NavigationStarting`: return `1` to cancel the current navigation. Applies only synchronously to the current start. |
| `NewWindow` | Control input for a new-window request: return `1` to cancel the request. Otherwise behavior is controlled by `PopupWindow`. |
| `CurrentURL` | Last URL from `NavigationStarting` or `SourceChanged`. |
| `Page` | Last HTML received through `doGetPage`; cleared when new navigation starts. |
| `Title` | Last document title. |
| `BrowserVersion` | WebView2 Runtime version. |
| `LastError` | Last error text. |

## Behavior

WebView2 is created asynchronously. After the controller is ready, one startup load is selected: pending HTML from `doFromText`, otherwise pending URL from `doNavigate`, otherwise the `URL` property.

The WebView2 theme is applied through `ICoreWebView2_13.Profile.PreferredColorScheme`. It affects WebView2 UI and the CSS media feature `prefers-color-scheme`, but it does not change the HiAsm parent window styling.

When the renderer process fails, the element makes one recovery attempt through `Reload`. A repeated failure is sent to `onError` and `onStatus`.

## Limitations

- `NavigateToString` loads HTML without a separate base URL setting.
- `doGetPage` depends on the current DOM and JavaScript execution in the page.
- Theme control requires a WebView2 Runtime that supports `ICoreWebView2_13`; with `Theme=Auto`, older runtimes stay in the system mode, while `Light`/`Dark` without that interface is reported through `onError`/`onStatus`.
- Network errors, CAPTCHA, anti-bot checks, and site policies are not element errors.

## Licensing

Element code: `GPL-3.0-or-later OR Commercial License`; the GPL text is in the repository root [`../LICENSE`](../LICENSE). A separate commercial license text is not included in this directory.

Third-party legal notices for the WebView2 loader are in [`THIRD-PARTY-NOTICES.txt`](THIRD-PARTY-NOTICES.txt). A Russian explanatory summary is in [`THIRD-PARTY-NOTICES.ru.txt`](THIRD-PARTY-NOTICES.ru.txt).
