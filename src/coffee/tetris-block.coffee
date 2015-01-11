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

class Block
  constructor: (shape, @color)->
    @cells = for y in [0...4]
      for x in [0...4]
        if shape[4 * y + x] then 1 else 0

  # 操作ブロックを回す処理
  rotate: ()->
    block = new Block([], @color)
    block.cells = @eachCell (y, x, cell)=>
      @cells[ 3 - x ][ y ]
    block

  eachCell: (func)->
    for y in [0...4]
      func(y, x, @cells[y][x]) for x in [0...4]

# shapesからランダムにブロックのパターンを出力し、盤面の一番上へセットする
generate = ()->
  # ランダムにインデックスを出す
  id = Math.floor( Math.random() * shapes.length )
  current = new Block(shapes[id], colors[id])

module.exports =

  generate: generate
