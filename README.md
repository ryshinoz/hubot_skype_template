# hubot skype template

## 準備

以下をインストールしておく

- vagrant
- virtualbox
- berkshelf

## 構築

cookbookインストール

```bash
$ berks install -p cookbooks
```

SkypeのID、パスワードを設定

```ruby
chef.json = { :skype => { :user => '', :password => '' } }
```

起動

```bash
$ vagrant up
```

起動したらログインしてパスワード設定

```bash
$ vagrant ssh
$ ./init_x11vnc
```

サービス起動

```bash
$ sudo service skype start
```

初回だけアクセス認証がいるので

```bash
$ ./run_x11vnc
```

locahost:5901にアクセス

## Links
