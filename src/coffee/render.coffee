#  現在の盤面の状態を描画する処理

# キャンバス
canvas = document.getElementsByTagName( 'canvas' )[ 0 ]
# コンテクスト
ctx = canvas.getContext( '2d' )
# 横10、縦20マス
COLS = 10
ROWS = 20
# キャンバスのサイズ
W = 300
H = 600
# マスの幅を設定
BLOCK_W = W / COLS
BLOCK_H = H / ROWS

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

# x, yの部分へマスを描画する処理
drawBlock = (x, y)->
  args = [BLOCK_W * x, BLOCK_H * y, BLOCK_W - 1 , BLOCK_H - 1]
  ctx.fillRect(args...)
  ctx.strokeRect(args...)

# 30ミリ秒ごとに状態を描画する関数を呼び出す
setInterval(render, 30)
