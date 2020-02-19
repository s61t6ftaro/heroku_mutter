># Herokuを使ってアプリケーションをデプロイしてみた。(Ruby On Rails)

>## はじめに

学校の作品提出課題で作ったアプリケーションをデプロイしなくてはいけなかった。<br>
大体は授業で習ったAWSを使ってデプロイしていたのだが、私はAWSあまり理解できてなかったので別の方法にしようと考えた。<br>
その時先輩が「自分はHerokuをつかってデプロイした」と言っていたので早速調べてAWSよりは複雑ではなかったのでHerokuを使うことに決めた。

>## Herokuのいいところ～

- あまりこちら側が何もしなくても勝手に動いてくれる～安心！
- デプロイするときはコマンド一発。（2発の物も）
- コマンドが苦手な人はGUIでもデプロイできるからエンジニアでも非エンジニアでも安心！
- そしてなんといっても無料！


>## デプロイに必要な物。

私は今回デプロイするアプリケーションはrubyで作りました。
それぞれ開発言語は違うと思うので、それぞれに合った方法じゃないとデプロイできない場合などあるので、その時は、ご自身で調べてください。<br>
それでは必要な物を挙げていきます（準備するもの）.....

### 大きく分けるとこの3つです

- デプロイしたいアプリケーション
- git登録
- Herkou CliのDownlod
- Herokuのユーザ登録

それではひとつずつ説明していきます。

>## 自分の環境

- Ruby 2.6.5
- Rails 6.02
- git 2.16.2
- heroku/7.38.1 win32-x64 node-v12.13.0

># Railsアプリをデプロイする場合。

**※railsアプリじゃないよーという方は飛ばしてもらっても大丈夫です。**

### デプロイ準備

- config/routes.rbでroot設定
- Gemfileの設定
- config/datebase.ymlの設定
- config/envionments/production.rbの設定
- bin以下のフォルダの設定(任意)

このやらなきゃいけない一覧をみて「うっわ。めんど」って思ったかもしれないですが、特に長いコード追加とかしないんで大丈夫です。
すぐ終わります。

>## congig/routs.rbの設定

configフォルダ中のroutes.rbを以下のように編集しましょう。<br>
自分がトップにしたいページのファイルをroot設定してください。<br>
これを設定しないとデプロイした後の環境でエラーが出ます。（URLが合ってないぞ！）

<image src="image/heroku_review1.png">

>### Gemfileの設定

次にGemfileを設定していきます。<br>
まずGemfileに`gem sqlite3`と記述してある箇所を探しコメントアウトしましょう<br>
```
# sqlite3
```
コメントアウトができたらGemfileの`group :development, :test do ~~ end`内に以下のように追加してください。
```
group :development, test do
  gem 'sqlite3' 
end
```

Gemfileは最後もう一箇所設定します。<br>
下記のコードはGemfile内のどこかについかしてください。（一番下に書くのが安全）<br>
ここで環境ごとのデータベース変更を行っています。<br>

```
group :production do
  gem 'pg'
end
```

これら2つの箇所を追記できたらしっかり`bundle install`しましょう。<br>
ですが、下記のオプションを追加して`bundle install`する必要があります。<br>
```
$bundle install --without production
```
これをする意味はさきほどの`group :production do ~ end`のインストールのみを避けたいからこのオプションを付ける。<br>
※パソコンにPostgreSQLが入っている人は付けなくても大丈夫です。本番環境のみでPostgreSQLを使うので<br>
これでGemfileの設定は終わりです。

> ### config/datebase.ymlの設定

前段階でGemfileを設定したことにより「このアプリは本番環境でPostgreSQLを使います。」という宣言は完了しました。<br>
ですが、データベースと接続する記述はまだ完了していません<br>
今回はその設定をするためにconfig/datebase.ymlを設定します。<br>
configの中のdatebase.ymlを開き、`production`環境についての設定を下記のように設定してください。
```
production: #半角スペース2個分↓
  <<: *default
  adapter: postgresql
  encoding: unicode
  pool: 5
```
### それぞれの説明
```
adapter: postgresql --- postgresqlのデータベースに接続します。
encoding: unicode   --- unicodeという文字コードを使用します
pool: 5             --- DBに接続できる上限の数を決めます。 
```

configの設定は最後にもう一つあります。

>### config/environments/production.rbの設定

Railsは本番環境での動的な画像の表示がDefaultでOffになっています。<br>
なのでこれをOnにしてあげる必要があります。<br>
以下の部分をfalseからtrueに設定してください。
```
config.assets.compile = true
```
これでconfigの設定は終わりです。

>### heroku run rails db:migrateでエラーが出ないように

