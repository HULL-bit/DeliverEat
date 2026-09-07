# DeliverEat — Livraison de repas à Dakar

Application Flutter (Android · iOS · Linux desktop) pour DeliverEat, connectée à
l'API publique `https://delivereat.89-167-122-158.sslip.io`. Aucune donnée
métier (restaurant, plat, prix, avis...) n'est codée en dur : tout provient de
l'API en temps réel.

## Architecture

Feature-first en couches strictes, avec un sens de dépendance unique :

```
UI (screens/, widgets/)
   ↓ lit via context.watch/select, agit via context.read<X>().méthode()
providers/ (ChangeNotifier, état typé ViewState<T>)
   ↓ appelle
services/ (seul point d'appel réseau, mappe DioException → ApiException)
   ↓ utilise
core/network/ (DioClient + AuthInterceptor) · models/ (fromJson typés)
```

- **`core/config/app_config.dart`** — unique constante `baseUrl` ; changer
  d'environnement ne coûte qu'une ligne. `wsUrl()` en dérive.
- **`core/network/auth_interceptor.dart`** — sur 401 `TOKEN_EXPIRED`, déclenche
  `/auth/refresh`, rejoue la requête d'origine, et protège les refresh
  concurrents avec un verrou *single-flight* (`Completer` partagé) pour ne
  jamais consommer deux refresh tokens rotatifs en parallèle.
- **`models/view_state.dart`** — `ViewState<T>` générique
  (`initial/loading/success/error`) utilisé par **tous** les providers : un
  `switch` unique dans l'UI pour chargement / erreur+retry / vide / contenu.
