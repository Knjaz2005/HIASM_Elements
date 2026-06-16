# XMLNativeAOTEditor

`XMLNativeAOTEditor` is a non-visual HiAsm element for loading, navigating, reading, editing, and saving XML through `XMLNativeAOTEditor.dll`. The Pascal side is a thin HiAsm wrapper; XML parsing, XPath, namespace mapping, and serialization are handled by the NativeAOT DLL.

Russian documentation: [`README.md`](README.md).

## Features

- Load XML from a string or a file.
- Create a new XML document with a selected root element.
- Select one or more element nodes by XPath.
- Use simple `NodePath` addressing to read or edit one known element node without XPath.
- Work with the current node: read/replace text value, get node XML, replace the node with an XML fragment, delete the node.
- Work with attributes: read, set, remove, JSON list, and indexed enumeration.
- Add a child element by name or append an XML fragment.
- Namespace mapping for XPath and element/attribute names.
- Serialize the whole document to a string or a UTF-8 file without BOM.
- Inspect the current node through `NodeInfoJson`, diagnostic `CurrentNodePath`, and loaded-DLL metadata through `BridgeInfo`.
- Uniform completion signal: `OnDone=1` on success, `OnDone=0` plus `OnError` on failure.

## Layout

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

`AOTXMLEditor.sha` is a HiAsm sample scheme for manual element checks.

`win-x86` contains the 32-bit DLL, and `win-x64` contains the 64-bit DLL.

## Requirements

- Windows.
- A HiAsm/Delphi tree where the element `.ini`, `.pas`, and `.ico` files can be installed.
- For FPC/FPC2 builds, a HiAsm environment with the FPC2 kit installed when that compiler path is used.
- `XMLNativeAOTEditor.dll` next to the generated EXE in an architecture subfolder:

```text
MyApp.exe
win-x86/XMLNativeAOTEditor.dll
win-x64/XMLNativeAOTEditor.dll
```

`XMLNativeAOTEditor.dll` is built with NativeAOT and does not require an installed .NET Runtime on the target machine. Based on the DLL imports, it uses system Windows APIs and Universal CRT `api-ms-win-crt-*`; on modern Windows this is normally part of the OS.

Locally verified versions of the included DLLs:

| File | FileVersion | ProductVersion |
| --- | --- | --- |
| `win-x86/XMLNativeAOTEditor.dll` | `1.1.0.0` | `1.1.0+a944a707a320d04b331083fc2e47eeb2a4887c6e` |
| `win-x64/XMLNativeAOTEditor.dll` | `1.1.0.0` | `1.1.0+a944a707a320d04b331083fc2e47eeb2a4887c6e` |

