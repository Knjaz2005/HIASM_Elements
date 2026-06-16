# FPCBrowser

`FPCBrowser` - визуальный элемент `FPCWebBrowser` для встраивания Microsoft Edge WebView2. Он заменяет IE-based `WebBrowser` там, где нужен современный браузерный движок, но проект должен собираться в среде HiAsm с установленным комплектом FPC2 для x32/x64 в ANSI/Unicode-режимах.

English documentation: [`README.en.md`](README.en.md).

## Возможности

- Навигация по URL, `Refresh`, `Stop`, `Back`, `Forward`.
- Загрузка HTML-строки через WebView2 `NavigateToString`.
- Асинхронное чтение HTML текущей страницы.
- События URL, заголовка, загрузки, ошибок и запросов нового окна.
- Управление JavaScript-диалогами, контекстным меню, DevTools, popup-поведением, масштабом и темой WebView2.

## Состав

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

`Browser64.sha` - пример схемы HiAsm с элементом `FPCWebBrowser`, базовой навигацией, загрузкой HTML из текста и переключением темы.

## Требования

- Windows.
- WebView2 Runtime: системный Evergreen или Fixed Version через `BrowserExecutableFolder`.
- `WebView2Loader.dll` рядом с EXE в архитектурном подкаталоге:

```text
MyApp.exe
win-x32/WebView2Loader.dll
win-x64/WebView2Loader.dll
```

`LoaderDLL` может задать явный путь к DLL. Если `LoaderDLL` пустой или равен `WebView2Loader.dll`, элемент выбирает `win-x32` или `win-x64` по архитектуре сборки.

`WebView2Loader.dll` из этого пакета взят из NuGet-пакета `Microsoft.Web.WebView2` версии `1.0.4022.49`. Сам WebView2 Runtime в каталог не включен.

Локально проверенные метаданные включенных загрузчиков:

| Файл | File/Product version | Размер | SHA-256 |
| --- | --- | ---: | --- |
| `win-x32/WebView2Loader.dll` | `1.0.4022.49` | 124296 байт | `9DDE881D0CB0685053DA9F2EBF7A27737882682D2F907D42AF1C029DC603A0DC` |
| `win-x64/WebView2Loader.dll` | `1.0.4022.49` | 163208 байт | `12F7708910E1AAC5CC9AC43603D122F1D2E770AE2651830A07EF8B3117F28C55` |

## Совместимость

Минимальная поддерживаемая среда: `HiasmAltOriginal` с установленным поверх комплектом FPC2. Голый оригинальный D4 HiAsm и старый FPC 1.9.x больше не считаются тестовыми целями для этого элемента, потому что в них отличаются настройки условной компиляции и сопутствующая runtime-конфигурация.

Работа со старым FPC рассматривается только при установленном комплекте FPC2, который переопределяет часть знаков условной компиляции. В чистом HiAsm на старом FPC элемент, скорее всего, работать не будет. Дублированный комплект FPC2: <https://disk.yandex.ru/d/9nHdCgy8OygKmA>. Профильная тема форума HiAsm: <https://forum.hiasm.com/topic/61538/0>.

Проверяемые сборки:

- FPC2 x32 ANSI/Unicode.
- FPC2 x64 ANSI/Unicode.

## Свойства

| Свойство | Поведение |
| --- | --- |
| `URL` | Начальный URL и значение по умолчанию для `doNavigate`. Используется при старте, если до готовности WebView2 не был сохранен другой `doNavigate` или `doFromText`. |
| `LoaderDLL` | Явный путь к `WebView2Loader.dll`; применяется только при запуске WebView2. |
| `BrowserExecutableFolder` | Папка Fixed Version Runtime; пусто означает системный Evergreen Runtime. Применяется только при создании окружения. |
| `UserDataFolder` | Папка профиля WebView2; пусто означает профиль по умолчанию. Применяется только при создании окружения. |
| `Silent` | Отключает стандартные JavaScript-диалоги при создании контроллера. |
| `ContextMenu` | Включает или отключает стандартное контекстное меню WebView2 при создании контроллера. |
| `DevTools` | Разрешает или запрещает DevTools при создании контроллера. |
| `PopupWindow` | Если `False`, неотмененный запрос нового окна открывается в текущем браузере. Если `True`, запрос передается WebView2. |
| `Zoom` | Начальный масштаб, ограничивается диапазоном `25..500`. |
| `Theme` | Начальная тема WebView2: `Auto`, `Light` или `Dark`. В коде значения соответствуют `0`, `1`, `2`. |

## Рабочие точки