- **`providers/`** — un `ChangeNotifier` par domaine (Auth, Restaurant, Cart,
  Favorite, Order, OrderTracking, Theme, Locale, Connectivity), câblés dans
  `app.dart` via `MultiProvider` / `ChangeNotifierProxyProvider` (les
  providers authentifiés s'abonnent à `AuthProvider`).
- **`services/order_socket.dart`** — client WebSocket avec reconnexion à
  backoff croissant, régénération du token avant chaque reconnexion (le token
  de l'URL expire comme n'importe quel access token), et gestion du code de
  fermeture `4001`. `OrderTrackingProvider` bascule automatiquement sur un
  polling REST (`GET /orders/:id`) tant que le WebSocket est indisponible.
- **`core/network/retry_interceptor.dart`** — petit backoff automatique sur
  429 `RATE_LIMITED` (respecte l'en-tête `Retry-After` si présent) et sur les
  erreurs réseau transitoires pour les requêtes idempotentes (GET), bornée à
  2 tentatives pour ne jamais spammer l'API.
- **`core/utils/error_messages.dart`** — mapping unique code → message
  FR/EN. Les providers ne dépendent jamais de `BuildContext` : ils stockent
  le `code` d'erreur dans `ViewState.errorCode`, et c'est l'UI qui le résout
  au moment de l'affichage via `ErrorMessages.resolve`.

## Packages utilisés (et pourquoi)

| Package | Rôle |
|---|---|
| `dio` | Client HTTP + intercepteurs (auth, refresh transparent) |
| `provider` | Gestion d'état exigée par le sujet |
| `flutter_secure_storage` | Stockage des tokens (Keystore/Keychain/libsecret) |
| `web_socket_channel` | Suivi de commande en direct |
| `cached_network_image` + `shimmer` | Images distantes avec cache et squelette de chargement |
| `image_picker` / `file_selector` | Sélection d'avatar : galerie/caméra mobile vs sélecteur de fichier Linux, derrière `MediaPickerService` |
| `connectivity_plus` | Bannière hors ligne + repli sur cache |
| `shared_preferences` | Préférences (thème, langue, onboarding, recherches récentes, cache restaurants) |
| `intl` + `flutter_localizations` | FR/EN, formats de date/prix |
| `google_fonts` | Typographie Sora (titres) / Inter (corps) |
| `flutter_rating_bar` | Étoiles (affichage + saisie d'avis) |
| `timeago` | Horodatages relatifs localisés (frise de suivi, avis) |
| `flutter_local_notifications` | Notification locale à chaque changement de statut de commande |
| `package_info_plus` | Version affichée dans Réglages |
| `flutter_animate` | Animations déclaratives (listes, micro-interactions) |
| `animations` | Container-transform (carte → fiche restaurant), shared-axis (onglets), fade-through (navigation) |
| `flutter_svg`, `lottie` | Dépendances prêtes pour illustrations vectorielles/Lottie (voir *Difficultés*) |

Pas de package ajouté sans usage identifié (ex : pas de gestion d'état
supplémentaire, pas de générateur de code lourd).

## Difficultés rencontrées & hypothèses documentées

- **Forme réelle de l'API** vérifiée par appels directs (`curl`) plutôt que
  supposée : `GET /categories` et `GET /me/favorites` renvoient
  `{ "data": [...] }` (pas un tableau nu) ; `GET/PATCH /auth/me` renvoient
  `{ "user": {...} }` ; les restaurants exposent `deliveryTimeMin`/`deliveryTimeMax`
  (pas un `deliveryTime` unique) ; les entrées de `statusHistory` utilisent la
  clé `at` (pas `timestamp`). Le code est aligné sur ces formes réelles.
- **Regroupement du menu par section** : l'API renvoie une liste plate
  d'articles portant chacun un champ `section` (`"Entrées"`, `"Plats"`,
  `"Boissons"`...) — le regroupement est fait côté client (`RestaurantDetailScreen`).
- **Lottie** : le package est intégré et prêt à l'emploi, mais aucun fichier
  `.json` Lottie n'a été inventé à la main (risque de fichier invalide
  impossible à prévisualiser hors ligne). Les moments d'animation forts
  (frise de suivi, favoris, états vides) sont implémentés avec
  `flutter_animate` + `CustomPainter` (motif wax), qui offrent le même
  niveau de finition sans dépendre d'un asset binaire non vérifiable.
- **Images décoratives** (splash/onboarding) : issues de `media/` (photos
  libres de droits déjà présentes dans le dépôt), recadrées et compressées
  dans `assets/images/onboarding/`. Toutes les données de restaurants/plats
  restent 100 % API.
- **Accessibilité** : `Semantics`/`tooltip` sur les boutons icône-seule
  (favori, retour, quantité panier, changer photo...) ; les animations
  respectent `MediaQuery.disableAnimations`.

## Rapport & captures

`Rapport_DeliverEat_Souleymane_DIAW.docx` (racine du dépôt) détaille
l'architecture, les packages et le parcours complet illustré par les
captures d'écran réelles du dossier `captures/` (exécutable Linux).

## Prérequis Linux (développement sous Linux)

```bash
flutter config --enable-linux-desktop
flutter create --platforms=android,ios,linux .   # déjà fait dans ce dépôt

# Debian/Ubuntu :
sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev \
  liblzma-dev libsecret-1-dev libjsoncpp-dev

# Fedora :
sudo dnf install -y clang cmake ninja-build gtk3-devel xz-devel \
  libsecret-devel jsoncpp-devel
```

`libsecret` est requis par `flutter_secure_storage` sur Linux (accès au
trousseau système) ; aucune logique différente n'est écrite côté Dart.

## Lancer le projet

```bash
flutter pub get
flutter run -d linux     # bureau Linux (développement principal)
flutter run -d android   # émulateur/appareil Android
flutter run -d ios       # simulateur/appareil iOS
```

Compte de démonstration : `demo@delivereat.app` / `password123` (bouton de
préremplissage sur l'écran de connexion).

> **Note** : Gradle affiche un avertissement non bloquant recommandant
> `compileSdk = 37` (requis en théorie par `flutter_secure_storage`). Sur des
> installations où la plateforme SDK 37 n'est pas encore correctement
> enregistrée par `sdkmanager`, le forcer casse le build ; `compileSdk`
> reste donc sur la valeur par défaut de Flutter (rétro-compatible), et les
> builds Android/Linux ont été vérifiés de bout en bout dans cet état.

## Générer l'APK de debug

```bash
flutter build apk --debug
# APK produit dans build/app/outputs/flutter-apk/app-debug.apk
```

**Ne pas inclure `build/` ni `.dart_tool/` dans l'archive envoyée.**
