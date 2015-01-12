controller = require './tetris-controller'

# キャンバスのサイズ
W = 300
H = 600
# 横10、縦20マス
COLS = 10
ROWS = 20
# マスの幅
BLOCK_W = W / COLS
BLOCK_H = H / ROWS

# キャンバス
canvas = document.getElementsByTagName( 'canvas' )[ 0 ]
# コンテクスト
ctx = canvas.getContext( '2d' )
clearSound = document.getElementById('clearsound')
# 盤面情報
board = null
# 今操作しているブロックの位置
currentX = null
currentY = null
currentBlock = null

class Board
  constructor: (@rows, @cols)->
    @cells = for y in [0...rows]
      0 for x in [0...cols]

  eachCell: (func)->
    for y in [0...@rows]
      func(y, x, @cells[y][x]) for x in [0...@cols]

  isRowFilled: (y)->
    return false for x in [0...@cols] when !@cells[y][x]
    true

  isEmpty: (y, x)->
    return false if y >= @rows
    return false if x < 0 || x >= @cols
    return false if @cells[y][x]
    true

  # 着地
  land: (y, x, block)->
    block.eachCell (offsetY, offsetX, cell)=>
      return unless cell
      @cells[y + offsetY][x + offsetX] = block.color
    @clearLines()

  # 一行が揃っているか調べ、揃っていたらそれらを消す
  clearLines: ()->

    livingLines = (@cells[y] for y in [0...@rows] when !@isRowFilled(y))
    clearedNum = @rows - livingLines.length

    if clearedNum
      for y in [0...clearedNum]
        @cells[y][x] = 0 for x in [0...@cols]
      for rows, y in livingLines
        @cells[clearedNum + y] = rows

    clearedNum

# // 指定された方向に、操作ブロックを動かせるかどうかチェックする
# // ゲームオーバー判定もここで行う
valid = (offsetX = 0, offsetY = 0, newCurrent = currentBlock)->
  offsetX = currentX + offsetX
  offsetY = currentY + offsetY

  for y in [0...4]
    for x in [0...4]

      continue unless newCurrent.cells[y][x]
      continue if board.isEmpty(y + offsetY, x + offsetX)
      return false

  true

moveLeft = ()->
  return unless currentBlock
  return unless valid(-1)
  --currentX
  render()

moveRight = ()->
  return unless currentBlock
  return unless valid(1)
  ++currentX
  render()

moveDown = ()->
  return unless currentBlock
  # １つ下へ移動する
  if valid(0, 1)
    ++currentY
    return true

  throw new Error("game over") if currentY == 0

  # もし着地していたら(１つしたにブロックがあったら)
  # 操作ブロックを盤面へ固定する
  clearLines = board.land(currentY, currentX, currentBlock)
  currentBlock = null
  # 消滅サウンドを鳴らす
  clearSound.play() if clearLines
  render()
  false

rotate = ()->
  return unless currentBlock
  rotated = currentBlock.rotate()
  return unless valid(0, 0, rotated)

  currentBlock = rotated
  render()

# x, yの部分へマスを描画する処理
drawCell = (x, y, color)->
  ctx.fillStyle = color
  args = [BLOCK_W * x, BLOCK_H * y, BLOCK_W - 1 , BLOCK_H - 1]
  ctx.fillRect(args...)
  ctx.strokeRect(args...)

# 盤面と操作ブロックを描画する
render = ()->
  resetCanvas()
  renderBoard()
  renderBlock()

# キャンバスを真っさらにする
resetCanvas = ()->
  ctx.clearRect( 0, 0, W, H )
  # えんぴつの色を黒にする
  ctx.strokeStyle = 'black'

# 盤面を描画する
renderBoard = ()->
  board.eachCell (y, x, cell)->
    drawCell(x, y, cell) if cell

# 操作ブロックを描画する
renderBlock = ()->
  currentBlock?.eachCell (y, x, cell)->
    return unless cell
    drawCell(currentX + x, currentY + y, currentBlock.color)

api =
  init: ()->
    board = new Board(ROWS, COLS)

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
