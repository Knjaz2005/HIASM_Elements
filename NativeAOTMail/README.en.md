# NativeAOTMail

`NativeAOTMail` is a set of non-visual HiAsm elements for sending, listing, reading, and deleting email through `HiMailNative.dll`. The Pascal side stays a thin HiAsm wrapper, while SMTP, IMAP, POP3, MIME, TLS, and attachment handling are implemented in the NativeAOT DLL.

Russian documentation: [`README.md`](README.md).

## Features

- Session-based mail configuration through `MailSession`.
- SMTP sending through `MailSend`: multiple recipients, `Cc`, `Bcc`, plain-text or HTML body, and attachments.
- Message listing through `MailList`.
- Message reading through `MailRead`: subject, sender, recipients, text/html body, attachment metadata, and optional attachment saving.
- Message deletion through `MailDelete` by 1-based index or IMAP UID.
- IMAP/POP3 for receive operations and SMTP for sending.
- TLS modes: `Auto`, `None`, `SSL`, `STARTTLS`, `STARTTLSWhenAvailable`.
- Authentication modes: `Password`, `OAuth2`, `None`; SMTP password authentication can use `Auto`, `Plain`, or `Login`.
- Every operation returns full JSON in `Result`; the last error text is available through `onError` and `Error`.

## Layout

```text
NativeAOTMail/
  README.md
  README.en.md
  THIRD-PARTY-NOTICES.txt
  THIRD-PARTY-NOTICES.ru.txt
  MailExample.sha
  Element/0.1/
    MailSession.ini / hiMailSession.pas / MailSession.ico
    MailSend.ini    / hiMailSend.pas    / MailSend.ico
    MailList.ini    / hiMailList.pas    / MailList.ico
    MailRead.ini    / hiMailRead.pas    / MailRead.ico
    MailDelete.ini  / hiMailDelete.pas  / MailDelete.ico
    HiMailNativeShared.pas
  win-x32/HiMailNative.dll
  win-x64/HiMailNative.dll
```

`MailExample.sha` is a HiAsm sample scheme for manual checks. Server names, login, and password in the sample are sanitized and must be replaced before running it. The compiled `MailExample.exe` is not part of the published repository contents.

`win-x32` contains the 32-bit DLL, and `win-x64` contains the 64-bit DLL. The DLLs are different binaries, but they export the same API.

## Installation

1. Import each needed element into HiAsm by dragging its `.ini` file from `Element/0.1/` onto the HiAsm window.
2. Keep the same-named `.pas` and `.ico` files next to each `.ini`, plus the shared `HiMailNativeShared.pas`.
3. Copy the `win-x32` and/or `win-x64` runtime folders next to the generated EXE when the scheme uses `HiMailNative.dll`.

```text
MyApp.exe
win-x32/HiMailNative.dll
win-x64/HiMailNative.dll
```

## Requirements

- Windows.
- A HiAsm/Delphi tree where the element `.ini`, `.pas`, and `.ico` files can be installed.
- For FPC/FPC2 builds, a HiAsm environment with the FPC2 kit installed when that compiler path is used.
- `HiMailNative.dll` next to the generated EXE in an architecture subfolder or next to the EXE itself.

`HiMailNative.dll` is built as a .NET 10 NativeAOT shared library and does not require an installed .NET Runtime on the target machine.

Locally verified metadata for the included DLLs:

| File | FileVersion | ProductVersion |
| --- | --- | --- |
| `win-x32/HiMailNative.dll` | `1.0.0.0` | `1.0.0+9e0dd40cdfb7250c2e68f3bc6e79456f932c927c` |
| `win-x64/HiMailNative.dll` | `1.0.0.0` | `1.0.0+9e0dd40cdfb7250c2e68f3bc6e79456f932c927c` |

The bridge version string in the DLL source code is `HiMailNative 1.0.0`.

## Runtime DLL and Bridge

```text
win-x32\HiMailNative.dll -> next to the EXE for 32-bit builds
win-x64\HiMailNative.dll -> next to the EXE for 64-bit builds
```

On the first bridge access, the Pascal loader searches for the DLL in this order:

1. the architecture-specific subfolder next to the EXE: `win-x32` for 32-bit, `win-x64` for 64-bit;
2. the legacy 32-bit fallback folder `win-x86` when `win-x32` is not found;
3. `HiMailNative.dll` next to the EXE;
4. the normal Windows DLL search path.

