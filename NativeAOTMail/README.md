# NativeAOTMail

`NativeAOTMail` - набор невизуальных элементов HiAsm для отправки, просмотра, чтения и удаления почты через `HiMailNative.dll`. Pascal-часть остается тонкой оберткой HiAsm, а работа с SMTP, IMAP, POP3, MIME, TLS и вложениями выполняется в NativeAOT DLL.

English documentation: [`README.en.md`](README.en.md).

## Возможности

- Сессионная конфигурация почтовых параметров через `MailSession`.
- Отправка SMTP через `MailSend`: несколько получателей, `Cc`, `Bcc`, текстовое или HTML-тело, вложения.
- Получение списка сообщений через `MailList`.
- Чтение сообщения через `MailRead`: тема, отправитель, получатели, text/html body, метаданные вложений и сохранение вложений в каталог.
- Удаление сообщения через `MailDelete` по 1-based индексу или IMAP UID.
- IMAP/POP3 для операций чтения, SMTP для отправки.
- TLS режимы `Auto`, `None`, `SSL`, `STARTTLS`, `STARTTLSWhenAvailable`.
- Аутентификация `Password`, `OAuth2`, `None`; для SMTP password auth можно выбрать `Auto`, `Plain`, `Login`.
- Все операции возвращают полный JSON в `Result`; текст последней ошибки доступен через `onError` и `Error`.

## Состав

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

`MailExample.sha` - пример схемы HiAsm для ручной проверки. Серверы, логин и пароль в примере обезличены и должны быть заменены перед запуском. Скомпилированный `MailExample.exe` не входит в публикуемый состав репозитория.

`win-x32` содержит 32-bit DLL, `win-x64` содержит 64-bit DLL. DLL разные физически, но экспортируют один и тот же API.

## Установка

1. Импортируйте в HiAsm каждый нужный элемент, перетащив соответствующий `.ini` из `Element/0.1/` на окно HiAsm.
2. Убедитесь, что рядом с `.ini` остаются одноименные `.pas` и `.ico`, а также общий `HiMailNativeShared.pas`.
3. Скопируйте runtime-папки `win-x32` и/или `win-x64` рядом с генерируемым EXE, если схема будет использовать `HiMailNative.dll`.

```text
MyApp.exe
win-x32/HiMailNative.dll
win-x64/HiMailNative.dll
```

## Требования

- Windows.
- Дерево HiAsm/Delphi, в которое можно установить `.ini`, `.pas` и `.ico` элементы.
- Для FPC/FPC2-сборок - среда HiAsm с установленным комплектом FPC2, если используется соответствующая ветка компиляции.
- `HiMailNative.dll` рядом с генерируемым EXE в архитектурном подкаталоге или рядом с EXE.

`HiMailNative.dll` собрана как .NET 10 NativeAOT shared library и не требует установленного .NET Runtime на целевой машине.

Проверенные локальные метаданные включенных DLL:

| Файл | FileVersion | ProductVersion |
| --- | --- | --- |
| `win-x32/HiMailNative.dll` | `1.0.0.0` | `1.0.0+9e0dd40cdfb7250c2e68f3bc6e79456f932c927c` |
| `win-x64/HiMailNative.dll` | `1.0.0.0` | `1.0.0+9e0dd40cdfb7250c2e68f3bc6e79456f932c927c` |

Строка версии bridge в исходном коде DLL: `HiMailNative 1.0.0`.

## Runtime DLL и bridge

```text
win-x32\HiMailNative.dll -> рядом с EXE для 32-bit сборки
win-x64\HiMailNative.dll -> рядом с EXE для 64-bit сборки
```

Pascal-loader при первом обращении к bridge ищет DLL в таком порядке:

1. архитектурный подкаталог рядом с EXE: `win-x32` для 32-bit, `win-x64` для 64-bit;
2. запасной 32-bit подкаталог `win-x86`, если `win-x32` не найден;
3. `HiMailNative.dll` рядом с EXE;
4. стандартный Windows DLL search path.

Фактические exports включенных DLL:

| Export | Назначение |
| --- | --- |
| `HiMail_OpenSession(PAnsiChar configUtf8): PAnsiChar` | Создает session handle и сохраняет JSON-конфигурацию. |
| `HiMail_SessionJson(Integer handle, PAnsiChar requestUtf8): PAnsiChar` | Выполняет операцию с конфигурацией session; поля запроса переопределяют одноименные поля session. |
| `HiMail_CloseSession(Integer handle): PAnsiChar` | Удаляет session handle. |
| `HiMail_ExecuteJson(PAnsiChar requestUtf8): PAnsiChar` | Выполняет одиночный JSON-запрос без session handle. |
| `HiMail_FreeString(PAnsiChar resultUtf8)` | Освобождает строку, возвращенную DLL. |
| `HiMail_Version(): PAnsiChar` | Возвращает строку версии bridge. |

