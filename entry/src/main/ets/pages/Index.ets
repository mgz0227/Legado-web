import web_webview from '@ohos.web.webview';
import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import { PreferencesHelper } from '../utils/PreferencesHelper';

@Entry
@Component
struct Index {
  private controller: web_webview.WebviewController = new web_webview.WebviewController();

  async onWebReadyInject() {
    const ip = await PreferencesHelper.get('server_ip', '');
    const port = await PreferencesHelper.get('server_port', '');
    if (ip && port) {
      const js = `
        localStorage.setItem('remoteUrl', 'http://${ip}:${port}');
        if (!sessionStorage.__injected__) { sessionStorage.__injected__ = '1'; location.reload(); }
      `;
      try {
        await this.controller.runJavaScript(js);
        console.info('Injected remoteUrl success');
      } catch (err) {
        const error = err as BusinessError<void>;
        console.error(`runJavaScript failed: code=${error.code}, message=${error.message}`);
      }
    }
  }

  build() {
    Column({ space: 8 }) {
      Row() {
        Text('开源阅读Web')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
        Blank()
        Button('设置服务器')
          .onClick(() => {
            router.pushUrl({ url: 'pages/Settings' })
              .then(() => console.info('Navigation success'))
              .catch((err: BusinessError<void>) => {
                console.error(`Navigation failed: code=${err.code}, message=${err.message}`);
              });
          })
      }
      .width('100%')
      .padding(12)

      Web({
        src: $rawfile('web/index.html'),
        controller: this.controller
      })
        .javaScriptAccess(true)
        .domStorageAccess(true)
        .onPageEnd((event) => {
          console.info('Web page finished:', event.url);
          this.onWebReadyInject();
        })
        .width('100%')
        .height('100%')
    }
    .height('100%')
    .width('100%')
  }
}
