# GitHubSearchUIKit

同じ GitHub 検索仕様を **UIKit + Combine** と **SwiftUI + Observation** で書き分けた、アーキテクチャ比較・検証用のサンプルです。  
(SwiftUI 版はこちら: [GitHubSearchSwiftUI](https://github.com/mickey-wt-pkmn/GitHubSearchSwiftUI))

画面のイベント制御は Combine、通信は async / await で実装しています。  
実務の RxSwift で一般的な Input / Output パターンを Combine で構成しました。

## 動作
検索欄で文字を入力し、キーボードの検索ボタンで検索します。入力のたびには検索しません。

## 構成
- `SearchViewModel.transform` が `Input` を `Output` に変換します
- `Output` は `sections`、`isLoading`、`errorMessage` です
- 通信の async 処理は `deferredTask` で Publisher に変換し、`switchToLatest` で直前の検索をキャンセルします
- `SearchViewModelTests` で空文字・成功・失敗のテストを実装しています
- GitHub の未認証 Search API には回数制限(1分あたり10回)があります

## 動作環境
- Xcode 27.2 / iOS 27.2