Actual exports of the included DLLs:

| Export | Purpose |
| --- | --- |
| `HiMail_OpenSession(PAnsiChar configUtf8): PAnsiChar` | Creates a session handle and stores JSON configuration. |
| `HiMail_SessionJson(Integer handle, PAnsiChar requestUtf8): PAnsiChar` | Executes an operation using session configuration; request fields override same-named session fields. |
| `HiMail_CloseSession(Integer handle): PAnsiChar` | Removes a session handle. |
| `HiMail_ExecuteJson(PAnsiChar requestUtf8): PAnsiChar` | Executes a single JSON request without a session handle. |
| `HiMail_FreeString(PAnsiChar resultUtf8)` | Frees a string returned by the DLL. |
| `HiMail_Version(): PAnsiChar` | Returns the bridge version string. |

Strings are passed to the DLL as UTF-8. The DLL returns UTF-8 strings allocated with `CoTaskMem`; the Pascal wrapper frees them through `HiMail_FreeString`. In old ANSI HiAsm, the Pascal wrapper converts strings between the current Windows ANSI code page and UTF-8.

The backend accepts operations `send`, `check`/`checksmtp`, `list`, `get`/`read`, `delete`, and `version`. The current HiAsm element set directly exposes session, send, list, read, and delete; there is no dedicated element for `check/checksmtp` or `version`.

## Compatibility and Verification

The element code contains branches for Delphi 4/Win32 and FPC/FPC2 x32/x64. Old FPC operation is intended for HiAsm with the FPC2 kit installed, because that kit overrides some conditional-compilation symbols.

Mirrored FPC2 kit: <https://disk.yandex.ru/d/9nHdCgy8OygKmA>. Relevant HiAsm forum topic: <https://forum.hiasm.com/topic/61538/0>.

At the time of this documentation edit, `NativeAOTMail` has no recorded clean `clean` or `clean-fpc2` compile/runtime check. This public documentation therefore does not claim clean compatibility for third-party installations; such claims require a separate project `tests.md` entry with the matching status.

## Elements

| Element | `.ini` Version | Purpose |
| --- | --- | --- |
| `MailSession` | `1.0` | Stores SMTP/IMAP/POP3 settings and creates/closes a session handle. |
| `MailSend` | `0.1` | Sends a message through a session handle. |
| `MailList` | `0.1` | Returns message summaries and fills `Count`. |
| `MailRead` | `0.1` | Reads one message and fills `SubjectOut`, `FromOut`, `ToOut`, `BodyText`, `BodyHtml`. |
| `MailDelete` | `0.1` | Deletes a message by `Uid` or 1-based `Index`; can perform IMAP `Expunge`. |

## Runtime Model

`MailSession.doOpen` does not open a persistent SMTP/IMAP/POP3 network connection. It passes JSON configuration to the DLL, receives a numeric handle, and keeps it until `doClose` or element destruction. A network connection is created and closed inside each `MailSend`, `MailList`, `MailRead`, or `MailDelete` operation.

Work points read input data at the moment they are called. If an input is not connected or is empty, the element property or `MailSession` value is used. JSON request fields from helper elements override same-named session fields.

On success, the element's primary event receives the full JSON result. On failure, `onError` receives the short error text when that event is connected; the full JSON remains in `Result`, and the error text remains in `Error`.

## Main MailSession Properties

| Property | Behavior |
| --- | --- |
| `SmtpServer`, `SmtpPort` | SMTP host and port. Port `0` selects a default value based on protocol and TLS; the current `.ini` default is `587`. |
| `MailServer`, `MailPort` | IMAP/POP3 host and port. If `MailServer` is empty or contains the placeholder `imap.example.com`/`pop3.example.com`, the DLL tries to derive the host from an SMTP host such as `smtp.example.com` -> `imap.example.com` or `pop3.example.com`. |
| `ReceiveProtocol` | `IMAP` or `POP3` for receive helpers. |
| `Security` | TLS mode: `Auto`, `None`, `SSL`, `STARTTLS`, `STARTTLSWhenAvailable`. |
| `Auth` | `Password`, `OAuth2`, or `None`. |
| `AuthMechanism` | SMTP AUTH mechanism for password auth: `Auto`, `Plain`, `Login`. |
| `Login`, `Password`, `AccessToken` | Credentials. `OAuth2` requires `Login` and `AccessToken`. |
| `Timeout` | Network operation timeout in milliseconds; the current `.ini` default is `30000`. |
| `IgnoreCertificateErrors` | Disables TLS certificate validation when enabled. This is an unsafe diagnostic mode. |
| `Folder`, `Limit`, `Expunge` | Defaults for list/read/delete helpers. |

