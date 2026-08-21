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
        message = null;

  const ViewState.loading({this.data})
      : status = ViewStatus.loading,
        message = null;

  const ViewState.success(T this.data)
      : status = ViewStatus.success,
        message = null;

  const ViewState.error(this.message, {this.data}) : status = ViewStatus.error;

  final ViewStatus status;
  final T? data;

  /// Message d'erreur déjà traduit, prêt à être affiché.
  final String? message;

  bool get isInitial => status == ViewStatus.initial;
  bool get isLoading => status == ViewStatus.loading;
  bool get isSuccess => status == ViewStatus.success;
  bool get isError => status == ViewStatus.error;

  bool get hasData => data != null;
}
