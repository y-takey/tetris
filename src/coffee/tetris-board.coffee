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
      ctx.fillStyle = colors[ board[ y ][ x ] - 1 ]
      # マスを描画
      drawBlock(x, y)

  # 操作ブロックを描画する
  for y in [0...4]
    for x in [0...4]
      continue unless current[ y ][ x ]

      # マスの種類に合わせて塗りつぶす色を設定
      ctx.fillStyle = colors[ current[ y ][ x ] - 1 ]
      # マスを描画
      drawBlock( currentX + x, currentY + y )

module.exports =

  init: ()->
    board = for y in [0...ROWS]
      0 for x in [0...COLS]

    # 30ミリ秒ごとに描画
    setInterval(render, 30)

  clearLines: clearLines
