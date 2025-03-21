// 坐标类型
interface Coord {
  x: number;
  y: number;
  color: boolean;
}

@Entry
@Component
struct Index {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  // 棋盘起始坐标
  board_x: number = 0
  board_y: number = 0
  // 棋盘宽度
  board_width: number = 0
  // 棋盘线的间距
  line_spacing: number = 0
  // true黑 false白
  chess_color: boolean = true
  // 棋子坐标
  chess_coord: Coord[] = []

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .backgroundColor($r("sys.color.ohos_id_color_background"))
        .onReady(() => {
          this.init()
        })
        .onClick((e) => {
          this.drawChess(e.x, e.y)
        })
        .backgroundImage($r("app.media.background_img"))
        .backgroundImageSize(ImageSize.Cover)
    }
    .width('100%')
    .height('100%')
  }

  // 初始化棋盘方法
  init() {
    // 计算宽度，适配横屏
    if (this.context.width < this.context.height) {
      this.board_width = this.context.width - 40
    } else {
      this.board_width = this.context.height - 40
    }
    this.board_x = (this.context.width - this.board_width) / 2
    this.board_y = (this.context.height - this.board_width) / 2
    // 绘制正方形
    this.context.lineWidth = 4
    this.context.fillStyle = '#DBC26F'; // 设置填充颜色
    this.context.strokeStyle = '#000'
    this.context.fillRect(this.board_x, this.board_y, this.board_width, this.board_width); // 填充圆形
    this.context.strokeRect(this.board_x, this.board_y, this.board_width, this.board_width)

    // 计算棋盘线间距
    this.line_spacing = this.board_width / 14
    this.context.beginPath(); // 开始新路径
    this.context.lineWidth = 2
    for (let i = 0; i < 14; i++) {
      this.context.moveTo(this.board_x, this.board_y + i * this.line_spacing)
      this.context.lineTo(this.board_x + this.board_width, this.board_y + i * this.line_spacing)
    }
    for (let i = 0; i < 14; i++) {
      this.context.moveTo(this.board_x + i * this.line_spacing, this.board_y)
      this.context.lineTo(this.board_x + i * this.line_spacing, this.board_y + this.board_width)
    }
    this.context.stroke() // 绘制

    // 绘制棋盘上的五个点
    const points: Coord[] = [
      { x: 3, y: 3, color: true },
      { x: 11, y: 3, color: true },
      { x: 3, y: 11, color: true },
      { x: 11, y: 11, color: true },
      { x: 7, y: 7, color: true }
    ];

    this.context.fillStyle = '#000'; // 设置填充颜色
    this.context.lineWidth = 1; // 设置描边宽度

    for (const point of points) {
      this.context.beginPath(); // 新路径
      const x = this.board_x + this.line_spacing * point.x;
      const y = this.board_y + this.line_spacing * point.y;
      this.context.arc(x, y, 4, 0, 2 * Math.PI); // 绘制圆形路径
      this.context.fill(); // 填充圆形
    }
  }

  // 绘制棋子
  drawChess(x: number, y: number) {
    // 判断点击区域是否在棋盘内
    if (x >= this.board_x && x <= this.board_x + this.board_width && y >= this.board_y &&
      y <= this.board_y + this.board_width) {

      // 判断并设置棋子颜色
      if (this.chess_color) {
        this.context.fillStyle = '#000';
      } else {
        this.context.fillStyle = '#FFF';
      }

      // 修正坐标
      x = Math.round((x - this.board_x) / this.line_spacing);
      y = Math.round((y - this.board_y) / this.line_spacing);

      // 判断是否已经有棋子
      for (const coord of this.chess_coord) {
        if (coord.x === x && coord.y === y) {
          return
        }
      }

      // 绘制棋子
      this.context.strokeStyle = '#000'; // 设置描边颜色
      this.context.beginPath(); // 新路径
      this.context.arc(x * this.line_spacing + this.board_x, y * this.line_spacing + this.board_y,
        this.line_spacing / 2 - 1, 0, 2 * Math.PI); // 绘制圆形路径
      this.context.fill(); // 填充圆形
      this.context.stroke(); // 描边圆形

      // 加入棋子坐标
      this.chess_coord.push({ x, y, color: this.chess_color })

      // 判断是否五子连珠
      this.checkLink()

      // 切换棋子颜色
      this.chess_color = !this.chess_color

    }
  }

  // 判断是否五子连珠
  checkLink() {
    if (!this.chess_coord || this.chess_coord.length === 0) {
      return;
    }

    const lastCoord = this.chess_coord[this.chess_coord.length - 1];
    const directions: [number, number][] = [
      [1, 0], // 垂直方向
      [0, 1], // 水平方向
      [1, 1], // 右对角线
      [-1, 1]// 左对角线
    ];

    for (const direction of directions) {
      for (let method = 0; method < 5; method++) {
        const linkingCoords: Coord[] = [];
        for (let i = 0; i < 5; i++) {
          const newCoord: Coord = {
            x: lastCoord.x + direction[0] * (i - method),
            y: lastCoord.y + direction[1] * (i - method),
            color: lastCoord.color
          };

          const found = this.chess_coord.find(coord =>
          coord.x === newCoord.x && coord.y === newCoord.y && coord.color === newCoord.color
          );

          if (found) {
            linkingCoords.push(found)
          }
        }
        if (linkingCoords.length >= 5) {
          linkingCoords.forEach(item => {
            console.log(item.x.toString(), item.y.toString(), item.color)
            this.context.strokeStyle = '#FEFE00'; // 设置描边颜色
            this.context.beginPath(); // 新路径
            this.context.arc(item.x * this.line_spacing + this.board_x, item.y * this.line_spacing + this.board_y,
              this.line_spacing / 2 - 1, 0, 2 * Math.PI); // 绘制圆形路径
            this.context.stroke(); // 描边圆形
          })
          AlertDialog.show({
            message: `恭喜${this.chess_color ? '黑棋' : '白棋'}，你赢了！`,
            cancel: () => {
              // 初始化棋盘
              this.chess_coord = []
              this.chess_color = true
              // 初始化棋盘
              this.context.clearRect(0, 0, this.context.width, this.context.height);
              this.init()
            }
          });
        }
      }
    }
  }
}
