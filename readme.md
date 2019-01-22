# MEOKit

俺得なSwiftライブラリ

- よく使う機能を extension で追加しています
- 自作フレームワーク [MEKitObjC](https://github.com/mitsuharu/MEKitObjC_framework) からの移植です（作業中）


## Extensions

作成中

## Toast

- AndroidのようなToast表示する

```
Toast.show(text: "メッセージ")
```

## Cached

- データ（Data, String, UIImage）のデータキャッシュを行う

```
let key: String = "hogehoge"
Cached.add(string: "キャッシュデータ", key: key)
if let str = Cached.string(key: key){
    print("str \(str)")
}
```

- デフォルトの保存期間は1週間
	- キャッシュデータはアプリのcacheフォルダに保存される
	- データ削除はcacheフォルダの自動削除か手動削除を用いる
	- データの自動削除は未実装

# Installation


Carthage

```
github "mitsuharu/MEOKit"
```

CocoaPods

```
pod "MEOKit"
```


# License

MIT license