## Helper Elements

| Element | Main inputs and properties | Result |
| --- | --- | --- |
| `MailSend` | `Handle`, `From`, `To`, `Cc`, `Bcc`, `Subject`, `Body`, `Html`, `Attachments` | Sends a message through SMTP. `To`, `Cc`, `Bcc`, and `Attachments` accept semicolon-separated strings; `Attachments` also accepts a HiAsm string array. |
| `MailList` | `Handle`, `Folder`, `Limit` | Returns recent messages and updates `Count`. `Limit < 1` becomes `20` in the backend, and the maximum is clamped to `500`. |
| `MailRead` | `Handle`, `Folder`, `Index`, `Uid`, `SaveAttachmentsDir` | Reads a message. `Index` is one-based; a non-empty `Uid` is used for IMAP. With a non-empty `SaveAttachmentsDir`, attachments are saved with safe unique names. |
| `MailDelete` | `Handle`, `Folder`, `Index`, `Uid`, `Expunge` | Deletes a message. For IMAP, sets the `Deleted` flag and runs expunge when `Expunge=True`; for POP3, deletes by index. |

## Basic Workflow

1. Configure `MailSession`.
2. Call `doOpen`; store `Handle` from `onOpen` or from the `Handle` variable.
3. Pass `Handle` to `MailSend`, `MailList`, `MailRead`, or `MailDelete`.
4. Read full JSON from `Result`; on failure use `onError` or `Error`.
5. Call `doClose` when the session is no longer needed.

## JSON Results

Successful responses always contain `"ok":true`; errors contain `"ok":false`, `code`, and `error`.

| Operation | Main response fields |
| --- | --- |
| `send` | `operation`, `message`. |
| `list` | `operation`, `protocol`, `count`, `messages[]` with `index`, `uid`, `subject`, `from`, `to`, `date`, `size`, `seen`. |
| `get`/`read` | `operation`, `protocol`, `message` with `subject`, `from`, `to`, `cc`, `bcc`, `replyTo`, `date`, `messageId`, `bodyText`, `bodyHtml`, `attachments[]`. |
| `delete` | `operation`, `protocol`, `message`. |

Possible error codes include `LOCAL` for Pascal-loader errors, `ARGUMENT`, `JSON`, `SESSION`, `FILE`, and backend exception names such as `SmtpCommandException`, `ArgumentException`, or `ArgumentOutOfRangeException`. SMTP command errors may also contain `statusCode`, `errorCode`, and `mailbox`.

## Limitations

- Operations are synchronous: the current HiAsm thread is occupied while the network request is running.
- `MailSession` stores configuration but does not keep a persistent network connection.
- POP3 does not support server-side folders like IMAP; `Folder` is effectively ignored by the backend for POP3.
- The current HiAsm elements have no dedicated ports for backend operations `check/checksmtp`, `version`, or for backend aliases `imapServer`, `pop3Server`, `server`, `host`, and the `replyTo` field.
- Old ANSI HiAsm uses the current Windows ANSI code page when converting strings. The backend attempts to clean common UTF-8/Windows-1251 mojibake in received text, but this is not a guaranteed recoding path for all messages.
- SMTP/IMAP/POP3 errors depend on the provider. For example, `535` is usually returned by an SMTP server when authentication is rejected.
- Compatibility claims should use only project `tests.md` results marked `clean` or `clean-fpc2`.

## Licensing and Notices

The Pascal element code is in a repository with the root license file [`../LICENSE`](../LICENSE), unless a separate file states otherwise. Third-party component notices for components included in `HiMailNative.dll` or used to build it are in [`THIRD-PARTY-NOTICES.txt`](THIRD-PARTY-NOTICES.txt). A Russian explanatory summary is in [`THIRD-PARTY-NOTICES.ru.txt`](THIRD-PARTY-NOTICES.ru.txt).
