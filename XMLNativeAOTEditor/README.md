# XMLNativeAOTEditor

`XMLNativeAOTEditor` - невизуальный элемент HiAsm для загрузки, навигации, чтения, изменения и сохранения XML через `XMLNativeAOTEditor.dll`. Pascal-часть остается тонкой оберткой HiAsm, а XML-разбор, XPath, namespace map и сериализация выполняются в NativeAOT DLL.

English documentation: [`README.en.md`](README.en.md).

## Возможности

- Загрузка XML из строки или файла.
- Создание нового XML-документа с заданным корневым элементом.
- XPath-выборка одного или нескольких element-узлов.
- Простой `NodePath`-адресатор для чтения и изменения одного известного element-узла без XPath.
- Работа с текущим узлом: чтение/замена текстового значения, получение XML узла, замена узла XML-фрагментом, удаление.
- Работа с атрибутами: чтение, установка, удаление, список JSON, перечисление по индексу.
- Добавление дочернего элемента по имени или готового XML-фрагмента.
- Namespace map для XPath и для имен элементов/атрибутов.
- Сериализация всего документа в строку или UTF-8 файл без BOM.
- Диагностика текущего узла через `NodeInfoJson`, диагностический путь `CurrentNodePath` и сведения о загруженной DLL через `BridgeInfo`.
- Единая схема результата: `OnDone=1` при успехе, `OnDone=0` и `OnError` при ошибке.

## Состав

```text
XMLNativeAOTEditor/
  README.md
  README.en.md
  THIRD-PARTY-NOTICES.txt
  THIRD-PARTY-NOTICES.ru.txt
  AOTXMLEditor.sha
  Element/0.1/
    XMLNativeAOTEditor.ini
    hiXMLNativeAOTEditor.pas
    XMLNativeAOTEditor.ico
  win-x86/XMLNativeAOTEditor.dll
  win-x64/XMLNativeAOTEditor.dll
```

`AOTXMLEditor.sha` - пример схемы HiAsm для ручной проверки элемента.

`win-x86` содержит 32-bit DLL, `win-x64` содержит 64-bit DLL.

## Требования

- Windows.
- Для FPC/FPC2-сборок - среда HiAsm с установленным комплектом FPC2, если используется соответствующая ветка компиляции.
- `XMLNativeAOTEditor.dll` рядом с генерируемым EXE в архитектурном подкаталоге:

```text
MyApp.exe
win-x86/XMLNativeAOTEditor.dll
win-x64/XMLNativeAOTEditor.dll
```

`XMLNativeAOTEditor.dll` собрана NativeAOT и не требует установленного .NET Runtime на целевой машине. По импортам DLL использует системные Windows API и Universal CRT `api-ms-win-crt-*`; на современных Windows это обычно системная часть ОС.

Проверенные локальные версии включенных DLL:

| Файл | FileVersion | ProductVersion |
| --- | --- | --- |
| `win-x86/XMLNativeAOTEditor.dll` | `1.1.0.0` | `1.1.0+a944a707a320d04b331083fc2e47eeb2a4887c6e` |
| `win-x64/XMLNativeAOTEditor.dll` | `1.1.0.0` | `1.1.0+a944a707a320d04b331083fc2e47eeb2a4887c6e` |

`doGetBridgeInfo` для x64 DLL возвращает, в частности:

```json
{
  "ok": true,
  "name": "XMLNativeAOTEditor",
  "version": "XMLNativeAOTEditor 1.1.0 NativeAOT",
  "architecture": "X64",
  "nativeAot": true,
  "xPath": true,
  "nodePath": true,
  "namespaces": true,
  "secureXmlReader": true,
  "stringContract": "UTF-8 input and CoTaskMem UTF-8 output; caller must invoke XMLNativeAOT_FreeString"
}
```

## Runtime DLL

```text
win-x86\XMLNativeAOTEditor.dll -> рядом с EXE для 32-bit сборки
win-x64\XMLNativeAOTEditor.dll -> рядом с EXE для 64-bit сборки
```

Поиск DLL выполняется один раз при первом обращении к bridge: соответствующий архитектуре подкаталог рядом с EXE, затем DLL рядом с EXE, затем стандартный Windows search path.

## Совместимость

По `tests.md` на момент подготовки документации:

