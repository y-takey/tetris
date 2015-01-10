# キーボードを入力した時に一番最初に呼び出される処理

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
