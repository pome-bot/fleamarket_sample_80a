# README

<h1 align="center">フリーマーケットサイト</h1>

- メルカリクローンのフリーマーケットサイトです。
- TECH::CAMP 80期短期集中コースAチームで作成。
- 作成期間 2020/8/4 ~ 2020/8/28
![fleamarket_sample](https://user-images.githubusercontent.com/61574277/91686571-8f4d8500-eb98-11ea-8767-91a0030414ff.jpeg)

## :paperclip: 主な使用言語
<a><img src="https://user-images.githubusercontent.com/39142850/71774533-1ddf1780-2fb4-11ea-8560-753bed352838.png" width="70px;" /></a> <!-- rubyのロゴ -->
<a><img src="https://user-images.githubusercontent.com/39142850/71774548-731b2900-2fb4-11ea-99ba-565546c5acb4.png" height="60px;" /></a> <!-- RubyOnRailsのロゴ -->
<a><img src="https://user-images.githubusercontent.com/39142850/71774618-b32edb80-2fb5-11ea-9050-d5929a49e9a5.png" height="60px;" /></a> <!-- Hamlのロゴ -->
<a><<img src="https://user-images.githubusercontent.com/39142850/71774644-115bbe80-2fb6-11ea-822c-568eabde5228.png" height="60px" /></a> <!-- Scssのロゴ -->
<a><img src="https://user-images.githubusercontent.com/39142850/71774768-d064a980-2fb7-11ea-88ad-4562c59470ae.png" height="65px;" /></a> <!-- jQueryのロゴ -->
<a><img src="https://user-images.githubusercontent.com/39142850/71774786-37825e00-2fb8-11ea-8b90-bd652a58f1ad.png" height="60px;" /></a> <!-- AWSのロゴ -->

## 機能紹介
- 新規会員登録・ログインをすると商品の購入、出品ができます。
- 新規会員登録、ログインがお済みでない方も商品の一覧、詳細を閲覧可能です。
- 決済方法はご自身のクレジットカードを登録して購入できます。


## 担当箇所
- トップページのマークアップ
- 商品一覧表示
- 商品詳細ページのマークアップ、バックエンド
- 商品出品ページのマークアップ
- 商品購入確認ページのマークアップ、バックエンド
- 商品の削除機能
- パンくず機能の実装
- ユーザー新規登録、ログインの本人確認情報のマークアップ、バックエンド
- クレジットカード未登録時の処理




## サイトURL紹介
- ID:team1
- パスワード:A5112
- IPアドレス:
[link](http://54.95.98.71/){:target="_blank" rel="noopener noreferrer}


## テストアカウント
### 購入者用
- メールアドレス：tanaka@user50.com
- パスワード：3334444
### 購入用カード情報
- 番号：4242 4242 4242 4242
- 期限：3 / 22
- セキュリティカード：111
### 出品者用
- メールアドレス：yamada@user50.com
- パスワード：3335555




# :page_facing_up: DB設計

## users table
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|email|string|null: false, unique: true|
|password|string|null: false, minimum: 7|
### Association
- has_many :seller_items, foreign_key: "seller_id", class_name: "Item", dependent: :destroy
- has_many :buyer_items, foreign_key: "buyer_id", class_name: "Item", dependent: :nullify
- has_many :comments, dependent: :destroy
- has_one :credit_card, dependent: :destroy
- has_one :user_profile, dependent: :destroy
- has_one :user_address, dependent: :destroy

## credit_cards table
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|payjp_customer_id|string|null: false, unique: true|
|payjp_card_id|string|null: false, unique: true|
### Association
- belongs_to :user

## user_profiles table
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|first_name|string|null: false|
|family_name|string|null: false|
|first_name_kana|string|null: false|
|family_name_kana|string|null: false|
|birth_day|date|null: false|
|introduction|text||
|image|string||
### Association
- belongs_to :user

## user_addresses table
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|first_name|string|null: false|
|family_name|string|null: false|
|first_name_kana|string|null: false|
|family_name_kana|string|null: false|
|postcode|string|null: false, limit: 7|
|prefecture_code|integer|null: false, jp_prefecture|
|city|string|null: false|
|house_number|string|null: false|
|building_name|string||
|phone_number|string|unique: true|
### Association
- belongs_to :user

## items table
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|introduction|text|null: false|
|price|integer|null: false|
|category_id|integer|null: false, foreign_key: true|
|brand_id|integer|foreign_key: true|
|condition_id|integer|null: false, foreign_key: true|
|postage_burden_id|integer|null: false, foreign_key: true|
|prefecture_code|integer|null: false, jp_prefecture|
|postage_days_id|integer|null: false, foreign_key: true|
|seller_id|integer|null: false, foreign_key: true|
|buyer_id|integer|foreign_key: true|
|deal_done_date|datetime||
### Association
- has_many :comments, dependent: :destroy
- has_many :item_images, dependent: :destroy
- belongs_to :category
- belongs_to :brand
- belongs_to_active_hash :condition, class_name: "ItemCondition"
- belongs_to_active_hash :postage_burden
- belongs_to_active_hash :postage_days
- belongs_to :seller, class_name: "User"
- belongs_to :buyer, class_name: "User"

## categories table
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|string|null: false|
### Association
- has_many :items

## brands table
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true|
### Association
- has_many :items

## item_images table
|Column|Type|Options|
|------|----|-------|
|item_id|integer|null: false, foreign_key: true|
|image|string|null: false|
### Association
- belongs_to :item

## comments table
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|item_id|integer|null: false, foreign_key: true|
|comment|text|null: false|
### Association
- belongs_to :user
- belongs_to :item
