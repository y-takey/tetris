# 今操作しているブロックの形
current = null

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

# shapesからランダムにブロックのパターンを出力し、盤面の一番上へセットする
generate = ()->
  # ランダムにインデックスを出す
  id = Math.floor( Math.random() * shapes.length )
  shape = shapes[id]
  # パターンを操作ブロックへセットする
  current = for y in [0...4]
    for x in [0...4]
      i = 4 * y + x
      if shape[i] then id + 1 else 0

# 操作ブロックを回す処理
rotate = ()->
  for y in [0...4]
    current[ 3 - x ][ y ] for x in [0...4]

module.exports =

  generate: generate
  rotate: rotate
