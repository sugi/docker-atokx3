# Dockerfile for ATOK X3

## なにこれ？

最近のライブラリに対応できなくなったり、依存関係の変更でパッケージがうまく入らなくなってしまった
ATOK X3 を Docker 内に分離して動かす為の Dockerfile です。

Docker の環境内には、既にサポートの終了した Debian etch i386 を使っています。
/tmp を bind mount して X11 や iiim のソケットを引き渡し、直接通信します。

あんまりうまく動きませんが、取り合えず使えます。

## ビルド手順

まず、atokx3 のファイルを用意して下さい。以下の3つが必要です。

* atokx3.tar.gz -- オリジナルのCDなどに入っている物
* atokx3up2.tar.gz -- サポートサイトからダウンロード
* a20y1311lx.tgz  -- サポートサイトからダウンロード

これらを Dockerfile と同じディレクトリにおきます。
下の 2 つは無くても多分動きますが、そうしたい場合は Dockerfile を書き換えて下さい。

ファイルを用意したら、**Dockerfile の最後の行をホスト側の自分のユーザに会わせて書き換えて下さい**。Docker 内の動作ユーザは外側と同じ uid/gid ユーザ名である必要があります。

書き換えたら

    docker build -t local/atokx3 .

等としてビルドします。

## 起動方法

以下のようにします。

    docker run -d -v /tmp:/tmp -v /home:/home \
      -e LC_CTYPE=ja_JP.utf-8 -e LC_COLLATE=ja_JP.utf-8 \
      -e DISPLAY=$DISPLAY -e HOME=$HOME \
      -e XDG_SESSION_COOKIE=$XDG_SESSION_COOKIE \
      -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
      -u `whoami` local/atokx3 \
      bash -c '/usr/bin/iiimx -iiimd; trap exit TERM INT; sleep infinity'

これで /tmp/.iiim-$USER 以下にソケットができていれば動いています。

## 制限＆問題＆TODO

### 辞書ツールなどが動かない

起動しません。どうして良いか分かりません。

### ソケットのパスが変わる

何故かソケットが /tmp/.iiim-$USER/:0 ではなくて /tmp/.iiim-$USER/:0.0
にできて通信できなくなる事があります。良く分からないのですが、自分はとりあえず以下のように symlink を張って回避しています。

    ln -s :0.0 /tmp/.iiim-$USER/:0 

## ライセンス

このレポジトリに含まれる全て: The BSD 2-Clause License

## コンタクト

Tatsuki Sugiura <sugi@nemui.org>
