// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'DeliverEat';

  @override
  String get appTagline => 'The taste of Dakar, delivered to you';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonClose => 'Close';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonOr => 'or';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonNext => 'Next';

  @override
  String get commonStart => 'Get started';

  @override
  String get commonDone => 'Done';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonUnknownError => 'An unexpected error occurred.';

  @override
  String get errorEmailTaken =>
      'This email is already used by another account.';

  @override
  String get errorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get errorRestaurantClosed => 'This restaurant is currently closed.';

  @override
  String get errorMixedRestaurants =>
      'Your cart contains items from another restaurant.';

  @override
  String get errorValidation =>
      'Some information is invalid. Please check the form.';

  @override
  String get errorAlreadyReviewed =>
      'You have already left a review for this restaurant.';

  @override
  String get errorCannotCancel => 'This order can no longer be cancelled.';

  @override
  String get errorFileTooLarge =>
      'The file exceeds the maximum allowed size (2 MB).';

  @override
  String get errorRateLimited => 'Too many requests, please try again shortly.';

  @override
  String get errorNotFound => 'Resource not found.';

  @override
  String get errorNetwork => 'No internet connection. Check your network.';

  @override
  String get errorTimeout => 'The server is taking too long to respond.';

  @override
  String get errorUnauthorized =>
      'Your session has expired, please sign in again.';

  @override
  String get errorConflict => 'This action conflicts with the current state.';

  @override
  String get onboardingTitle1 => 'The flavors of Dakar';

  @override
  String get onboardingSubtitle1 =>
      'Thieboudienne, yassa, mafé... the best Senegalese dishes delivered to you.';

  @override
  String get onboardingTitle2 => 'Order in a few taps';

  @override
  String get onboardingSubtitle2 =>
      'Browse restaurants, build your cart and checkout with ease.';

  @override
  String get onboardingTitle3 => 'Track your delivery live';

  @override
  String get onboardingSubtitle3 =>
      'From preparation to your doorstep, follow every step in real time.';

  @override
  String get authLoginTitle => 'Welcome back';

  @override
  String get authLoginSubtitle => 'Sign in to continue';

  @override
  String get authRegisterTitle => 'Create an account';

  @override
  String get authRegisterSubtitle => 'Join DeliverEat in a few seconds';

  @override
  String get authFieldName => 'Full name';

  @override
  String get authFieldEmail => 'Email address';

  @override
  String get authFieldPassword => 'Password';

  @override
  String get authFieldPhone => 'Phone';

  @override
  String get authLoginButton => 'Sign in';

  @override
  String get authRegisterButton => 'Sign up';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authHasAccount => 'Already have an account?';

  @override
  String get authCreateAccount => 'Create an account';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authErrorEmailInvalid => 'Invalid email address.';

  @override
  String get authErrorPasswordTooShort =>
      'Password must be at least 6 characters.';

  @override
  String get authErrorNameRequired => 'Name is required.';

  @override
  String get authLogoutTitle => 'Sign out';

  @override
  String get authLogoutConfirm => 'Are you sure you want to sign out?';

  @override
  String get homeTitle => 'Home';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeSearchHint => 'Search a restaurant, a dish...';

  @override
  String get homeCategoriesTitle => 'Categories';

  @override
  String get homeRestaurantsTitle => 'Restaurants';

  @override
  String get homeOpenOnly => 'Open only';

  @override
  String get homeSortLabel => 'Sort by';

  @override
  String get homeSortRating => 'Rating';

  @override
  String get homeSortDeliveryTime => 'Delivery time';

  @override
  String get homeSortDeliveryFee => 'Delivery fee';

  @override
  String get homeSortName => 'Name';

  @override
  String get homeEmptyTitle => 'No results';

  @override
  String get homeEmptySubtitle => 'Try another search or filter.';

  @override
  String get homeRecentSearches => 'Recent searches';

  @override
  String get homeClearSearches => 'Clear';

  @override
  String get restaurantClosedBadge => 'Closed';

  @override
  String restaurantMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get restaurantMenuTitle => 'Menu';

  @override
  String get restaurantReviewsTitle => 'Reviews';

  @override
  String get restaurantAboutTitle => 'About';

  @override
  String get restaurantAddReview => 'Leave a review';

  @override
  String get restaurantReviewHint => 'Share your experience...';

  @override
  String get restaurantReviewSubmit => 'Post review';

  @override
  String get restaurantNoReviews => 'No reviews yet.';

  @override
  String get restaurantAddToCart => 'Add';

  @override
  String get restaurantFavoriteAdded => 'Added to favorites';

  @override
  String get restaurantFavoriteRemoved => 'Removed from favorites';

  @override
  String get restaurantSwitchTitle => 'Clear cart?';

  @override
  String restaurantSwitchBody(String restaurant) {
    return 'Your cart contains items from $restaurant. Clear it to add items from this restaurant?';
  }

  @override
  String get restaurantSwitchConfirm => 'Clear cart';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptySubtitle =>
      'Add dishes from a restaurant to get started.';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartDeliveryFee => 'Delivery fee';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartViewCart => 'View cart';

  @override
  String get cartCheckoutButton => 'Checkout';

  @override
  String get cartQuantity => 'Quantity';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutAddressLabel => 'Delivery address';

  @override
  String get checkoutAddressHint => 'E.g: Sacré-Cœur 3, Villa n°12, Dakar';

  @override
  String get checkoutAddressRequired => 'Delivery address is required.';

  @override
  String get checkoutNotesLabel => 'Notes (optional)';

  @override
  String get checkoutNotesHint => 'E.g: ring the bell, no chili...';

  @override
  String get checkoutSummaryTitle => 'Summary';

  @override
  String get checkoutPlaceOrder => 'Confirm order';

  @override
  String get checkoutSuccessTitle => 'Order placed!';

  @override
  String get checkoutSuccessBody =>
      'Your order has been sent to the restaurant.';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusConfirmed => 'Confirmed';

  @override
  String get orderStatusPreparing => 'Preparing';

  @override
  String get orderStatusDelivering => 'Delivering';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get orderTrackingTitle => 'Order tracking';

  @override
  String get orderTrackingLive => 'Live tracking';

  @override
  String get orderTrackingOffline =>
      'Live connection unavailable, refreshing periodically.';

  @override
  String get orderCancelButton => 'Cancel order';

  @override
  String get orderCancelConfirmTitle => 'Cancel this order?';

  @override
  String get orderCancelConfirmBody => 'This action cannot be undone.';

  @override
  String get orderReorder => 'Reorder';

  @override
  String get orderDetailsTitle => 'Order details';

  @override
  String orderNumber(String id) {
    return 'Order #$id';
  }

  @override
  String get ordersTitle => 'My orders';

  @override
  String get ordersFilterAll => 'All';

  @override
  String get ordersEmptyTitle => 'No orders';

  @override
  String get ordersEmptySubtitle => 'Your past orders will appear here.';

  @override
  String get favoritesTitle => 'My favorites';

  @override
  String get favoritesEmptyTitle => 'No favorites';

  @override
  String get favoritesEmptySubtitle =>
      'Tap the heart on a restaurant to add it here.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get profileName => 'Name';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profileChoosePhotoGallery => 'Choose from gallery';

  @override
  String get profileChoosePhotoCamera => 'Take a photo';

  @override
  String get profileChoosePhotoFile => 'Choose a file';

  @override
  String get profileSaved => 'Profile updated';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileMyOrders => 'My orders';

  @override
  String get profileMyFavorites => 'My favorites';

  @override
  String get profileLogout => 'Log out';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLogout => 'Sign out';

  @override
  String get offlineBanner => 'You are offline. Some data may be outdated.';

  @override
  String get offlineCachedNotice => 'Cached results (offline)';

  @override
  String get notifOrderUpdateTitle => 'Order update';

  @override
  String notifOrderUpdateBody(String id, String status) {
    return 'Your order #$id is now: $status';
  }
}
