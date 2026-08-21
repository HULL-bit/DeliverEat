import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/gen/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.authLogoutTitle),
        content: Text(l10n.authLogoutConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.commonConfirm)),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SectionLabel(label: l10n.settingsAppearance),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: Text(l10n.settingsDarkMode),
            value: themeProvider.isDark,
            onChanged: themeProvider.toggleDark,
          ),
          const Divider(height: 1),
          _SectionLabel(label: l10n.settingsLanguage),
          RadioGroup<String>(
            groupValue: localeProvider.locale.languageCode,
            onChanged: (value) {
              if (value != null) localeProvider.setLocale(Locale(value));
            },
            child: Column(
              children: [
                RadioListTile<String>(title: Text(l10n.settingsLanguageFrench), value: 'fr'),
                RadioListTile<String>(title: Text(l10n.settingsLanguageEnglish), value: 'en'),
              ],
            ),
          ),
          const Divider(height: 1),
          _SectionLabel(label: l10n.settingsAbout),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) => ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: Text(l10n.settingsVersion),
              trailing: Text(snapshot.hasData ? '${snapshot.data!.version} (${snapshot.data!.buildNumber})' : '—'),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout_rounded, color: Theme.of(context).colorScheme.error),
            title: Text(l10n.settingsLogout, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
