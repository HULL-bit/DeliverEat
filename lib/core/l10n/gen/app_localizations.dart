import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('fr'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'DeliverEat'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In fr, this message translates to:
  /// **'Le goût de Dakar, livré chez vous'**
  String get appTagline;

  /// No description provided for @commonRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get commonConfirm;

  /// No description provided for @commonSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get commonSave;

  /// No description provided for @commonClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get commonClose;

  /// No description provided for @commonSeeAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout voir'**
  String get commonSeeAll;

  /// No description provided for @commonLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get commonLoading;

  /// No description provided for @commonYes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get commonNo;

  /// No description provided for @commonOr.
  ///
  /// In fr, this message translates to:
  /// **'ou'**
  String get commonOr;

  /// No description provided for @commonSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get commonSkip;

  /// No description provided for @commonNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get commonNext;

  /// No description provided for @commonStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get commonStart;

  /// No description provided for @commonDone.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get commonDone;

  /// No description provided for @commonEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get commonEdit;

  /// No description provided for @commonRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get commonRemove;

  /// No description provided for @commonSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get commonSearch;

  /// No description provided for @commonUnknownError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur inattendue est survenue.'**
  String get commonUnknownError;

  /// No description provided for @errorEmailTaken.
  ///
  /// In fr, this message translates to:
  /// **'Cet e-mail est déjà utilisé par un autre compte.'**
  String get errorEmailTaken;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In fr, this message translates to:
  /// **'E-mail ou mot de passe incorrect.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorRestaurantClosed.
  ///
  /// In fr, this message translates to:
  /// **'Ce restaurant est actuellement fermé.'**
  String get errorRestaurantClosed;

  /// No description provided for @errorMixedRestaurants.
  ///
  /// In fr, this message translates to:
  /// **'Votre panier contient des articles d\'un autre restaurant.'**
  String get errorMixedRestaurants;

  /// No description provided for @errorValidation.
  ///
  /// In fr, this message translates to:
  /// **'Certaines informations sont invalides. Vérifiez le formulaire.'**
  String get errorValidation;

  /// No description provided for @errorAlreadyReviewed.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez déjà laissé un avis pour ce restaurant.'**
  String get errorAlreadyReviewed;

  /// No description provided for @errorCannotCancel.
  ///
  /// In fr, this message translates to:
  /// **'Cette commande ne peut plus être annulée.'**
  String get errorCannotCancel;

  /// No description provided for @errorFileTooLarge.
  ///
  /// In fr, this message translates to:
  /// **'Le fichier dépasse la taille maximale autorisée (2 Mo).'**
  String get errorFileTooLarge;

  /// No description provided for @errorRateLimited.
  ///
  /// In fr, this message translates to:
  /// **'Trop de requêtes, réessayez dans un instant.'**
  String get errorRateLimited;

  /// No description provided for @errorNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Ressource introuvable.'**
  String get errorNotFound;

  /// No description provided for @errorNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion internet. Vérifiez votre réseau.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur met trop de temps à répondre.'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In fr, this message translates to:
  /// **'Votre session a expiré, veuillez vous reconnecter.'**
  String get errorUnauthorized;

  /// No description provided for @errorConflict.
  ///
  /// In fr, this message translates to:
  /// **'Cette action entre en conflit avec l\'état actuel.'**
  String get errorConflict;

  /// No description provided for @onboardingTitle1.
  ///
  /// In fr, this message translates to:
  /// **'Les saveurs de Dakar'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In fr, this message translates to:
  /// **'Thiéboudienne, yassa, mafé... les meilleurs plats sénégalais livrés chez vous.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In fr, this message translates to:
  /// **'Commandez en quelques taps'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In fr, this message translates to:
  /// **'Parcourez les restaurants, composez votre panier et validez en toute simplicité.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In fr, this message translates to:
  /// **'Suivez votre livraison en direct'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In fr, this message translates to:
  /// **'De la préparation à votre porte, suivez chaque étape en temps réel.'**
  String get onboardingSubtitle3;

  /// No description provided for @authLoginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Content de vous revoir'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour continuer'**
  String get authLoginSubtitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez DeliverEat en quelques secondes'**
  String get authRegisterSubtitle;

  /// No description provided for @authFieldName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get authFieldName;

  /// No description provided for @authFieldEmail.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get authFieldEmail;

  /// No description provided for @authFieldPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get authFieldPassword;

  /// No description provided for @authFieldPhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get authFieldPhone;

  /// No description provided for @authLoginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authLoginButton;

  /// No description provided for @authRegisterButton.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get authRegisterButton;

  /// No description provided for @authNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get authNoAccount;

  /// No description provided for @authHasAccount.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez déjà un compte ?'**
  String get authHasAccount;

  /// No description provided for @authCreateAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authCreateAccount;

  /// No description provided for @authSignIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authSignIn;

  /// No description provided for @authErrorEmailInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail invalide.'**
  String get authErrorEmailInvalid;

  /// No description provided for @authErrorPasswordTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères.'**
  String get authErrorPasswordTooShort;

  /// No description provided for @authErrorNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le nom est requis.'**
  String get authErrorNameRequired;

  /// No description provided for @authLogoutTitle.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get authLogoutTitle;

  /// No description provided for @authLogoutConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment vous déconnecter ?'**
  String get authLogoutConfirm;

  /// No description provided for @homeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get homeTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un restaurant, un plat...'**
  String get homeSearchHint;

  /// No description provided for @homeCategoriesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get homeCategoriesTitle;

  /// No description provided for @homeRestaurantsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Restaurants'**
  String get homeRestaurantsTitle;

  /// No description provided for @homeOpenOnly.
  ///
  /// In fr, this message translates to:
  /// **'Ouverts uniquement'**
  String get homeOpenOnly;

  /// No description provided for @homeSortLabel.
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get homeSortLabel;

  /// No description provided for @homeSortRating.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get homeSortRating;

  /// No description provided for @homeSortDeliveryTime.
  ///
  /// In fr, this message translates to:
  /// **'Délai de livraison'**
  String get homeSortDeliveryTime;

  /// No description provided for @homeSortDeliveryFee.
  ///
  /// In fr, this message translates to:
  /// **'Frais de livraison'**
  String get homeSortDeliveryFee;

  /// No description provided for @homeSortName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get homeSortName;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Essayez une autre recherche ou un autre filtre.'**
  String get homeEmptySubtitle;

  /// No description provided for @homeRecentSearches.
  ///
  /// In fr, this message translates to:
  /// **'Recherches récentes'**
  String get homeRecentSearches;

  /// No description provided for @homeClearSearches.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get homeClearSearches;

  /// No description provided for @restaurantClosedBadge.
  ///
  /// In fr, this message translates to:
  /// **'Fermé'**
  String get restaurantClosedBadge;

  /// No description provided for @restaurantMinutes.
  ///
  /// In fr, this message translates to:
  /// **'{minutes} min'**
  String restaurantMinutes(int minutes);

  /// No description provided for @restaurantMenuTitle.
  ///
  /// In fr, this message translates to:
  /// **'Menu'**
  String get restaurantMenuTitle;

  /// No description provided for @restaurantReviewsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Avis'**
  String get restaurantReviewsTitle;

  /// No description provided for @restaurantAboutTitle.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get restaurantAboutTitle;

  /// No description provided for @restaurantAddReview.
  ///
  /// In fr, this message translates to:
  /// **'Laisser un avis'**
  String get restaurantAddReview;

  /// No description provided for @restaurantReviewHint.
  ///
  /// In fr, this message translates to:
  /// **'Partagez votre expérience...'**
  String get restaurantReviewHint;

  /// No description provided for @restaurantReviewSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Publier l\'avis'**
  String get restaurantReviewSubmit;

  /// No description provided for @restaurantNoReviews.
  ///
  /// In fr, this message translates to:
  /// **'Aucun avis pour le moment.'**
  String get restaurantNoReviews;

  /// No description provided for @restaurantAddToCart.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get restaurantAddToCart;

  /// No description provided for @restaurantFavoriteAdded.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté aux favoris'**
  String get restaurantFavoriteAdded;

  /// No description provided for @restaurantFavoriteRemoved.
  ///
  /// In fr, this message translates to:
  /// **'Retiré des favoris'**
  String get restaurantFavoriteRemoved;

  /// No description provided for @restaurantSwitchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vider le panier ?'**
  String get restaurantSwitchTitle;

  /// No description provided for @restaurantSwitchBody.
  ///
  /// In fr, this message translates to:
  /// **'Votre panier contient des articles de {restaurant}. Voulez-vous le vider pour ajouter des articles de ce restaurant ?'**
  String restaurantSwitchBody(String restaurant);

  /// No description provided for @restaurantSwitchConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Vider le panier'**
  String get restaurantSwitchConfirm;

  /// No description provided for @cartTitle.
  ///
  /// In fr, this message translates to:
  /// **'Panier'**
  String get cartTitle;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre panier est vide'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez des plats depuis un restaurant pour commencer.'**
  String get cartEmptySubtitle;

  /// No description provided for @cartSubtotal.
  ///
  /// In fr, this message translates to:
  /// **'Sous-total'**
  String get cartSubtotal;

  /// No description provided for @cartDeliveryFee.
  ///
  /// In fr, this message translates to:
  /// **'Frais de livraison'**
  String get cartDeliveryFee;

  /// No description provided for @cartTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get cartTotal;

  /// No description provided for @cartViewCart.
  ///
  /// In fr, this message translates to:
  /// **'Voir le panier'**
  String get cartViewCart;

  /// No description provided for @cartCheckoutButton.
  ///
  /// In fr, this message translates to:
  /// **'Commander'**
  String get cartCheckoutButton;

  /// No description provided for @cartQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Quantité'**
  String get cartQuantity;

  /// No description provided for @checkoutTitle.
  ///
  /// In fr, this message translates to:
  /// **'Validation de commande'**
  String get checkoutTitle;

  /// No description provided for @checkoutAddressLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse de livraison'**
  String get checkoutAddressLabel;

  /// No description provided for @checkoutAddressHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Sacré-Cœur 3, Villa n°12, Dakar'**
  String get checkoutAddressHint;

  /// No description provided for @checkoutAddressRequired.
  ///
  /// In fr, this message translates to:
  /// **'L\'adresse de livraison est requise.'**
  String get checkoutAddressRequired;

  /// No description provided for @checkoutNotesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Remarques (facultatif)'**
  String get checkoutNotesLabel;

  /// No description provided for @checkoutNotesHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: sonner à l\'interphone, sans piment...'**
  String get checkoutNotesHint;

  /// No description provided for @checkoutSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Récapitulatif'**
  String get checkoutSummaryTitle;

  /// No description provided for @checkoutPlaceOrder.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la commande'**
  String get checkoutPlaceOrder;

  /// No description provided for @checkoutSuccessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Commande envoyée !'**
  String get checkoutSuccessTitle;

  /// No description provided for @checkoutSuccessBody.
  ///
  /// In fr, this message translates to:
  /// **'Votre commande a été transmise au restaurant.'**
  String get checkoutSuccessBody;

  /// No description provided for @orderStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get orderStatusPending;

  /// No description provided for @orderStatusConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Confirmée'**
  String get orderStatusConfirmed;

  /// No description provided for @orderStatusPreparing.
  ///
  /// In fr, this message translates to:
  /// **'En préparation'**
  String get orderStatusPreparing;

  /// No description provided for @orderStatusDelivering.
  ///
  /// In fr, this message translates to:
  /// **'En livraison'**
  String get orderStatusDelivering;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In fr, this message translates to:
  /// **'Livrée'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulée'**
  String get orderStatusCancelled;

  /// No description provided for @orderTrackingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Suivi de commande'**
  String get orderTrackingTitle;

  /// No description provided for @orderTrackingLive.
  ///
  /// In fr, this message translates to:
  /// **'Suivi en direct'**
  String get orderTrackingLive;

  /// No description provided for @orderTrackingOffline.
  ///
  /// In fr, this message translates to:
  /// **'Connexion en direct indisponible, actualisation périodique.'**
  String get orderTrackingOffline;

  /// No description provided for @orderCancelButton.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la commande'**
  String get orderCancelButton;

  /// No description provided for @orderCancelConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la commande ?'**
  String get orderCancelConfirmTitle;

  /// No description provided for @orderCancelConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible.'**
  String get orderCancelConfirmBody;

  /// No description provided for @orderReorder.
  ///
  /// In fr, this message translates to:
  /// **'Recommander'**
  String get orderReorder;

  /// No description provided for @orderDetailsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détails de la commande'**
  String get orderDetailsTitle;

  /// No description provided for @orderEtaMinutes.
  ///
  /// In fr, this message translates to:
  /// **'Livraison estimée dans {minutes} min'**
  String orderEtaMinutes(int minutes);

  /// No description provided for @orderEtaImminent.
  ///
  /// In fr, this message translates to:
  /// **'Livraison imminente'**
  String get orderEtaImminent;

  /// No description provided for @orderNumber.
  ///
  /// In fr, this message translates to:
  /// **'Commande #{id}'**
  String orderNumber(String id);

  /// No description provided for @ordersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes commandes'**
  String get ordersTitle;

  /// No description provided for @ordersFilterAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get ordersFilterAll;

  /// No description provided for @ordersEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune commande'**
  String get ordersEmptyTitle;

  /// No description provided for @ordersEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos commandes passées apparaîtront ici.'**
  String get ordersEmptySubtitle;

  /// No description provided for @favoritesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes favoris'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun favori'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur le cœur d\'un restaurant pour l\'ajouter ici.'**
  String get favoritesEmptySubtitle;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @profileEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get profileEditTitle;

  /// No description provided for @profileName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get profileName;

  /// No description provided for @profilePhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get profilePhone;

  /// No description provided for @profileEmail.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get profileEmail;

  /// No description provided for @profileChangePhoto.
  ///
  /// In fr, this message translates to:
  /// **'Changer la photo'**
  String get profileChangePhoto;

  /// No description provided for @profileChoosePhotoGallery.
  ///
  /// In fr, this message translates to:
  /// **'Choisir dans la galerie'**
  String get profileChoosePhotoGallery;

  /// No description provided for @profileChoosePhotoCamera.
  ///
  /// In fr, this message translates to:
  /// **'Prendre une photo'**
  String get profileChoosePhotoCamera;

  /// No description provided for @profileChoosePhotoFile.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un fichier'**
  String get profileChoosePhotoFile;

  /// No description provided for @profileSaved.
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour'**
  String get profileSaved;

  /// No description provided for @profileSettings.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get profileSettings;

  /// No description provided for @profileMyOrders.
  ///
  /// In fr, this message translates to:
  /// **'Mes commandes'**
  String get profileMyOrders;

  /// No description provided for @profileMyFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Mes favoris'**
  String get profileMyFavorites;

  /// No description provided for @profileLogout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get profileLogout;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get settingsAppearance;

  /// No description provided for @settingsDarkMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode sombre'**
  String get settingsDarkMode;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsLanguageFrench;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsLogout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get settingsLogout;

  /// No description provided for @offlineBanner.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes hors ligne. Certaines données peuvent être obsolètes.'**
  String get offlineBanner;

  /// No description provided for @offlineCachedNotice.
  ///
  /// In fr, this message translates to:
  /// **'Résultats mis en cache (hors ligne)'**
  String get offlineCachedNotice;

  /// No description provided for @notifOrderUpdateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour de commande'**
  String get notifOrderUpdateTitle;

  /// No description provided for @notifOrderUpdateBody.
  ///
  /// In fr, this message translates to:
  /// **'Votre commande #{id} est maintenant : {status}'**
  String notifOrderUpdateBody(String id, String status);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