- `clean-fpc2`: прямой compile-check `Element\0.1\hiXMLNativeAOTEditor.pas` прошел в чистой среде `HiasmFPCOriginal` для FPC2 `32A`, `32U`, `64A`, `64U` без изменения baseline-файлов.
- `author-working-only`: прямой compile-check прошел в рабочей среде автора `HiAsm` для Delphi 4 / Win32.
- `test-env-only`: прямой compile-check прошел в тестовой среде `HiAsm_fpc_gdi+` для FPC2 `32A`, `32U`, `64A`, `64U`.
- `app-scenario-only`: runtime harness прошел в прикладной среде `HI_REM_ACC_MANAGER` для Delphi 4 / Win32 и FPC2 / Win64.

Чистая проверка полного `.sha`-проекта в pristine-среде `HiasmFPCOriginal` не записана. Чистая проверка для исходного HiAsm 4 / old FPC также не записана; старый FPC harness проходил только в загрязненной baseline-среде и не считается `clean`.

Поэтому публично корректная формулировка совместимости: исходник элемента имеет `clean-fpc2` compile-check, а runtime-проверки записаны для рабочих и прикладных сред из `tests.md`.

## Модель работы

Элемент хранит native session handle в `SessionIDOut`. Сессия создается лениво при первой операции, которой нужна DLL. `doClose` уничтожает native session и очищает `LoadedXml`; в долгоживущих схемах его стоит вызывать явно, когда XML-документ больше не нужен.

Все операции синхронные. На время загрузки, XPath-запроса, изменения или сохранения занят текущий поток HiAsm.

Входные строки передаются в DLL как UTF-8. Для старого ANSI HiAsm Pascal-обертка конвертирует строку из текущей ANSI code page в UTF-8 и обратно.

`LoadedXml` - это не всегда "текущий XML после всех изменений":

- после `doLoadXmlString` хранит исходную загруженную строку;
- после `doLoadXmlFile` хранит сериализованный snapshot загруженного документа;
- после `doCreateNewXml` хранит сериализованный snapshot нового документа;
- после изменений документа используйте `doSaveXmlToString` и `SavedXmlString`.

Перед каждой операцией очищаются большинство промежуточных выходов: `QueryResult`, `NodeValue`, `AttributeValue`, `AttributeListJson`, `SavedXmlString`, `NodeInfoJson`, `NodeXml`, индексы и счетчики. `ErrorMessage` и `ErrorCode` очищаются в начале новой операции и заполняются при ошибке.

## NodePath

`NodePathIn` - простой адрес одного element-узла. Это не XPath и не язык запросов, а короткий путь для типовых схем, где нужно прочитать или изменить известный узел:

```text
/root/items/item[2]/name
/items/item[2]/name
./child
../sibling
```

Правила:

- индексы одно-based; если индекс не указан, используется `[1]`;
- `/root/items` и `/items` оба допустимы для документа с корнем `root`; `CurrentNodePath` всегда возвращает канонический путь с корнем;
- `./` и `../` работают относительно текущего узла;
- имя без namespace prefix выбирает по local-name, если среди sibling-узлов нет одноименных элементов из разных namespaces;
- для точного namespace используйте настроенный `prefix:name` или форму `{namespace-uri}name`;
- `NodePath` адресует только элементы; атрибуты читаются и пишутся существующими точками `AttributeNameIn`/`doGetAttributeValue`/`doSetAttributeValue` после выбора элемента.

`doSelectNodePath` возвращает `1` или `0` в `QueryResult`. `doPathExists` проверяет путь без смены текущего узла и заполняет `PathExists`/`ResolvedNodePath`. `doEnsureNodePath` создает недостающие элементы, делает целевой узел текущим, а в `QueryResult` помещает количество созданных элементов.

Ошибки NodePath возвращают коды `PATH_SYNTAX`, `PATH_INDEX`, `PATH_NOT_FOUND`, `PATH_NAMESPACE`, `PATH_AMBIGUOUS`, `PATH_TARGET`, `PATH_ROOT_MISMATCH`.

## Свойства

| Свойство | Значения | Поведение |
| --- | --- | --- |
| `Formatting` | `0` compact, `1` indented | Формат сериализации для `doSaveXmlToString`, `doSaveXmlToFile`, `doGetNodeXml`, перечисления узлов. Может быть переопределено входом `FormattingIn`. |
| `PreserveWhitespace` | `True`/`False` | Передается в XML reader при загрузке строки или файла. |
| `DtdProcessing` | `0` prohibit, `1` ignore, `2` parse | Режим обработки DTD при загрузке. Может быть переопределен входом `DtdProcessingIn`; значения вне диапазона ограничиваются `0..2`. |
| `MaxCharactersInDocument` | число, `0` без лимита | Ограничение размера XML при загрузке. Может быть переопределено входом `MaxCharactersInDocumentIn`; отрицательные значения становятся `0`. |
| `AutoNodeInfo` | `True`/`False` | При `True` после загрузки, выбора и изменений автоматически обновляет `NodeInfoJson` и вызывает `OnNodeInfoRetrieved`. |

