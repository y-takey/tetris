# キーボードを入力した時に一番最初に呼び出される処理

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

module.exports =
  bind: ()->
    document.body.onkeydown = (e)->
      # キーに名前をセットする
      keys =
        37: 'left'
        39: 'right'
        40: 'down'
        38: 'rotate'

      return unless keys[ e.keyCode ]

      # セットされたキーの場合はtetris.jsに記述された処理を呼び出す
      keyPress(keys[ e.keyCode ])
      # 描画処理を行う
      render()
