# 盤面情報
board = []
# 一番上までいっちゃったかどうか
lose = false
# ゲームを実行するタイマーを保持する変数
interval = null
# 今操作しているブロックの形
current = null
# 今操作しているブロックの位置
currentX = null
currentY = null

# 操作するブロックのパターン
shapes = [
    [ 1, 1, 1, 1 ],
    [ 1, 1, 1, 0,
      1 ],
    [ 1, 1, 1, 0,
      0, 0, 1 ],
    [ 1, 1, 0, 0,
      1, 1 ],
    [ 1, 1, 0, 0,
      0, 1, 1 ],
    [ 0, 1, 1, 0,
      1, 1 ],
    [ 0, 1, 0, 0,
      1, 1, 1 ]
]

# ブロックの色
colors = ['cyan', 'orange', 'blue', 'yellow', 'red', 'green', 'purple']

init = ()->
  for y in [0...ROWS]
    board[y] = []
    for x in [0...COLS]
      board[y][x] = 0

# shapesからランダムにブロックのパターンを出力し、盤面の一番上へセットする
newShape = ()->
  # ランダムにインデックスを出す
  id = Math.floor( Math.random() * shapes.length )
  shape = shapes[id]
  # パターンを操作ブロックへセットする
  current = []

  for y in [0...4]
    current[y] = [];
    for x in [0...4]
      i = 4 * y + x
      current[y][x] = if shape[i] then id + 1 else 0

  # ブロックを盤面の上のほうにセットする
  currentX = 5
  currentY = 0

tick = ()->
  # １つ下へ移動する
  if valid(0, 1)
    ++currentY

  # もし着地していたら(１つしたにブロックがあったら)
  else
    # 操作ブロックを盤面へ固定する
    freeze()
    # ライン消去処理
    clearLines()
    if lose
      # もしゲームオーバなら最初から始める
      newGame()
      return false

    # 新しい操作ブロックをセットする
    newShape()

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

      if typeof board[y + offsetY] == 'undefined' ||
        typeof board[y + offsetY][x + offsetX] == 'undefined' ||
        board[y + offsetY][x + offsetX] ||
        x + offsetX < 0 ||
        y + offsetY >= ROWS ||
        x + offsetX >= COLS

          # もし操作ブロックが盤面の上にあったらゲームオーバー
          if (offsetY == 1 && offsetX - currentX == 0 && offsetY - currentY == 1)
            console.log('game over')
            lose = true

          return false

  return true

# 操作ブロックを盤面にセットする関数
freeze = ()->
  for y in [0...4]
    for x in [0...4]
      if current[ y ][ x ]
        board[ y + currentY ][ x + currentX ] = current[ y ][ x ]

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
      rotated = rotate(current)
      # // 回せる場合は回したあとの状態に操作ブロックをセットする
      current = rotated if valid(0, 0, rotated)

# 操作ブロックを回す処理
rotate = (current)->
  newCurrent = []
  for y in [0...4]
    newCurrent[ y ] = []
    for x in [0...4]
      newCurrent[ y ][ x ] = current[ 3 - x ][ y ]

  newCurrent

newGame = ()->
  # ゲームタイマーをクリア
  clearInterval(interval)
  # 盤面をまっさらにする
  init()
  # 操作ブロックをセット
  newShape()
  # 負けフラッグ
  lose = false
  # 250ミリ秒ごとにtickという関数を呼び出す
  interval = setInterval( tick, 250 )

newGame()
