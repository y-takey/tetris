controller = require './tetris-controller'

# 盤面情報
board = null
# 横10、縦20マス
COLS = 10
ROWS = 20
# キャンバス
canvas = document.getElementsByTagName( 'canvas' )[ 0 ]
# コンテクスト
ctx = canvas.getContext( '2d' )
# キャンバスのサイズ
W = 300
H = 600
# マスの幅を設定
BLOCK_W = W / COLS
BLOCK_H = H / ROWS
# 今操作しているブロックの位置
currentX = null
currentY = null
currentBlock = null

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
  newCurrent ||= currentBlock

  newCurrent.eachCell (y, x, cell)->
    return unless cell
    return unless isInvalid(y + offsetY, x + offsetX)

    # もし操作ブロックが盤面の上にあったらゲームオーバー
    if (offsetY == 1 && offsetX - currentX == 0 && offsetY - currentY == 1)
      throw new Error("game over");

    return false

  true

# 操作ブロックを盤面にセットする関数
freeze = ()->
  currentBlock.eachCell (y, x, cell)->
    return unless cell
    board[ y + currentY ][ x + currentX ] = currentBlock.color

moveLeft = ()->
  return unless valid(-1)
  --currentX
  render()

moveRight = ()->
  return unless valid(1)
  ++currentX
  render()

moveDown = ()->
  # １つ下へ移動する
  if valid(0, 1)
    ++currentY
    return true

  # もし着地していたら(１つしたにブロックがあったら)
  # 操作ブロックを盤面へ固定する
  freeze()
  # ライン消去処理
  clearLines()
  render()
  false

rotate = ()->
  rotated = currentBlock.rotate()
  return unless valid(0, 0, rotated)

  currentBlock = rotated
  render()

# 一行が揃っているか調べ、揃っていたらそれらを消す
clearLines = ()->
  y = ROWS
  while y > 0
    --y

    rowFilled = true

    # 一行が揃っているか調べる
    for x in [0...COLS]
      continue unless board[ y ][ x ] == 0
      rowFilled = false
      break

    # もし一行揃っていたら, サウンドを鳴らしてそれらを消す。
    continue unless rowFilled

    # 消滅サウンドを鳴らす
    document.getElementById( 'clearsound' ).play()
    # その上にあったブロックを一つずつ落としていく
    for yy in [y...0]
      for x in [0...COLS]
        board[ yy ][ x ] = board[ yy - 1 ][ x ]

    # 一行落としたのでチェック処理を一つ下へ送る
    ++y

# x, yの部分へマスを描画する処理
drawBlock = (x, y)->
  args = [BLOCK_W * x, BLOCK_H * y, BLOCK_W - 1 , BLOCK_H - 1]
  ctx.fillRect(args...)
  ctx.strokeRect(args...)

# 盤面と操作ブロックを描画する
render = ()->
  # 一度キャンバスを真っさらにする
  ctx.clearRect( 0, 0, W, H )
  # えんぴつの色を黒にする
  ctx.strokeStyle = 'black'

  # 盤面を描画する
  for x in [0...COLS]
    for y in [0...ROWS]
      # マスが空、つまり0ではなかったら
      continue unless board[ y ][ x ]

      # マスの種類に合わせて塗りつぶす色を設定
      ctx.fillStyle = board[ y ][ x ]
      # マスを描画
      drawBlock(x, y)

  # 操作ブロックを描画する
  currentBlock.eachCell (y, x, cell)->
    return unless cell

    # マスの種類に合わせて塗りつぶす色を設定
    ctx.fillStyle = currentBlock.color
    # マスを描画
    drawBlock( currentX + x, currentY + y )

api =
  init: ()->
    board = for y in [0...ROWS]
      0 for x in [0...COLS]

    # 30ミリ秒ごとに描画
    setInterval(render, 30)

  add: (block)->
    # ブロックを盤面の上のほうにセットする
    currentX = 5
    currentY = 0
    currentBlock = block

  moveLeft: moveLeft
  moveRight: moveRight
  moveDown: moveDown
  rotate: rotate

controller.bind(api)

module.exports = api
