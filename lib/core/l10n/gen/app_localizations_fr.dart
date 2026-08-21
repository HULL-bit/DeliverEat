// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'DeliverEat';

  @override
  String get appTagline => 'Le goût de Dakar, livré chez vous';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonSeeAll => 'Tout voir';

  @override
  String get commonLoading => 'Chargement...';

  @override
  String get commonYes => 'Oui';

  @override
  String get commonNo => 'Non';

  @override
  String get commonOr => 'ou';

  @override
  String get commonSkip => 'Passer';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonStart => 'Commencer';

  @override
  String get commonDone => 'Terminé';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonRemove => 'Retirer';

  @override
  String get commonSearch => 'Rechercher';

  @override
  String get commonUnknownError => 'Une erreur inattendue est survenue.';

  @override
  String get errorEmailTaken =>
      'Cet e-mail est déjà utilisé par un autre compte.';

  @override
  String get errorInvalidCredentials => 'E-mail ou mot de passe incorrect.';

  @override
  String get errorRestaurantClosed => 'Ce restaurant est actuellement fermé.';

  @override
  String get errorMixedRestaurants =>
      'Votre panier contient des articles d\'un autre restaurant.';

  @override
  String get errorValidation =>
      'Certaines informations sont invalides. Vérifiez le formulaire.';

  @override
  String get errorAlreadyReviewed =>
      'Vous avez déjà laissé un avis pour ce restaurant.';

  @override
  String get errorCannotCancel => 'Cette commande ne peut plus être annulée.';

  @override
  String get errorFileTooLarge =>
      'Le fichier dépasse la taille maximale autorisée (2 Mo).';

  @override
  String get errorRateLimited => 'Trop de requêtes, réessayez dans un instant.';

  @override
  String get errorNotFound => 'Ressource introuvable.';

  @override
  String get errorNetwork =>
      'Pas de connexion internet. Vérifiez votre réseau.';

  @override
  String get errorTimeout => 'Le serveur met trop de temps à répondre.';

  @override
  String get errorUnauthorized =>
      'Votre session a expiré, veuillez vous reconnecter.';

  @override
  String get errorConflict =>
      'Cette action entre en conflit avec l\'état actuel.';

  @override
  String get onboardingTitle1 => 'Les saveurs de Dakar';

  @override
  String get onboardingSubtitle1 =>
      'Thiéboudienne, yassa, mafé... les meilleurs plats sénégalais livrés chez vous.';

  @override
  String get onboardingTitle2 => 'Commandez en quelques taps';

  @override
  String get onboardingSubtitle2 =>
      'Parcourez les restaurants, composez votre panier et validez en toute simplicité.';

  @override
  String get onboardingTitle3 => 'Suivez votre livraison en direct';

  @override
  String get onboardingSubtitle3 =>
      'De la préparation à votre porte, suivez chaque étape en temps réel.';

  @override
  String get authLoginTitle => 'Content de vous revoir';

  @override
  String get authLoginSubtitle => 'Connectez-vous pour continuer';

  @override
  String get authRegisterTitle => 'Créer un compte';

  @override
  String get authRegisterSubtitle =>
      'Rejoignez DeliverEat en quelques secondes';

  @override
  String get authFieldName => 'Nom complet';

  @override
  String get authFieldEmail => 'Adresse e-mail';

  @override
  String get authFieldPassword => 'Mot de passe';

  @override
  String get authFieldPhone => 'Téléphone';

  @override
  String get authLoginButton => 'Se connecter';

  @override
  String get authRegisterButton => 'S\'inscrire';

  @override
  String get authNoAccount => 'Pas encore de compte ?';

  @override
  String get authHasAccount => 'Vous avez déjà un compte ?';

  @override
  String get authCreateAccount => 'Créer un compte';

  @override
  String get authSignIn => 'Se connecter';

  @override
  String get authErrorEmailInvalid => 'Adresse e-mail invalide.';

  @override
  String get authErrorPasswordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères.';

  @override
  String get authErrorNameRequired => 'Le nom est requis.';

  @override
  String get authLogoutTitle => 'Se déconnecter';

  @override
  String get authLogoutConfirm => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get homeTitle => 'Accueil';

  @override
  String homeGreeting(String name) {
    return 'Bonjour, $name';
  }

  @override
  String get homeSearchHint => 'Rechercher un restaurant, un plat...';

  @override
  String get homeCategoriesTitle => 'Catégories';

  @override
  String get homeRestaurantsTitle => 'Restaurants';

  @override
  String get homeOpenOnly => 'Ouverts uniquement';

  @override
  String get homeSortLabel => 'Trier par';

  @override
  String get homeSortRating => 'Note';

  @override
  String get homeSortDeliveryTime => 'Délai de livraison';

  @override
  String get homeSortDeliveryFee => 'Frais de livraison';

  @override
  String get homeSortName => 'Nom';

  @override
  String get homeEmptyTitle => 'Aucun résultat';

  @override
  String get homeEmptySubtitle =>
      'Essayez une autre recherche ou un autre filtre.';

  @override
  String get homeRecentSearches => 'Recherches récentes';

  @override
  String get homeClearSearches => 'Effacer';

  @override
  String get restaurantClosedBadge => 'Fermé';

  @override
  String restaurantMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get restaurantMenuTitle => 'Menu';

  @override
  String get restaurantReviewsTitle => 'Avis';

  @override
  String get restaurantAboutTitle => 'À propos';

  @override
  String get restaurantAddReview => 'Laisser un avis';

  @override
  String get restaurantReviewHint => 'Partagez votre expérience...';

  @override
  String get restaurantReviewSubmit => 'Publier l\'avis';

  @override
  String get restaurantNoReviews => 'Aucun avis pour le moment.';

  @override
  String get restaurantAddToCart => 'Ajouter';

  @override
  String get restaurantFavoriteAdded => 'Ajouté aux favoris';

  @override
  String get restaurantFavoriteRemoved => 'Retiré des favoris';

  @override
  String get restaurantSwitchTitle => 'Vider le panier ?';

  @override
  String restaurantSwitchBody(String restaurant) {
    return 'Votre panier contient des articles de $restaurant. Voulez-vous le vider pour ajouter des articles de ce restaurant ?';
  }

  @override
  String get restaurantSwitchConfirm => 'Vider le panier';

  @override
  String get cartTitle => 'Panier';

  @override
  String get cartEmptyTitle => 'Votre panier est vide';

  @override
  String get cartEmptySubtitle =>
      'Ajoutez des plats depuis un restaurant pour commencer.';

  @override
  String get cartSubtotal => 'Sous-total';

  @override
  String get cartDeliveryFee => 'Frais de livraison';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartViewCart => 'Voir le panier';

  @override
  String get cartCheckoutButton => 'Commander';

  @override
  String get cartQuantity => 'Quantité';

  @override
  String get checkoutTitle => 'Validation de commande';

  @override
  String get checkoutAddressLabel => 'Adresse de livraison';

  @override
  String get checkoutAddressHint => 'Ex: Sacré-Cœur 3, Villa n°12, Dakar';

  @override
  String get checkoutAddressRequired => 'L\'adresse de livraison est requise.';

  @override
  String get checkoutNotesLabel => 'Remarques (facultatif)';

  @override
  String get checkoutNotesHint => 'Ex: sonner à l\'interphone, sans piment...';

  @override
  String get checkoutSummaryTitle => 'Récapitulatif';

  @override
  String get checkoutPlaceOrder => 'Confirmer la commande';

  @override
  String get checkoutSuccessTitle => 'Commande envoyée !';

  @override
  String get checkoutSuccessBody =>
      'Votre commande a été transmise au restaurant.';

  @override
  String get orderStatusPending => 'En attente';

  @override
  String get orderStatusConfirmed => 'Confirmée';

  @override
  String get orderStatusPreparing => 'En préparation';

  @override
  String get orderStatusDelivering => 'En livraison';

  @override
  String get orderStatusDelivered => 'Livrée';

  @override
  String get orderStatusCancelled => 'Annulée';

  @override
  String get orderTrackingTitle => 'Suivi de commande';

  @override
  String get orderTrackingLive => 'Suivi en direct';

  @override
  String get orderTrackingOffline =>
      'Connexion en direct indisponible, actualisation périodique.';

  @override
  String get orderCancelButton => 'Annuler la commande';

  @override
  String get orderCancelConfirmTitle => 'Annuler la commande ?';

  @override
  String get orderCancelConfirmBody => 'Cette action est irréversible.';

  @override
  String get orderReorder => 'Recommander';

  @override
  String get orderDetailsTitle => 'Détails de la commande';

  @override
  String orderEtaMinutes(int minutes) {
    return 'Livraison estimée dans $minutes min';
  }

  @override
  String get orderEtaImminent => 'Livraison imminente';

  @override
  String orderNumber(String id) {
    return 'Commande #$id';
  }

  @override
  String get ordersTitle => 'Mes commandes';

  @override
  String get ordersFilterAll => 'Toutes';

  @override
  String get ordersEmptyTitle => 'Aucune commande';

  @override
  String get ordersEmptySubtitle => 'Vos commandes passées apparaîtront ici.';

  @override
  String get favoritesTitle => 'Mes favoris';

  @override
  String get favoritesEmptyTitle => 'Aucun favori';

  @override
  String get favoritesEmptySubtitle =>
      'Appuyez sur le cœur d\'un restaurant pour l\'ajouter ici.';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEditTitle => 'Modifier le profil';

  @override
  String get profileName => 'Nom';

  @override
  String get profilePhone => 'Téléphone';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profileChangePhoto => 'Changer la photo';

  @override
  String get profileChoosePhotoGallery => 'Choisir dans la galerie';

  @override
  String get profileChoosePhotoCamera => 'Prendre une photo';

  @override
  String get profileChoosePhotoFile => 'Choisir un fichier';

  @override
  String get profileSaved => 'Profil mis à jour';

  @override
  String get profileSettings => 'Réglages';

  @override
  String get profileMyOrders => 'Mes commandes';

  @override
  String get profileMyFavorites => 'Mes favoris';

  @override
  String get profileLogout => 'Déconnexion';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsDarkMode => 'Mode sombre';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLogout => 'Se déconnecter';

  @override
  String get offlineBanner =>
      'Vous êtes hors ligne. Certaines données peuvent être obsolètes.';

  @override
  String get offlineCachedNotice => 'Résultats mis en cache (hors ligne)';

  @override
  String get notifOrderUpdateTitle => 'Mise à jour de commande';

  @override
  String notifOrderUpdateBody(String id, String status) {
    return 'Votre commande #$id est maintenant : $status';
  }
}
