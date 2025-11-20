import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gymplan/services/settings_service.dart';

class AiService {
  static Future<String> generateWorkoutPlan({
    required double bodyWeight,
    required double height,
    required String extraInfo,
  }) async {
    final provider = await SettingsService.getApiProvider();
    
    final prompt = _buildPrompt(bodyWeight, height, extraInfo);

    if (provider == ApiProvider.gemini) {
      return await _generateWithGemini(prompt);
    } else {
      return await _generateWithOllama(prompt);
    }
  }

  static String _buildPrompt(double bodyWeight, double height, String extraInfo) {
    return '''Create a personalized weekly workout plan for someone with the following details:
- Body Weight: ${bodyWeight} kg
- Height: ${height} cm
- Additional Information: $extraInfo

Please provide a detailed 7-day workout plan with specific exercises, sets, reps, and rest periods. Format it clearly with days of the week.''';
  }

  static Future<String> _generateWithGemini(String prompt) async {
    final apiKey = await SettingsService.getGeminiApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Gemini API key is not configured');
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text ?? 'No response generated';
    } catch (e) {
      throw Exception('Failed to generate with Gemini: $e');
    }
  }

  static Future<String> _generateWithOllama(String prompt) async {
    final ip = await SettingsService.getOllamaIp();
    final port = await SettingsService.getOllamaPort();
    
    final url = Uri.parse('http://$ip:$port/api/generate');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': 'llama2',
          'prompt': prompt,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? 'No response generated';
      } else {
        throw Exception('Ollama API returned status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to generate with Ollama: $e');
    }
  }
}
