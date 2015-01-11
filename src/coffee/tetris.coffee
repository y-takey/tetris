board = require './tetris-board'
block = require './tetris-block'

# ゲームを実行するタイマーを保持する変数
interval = null

tick = ()->
  try
    entryBlock() unless board.moveDown()
  catch error
    console.log(error)
    newGame()

setupTicker = ()->
  clearInterval(interval)
  interval = setInterval(tick, 250)

entryBlock = ()->
  # 新しい操作ブロックをセットする
  board.add(block.generate())

newGame = ()->
  board.init()
  entryBlock()
  setupTicker()

module.exports =
  start: ()->
    newGame()