## Рабочие точки

| Точка | Входы | Успешный результат |
| --- | --- | --- |
| `doLoadXmlString` | `XmlStringIn`, `DtdProcessingIn`, `MaxCharactersInDocumentIn` | Загружает XML из строки, вызывает `OnXmlLoaded`, обновляет `SelectedCount`, `CurrentNodePath`, при `AutoNodeInfo` - `NodeInfoJson`. |
| `doLoadXmlFile` | `FilePathIn`, `FormattingIn`, `DtdProcessingIn`, `MaxCharactersInDocumentIn` | Загружает XML из файла, затем сериализует snapshot в `LoadedXml`. |
| `doCreateNewXml` | `RootNameIn`, `FormattingIn` | Создает документ с корнем, вызывает `OnXmlLoaded`, `OnChanged`. |
| `doSelectNodes` | `XPathIn` | Выбирает element-узлы, пишет количество в `QueryResult` и `SelectedCount`; первый узел становится текущим при наличии совпадений. |
| `doSelectSingleNode` | `XPathIn` | Выбирает первый element-узел, вызывает `OnQueryExecuted` и `OnCurrentNodeChanged`. |
| `doSetCurrentNode` | `XPathIn` | Делает текущим узел по XPath без изменения документа. |
| `doSelectByIndex` | `IndexIn` | Делает текущим узел из текущей выборки по нулевому индексу. |
| `doSelectNodePath` | `NodePathIn` | Делает текущим один element-узел по простому пути; `QueryResult` получает `1` или `0`, `ResolvedNodePath` - канонический путь. |
| `doPathExists` | `NodePathIn` | Проверяет путь без смены текущего узла, заполняет `PathExists` и `ResolvedNodePath`. |
| `doEnsureNodePath` | `NodePathIn` | Создает отсутствующие элементы по пути, делает целевой узел текущим, пишет количество созданных узлов в `QueryResult`. |
| `doEnumSelectedNodes` | `FormattingIn` | Проходит по текущей выборке, обновляет `CurrentIndex`, `CurrentNodePath`, `NodeXml`, вызывает `OnNode` для каждого узла. |
| `doGetValue` | нет | Читает текстовое значение текущего элемента в `NodeValue`, вызывает `OnValueRetrieved`. |
| `doSetValue` | `NewValueIn` | Заменяет текстовое значение текущего элемента, вызывает `OnValueSet`, `OnChanged`. |
| `doGetPathValue` | `NodePathIn` | Читает текстовое значение узла по `NodePathIn`, делает его текущим, вызывает `OnValueRetrieved`. |
| `doSetPathValue` | `NodePathIn`, `NewValueIn` | Заменяет текстовое значение узла по `NodePathIn`, делает его текущим, вызывает `OnValueSet`, `OnChanged`. |
| `doGetAttributeValue` | `AttributeNameIn` | Читает атрибут текущего элемента в `AttributeValue`. |
| `doSetAttributeValue` | `AttributeNameIn`, `AttributeValueIn` | Устанавливает атрибут текущего элемента, вызывает `OnAttributeSet`, `OnChanged`. |
| `doGetAttributeList` | нет | Возвращает JSON-список атрибутов в `AttributeListJson`, обновляет `AttributeCount`. |
| `doEnumAttributes` | нет | Перечисляет атрибуты текущего элемента, обновляет `AttributeIndex`, `AttributeName`, `AttributeValue`, вызывает `OnAttribute`. |
| `doRemoveAttribute` | `AttributeNameIn` | Удаляет атрибут текущего элемента, вызывает `OnAttributeRemoved`, `OnChanged`. |
| `doAddChildNode` | `ChildNameIn` | Добавляет пустой дочерний элемент и делает его текущим. |
| `doAddChildXml` | `ChildXmlIn` | Добавляет XML element-фрагмент как дочерний узел и делает добавленный узел текущим. |
| `doDeleteNode` | нет | Удаляет текущий элемент; удаление корня очищает документ. |
| `doGetNodeXml` | `FormattingIn` | Сериализует текущий элемент в `NodeXml`. |
| `doSetNodeXml` | `NodeXmlIn` | Заменяет текущий элемент XML element-фрагментом. |
| `doGetPathXml` | `NodePathIn`, `FormattingIn` | Сериализует узел по `NodePathIn` в `NodeXml` и делает его текущим. |
| `doSetPathXml` | `NodePathIn`, `NodeXmlIn` | Заменяет узел по `NodePathIn` XML element-фрагментом и делает новый узел текущим. |
| `doDeletePath` | `NodePathIn` | Удаляет узел по `NodePathIn`; после удаления текущим становится родитель, а удаление корня очищает документ. |
| `doSaveXmlToString` | `FormattingIn` | Сериализует документ в `SavedXmlString` и отправляет его через `OnXmlSaved`. |
| `doSaveXmlToFile` | `FilePathIn`, `FormattingIn` | Сериализует документ в UTF-8 файл без BOM, вызывает `OnXmlSaved` без строки. |
| `doSetNamespacePrefix` | `NamespacePrefixIn`, `NamespaceUriIn` | Добавляет или обновляет namespace prefix mapping; пустой URI удаляет prefix. |
| `doSetNamespacesJson` | `NamespacesJsonIn` | Заменяет всю namespace map из JSON object вида `{"x":"urn:test"}`. |
| `doClearNamespaces` | нет | Очищает namespace map. |
| `doGetBridgeInfo` | нет | Возвращает JSON с metadata DLL и ABI contract в `BridgeInfo`. |
| `doGetNodeInfo` | нет | Обновляет `NodeInfoJson` для текущего узла. |
| `doClose` | нет | Уничтожает native session, сбрасывает `SessionIDOut` в `0`, очищает `LoadedXml`. |

