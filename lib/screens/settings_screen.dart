import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymplan/services/settings_service.dart';
import 'package:gymplan/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ApiProvider? _selectedProvider;
  AppLanguage? _selectedLanguage;
  final _geminiApiKeyController = TextEditingController();
  final _ollamaIpController = TextEditingController();
  final _ollamaPortController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _geminiApiKeyController.dispose();
    _ollamaIpController.dispose();
    _ollamaPortController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    final provider = await SettingsService.getApiProvider();
    final language = await SettingsService.getLanguage();
    final geminiApiKey = await SettingsService.getGeminiApiKey();
    final ollamaIp = await SettingsService.getOllamaIp();
    final ollamaPort = await SettingsService.getOllamaPort();

    setState(() {
      _selectedProvider = provider;
      _selectedLanguage = language;
      _geminiApiKeyController.text = geminiApiKey ?? '';
      _ollamaIpController.text = ollamaIp;
      _ollamaPortController.text = ollamaPort;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    await SettingsService.setApiProvider(_selectedProvider!);
    await SettingsService.setLanguage(_selectedLanguage!);
    await SettingsService.setGeminiApiKey(_geminiApiKeyController.text);
    await SettingsService.setOllamaIp(_ollamaIpController.text);
    await SettingsService.setOllamaPort(_ollamaPortController.text);

    if (mounted) {
      // Update app language
      MyApp.of(context).setLanguage(_selectedLanguage!);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.save),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.settings)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        actions: [
          TextButton(
            onPressed: _selectedProvider != null && _selectedLanguage != null
                ? _saveSettings
                : null,
            child: Text(l10n.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.language,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<AppLanguage>(
              segments: [
                ButtonSegment(
                  value: AppLanguage.english,
                  label: Text(l10n.english),
                ),
                ButtonSegment(
                  value: AppLanguage.persian,
                  label: Text(l10n.persian),
                ),
              ],
              selected: {_selectedLanguage!},
              onSelectionChanged: (Set<AppLanguage> newSelection) {
                setState(() {
                  _selectedLanguage = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 32),
            Text(
              l10n.apiProvider,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<ApiProvider>(
              segments: [
                ButtonSegment(
                  value: ApiProvider.gemini,
                  label: Text(l10n.gemini),
                ),
                ButtonSegment(
                  value: ApiProvider.ollama,
                  label: Text(l10n.ollama),
                ),
              ],
              selected: {_selectedProvider!},
              onSelectionChanged: (Set<ApiProvider> newSelection) {
                setState(() {
                  _selectedProvider = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 32),
            if (_selectedProvider == ApiProvider.gemini) ...[
              Text(
                l10n.geminiApiKey,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _geminiApiKeyController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: l10n.apiKey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ] else ...[
              Text(
                l10n.ollamaIp,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _ollamaIpController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'localhost',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.ollamaPort,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _ollamaPortController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '11434',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
