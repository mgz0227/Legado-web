import { PreferencesHelper } from '../utils/PreferencesHelper';

@Entry
@Component
struct Settings {
  @State ip: string = ''
  @State port: string = ''

  commonServers: any[] = [
    { name: '本机服务器', ip: '192.168.1.8', port: '1122' },
    { name: '本地调试', ip: '127.0.0.1', port: '1122' },
    { name: '云端示例', ip: 'demo.example.com', port: '80' }
  ]

  async aboutToAppear() {
    this.ip = await PreferencesHelper.get('server_ip', '')
    this.port = await PreferencesHelper.get('server_port', '')
  }

  private async save() {
    await PreferencesHelper.set('server_ip', this.ip.trim())
    await PreferencesHelper.set('server_port', this.port.trim())
    promptAction.showToast({ message: '已保存' })
    router.back()
  }

  private usePreset(item: any) {
    this.ip = item.ip
    this.port = item.port
  }

  build() {
    Column({ space: 16 }) {
      Text('服务器设置').fontSize(20).fontWeight(FontWeight.Medium)
      ForEach(this.commonServers, (item) => {
        Button(item.name + ' (' + item.ip + ':' + item.port + ')')
          .onClick(() => this.usePreset(item))
          .width('100%')
      })
      TextInput({ placeholder: 'IP，例如 192.168.1.8' })
        .text(this.ip).onChange(v => this.ip = v)
      TextInput({ placeholder: '端口，例如 1122' })
        .text(this.port).onChange(v => this.port = v)
      Button('保存').onClick(() => this.save()).width('100%')
    }
    .padding(20)
    .width('100%').height('100%')
  }
}
