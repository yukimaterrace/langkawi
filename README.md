# Langkawi
Matching Application API

## 準備
1. .env.testに以下の環境変数を設定してください。

```
DATABASE_URL=
```

2. .env.developmentに以下の環境変数を設定してください。

```
DATABASE_HOST=
DATABASE=
DATABASE_USER=
DATABASE_PASSWORD=
DATABASE_URL=postgres://${DATABASE_USER}:${DATABASE_PASSWORD}@${DATABASE_HOST}/${DATABASE}
CLOUDINARY_CLOUD_NAME=
CLOUDINARY_API_KEY=
CLOUDINARY_API_SECRET=
```

## テスト
ローカルのデータベースを使用します。
```
bin/rails db:schema:load RAILS_ENV=test
bundle exec rspec
```

## 開発用サーバの起動
```
bin/rails db:schema:load
bin/rails s
```
