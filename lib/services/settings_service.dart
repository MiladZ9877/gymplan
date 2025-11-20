import 'package:shared_preferences/shared_preferences.dart';

enum ApiProvider { gemini, ollama }

enum AppLanguage { english, persian }

class SettingsService {
  static const String _keyApiProvider = 'api_provider';
  static const String _keyGeminiApiKey = 'gemini_api_key';
  static const String _keyOllamaIp = 'ollama_ip';
  static const String _keyOllamaPort = 'ollama_port';
  static const String _keyLanguage = 'language';

  static Future<ApiProvider> getApiProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final provider = prefs.getString(_keyApiProvider) ?? 'gemini';
    return provider == 'ollama' ? ApiProvider.ollama : ApiProvider.gemini;
  }

  static Future<void> setApiProvider(ApiProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyApiProvider,
      provider == ApiProvider.ollama ? 'ollama' : 'gemini',
    );
  }

  static Future<String?> getGeminiApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyGeminiApiKey);
  }

  static Future<void> setGeminiApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyGeminiApiKey, apiKey);
  }

  static Future<String> getOllamaIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyOllamaIp) ?? 'localhost';
  }

  static Future<void> setOllamaIp(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOllamaIp, ip);
  }

  static Future<String> getOllamaPort() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyOllamaPort) ?? '11434';
  }

  static Future<void> setOllamaPort(String port) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOllamaPort, port);
  }

  static Future<AppLanguage> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString(_keyLanguage) ?? 'english';
    return lang == 'persian' ? AppLanguage.persian : AppLanguage.english;
  }

  static Future<void> setLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyLanguage,
      language == AppLanguage.persian ? 'persian' : 'english',
    );
  }
}
