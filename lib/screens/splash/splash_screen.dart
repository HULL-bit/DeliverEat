import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/routing/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/wax_pattern_painter.dart';

const _splashBackgrounds = [
  'assets/images/onboarding/onboarding_1.jpg',
  'assets/images/onboarding/onboarding_2.jpg',
  'assets/images/onboarding/onboarding_3.jpg',
];

/// Écran de démarrage : logo animé (scale + fade) sur un fond photo qui
/// alterne entre les 3 visuels culinaires, filigrané du motif wax, pendant
/// que la session est restaurée depuis le stockage sécurisé. S'affiche à
/// chaque lancement (un utilisateur doit toujours voir que l'app démarre) ;
/// un tap n'importe où saute l'attente minimale une fois la session vérifiée.
/// Redirige ensuite vers l'accueil, la connexion ou l'onboarding (première
/// ouverture) via une transition fade-through.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _skipRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final stopwatch = Stopwatch()..start();
    final auth = context.read<AuthProvider>();
    final prefs = await SharedPreferences.getInstance();

    final hasSession = await auth.restoreSession();
    final onboardingSeen = prefs.getBool(StorageKeys.onboardingSeen) ?? false;

    final elapsed = stopwatch.elapsed;
    final remaining = AppDurations.splashMinDuration - elapsed;
    if (remaining > Duration.zero && !_skipRequested) {
      await Future.delayed(remaining);
    }
    if (!mounted) return;

    final destination = hasSession
        ? AppRoutes.home
        : (onboardingSeen ? AppRoutes.login : AppRoutes.onboarding);
    Navigator.of(context).pushReplacementNamed(destination);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.primary,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _skipRequested = true),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const _SplashBackgroundCarousel(),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scheme.primary.withValues(alpha: 0.45),
                    scheme.primary.withValues(alpha: 0.55),
                    scheme.primary.withValues(alpha: 0.85),
                  ],
                  stops: const [0, 0.5, 1],
                ),
              ),
            ),
            WaxPatternBackground(
              opacity: 0.10,
              child: Center(child: _SplashLogo()),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashBackgroundCarousel extends StatefulWidget {
  const _SplashBackgroundCarousel();

  @override
  State<_SplashBackgroundCarousel> createState() => _SplashBackgroundCarouselState();
}

class _SplashBackgroundCarouselState extends State<_SplashBackgroundCarousel> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (!WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations) {
      _timer = Timer.periodic(const Duration(milliseconds: 1600), (_) {
        if (mounted) setState(() => _index = (_index + 1) % _splashBackgrounds.length);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      child: Image.asset(
        _splashBackgrounds[_index],
        key: ValueKey(_index),
        fit: BoxFit.cover,
      ),
    );
  }
}

class _SplashLogo extends StatefulWidget {
  @override
  State<_SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<_SplashLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  late final Animation<double> _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.6, curve: Curves.easeOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final logo = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 24, offset: const Offset(0, 12))],
          ),
          alignment: Alignment.center,
          child: Text('🍲', style: const TextStyle(fontSize: 44)),
        ),
        const SizedBox(height: 20),
        Text(
          'DeliverEat',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          'Dakar',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white.withValues(alpha: 0.85), letterSpacing: 4),
        ),
      ],
    );

    if (reduceMotion) return logo;
    return ScaleTransition(
      scale: _scale,
      child: FadeTransition(opacity: _fade, child: logo),
    );
  }
}
