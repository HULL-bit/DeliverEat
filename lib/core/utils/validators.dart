/// Validations de formulaires côté client, indépendantes de l'UI.
class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[\w\.\-\+]+@[\w\-]+\.[a-zA-Z]{2,}$');

  /// Retourne `true` si [value] a un format d'e-mail valide.
  static bool isValidEmail(String value) => _emailRegex.hasMatch(value.trim());

  /// Retourne `true` si [value] contient au moins 6 caractères.
  static bool isValidPassword(String value) => value.length >= 6;

  static bool isNotEmpty(String value) => value.trim().isNotEmpty;
}
