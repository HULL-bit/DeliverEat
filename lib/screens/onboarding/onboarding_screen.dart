import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../widgets/wax_pattern_painter.dart';

class _OnboardingPageData {
  const _OnboardingPageData({required this.asset, required this.title, required this.subtitle});
  final String asset;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) subtitle;
}

final _pages = [
  _OnboardingPageData(
    asset: 'assets/images/onboarding/onboarding_1.jpg',
    title: (l10n) => l10n.onboardingTitle1,
    subtitle: (l10n) => l10n.onboardingSubtitle1,
  ),
  _OnboardingPageData(
    asset: 'assets/images/onboarding/onboarding_2.jpg',
    title: (l10n) => l10n.onboardingTitle2,
    subtitle: (l10n) => l10n.onboardingSubtitle2,
  ),
  _OnboardingPageData(
    asset: 'assets/images/onboarding/onboarding_3.jpg',
    title: (l10n) => l10n.onboardingTitle3,
    subtitle: (l10n) => l10n.onboardingSubtitle3,
  ),
];

/// Onboarding 3 écrans, affiché une seule fois (persisté via
/// `shared_preferences`). Purement décoratif/pédagogique : aucune donnée
/// métier n'y figure.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.onboardingSeen, true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _finish();
      return;
    }
    _controller.nextPage(duration: AppDurations.animMedium, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isLast = _index == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextButton(onPressed: _finish, child: Text(l10n.commonSkip)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _OnboardingPage(data: _pages[i]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: AppDurations.animFast,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _index ? scheme.primary : scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(isLast ? l10n.commonStart : l10n.commonNext),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(data.asset, fit: BoxFit.cover),
                  WaxPatternBackground(opacity: 0.08, child: const SizedBox.expand()),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.96, 0.96), curve: Curves.easeOutCubic),
          const SizedBox(height: 32),
          Text(
            data.title(l10n),
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 100.ms, duration: 350.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 12),
          Text(
            data.subtitle(l10n),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 180.ms, duration: 350.ms),
          const Spacer(),
        ],
      ),
    );
  }
}
