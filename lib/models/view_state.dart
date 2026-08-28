/// Statut générique d'un écran ou d'une section d'écran.
enum ViewStatus { initial, loading, success, error }

/// État typé réutilisable pour tout provider exposant des données
/// asynchrones à l'UI.
///
/// Remplace les triplets `isLoading` / `hasError` / `data` dispersés par un
/// seul objet immuable : l'UI se contente d'un `switch` sur [status].
class ViewState<T> {
  const ViewState.initial()
      : status = ViewStatus.initial,
        data = null,
        message = null,
        errorCode = null;

  const ViewState.loading({this.data})
      : status = ViewStatus.loading,
        message = null,
        errorCode = null;

  const ViewState.success(T this.data)
      : status = ViewStatus.success,
        message = null,
        errorCode = null;

  const ViewState.error(this.message, {this.data, this.errorCode}) : status = ViewStatus.error;

  final ViewStatus status;
  final T? data;

  /// Message brut renvoyé par l'API (repli si [errorCode] n'a pas de
  /// traduction connue).
  final String? message;

  /// Code métier de l'erreur (ex: `RESTAURANT_CLOSED`, `RATE_LIMITED`),
  /// utilisé par l'UI pour résoudre un message déjà traduit FR/EN via
  /// `ErrorMessages.resolve` au moment de l'affichage.
  final String? errorCode;

  bool get isInitial => status == ViewStatus.initial;
  bool get isLoading => status == ViewStatus.loading;
  bool get isSuccess => status == ViewStatus.success;
  bool get isError => status == ViewStatus.error;

  bool get hasData => data != null;
}