| Точка | Аргументы и влияние |
| --- | --- |
| `doNavigate` | Читает `URL`, иначе свойство `URL`. Пустая строка игнорируется. До готовности WebView2 сохраняет URL как отложенную навигацию; повторный вызов перезаписывает предыдущее отложенное значение. После отправки навигации изменение `URL` на нее не влияет. |
| `doFromText` | Читает HTML из `Text`. До готовности WebView2 сохраняет HTML как отложенную загрузку; повторный вызов перезаписывает предыдущее отложенное значение. После вызова изменение `Text` не влияет на сохраненный или начатый переход. |
| `doRefresh` | Без аргументов. Если WebView2 создан, вызывает `Reload`; до готовности игнорируется. |
| `doBack` | Без аргументов. В момент вызова проверяет `CanGoBack`; до готовности или без истории ничего не делает. |
| `doForward` | Без аргументов. В момент вызова проверяет `CanGoForward`; до готовности или без истории ничего не делает. |
| `doGetPage` | Без аргументов. Если WebView2 готов и нет активного запроса страницы, запускает чтение `document.documentElement.outerHTML`; результат приходит в `onPage` и `Page`. Повторный вызов до завершения текущего запроса игнорируется. |
| `doOpenDevTools` | Без аргументов. Если WebView2 создан, вызывает `OpenDevToolsWindow`; при `DevTools=False` WebView2 может отказать. |
| `doZoom` | Читает `Zoom`, иначе свойство `Zoom`. Значение ограничивается `25..500`. До готовности WebView2 сохраняется и применяется при создании контроллера; после готовности применяется сразу. |
| `doTheme` | Читает `Theme`, иначе свойство `Theme`. Значение ограничивается диапазоном `0..2`: `0` Auto, `1` Light, `2` Dark. До готовности WebView2 сохраняется и применяется при создании контроллера; после готовности применяется сразу. |
| `doStop` | Без аргументов. Если WebView2 создан, останавливает текущую загрузку; до готовности игнорируется. |

## События и данные

| Точка | Данные |
| --- | --- |
| `onNavigate` | Текущий URL при `SourceChanged`. |
| `onTitle` | Текущий заголовок документа. |
| `onStatus` | Диагностика WebView2: загрузчик, окружение, контроллер, навигация, размер, восстановление, ошибки. |
| `onProgress` | `0` при `NavigationStarting`, `65535` при `NavigationCompleted`. |
| `onLoad` | `1` при старте загрузки, `0` при завершении. |
| `onError` | Текст последней ошибки элемента или WebView2. |
| `onPage` | HTML после `doGetPage`. |
| `onNewWindow` | URI запроса нового окна. |
| `URL` | Входные данные для `doNavigate`; если не заданы, используется свойство `URL`. |
| `Text` | HTML-строка для `doFromText`. |
| `Zoom` | Входные данные для `doZoom`; если не заданы, используется свойство `Zoom`. |
| `Theme` | Входные данные для `doTheme`: `0` Auto, `1` Light, `2` Dark. |
| `Navigate` | Управляющий вход для `NavigationStarting`: если вернуть `1`, текущая навигация отменяется. Действует только синхронно на текущий старт. |
| `NewWindow` | Управляющий вход для запроса нового окна: если вернуть `1`, запрос отменяется. Иначе поведение определяет `PopupWindow`. |
| `CurrentURL` | Последний URL из `NavigationStarting` или `SourceChanged`. |
| `Page` | Последний HTML, полученный через `doGetPage`; очищается при старте новой навигации. |
| `Title` | Последний заголовок документа. |
| `BrowserVersion` | Версия WebView2 Runtime. |
| `LastError` | Последний текст ошибки. |

## Поведение

WebView2 создается асинхронно. После готовности контроллера выбирается одна стартовая загрузка: отложенный HTML из `doFromText`, иначе отложенный URL из `doNavigate`, иначе свойство `URL`.

Тема WebView2 применяется через `ICoreWebView2_13.Profile.PreferredColorScheme`. Она влияет на UI WebView2 и CSS media feature `prefers-color-scheme`, но не меняет оформление родительского окна HiAsm.

При падении render-процесса элемент делает одну попытку восстановления через `Reload`. Повторное падение передается в `onError` и `onStatus`.

## Ограничения

- `NavigateToString` загружает HTML без отдельной настройки base URL.
- `doGetPage` зависит от текущего DOM и выполнения JavaScript в странице.
- Управление темой требует WebView2 Runtime с поддержкой `ICoreWebView2_13`; при `Theme=Auto` старый runtime остается в системном режиме, при `Light`/`Dark` отсутствие интерфейса передается в `onError`/`onStatus`.
- Сетевые ошибки, CAPTCHA, антибот-проверки и политики сайтов не являются ошибками элемента.

## Лицензия

Код элемента: `GPL-3.0-or-later OR Commercial License`; текст GPL находится в корневом файле [`../LICENSE`](../LICENSE). Отдельный текст коммерческой лицензии в каталоге не включен.

Основной юридический файл по сторонним компонентам: [`THIRD-PARTY-NOTICES.txt`](THIRD-PARTY-NOTICES.txt). Русское пояснение: [`THIRD-PARTY-NOTICES.ru.txt`](THIRD-PARTY-NOTICES.ru.txt).
