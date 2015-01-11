keyMap =
  37: 'moveLeft'
  39: 'moveRight'
  40: 'moveDown'
  38: 'rotate'

module.exports =
  bind: (board)->

    document.body.onkeydown = (e)->
      meth = keyMap[e.keyCode]
      board[meth]() if meth