この設定は、人によって大丈夫なことが多いが、rbenvなど使ってない人は陥りがちらしいので記述していきます。<br>
アプリ内に`bin`フォルダがありますので、その中のファイルすべて下記のように変更していきます。<br>
`bundle`,`rails`,`setup`,`update`,`yarn`などのファイルです。
```
- bun
  - bundle
  - rails
  - setup
  - update
  - yarn
```

それぞれのファイルの一番上に

`#!/usr/bin/env ruby`と記述されているところが、`#!/usr/bin/env ruby 2.3.1`のようにバージョンの詳細が記述されていたら、そのバージョンの詳細（数字のみ）を消してください。

これでRailsアプリケーションのデプロイ準備は終わりです。

>## gitの登録

gitに関してはしっかり説明すると長いので、自身で調べて下さい
参考URLを貼っておきます
https://qiita.com/yunico-jp/items/87bdd13971e82833f6bb

まず下記のURLからgitをinstallしましょう。
https://git-scm.com/downloads

### ubuntuの場合

```
$apt-get install git 
```

以下のコマンドを打って、インストールしたバージョンを確認できたらインストールが完了しています。
```
$git --version
>>git version 2.16.2
```

gitがインストールできたらターミナルで以下のコマンドを打ってください。
gitとフォルダを紐づける為のコマンドです。
```
$git init
```
次に、gitを使ったアプリを保存するコマンドです。（アプリというかファイルなど）
```
$git add -A                     #-Aとつけたのはすべてという意味。*でも同じ意味
$git commit -m "first commit"   #addしたファイルの保存の確定、-mはメッセージの頭文字、メッセージ内容は何でもいい。
```
ここで、初めてコミットする場合は、githubのユーザー名とemailの入力を求められます。
自身で入力して決めましょう。

これでgitの準備は終わりです。

>## Heroku
    PaaS（Platform as a Service）と呼ばれるサービス
    サーバやOS、データベースなどの「プラットフォーム」と呼ばれる部分を、インターネット越しに使えるようにしてくれるサービス
    簡単かつ無料でRailsアプリがあげられる
    通常、Railsアプリはデプロイが難しいことが多いのですが、このherokuを使うと比較的簡単にデプロイすることができます。機能的には物足りない部分もあるのですが、その場合は有料版を使えば問題なくサービスを立ち上げることができます。

>### Herokuの登録

下記のURLからHerokuに登録しましょう。英語なのでGoogle翻訳をうまく使いましょう。<br>
https://signup.heroku.com/login

会員登録ができたら次は、Herokuの機能を自分のPCに紐づけましょう。

>### Heroku Cli Downlod

https://devcenter.heroku.com/articles/heroku-cli

### ubuntuの場合
```
$curl https://cli-assets.heroku.com./install-ubuntu.sh | sh
```

パスを通してくださいという文と以下のコマンドがでるのでコピペして打ちましょう
```
$echo 'PATH="/usr/local/heroku/bin:$PATH"' >> ~/.profile
```

gitと同じように以下のコマンドを打ってHerokuのバージョンが確認できたらインストールが完了です。
```
$heroku --version
>>heroku heroku/7.38.1 win32-x64 node-v12.13.0
```

### RailsアプリとHerokuの紐づけ

pcから（ターミナル）Herokuにログインしましょう

```
$heroku login
```
これでずっと待機中になるばあいは下記のコマンドを打ちましょう
```
$heroku login --interactive
```

さきほど登録したEmail,Passwordを打ちましょう。

```
Enter your Heroku credentials:
Email: [設定したEmail]
Password: [設定したPassword]
Logged in as [~~~~~@example.com]
```
>### デプロイ

デプロイする前にアプリ1つごとに1回Herokuとアプリを紐づけるコマンドを打ちます
```
$Heroku create 好きなアプリ名(アンダーバーやハイフンなどはつかえない、入力する文字列はURLになるものなので)
```
※空欄でもOK、自動で作ってくれます。

そしたらHerokuにデプロイしましょう。
さきほど`git add`して`git commit`までしたので後は`git push`するだけです。
```
$git push heroku master
```
このままエラーがでなければデプロイは完了です！。<br>
最後から5行目くらいにこのデプロイしたURLが表示されるので確認しましょう。

ex(https://agile-brushlands-86666.herokuapp.com/)

これで終わり・・・かと思いきや最後にやることがあります。

>## 本番環境(Heroku)でのマイグレーション

```
$heroku run rails db:migrate
```

何もエラーが出なければこれですべて完了です。
確認したURLに飛んでみましょう。

お疲れ様でした。

今回のデプロイ中に出たエラーの対処法はまた別の記事で書きます！
