Строки передаются в DLL как UTF-8. DLL возвращает UTF-8 строки, выделенные через `CoTaskMem`; Pascal-обертка освобождает их через `HiMail_FreeString`. В старом ANSI HiAsm Pascal-обертка конвертирует строки между текущей Windows ANSI code page и UTF-8.

Backend понимает операции `send`, `check`/`checksmtp`, `list`, `get`/`read`, `delete`, `version`. Текущий набор HiAsm-элементов напрямую предоставляет session, send, list, read и delete; отдельного элемента для `check/checksmtp` или `version` нет.

## Совместимость и проверки

Код элементов содержит ветки для Delphi 4/Win32 и FPC/FPC2 x32/x64. Работа со старым FPC рассчитана на HiAsm с установленным поверх комплектом FPC2, потому что этот комплект переопределяет часть знаков условной компиляции.

Дублированный комплект FPC2: <https://disk.yandex.ru/d/9nHdCgy8OygKmA>. Профильная тема форума HiAsm: <https://forum.hiasm.com/topic/61538/0>.

На момент этой редакции документации для `NativeAOTMail` не зафиксирована чистая `clean` или `clean-fpc2` запись compile/runtime-проверки. Публикационная документация поэтому не заявляет чистую совместимость для сторонней установки; для таких заявлений нужна отдельная запись проверки в проектном `tests.md` с соответствующим статусом.

## Элементы

| Элемент | Version в `.ini` | Назначение |
| --- | --- | --- |
| `MailSession` | `1.0` | Хранит SMTP/IMAP/POP3 настройки, создает и закрывает session handle. |
| `MailSend` | `0.1` | Отправляет письмо через session handle. |
| `MailList` | `0.1` | Возвращает список сообщений и счетчик `Count`. |
| `MailRead` | `0.1` | Читает одно сообщение, заполняет `SubjectOut`, `FromOut`, `ToOut`, `BodyText`, `BodyHtml`. |
| `MailDelete` | `0.1` | Удаляет сообщение по `Uid` или 1-based `Index`; может выполнять IMAP `Expunge`. |

## Модель работы

`doOpen` у `MailSession` не открывает постоянное SMTP/IMAP/POP3-соединение. Он передает JSON-конфигурацию в DLL, получает числовой handle и хранит его до `doClose` или уничтожения элемента. Сетевое соединение создается и закрывается внутри каждой операции `MailSend`, `MailList`, `MailRead` или `MailDelete`.

Рабочие точки читают входные данные в момент вызова. Если вход не подключен или пустой, используется свойство элемента или значение из `MailSession`. Поля JSON-запроса helper-элемента переопределяют одноименные поля session.

При успехе основной event элемента получает полный JSON результата. При ошибке `onError` получает короткий текст ошибки, если этот event подключен; полный JSON остается в `Result`, а текст ошибки - в `Error`.

## Основные свойства MailSession

| Свойство | Поведение |
| --- | --- |
| `SmtpServer`, `SmtpPort` | SMTP host и порт. Порт `0` выбирает значение по протоколу и TLS; текущий default в `.ini` - `587`. |
| `MailServer`, `MailPort` | IMAP/POP3 host и порт. Если `MailServer` пустой или содержит placeholder `imap.example.com`/`pop3.example.com`, DLL пытается вывести host из SMTP host вида `smtp.example.com` -> `imap.example.com` или `pop3.example.com`. |
| `ReceiveProtocol` | `IMAP` или `POP3` для receive helpers. |
| `Security` | TLS режим: `Auto`, `None`, `SSL`, `STARTTLS`, `STARTTLSWhenAvailable`. |
| `Auth` | `Password`, `OAuth2` или `None`. |
| `AuthMechanism` | SMTP AUTH механизм для password auth: `Auto`, `Plain`, `Login`. |
| `Login`, `Password`, `AccessToken` | Учетные данные. Для `OAuth2` нужны `Login` и `AccessToken`. |
| `Timeout` | Timeout сетевой операции в миллисекундах; текущий default в `.ini` - `30000`. |
| `IgnoreCertificateErrors` | Отключает проверку TLS-сертификата при включении. Это небезопасный диагностический режим. |
| `Folder`, `Limit`, `Expunge` | Значения по умолчанию для list/read/delete helpers. |

