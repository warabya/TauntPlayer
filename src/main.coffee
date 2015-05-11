app = require 'app' # Module to control application life.
http = require 'http'
url = require 'url'
fs = require 'fs'

BrowserWindow = require("browser-window") # Module to create native browser window.

# TODO: coffeescriptでconstの定義ってどうするんでしたっけ。
TAUNT_DIR_NAME = 'taunts'
WAITING_PORT_NUMBER = 2222

# Report crashes to our server.
# TODO: 要るのこれ？要るのであれば適切な使い方の調査必要
require("crash-reporter").start()

# TODO: ロガーの実装

# Keep a global reference of the window object, if you don't, the window will
# be closed automatically when the javascript object is GCed.
mainWindow = null

# Quit when all windows are closed.
app.on "window-all-closed", ->
  app.quit()  unless process.platform is "darwin"
  return


# This method will be called when Electron has done everything
# initialization and ready for creating browser windows.
app.on "ready", ->
  # Create the browser window.
  mainWindow = new BrowserWindow(
    width: 400
    height: 300
  )
  # and load the index.html of the app.
  mainWindow.loadUrl "file://" + __dirname + "/index.html?tauntFileName=100"

  # タウントのハッシュテーブルを作成
  # (key: タウント番号、タウントコード, value: タウントファイル名)
  # TODO: 現在非同期処理で動作しているため、タウントリクエストが入った瞬間にテーブルの構築が終わっていない可能性がある。テーブルの構築中は次のstatementへ処理を移さない実装が必要。
  tauntList = {}
  try
    # タウント格納ディレクトリ内のファイル全てを取得
    fs.readdir __dirname + '/' + TAUNT_DIR_NAME, (err, files) ->
      if err
        throw err
      # 全ファイルの内、ファイルであるもの（ディレクトリでないもの）かつ、拡張子がmp3なもののみ抽出
      files.filter((file) ->
        return fs.statSync(__dirname + '/' + TAUNT_DIR_NAME + '/' + file).isFile() && /.*\.mp3$/.test file
      # 抽出したタウントファイル名をタウント番号とタウントコードに分離し、連想配列で格納
      ).forEach (file) ->
        match = /(\d+)\s([^\.]+)/.exec file
        tauntList[match[1]] = file
        tauntList[match[2]] = file
        return
      return
  catch err
    # TODO: エラー処理
    console.log err

  server = http.createServer()
  server.on 'request', (req, res)->
    reqInfo = url.parse req.url, true

    tauntIdentifier = reqInfo.query.tauntIdentifier
    # tauntIdentifierが1桁ないし2桁の場合、3桁にpadding
    if /^\d{1}$/.test tauntIdentifier
      tauntIdentifier = '00' + tauntIdentifier
    else if /^\d{2}$/.test tauntIdentifier
      tauntIdentifier = '0' + tauntIdentifier

    # TODO: ログ化
    console.log 'request received(tauntIdentifier: ' + tauntIdentifier + ', tauntFileName: ' + tauntList[tauntIdentifier] + ')'

    mainWindow.loadUrl "file://" + __dirname + "/index.html?tauntFileName=" + tauntList[tauntIdentifier]
    res.writeHead 200, {"Content-Type": "text/plain"}
    res.write '(tauntIdentifier: ' + tauntIdentifier + ', tauntFileName: ' + tauntList[tauntIdentifier] + ')'
    res.end()
    return
  server.listen WAITING_PORT_NUMBER

  # Emitted when the window is closed.
  mainWindow.on "closed", ->

    # Dereference the window object, usually you would store windows
    # in an array if your app supports multi windows, this is the time
    # when you should delete the corresponding element.
    mainWindow = null
    return

  return

