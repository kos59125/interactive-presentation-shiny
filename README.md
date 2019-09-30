# Interactive Presentation with Shiny

## システム要件

- Shiny Server
- AWS
   - DynamoDB

### DynamoDB

下記 2 つのテーブルを作成します。

- プレゼン管理テーブル
   - プライマリーキー
      - パーティションキー: SessionId
- 回答収集テーブル
   - プライマリーキー
      - パーティションキー: UserId
      - ソートキー: SessionId
   - セカンダリーインデックス: SessionId-index
      - パーティションキー: SessionId

## 設定

### 環境変数

設定できる環境変数は下記の通りです。

| 環境変数 | 必須 | 説明 |
| --- | --- | --- |
| `R_CONFIG_ACTIVE` | | 設定ファイルの環境 |
| `APP_BASEURL` | | ベース URL（スラッシュ終わり） |
| `AWS_ACCESS_KEY_ID` | ○ | アクセスキー ID |
| `AWS_SECRET_ACCESS_KEY` | ○ | シークレットアクセスキー |
| `AWS_DEFAULT_REGION` | ○ | リージョン |

注意: 利用しているライブラリーの制限により、 IAM Role には対応していません。
`AWS_*` 環境変数は必ず作成してください。

### 設定ファイル

`config.yml` に設定を行います。記述形式は config パッケージに準拠します。

| 変数 | 説明 |
| --- | --- |
| `session_id` | プレゼンテーションを区別するための ID（同一プレゼンテーションファイルでも発表のたびに異なる値をとる） |
| `base_url` | ベース URL |
| `loglevel` | ロギングレベル（logging パッケージ準拠） |
| `table_presenter` | DynamoDB のテーブル名（ページ管理） |
| `table_respondent` | DynamoDB のテーブル名（回答） |

## 実行

### ローカル実行

1. 依存ライブラリーをインストール
   1. `setup_libs.R` を実行
1. Shiny を実行
   * プレゼンテーション: `presenter/main.Rmd`
   * 回答: `respondent/{server,ui}.R`

### Docker コンテナ

環境変数 `RUN_APP` に `presenter` または `respondent` を指定して起動します。

```bash
$ docker build -t interactive-presentation:develop .
$ docker run -p 8080:8080 -e RUN_APP=presenter -d interactive-presentation:develop
```

### ~~Cloud Run（GCP）~~

~~アプリケーションのポートはデフォルト 8080 ですが、 PORT 環境変数で指定したポートに変更できます。
これにより Cloud Run でも動かすことができます。~~
→ Cloud Run は websocket 対応していないので現状では動かなかった。