## Helper-элементы

| Элемент | Основные входы и свойства | Результат |
| --- | --- | --- |
| `MailSend` | `Handle`, `From`, `To`, `Cc`, `Bcc`, `Subject`, `Body`, `Html`, `Attachments` | Отправляет письмо через SMTP. `To`, `Cc`, `Bcc` и `Attachments` принимают строки с `;` как разделителем; `Attachments` также принимает HiAsm string array. |
| `MailList` | `Handle`, `Folder`, `Limit` | Возвращает последние сообщения и обновляет `Count`. `Limit < 1` превращается backend-ом в `20`, максимальное значение ограничено `500`. |
| `MailRead` | `Handle`, `Folder`, `Index`, `Uid`, `SaveAttachmentsDir` | Читает сообщение. `Index` one-based; при непустом `Uid` для IMAP используется UID. При непустом `SaveAttachmentsDir` вложения сохраняются с безопасными уникальными именами. |
| `MailDelete` | `Handle`, `Folder`, `Index`, `Uid`, `Expunge` | Удаляет сообщение. Для IMAP ставит флаг `Deleted` и при `Expunge=True` выполняет expunge; для POP3 удаляет сообщение по индексу. |

## Основной сценарий

1. Настроить `MailSession`.
2. Вызвать `doOpen`; сохранить `Handle` из `onOpen` или переменной `Handle`.
3. Передать `Handle` в `MailSend`, `MailList`, `MailRead` или `MailDelete`.
4. Читать полный JSON из `Result`; при ошибке использовать `onError` или `Error`.
5. Вызвать `doClose`, когда session больше не нужна.

## JSON-результаты

Успешные ответы всегда содержат `"ok":true`; ошибки содержат `"ok":false`, `code` и `error`.

| Операция | Основные поля ответа |
| --- | --- |
| `send` | `operation`, `message`. |
| `list` | `operation`, `protocol`, `count`, `messages[]` с `index`, `uid`, `subject`, `from`, `to`, `date`, `size`, `seen`. |
| `get`/`read` | `operation`, `protocol`, `message` с `subject`, `from`, `to`, `cc`, `bcc`, `replyTo`, `date`, `messageId`, `bodyText`, `bodyHtml`, `attachments[]`. |
| `delete` | `operation`, `protocol`, `message`. |

Возможные коды ошибок включают `LOCAL` для ошибок Pascal-loader, `ARGUMENT`, `JSON`, `SESSION`, `FILE`, а также имена исключений backend, например `SmtpCommandException`, `ArgumentException` или `ArgumentOutOfRangeException`. SMTP command errors дополнительно могут содержать `statusCode`, `errorCode` и `mailbox`.

## Ограничения

- Операции синхронные: на время сетевого запроса текущий поток HiAsm занят.
- `MailSession` хранит конфигурацию, но не держит постоянное сетевое соединение.
- POP3 не поддерживает серверные папки как IMAP; `Folder` для POP3 фактически игнорируется backend-ом.
- Текущие HiAsm-элементы не имеют отдельных портов для backend-операций `check/checksmtp`, `version`, а также для backend-алиасов `imapServer`, `pop3Server`, `server`, `host` и поля `replyTo`.
- Старый ANSI HiAsm использует текущую Windows ANSI code page при конвертации строк. Backend пытается исправлять типичные случаи UTF-8/Windows-1251 mojibake в полученных текстах, но это не является гарантированной перекодировкой всех писем.
- Ошибки SMTP/IMAP/POP3 зависят от провайдера. Например, `535` обычно приходит от SMTP-сервера при отклонении аутентификации.
- Для заявлений о чистой совместимости используйте только результаты с пометкой `clean` или `clean-fpc2` в проектном `tests.md`.

## Лицензирование и notices

Код Pascal-элементов находится в репозитории с основным файлом лицензии [`../LICENSE`](../LICENSE), если отдельный файл не задает другое. Сведения о сторонних компонентах, включенных в `HiMailNative.dll` или использованных при ее сборке, вынесены в [`THIRD-PARTY-NOTICES.txt`](THIRD-PARTY-NOTICES.txt). Русское пояснение находится в [`THIRD-PARTY-NOTICES.ru.txt`](THIRD-PARTY-NOTICES.ru.txt).
