app = require("app") # Module to control application life.
BrowserWindow = require("browser-window") # Module to create native browser window.

http = require 'http'
server = http.createServer()
server.on 'request', ->
  console.log 'request received'
server.listen 2222

# Report crashes to our server.
require("crash-reporter").start()

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
    width: 800
    height: 600
  )

  # and load the index.html of the app.
  console.log __dirname
  mainWindow.loadUrl "file://" + __dirname + "/index.html"

  # Emitted when the window is closed.
  mainWindow.on "closed", ->

    # Dereference the window object, usually you would store windows
    # in an array if your app supports multi windows, this is the time
    # when you should delete the corresponding element.
    mainWindow = null
    return

  return

