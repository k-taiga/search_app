import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
        appBar: AppBar(
            title: Text(settings.language == "English" ? "Settings" : "設定")),
        body: Column(
          children: [
            _buildLanguageTile(ref, settings),
            _buildThemeTile(ref, settings),
          ],
        ));
  }

  ListTile _buildLanguageTile(WidgetRef ref, UserSettings settings) {
    return ListTile(
        title:
            Text(settings.language == "English" ? "Change Language" : "言語の変更"),
        trailing: Text(settings.language),
        onTap: () async {
          final newLanguage =
              settings.language == "English" ? "日本語" : "English";
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('language', newLanguage);
          ref.read(settingsProvider.notifier).updateLanguage(newLanguage);
        });
  }

  ListTile _buildThemeTile(WidgetRef ref, UserSettings settings) {
    final themeText = settings.theme == "Light"
        ? (settings.language == "English" ? "Light Mode" : "ライトモード")
        : (settings.language == "English" ? "Dark Mode" : "ダークモード");

    return ListTile(
        title: Text(settings.language == "English" ? "Change Theme" : "テーマの変更"),
        trailing: Text(settings.language),
        onTap: () async {
          final newTheme = settings.theme == "Light" ? "Dark" : "Light";
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('theme', newTheme);
          ref.read(settingsProvider.notifier).updateTheme(newTheme);
        });
  }
}