For the x64 DLL, `doGetBridgeInfo` returns, among other fields:

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
win-x86\XMLNativeAOTEditor.dll -> next to the EXE for 32-bit builds
win-x64\XMLNativeAOTEditor.dll -> next to the EXE for 64-bit builds
```

DLL lookup happens once on the first bridge access: the architecture-matching subfolder next to the EXE, then the DLL next to the EXE, then the normal Windows search path.

## Compatibility

According to `tests.md` at the time this documentation was prepared:

- `clean-fpc2`: direct compile-check of `Element\0.1\hiXMLNativeAOTEditor.pas` passed in the clean `HiasmFPCOriginal` environment for FPC2 `32A`, `32U`, `64A`, `64U` without changing baseline files.
- `author-working-only`: direct compile-check passed in the author's working `HiAsm` environment for Delphi 4 / Win32.
- `test-env-only`: direct compile-check passed in the `HiAsm_fpc_gdi+` test environment for FPC2 `32A`, `32U`, `64A`, `64U`.
- `app-scenario-only`: runtime harness passed in the `HI_REM_ACC_MANAGER` application environment for Delphi 4 / Win32 and FPC2 / Win64.

A clean full `.sha` project check in the pristine `HiasmFPCOriginal` environment is not recorded. A clean check for original HiAsm 4 / old FPC is also not recorded; the old FPC harness passed only in a modified baseline environment and is not counted as `clean`.

Therefore the precise public compatibility statement is: the element source has a `clean-fpc2` compile-check, while runtime checks are recorded for the working and application environments listed in `tests.md`.

## Runtime Model

The element stores the native session handle in `SessionIDOut`. The session is created lazily by the first operation that needs the DLL. `doClose` destroys the native session and clears `LoadedXml`; long-lived schemes should call it explicitly when the XML document is no longer needed.

All operations are synchronous. Loading, XPath queries, edits, and saving occupy the current HiAsm thread until completion.

Input strings are passed to the DLL as UTF-8. For old ANSI HiAsm, the Pascal wrapper converts strings from the current ANSI code page to UTF-8 and back.

`LoadedXml` is not always "the current XML after all edits":

- after `doLoadXmlString`, it stores the original loaded string;
- after `doLoadXmlFile`, it stores a serialized snapshot of the loaded document;
- after `doCreateNewXml`, it stores a serialized snapshot of the new document;
- after document edits, use `doSaveXmlToString` and `SavedXmlString`.

Before each operation, most intermediate outputs are cleared: `QueryResult`, `NodeValue`, `AttributeValue`, `AttributeListJson`, `SavedXmlString`, `NodeInfoJson`, `NodeXml`, indexes, and counters. `ErrorMessage` and `ErrorCode` are cleared at the start of a new operation and filled on failure.

## NodePath

`NodePathIn` is a simple address for one element node. It is not XPath and not
a query language; it is a short path for common schemes that need to read or
edit a known node:

```text
/root/items/item[2]/name
/items/item[2]/name
./child
../sibling
```

Rules:

- indexes are one-based; a missing index means `[1]`;
- `/root/items` and `/items` are both valid for a document whose root is `root`; `CurrentNodePath` always emits the canonical path with the root;
- `./` and `../` are relative to the current node;
- a name without a namespace prefix matches by local-name when all matching sibling elements share the same namespace;
- for exact namespace addressing, use configured `prefix:name` or `{namespace-uri}name`;
- `NodePath` addresses elements only; attributes are read and written through the existing `AttributeNameIn`/`doGetAttributeValue`/`doSetAttributeValue` points after selecting the element.

`doSelectNodePath` returns `1` or `0` in `QueryResult`. `doPathExists` checks
the path without changing the current node and fills `PathExists` and
`ResolvedNodePath`. `doEnsureNodePath` creates missing elements, makes the
target current, and puts the created element count into `QueryResult`.

NodePath errors use `PATH_SYNTAX`, `PATH_INDEX`, `PATH_NOT_FOUND`,
`PATH_NAMESPACE`, `PATH_AMBIGUOUS`, `PATH_TARGET`, and `PATH_ROOT_MISMATCH`.

## Properties

| Property | Values | Behavior |
| --- | --- | --- |
| `Formatting` | `0` compact, `1` indented | Serialization format for `doSaveXmlToString`, `doSaveXmlToFile`, `doGetNodeXml`, and node enumeration. Can be overridden through `FormattingIn`. |
| `PreserveWhitespace` | `True`/`False` | Passed to the XML reader while loading a string or file. |
| `DtdProcessing` | `0` prohibit, `1` ignore, `2` parse | DTD mode while loading. Can be overridden through `DtdProcessingIn`; values are clamped to `0..2`. |
| `MaxCharactersInDocument` | number, `0` unlimited | XML size limit while loading. Can be overridden through `MaxCharactersInDocumentIn`; negative values become `0`. |
| `AutoNodeInfo` | `True`/`False` | When `True`, automatically refreshes `NodeInfoJson` and fires `OnNodeInfoRetrieved` after load, select, and edit operations. |

## Work Points

| Work point | Inputs | Successful result |
| --- | --- | --- |
| `doLoadXmlString` | `XmlStringIn`, `DtdProcessingIn`, `MaxCharactersInDocumentIn` | Loads XML from a string, fires `OnXmlLoaded`, updates `SelectedCount`, `CurrentNodePath`, and, with `AutoNodeInfo`, `NodeInfoJson`. |
| `doLoadXmlFile` | `FilePathIn`, `FormattingIn`, `DtdProcessingIn`, `MaxCharactersInDocumentIn` | Loads XML from a file and serializes a snapshot into `LoadedXml`. |
| `doCreateNewXml` | `RootNameIn`, `FormattingIn` | Creates a document with a root element, fires `OnXmlLoaded` and `OnChanged`. |
| `doSelectNodes` | `XPathIn` | Selects element nodes, writes the count into `QueryResult` and `SelectedCount`; the first match becomes current when matches exist. |
| `doSelectSingleNode` | `XPathIn` | Selects the first element node and fires `OnQueryExecuted` and `OnCurrentNodeChanged`. |
| `doSetCurrentNode` | `XPathIn` | Makes a node current by XPath without editing the document. |
| `doSelectByIndex` | `IndexIn` | Makes a node from the current selection current by zero-based index. |
| `doSelectNodePath` | `NodePathIn` | Makes one element node current by simple path; `QueryResult` receives `1` or `0`, `ResolvedNodePath` receives the canonical path. |
| `doPathExists` | `NodePathIn` | Checks the path without changing the current node and fills `PathExists` and `ResolvedNodePath`. |
| `doEnsureNodePath` | `NodePathIn` | Creates missing elements along the path, makes the target current, and writes the created-node count to `QueryResult`. |
| `doEnumSelectedNodes` | `FormattingIn` | Iterates over the current selection, updates `CurrentIndex`, `CurrentNodePath`, `NodeXml`, and fires `OnNode` for each node. |
| `doGetValue` | none | Reads current element text value into `NodeValue` and fires `OnValueRetrieved`. |
| `doSetValue` | `NewValueIn` | Replaces current element text value and fires `OnValueSet`, `OnChanged`. |
| `doGetPathValue` | `NodePathIn` | Reads the text value of the node addressed by `NodePathIn`, makes it current, and fires `OnValueRetrieved`. |
| `doSetPathValue` | `NodePathIn`, `NewValueIn` | Replaces the text value of the node addressed by `NodePathIn`, makes it current, and fires `OnValueSet`, `OnChanged`. |
| `doGetAttributeValue` | `AttributeNameIn` | Reads a current-element attribute into `AttributeValue`. |
| `doSetAttributeValue` | `AttributeNameIn`, `AttributeValueIn` | Sets a current-element attribute and fires `OnAttributeSet`, `OnChanged`. |
| `doGetAttributeList` | none | Returns a JSON attribute list in `AttributeListJson` and updates `AttributeCount`. |
| `doEnumAttributes` | none | Enumerates current-element attributes, updates `AttributeIndex`, `AttributeName`, `AttributeValue`, and fires `OnAttribute`. |
| `doRemoveAttribute` | `AttributeNameIn` | Removes a current-element attribute and fires `OnAttributeRemoved`, `OnChanged`. |
| `doAddChildNode` | `ChildNameIn` | Adds an empty child element and makes it current. |
| `doAddChildXml` | `ChildXmlIn` | Appends an XML element fragment as a child and makes the added node current. |
| `doDeleteNode` | none | Deletes the current element; deleting the root clears the document. |
| `doGetNodeXml` | `FormattingIn` | Serializes the current element into `NodeXml`. |
| `doSetNodeXml` | `NodeXmlIn` | Replaces the current element with an XML element fragment. |
| `doGetPathXml` | `NodePathIn`, `FormattingIn` | Serializes the node addressed by `NodePathIn` into `NodeXml` and makes it current. |
| `doSetPathXml` | `NodePathIn`, `NodeXmlIn` | Replaces the node addressed by `NodePathIn` with an XML element fragment and makes the new node current. |
| `doDeletePath` | `NodePathIn` | Deletes the node addressed by `NodePathIn`; after deletion the parent becomes current, and deleting the root clears the document. |
| `doSaveXmlToString` | `FormattingIn` | Serializes the document into `SavedXmlString` and sends it through `OnXmlSaved`. |
| `doSaveXmlToFile` | `FilePathIn`, `FormattingIn` | Serializes the document to a UTF-8 file without BOM and fires `OnXmlSaved` without a string payload. |
| `doSetNamespacePrefix` | `NamespacePrefixIn`, `NamespaceUriIn` | Adds or updates a namespace prefix mapping; an empty URI removes the prefix. |
| `doSetNamespacesJson` | `NamespacesJsonIn` | Replaces the whole namespace map from a JSON object like `{"x":"urn:test"}`. |
| `doClearNamespaces` | none | Clears the namespace map. |
| `doGetBridgeInfo` | none | Returns loaded-DLL metadata and ABI contract JSON in `BridgeInfo`. |
| `doGetNodeInfo` | none | Refreshes `NodeInfoJson` for the current node. |
| `doClose` | none | Destroys the native session, resets `SessionIDOut` to `0`, and clears `LoadedXml`. |

Element and attribute names in `RootNameIn`, `ChildNameIn`, and `AttributeNameIn` can use a configured prefix or `{uri}local` form when the corresponding backend operation supports it.

## Events and Outputs

| Event | When it fires |
| --- | --- |
| `OnXmlLoaded` | After successful XML load or new document creation. |
| `OnQueryExecuted` | After `doSelectNodes` or `doSelectSingleNode`; sends `QueryResult`. |
| `OnCurrentNodeChanged` | After the current node changes; sends `CurrentNodePath`. |
| `OnPathResolved` | After NodePath operations; sends `ResolvedNodePath` or an empty string when the path is not found. |
| `OnNode` | For each node during `doEnumSelectedNodes`; sends `NodeXml`. |
| `OnValueRetrieved`, `OnValueSet` | After reading or writing the current element value. |
| `OnAttributeRetrieved`, `OnAttributeSet`, `OnAttributeRemoved` | After attribute operations. |
| `OnAttributeList`, `OnAttribute` | After getting the attribute list or during enumeration. |
| `OnNodeAdded`, `OnNodeDeleted`, `OnNodeXmlRetrieved`, `OnNodeXmlSet` | After node operations. |
| `OnXmlSaved` | After saving to string or file. For string save, sends `SavedXmlString`. |
| `OnNamespacesChanged` | After changing the namespace map. |
| `OnBridgeInfo` | After `doGetBridgeInfo`; sends `BridgeInfo`. |
| `OnNodeInfoRetrieved` | After manual or automatic `NodeInfoJson` refresh. |
| `OnChanged` | After a document mutation. |
| `OnError` | On bridge, XML, XPath, IO, JSON, or state errors; sends `ErrorMessage`. |
| `OnDone` | After each operation: `1` on success, `0` on failure. |

| Output | Contents |
| --- | --- |
| `LoadedXml` | Last loaded string or snapshot after file load/create. |
| `QueryResult` | Selected-node count as text; for `doSelectNodePath`, `1`/`0`; for `doEnsureNodePath`, the created-element count. |
| `NodeValue` | Current element value after `doGetValue` or `doSetValue`. |
| `AttributeName`, `AttributeValue` | Current attribute during operations and enumeration. |
| `AttributeListJson` | JSON object with current-element attributes. |
| `SavedXmlString` | Document after `doSaveXmlToString`. |
| `ErrorMessage`, `ErrorCode` | Last error text and code parsed from `ERROR: CODE: message`. |
| `NodeInfoJson` | JSON description of the current node, attributes, and child element summaries. |
| `BridgeInfo` | Loaded-DLL metadata JSON. |
| `NodeXml` | XML of the current or enumerated node. |
| `CurrentNodePath` | Diagnostic path like `/{uri}root[1]/{uri}item[2]`; this is not input XPath. |
| `ResolvedNodePath` | Canonical path resolved from `NodePathIn`, or an empty string when the path is not found. |
| `SelectedCount`, `CurrentIndex` | Current selection size and zero-based current/enumerated node index. |
| `AttributeCount`, `AttributeIndex` | Attribute count and zero-based enumeration index. |
| `PathExists` | `1` when the last NodePath operation found or created a target; otherwise `0`. |
| `SessionIDOut` | Native session handle; `0` means no active session. |

## JSON Formats

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

The actual `attributes` and `children` arrays are filled with objects containing name, full name, namespace URI, path, value, and counters.

## XPath and Namespaces

XPath expressions run against element nodes. For XML with a default namespace, do not use an unprefixed XPath such as `/root/item`; define a prefix first:

```json
{"d":"urn:default","x":"urn:x"}
```

Then use:

```text
/d:root/d:item[@id='1']/x:value
```

Namespace mapping is configured through `doSetNamespacePrefix` or replaced as a whole through `doSetNamespacesJson`. This map stays in the native session until `doClearNamespaces`, `doSetNamespacesJson`, `doClose`, or session destruction.

`CurrentNodePath` uses Clark notation `{uri}local` and one-based sibling indexes. It is useful for diagnostics and logs, but should not be pasted directly into `XPathIn`.

## Errors

A native operation is considered successful when the returned string does not start with `ERROR:`. On failure, the element:

1. stores the full text in `ErrorMessage`;
2. extracts `ErrorCode` from `ERROR: CODE: message`;
3. fires `OnError`;
4. fires `OnDone` with `0`.

Errors produced by the Pascal wrapper can use `BRIDGE_LOAD`, `BRIDGE_EXPORT`, `SESSION`, or `STATE`. Other codes come from the NativeAOT backend and refer to XML, XPath, IO, JSON, or document-state failures.

## Basic Workflow

1. Load XML through `doLoadXmlString` or `doLoadXmlFile`, or create a document through `doCreateNewXml`.
2. If the XML uses namespaces, call `doSetNamespacePrefix` or `doSetNamespacesJson`.
3. Run `doSelectSingleNode` for a one-node operation or `doSelectNodes` for a set.
4. Check `OnDone` and, when needed, `SelectedCount`.
5. Read or edit the current node.
6. After edits, call `doSaveXmlToString` or `doSaveXmlToFile`.
7. Call `doClose` when the session is no longer needed.

## Writing xpatch Instructions

The current element version has no built-in `doApplyPatch` work point and no built-in `xpatch` parser. `xpatch` should be an application-level operation description parsed by your HiAsm scheme or by a separate parser, then applied through `XMLNativeAOTEditor` work points.

A reliable `xpatch` operation should include:

- `op` - action type;
- `xpath` - target element-node address;
- operation data: new value, attribute name, XML fragment, child element name;
- expected node count when the operation must be strict;
- namespace map when the XML uses namespaces.

Recommended operation-to-port mapping:

| xpatch operation | Element sequence |
| --- | --- |
| `set-value` | `XPathIn` -> `doSelectSingleNode`, then `NewValueIn` -> `doSetValue`. |
| `set-attribute` | `doSelectSingleNode`, then `AttributeNameIn` + `AttributeValueIn` -> `doSetAttributeValue`. |
| `remove-attribute` | `doSelectSingleNode`, then `AttributeNameIn` -> `doRemoveAttribute`. |
| `add-child` | Select the parent with `doSelectSingleNode`, then `ChildNameIn` -> `doAddChildNode`. |
| `add-child-xml` | Select the parent with `doSelectSingleNode`, then `ChildXmlIn` -> `doAddChildXml`. |
| `replace-node` | `doSelectSingleNode`, then `NodeXmlIn` -> `doSetNodeXml`. |
| `delete-node` | `doSelectSingleNode`, then `doDeleteNode`. |
| `save` | `doSaveXmlToString` or `FilePathIn` -> `doSaveXmlToFile`. |

Example application-level JSON `xpatch` representation:

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

How to apply such a patch in a scheme:

1. Before the first operation, send `namespaces` to `NamespacesJsonIn` and call `doSetNamespacesJson`.
2. For each operation, send `xpath` to `XPathIn` and call `doSelectSingleNode`.
3. Check `OnDone=1` and `SelectedCount=1` when `expect` is `1`.
4. Send operation data to the matching element inputs and call the edit work point.
5. After each edit, check `OnDone`; on `OnDone=0`, stop the patch and read `ErrorMessage`/`ErrorCode`.
6. Save the document after all operations.

Practical rules:

- Use stable XPath: prefer `//*[@id='42']` or `/d:root/d:item[@code='A']` over positional `/d:root/d:item[3]` when the patch adds or removes sibling nodes.
- For one-node edits, require `SelectedCount=1`. If the match count is `0` or greater than `1`, treat it as a patch-scenario error.
- Run deletes from deeper and more specific nodes toward parents so an earlier operation does not change the address of a later one.
- Create parents before creating child nodes.
- `ChildXmlIn` and `NodeXmlIn` must be well-formed XML element fragments. Text values for `doSetValue` are plain strings, not XML.
- In XML with a default namespace, always assign a prefix through `NamespacesJsonIn`; unprefixed XPath does not select those elements.
- Namespaced attributes can use a configured prefix or `{uri}local`; regular attributes without namespace use a simple name.
- Do not rely on transactions: the element applies operations immediately. If rollback is needed, save the original XML first with `doSaveXmlToString`.

## Limitations

- Operations are synchronous and can block the UI thread on large XML files.
- The current node is an element node; comments, processing instructions, and separate text nodes are not exposed as dedicated ports.
- There is no built-in undo/redo, diff, or atomic patch operation.
- `LoadedXml` is not automatically refreshed after every mutation.
- DTD parsing is enabled only with `DtdProcessing=2`; the default is `0` prohibit.
- Compatibility claims should use only `tests.md` results marked `clean` or `clean-fpc2`.

## Licensing and Notices

The element code is in a repository with the root license file [`../LICENSE`](../LICENSE). Notices for the included NativeAOT runtime components are in [`THIRD-PARTY-NOTICES.txt`](THIRD-PARTY-NOTICES.txt). The Russian explanatory summary is in [`THIRD-PARTY-NOTICES.ru.txt`](THIRD-PARTY-NOTICES.ru.txt).
