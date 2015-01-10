(function() {
  var BLOCK_H, BLOCK_W, COLS, H, ROWS, W, board, canvas, clearLines, colors, ctx, current, currentX, currentY, drawBlock, freeze, init, interval, keyPress, lose, newGame, newShape, render, rotate, shapes, tick, valid;

  document.body.onkeydown = function(e) {
    var keys;
    keys = {
      37: 'left',
      39: 'right',
      40: 'down',
      38: 'rotate'
    };
    if (!keys[e.keyCode]) {
      return;
    }
    keyPress(keys[e.keyCode]);
    return render();
  };

  canvas = document.getElementsByTagName('canvas')[0];

  ctx = canvas.getContext('2d');

  COLS = 10;

  ROWS = 20;

  W = 300;

  H = 600;

  BLOCK_W = W / COLS;

  BLOCK_H = H / ROWS;

  render = function() {
    var x, y, _i, _j, _k, _results;
    ctx.clearRect(0, 0, W, H);
    ctx.strokeStyle = 'black';
    for (x = _i = 0; 0 <= COLS ? _i < COLS : _i > COLS; x = 0 <= COLS ? ++_i : --_i) {
      for (y = _j = 0; 0 <= ROWS ? _j < ROWS : _j > ROWS; y = 0 <= ROWS ? ++_j : --_j) {
        if (!board[y][x]) {
          continue;
        }
        ctx.fillStyle = colors[board[y][x] - 1];
        drawBlock(x, y);
      }
    }
    _results = [];
    for (y = _k = 0; _k < 4; y = ++_k) {
      _results.push((function() {
        var _l, _results1;
        _results1 = [];
        for (x = _l = 0; _l < 4; x = ++_l) {
          if (!current[y][x]) {
            continue;
          }
          ctx.fillStyle = colors[current[y][x] - 1];
          _results1.push(drawBlock(currentX + x, currentY + y));
        }
        return _results1;
      })());
    }
    return _results;
  };

  drawBlock = function(x, y) {
    var args;
    args = [BLOCK_W * x, BLOCK_H * y, BLOCK_W - 1, BLOCK_H - 1];
    ctx.fillRect.apply(ctx, args);
    return ctx.strokeRect.apply(ctx, args);
  };

  setInterval(render, 30);

  board = [];

  lose = false;

  interval = null;

  current = null;

  currentX = null;

  currentY = null;

  shapes = [[1, 1, 1, 1], [1, 1, 1, 0, 1], [1, 1, 1, 0, 0, 0, 1], [1, 1, 0, 0, 1, 1], [1, 1, 0, 0, 0, 1, 1], [0, 1, 1, 0, 1, 1], [0, 1, 0, 0, 1, 1, 1]];

  colors = ['cyan', 'orange', 'blue', 'yellow', 'red', 'green', 'purple'];

  init = function() {
    var x, y, _i, _results;
    _results = [];
    for (y = _i = 0; 0 <= ROWS ? _i < ROWS : _i > ROWS; y = 0 <= ROWS ? ++_i : --_i) {
      board[y] = [];
      _results.push((function() {
        var _j, _results1;
        _results1 = [];
        for (x = _j = 0; 0 <= COLS ? _j < COLS : _j > COLS; x = 0 <= COLS ? ++_j : --_j) {
          _results1.push(board[y][x] = 0);
        }
        return _results1;
      })());
    }
    return _results;
  };

  newShape = function() {
    var i, id, shape, x, y, _i, _j;
    id = Math.floor(Math.random() * shapes.length);
    shape = shapes[id];
    current = [];
    for (y = _i = 0; _i < 4; y = ++_i) {
      current[y] = [];
      for (x = _j = 0; _j < 4; x = ++_j) {
        i = 4 * y + x;
        current[y][x] = shape[i] ? id + 1 : 0;
      }
    }
    currentX = 5;
    return currentY = 0;
  };

  tick = function() {
    if (valid(0, 1)) {
      return ++currentY;
    } else {
      freeze();
      clearLines();
      if (lose) {
        newGame();
        return false;
      }
      return newShape();
    }
  };

  valid = function(offsetX, offsetY, newCurrent) {
    var x, y, _i, _j;
    offsetX || (offsetX = 0);
    offsetY || (offsetY = 0);
    offsetX = currentX + offsetX;
    offsetY = currentY + offsetY;
    newCurrent || (newCurrent = current);
    for (y = _i = 0; _i < 4; y = ++_i) {
      for (x = _j = 0; _j < 4; x = ++_j) {
        if (!newCurrent[y][x]) {
          continue;
        }
        if (typeof board[y + offsetY] === 'undefined' || typeof board[y + offsetY][x + offsetX] === 'undefined' || board[y + offsetY][x + offsetX] || x + offsetX < 0 || y + offsetY >= ROWS || x + offsetX >= COLS) {
          if (offsetY === 1 && offsetX - currentX === 0 && offsetY - currentY === 1) {
            console.log('game over');
            lose = true;
          }
          return false;
        }
      }
    }
    return true;
  };

  freeze = function() {
    var x, y, _i, _results;
    _results = [];
    for (y = _i = 0; _i < 4; y = ++_i) {
      _results.push((function() {
        var _j, _results1;
        _results1 = [];
        for (x = _j = 0; _j < 4; x = ++_j) {
          if (current[y][x]) {
            _results1.push(board[y + currentY][x + currentX] = current[y][x]);
          } else {
            _results1.push(void 0);
          }
        }
        return _results1;
      })());
    }
    return _results;
  };

  clearLines = function() {
    var rowFilled, x, y, yy, _i, _j, _k, _results;
    y = ROWS;
    _results = [];
    while (y > 0) {
      --y;
      rowFilled = true;
      for (x = _i = 0; 0 <= COLS ? _i < COLS : _i > COLS; x = 0 <= COLS ? ++_i : --_i) {
        if (board[y][x] !== 0) {
          continue;
        }
        rowFilled = false;
        break;
      }
      if (!rowFilled) {
        continue;
      }
      document.getElementById('clearsound').play();
      for (yy = _j = y; y <= 0 ? _j < 0 : _j > 0; yy = y <= 0 ? ++_j : --_j) {
        for (x = _k = 0; 0 <= COLS ? _k < COLS : _k > COLS; x = 0 <= COLS ? ++_k : --_k) {
          board[yy][x] = board[yy - 1][x];
        }
      }
      _results.push(++y);
    }
    return _results;
  };

  keyPress = function(key) {
    var rotated;
    switch (key) {
      case 'left':
        if (valid(-1)) {
          return --currentX;
        }
        break;
      case 'right':
        if (valid(1)) {
          return ++currentX;
        }
        break;
      case 'down':
        if (valid(0, 1)) {
          return ++currentY;
        }
        break;
      case 'rotate':
        rotated = rotate(current);
        if (valid(0, 0, rotated)) {
          return current = rotated;
        }
    }
  };

  rotate = function(current) {
    var newCurrent, x, y, _i, _j;
    newCurrent = [];
    for (y = _i = 0; _i < 4; y = ++_i) {
      newCurrent[y] = [];
      for (x = _j = 0; _j < 4; x = ++_j) {
        newCurrent[y][x] = current[3 - x][y];
      }
    }
    return newCurrent;
  };

  newGame = function() {
    clearInterval(interval);
    init();
    newShape();
    lose = false;
    return interval = setInterval(tick, 250);
  };

  newGame();

}).call(this);
