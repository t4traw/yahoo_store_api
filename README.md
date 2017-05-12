# YahooStoreApi

[![Build Status](https://travis-ci.org/t4traw/yahoo_store_api.svg?branch=master)](https://travis-ci.org/t4traw/yahoo_store_api)
[![Code Climate](https://codeclimate.com/github/t4traw/yahoo_store_api/badges/gpa.svg)](https://codeclimate.com/github/t4traw/yahoo_store_api)

Yahoo!ショッピング プロフェッショナル出店ストア向けAPIを簡単に叩けるrubyラッパーです。

現在開発中です🐛 まだ商品情報のCRUDと在庫情報の取得・更新、反映予約しかできません。順次機能追加をしていきたいと思います。

## できること

* 商品に関連するAPI
  * 商品参照API(`get_item`)
  * 商品登録API(`set_item`)
  * 商品削除API(`delete_item`)
* 在庫に関連するAPI
  * 在庫参照API(`get_stock`)
  * 在庫更新API(`set_stock`)
* 出品管理に関連するAPI
  * 全反映予約API(`reserve_publish`)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yahoo_store_api'
```

## 事前準備

事前にストア出品アカウントと連携した認証コードが必要になります。

まず、Yahooデベロッパーネットワークの[Yahoo!ショッピングのストア運営をサポートするAPIを利用したアプリケーション](https://e.developer.yahoo.co.jp/shopping/register)にアプリケーションを登録します。

登録が終えたら、次に[認可コードを取得](https://developer.yahoo.co.jp/yconnect/server_app/explicit/authorization.html)する必要があります。ページに表示するかリダイレクトした時のパラメーターにある認証コードを取得します。

※シンプルにページ上に認証コードを表示させる例: https://auth.login.yahoo.co.jp/yconnect/v1/authorization?response_type=code+id_token&client_id=[上で登録したアプリケーションID]&state=foobar&redirect_uri=oob&nonce=hogehoge

stateやnonceなどは[Authorizationエンドポイント](https://developer.yahoo.co.jp/yconnect/server_app/explicit/authorization.html)に詳細がありますので、適宜変更してください。

## Initialize

ストアアカウント、上で登録したアプリケーションid、シークレット、取得した認証コードでインスタンスを生成します。

```ruby
client = RmsItemApi::Client.new(
  seller_id: YOUR_STORE_ID, # ストアアカウントid
  application_id: YOUR_APPLICATION_ID, # アプリケーションid
  application_secret: YOUR_SECRET, # シークレット
  authorization_code: AUTHORIZATION_CODE # 認証コード
)
```

なお、この認証コードは1回のみ使用可能で、次からはリフレッシュトークンを使用するか、再度認証コードを取得する必要があります。リフレッシュトークンは生成したインスタンスから取得する事ができます。

```ruby
puts client.refresh_token
```

```ruby
client = RmsItemApi::Client.new(
  seller_id: YOUR_STORE_ID, # ストアアカウントid
  application_id: YOUR_APPLICATION_ID, # アプリケーションid
  application_secret: YOUR_SECRET, # シークレット
  refresh_token: YOUR_REFRESH_TOKEN # リフレッシュトークン
)
```

## Usage

### 商品情報の参照

ストアに登録されている商品情報を取得できます。

```ruby
item = client.get_item('test123')

# 商品名を取得
item.name
# 通常販売価格を取得
item.price
# 取得したすべての情報をhashで出力
item.all
```

### 商品情報の登録/更新

商品情報を登録・更新できます。

```ruby
item = client.edit_item({
  item_code: 'test1234',
  name: 'test_item',
  path: 'test_category',
  price: 1000,
})

# 送信結果をhashで出力
item.all
```

### 在庫情報の参照

ストアに登録されている商品の在庫情報を取得できます。

```ruby
stock = client.get_stock('test123')

# 在庫数の取得
stock.quantity
# 取得したすべての情報をhashで出力
stock.all
```

### 全反映予約

反映予約をします。

```ruby
pub = client.reserve_publish

# 結果を取得
pub.status
```
