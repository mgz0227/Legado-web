import preferences from '@ohos.data.preferences';

const STORE = 'server_prefs'

export class PreferencesHelper {
  static async get(key: string, def = ''): Promise<string> {
    const pref = await preferences.getPreferences(getContext(this).getApplicationContext(), STORE)
    return await pref.get(key, def)
  }

  static async set(key: string, value: string): Promise<void> {
    const pref = await preferences.getPreferences(getContext(this).getApplicationContext(), STORE)
    await pref.put(key, value)
    await pref.flush()
  }
}
