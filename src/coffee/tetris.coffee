board = require './tetris-board'
block = require './tetris-block'
renderer = require './tetris-renderer'
controller = require './tetris-controller'
controller.bind()

# 一番上までいっちゃったかどうか
lose = false
# ゲームを実行するタイマーを保持する変数
interval = null
# 今操作しているブロックの位置
currentX = null
currentY = null

tick = ()->
  # １つ下へ移動する
  if valid(0, 1)
    ++currentY

  # もし着地していたら(１つしたにブロックがあったら)
  else
    # 操作ブロックを盤面へ固定する
    freeze()
    # ライン消去処理
    board.clearLines()
    if lose
      # もしゲームオーバなら最初から始める
      newGame()
      return false

    # 新しい操作ブロックをセットする
    block.generate()

isInvalid = (y, x)->
  return true if y >= ROWS
  return true if x < 0 || x >= COLS
  return true if typeof board[y] == 'undefined'
  return true if typeof board[y][x] == 'undefined'
  return true if board[y][x]

# // 指定された方向に、操作ブロックを動かせるかどうかチェックする
# // ゲームオーバー判定もここで行う
valid = (offsetX, offsetY, newCurrent)->
  offsetX ||= 0
  offsetY ||= 0
  offsetX = currentX + offsetX
  offsetY = currentY + offsetY
  newCurrent ||= current

  for y in [0...4]
    for x in [0...4]
      continue unless newCurrent[ y ][ x ]
      continue unless isInvalid(y + offsetY, x + offsetX)

      # もし操作ブロックが盤面の上にあったらゲームオーバー
      if (offsetY == 1 && offsetX - currentX == 0 && offsetY - currentY == 1)
        console.log('game over')
        lose = true

      return false

  true

# 操作ブロックを盤面にセットする関数
freeze = ()->
  for y in [0...4]
    for x in [0...4]
      if current[ y ][ x ]
        board[ y + currentY ][ x + currentX ] = current[ y ][ x ]

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

newGame = ()->
  # ゲームタイマーをクリア
  clearInterval(interval)
  board.init()
  # 操作ブロックをセット
  block.generate()
  # 負けフラッグ
  lose = false
  # 30ミリ秒ごとに状態を描画する関数を呼び出す
  setInterval(renderer.render, 30)
  # 250ミリ秒ごとにtickという関数を呼び出す
  interval = setInterval( tick, 250 )

module.exports =
  start: ()->
    newGame()
