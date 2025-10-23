import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(stage: window.WindowStage) {
    const storage = new LocalStorage();
    storage.set('key', 'value');

    // ✅ 方法名小写
    stage.loadContent('pages/Index', storage)
      .then(() => {
        console.info('Page loaded successfully');
      })
      .catch((err: BusinessError<void>) => {
        console.error(`loadContent failed: code=${err.code}, message=${err.message}`);
      });
  }
}
