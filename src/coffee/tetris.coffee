board = require './tetris-board'
block = require './tetris-block'

# 一番上までいっちゃったかどうか
lose = false
# ゲームを実行するタイマーを保持する変数
interval = null

tick = ()->

  entryBlock() unless board.fallBlock()

# キーボードが押された時に呼び出される関数
keyPress = (key)->
  switch key
    when 'left'
      # // 左に一つずらす
      --currentX if valid(-1)
    when 'right'
      # // 右に一つずらす
      ++currentX if valid(1)
    when 'down'
      # // 下に一つずらす
      ++currentY if valid(0, 1)
    when 'rotate'
      # // 操作ブロックを回す
      rotated = block.rotate()
      # // 回せる場合は回したあとの状態に操作ブロックをセットする
      current = rotated if valid(0, 0, rotated)

entryBlock = ()->
  # 新しい操作ブロックをセットする
  board.add(block.generate())

newGame = ()->
  # ゲームタイマーをクリア
  clearInterval(interval)
  board.init()
  entryBlock()
  # 負けフラッグ
  lose = false
  # 250ミリ秒ごとにtickという関数を呼び出す
  interval = setInterval( tick, 250 )

module.exports =
  start: ()->
    newGame()
