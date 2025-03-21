import { font, router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  // 注册字体
  aboutToAppear() {
    font.registerFont({
      familyName: $r('app.string.index_title_font_name'),
      familySrc: $r('app.string.index_title_font_src'),
    })
  }

  build() {
    Column() {
      Row() {
        Text($r("app.string.index_title"))
          .fontSize($r('app.float.title_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .fontFamily('SThuawenxingkai')
      }

      Row() {
        Button() {
          Text($r("app.string.start_button_text"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#000')
            .fontFamily('SThuawenxingkai')
        }
        .onClick(() => {
          router.pushUrl({ url: "pages/Second" })
        })
        .type(ButtonType.Capsule)
        .startButtonStyle()
      }
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundImage($r("app.media.background_img"))
    .backgroundImageSize(ImageSize.Cover)
  }

  @Styles
  startButtonStyle() {
    .margin({
      top: 20
    })
    .backgroundColor($r('sys.color.button_background_color_transparent'))
    .width('40%')
    .height('6%')
    .borderRadius(20)
    .shadow({
      radius: 10,
      color: '#000',
      offsetX: 0,
      offsetY: 5
    })
  }
}