Имена элементов и атрибутов в `RootNameIn`, `ChildNameIn`, `AttributeNameIn` могут использовать настроенный prefix или форму `{uri}local`, если это поддерживается соответствующей backend-операцией.

## События и выходы

| Событие | Когда вызывается |
| --- | --- |
| `OnXmlLoaded` | После успешной загрузки XML или создания нового документа. |
| `OnQueryExecuted` | После `doSelectNodes` или `doSelectSingleNode`; передает `QueryResult`. |
| `OnCurrentNodeChanged` | После смены текущего узла; передает `CurrentNodePath`. |
| `OnPathResolved` | После NodePath-операций; передает `ResolvedNodePath` или пустую строку, если путь не найден. |
| `OnNode` | Для каждого узла при `doEnumSelectedNodes`; передает `NodeXml`. |
| `OnValueRetrieved`, `OnValueSet` | После чтения или записи значения текущего элемента. |
| `OnAttributeRetrieved`, `OnAttributeSet`, `OnAttributeRemoved` | После операций с атрибутом. |
| `OnAttributeList`, `OnAttribute` | После получения списка атрибутов или при перечислении. |
| `OnNodeAdded`, `OnNodeDeleted`, `OnNodeXmlRetrieved`, `OnNodeXmlSet` | После операций с узлами. |
| `OnXmlSaved` | После сохранения в строку или файл. Для строки передает `SavedXmlString`. |
| `OnNamespacesChanged` | После изменения namespace map. |
| `OnBridgeInfo` | После `doGetBridgeInfo`; передает `BridgeInfo`. |
| `OnNodeInfoRetrieved` | После ручного или автоматического обновления `NodeInfoJson`. |
| `OnChanged` | После мутации документа. |
| `OnError` | При ошибке bridge, XML, XPath, IO, JSON или состояния; передает `ErrorMessage`. |
| `OnDone` | После каждой операции: `1` при успехе, `0` при ошибке. |

| Выход | Содержимое |
| --- | --- |
| `LoadedXml` | Последняя загруженная строка или snapshot после file load/create. |
| `QueryResult` | Текстовое количество выбранных узлов; для `doSelectNodePath` - `1`/`0`, для `doEnsureNodePath` - количество созданных элементов. |
| `NodeValue` | Значение текущего элемента после `doGetValue` или `doSetValue`. |
| `AttributeName`, `AttributeValue` | Текущий атрибут при операциях и перечислении. |
| `AttributeListJson` | JSON-объект с атрибутами текущего элемента. |
| `SavedXmlString` | Документ после `doSaveXmlToString`. |
| `ErrorMessage`, `ErrorCode` | Текст последней ошибки и код из строки `ERROR: CODE: message`. |
| `NodeInfoJson` | JSON-описание текущего узла, его атрибутов и дочерних element-узлов. |
| `BridgeInfo` | JSON metadata загруженной DLL. |
| `NodeXml` | XML текущего или перечисляемого узла. |
| `CurrentNodePath` | Диагностический путь вида `/{uri}root[1]/{uri}item[2]`; это не входной XPath. |
| `ResolvedNodePath` | Канонический путь, полученный из `NodePathIn`, или пустая строка, если путь не найден. |
| `SelectedCount`, `CurrentIndex` | Размер текущей выборки и нулевой индекс текущего/перечисляемого узла. |
| `AttributeCount`, `AttributeIndex` | Количество атрибутов и нулевой индекс при перечислении. |
| `PathExists` | `1`, если последняя NodePath-операция нашла или создала цель; иначе `0`. |
| `SessionIDOut` | Native session handle; `0` означает отсутствие активной сессии. |

## JSON-форматы

`AttributeListJson`:

```json
{
  "ok": true,
  "count": 2,
  "attributes": [
    {
      "name": "id",
      "fullName": "id",
      "namespaceUri": "",
      "value": "1"
    },
    {
      "name": "active",
      "fullName": "active",
      "namespaceUri": "",
      "value": "true"
    }
  ]
}
```

`NodeInfoJson`:

```json
{
  "ok": true,
  "node": {
    "name": "item",
    "fullName": "{urn:default}item",
    "namespaceUri": "urn:default",
    "path": "/{urn:default}root[1]/{urn:default}item[1]",
    "value": "One100",
    "attributeCount": 2,
    "childElementCount": 2,
    "hasText": false,
    "hasMixedContent": false,
    "attributes": [],
    "children": []
  }
}
```

Фактические массивы `attributes` и `children` заполняются объектами с именем, полным именем, namespace URI, путем, значением и счетчиками.

## XPath и namespaces

XPath-запросы выполняются по element-узлам. Для XML с default namespace нельзя писать неперфиксированный XPath вроде `/root/item`; нужно заранее назначить prefix и использовать его:

```json
{"d":"urn:default","x":"urn:x"}
```

Затем:

```text
/d:root/d:item[@id='1']/x:value
```

Namespace map задается через `doSetNamespacePrefix` или целиком через `doSetNamespacesJson`. Эта map хранится в native session до `doClearNamespaces`, `doSetNamespacesJson`, `doClose` или уничтожения сессии.

`CurrentNodePath` использует Clark notation `{uri}local` и one-based sibling indexes. Он удобен для диагностики и логов, но его не нужно напрямую подставлять в `XPathIn`.

## Ошибки

Успех native-операции определяется отсутствием префикса `ERROR:` в возвращенной строке. При ошибке элемент:

1. записывает полный текст в `ErrorMessage`;
2. извлекает код в `ErrorCode` из формата `ERROR: CODE: message`;
3. вызывает `OnError`;
4. вызывает `OnDone` со значением `0`.

Ошибки самой Pascal-обертки могут иметь коды `BRIDGE_LOAD`, `BRIDGE_EXPORT`, `SESSION`, `STATE`. Остальные коды приходят из NativeAOT backend и относятся к XML, XPath, IO, JSON или состоянию документа.

## Основной сценарий

1. Загрузить XML через `doLoadXmlString` или `doLoadXmlFile`, либо создать новый документ через `doCreateNewXml`.
2. Если XML использует namespaces, вызвать `doSetNamespacePrefix` или `doSetNamespacesJson`.
3. Выполнить `doSelectSingleNode` для операции над одним узлом или `doSelectNodes` для набора.
4. Проверить `OnDone` и при необходимости `SelectedCount`.
5. Выполнить чтение или изменение текущего узла.
6. После изменений вызвать `doSaveXmlToString` или `doSaveXmlToFile`.
7. Вызвать `doClose`, когда session больше не нужна.

## Основы составления xpatch

В текущей версии элемента нет встроенной точки `doApplyPatch` и нет встроенного парсера `xpatch`. `xpatch` должен быть прикладным описанием набора операций, которое ваша схема HiAsm или отдельный parser разбирает и применяет через рабочие точки `XMLNativeAOTEditor`.

Надежная операция `xpatch` должна содержать:

- `op` - тип действия;
- `xpath` - адрес целевого element-узла;
- данные операции: новое значение, имя атрибута, XML-фрагмент, имя дочернего элемента;
- ожидаемое количество узлов, если операция должна быть строгой;
- namespace map, если XML содержит namespaces.

Рекомендуемое соответствие операций портам элемента:

| Операция xpatch | Последовательность в элементе |
| --- | --- |
| `set-value` | `XPathIn` -> `doSelectSingleNode`, затем `NewValueIn` -> `doSetValue`. |
| `set-attribute` | `doSelectSingleNode`, затем `AttributeNameIn` + `AttributeValueIn` -> `doSetAttributeValue`. |
| `remove-attribute` | `doSelectSingleNode`, затем `AttributeNameIn` -> `doRemoveAttribute`. |
| `add-child` | `doSelectSingleNode` родителя, затем `ChildNameIn` -> `doAddChildNode`. |
| `add-child-xml` | `doSelectSingleNode` родителя, затем `ChildXmlIn` -> `doAddChildXml`. |
| `replace-node` | `doSelectSingleNode`, затем `NodeXmlIn` -> `doSetNodeXml`. |
| `delete-node` | `doSelectSingleNode`, затем `doDeleteNode`. |
| `save` | `doSaveXmlToString` или `FilePathIn` -> `doSaveXmlToFile`. |

Пример прикладного JSON-представления `xpatch`:

```json
{
  "namespaces": {
    "d": "urn:default",
    "x": "urn:x"
  },
  "operations": [
    {
      "op": "set-attribute",
      "xpath": "/d:root/d:item[@id='1']",
      "name": "active",
      "value": "false",
      "expect": 1
    },
    {
      "op": "set-value",
      "xpath": "/d:root/d:item[@id='1']/x:value",
      "value": "101",
      "expect": 1
    },
    {
      "op": "add-child-xml",
      "xpath": "/d:root",
      "xml": "<item xmlns=\"urn:default\" id=\"3\" active=\"true\"><name>Three</name></item>",
      "expect": 1
    }
  ]
}
```

Как применять такой patch в схеме:

1. Перед первой операцией передать `namespaces` в `NamespacesJsonIn` и вызвать `doSetNamespacesJson`.
2. Для каждой операции передать `xpath` в `XPathIn` и вызвать `doSelectSingleNode`.
3. Проверить `OnDone=1` и `SelectedCount=1`, если `expect` равен `1`.
4. Передать данные операции в соответствующие входы элемента и вызвать рабочую точку изменения.
5. После каждого изменения проверять `OnDone`; при `OnDone=0` остановить patch и читать `ErrorMessage`/`ErrorCode`.
6. После всех операций сохранить документ.

Практические правила:

- Пишите XPath максимально устойчивым: лучше `//*[@id='42']` или `/d:root/d:item[@code='A']`, чем позиционный `/d:root/d:item[3]`, если до этого patch добавляет или удаляет соседние узлы.
- Для одиночных изменений требуйте `SelectedCount=1`. Если совпадений `0` или больше `1`, это обычно отдельная ошибка patch-сценария.
- Удаления выполняйте от более глубоких и конкретных узлов к родителям, чтобы предыдущая операция не изменила адрес следующей.
- Создание родителей должно идти раньше создания дочерних узлов.
- `ChildXmlIn` и `NodeXmlIn` должны быть well-formed XML element-фрагментами. Текстовые значения для `doSetValue` передаются как строки, не как XML.
- В XML с default namespace всегда задавайте prefix в `NamespacesJsonIn`; неперфиксированный XPath не выбирает такие элементы.
- Атрибуты с namespace указывайте через настроенный prefix или `{uri}local`; обычные атрибуты без namespace передаются простым именем.
- Не рассчитывайте на транзакционность: элемент применяет операции сразу. Если нужен rollback, заранее сохраните исходный XML через `doSaveXmlToString`.

## Ограничения

- Операции синхронные и могут блокировать UI-поток на больших XML-файлах.
- Текущим узлом является element-узел; работа с comment, processing instruction и отдельными text-node не вынесена отдельными портами.
- Встроенного undo/redo, diff или atomic patch нет.
- `LoadedXml` не обновляется автоматически после каждой мутации.
- DTD parsing включается только при `DtdProcessing=2`; по умолчанию используется режим `0` prohibit.
- Для заявлений о чистой совместимости используйте только результаты из `tests.md` с пометками `clean` или `clean-fpc2`.

## Лицензирование и notices

Код элемента находится в репозитории с основным файлом лицензии [`../LICENSE`](../LICENSE). Сведения о включенных NativeAOT runtime components и их notices вынесены в [`THIRD-PARTY-NOTICES.txt`](THIRD-PARTY-NOTICES.txt). Русское пояснение находится в [`THIRD-PARTY-NOTICES.ru.txt`](THIRD-PARTY-NOTICES.ru.txt).
