/// Métadonnées de pagination renvoyées par l'API sous `meta`.
class PageMeta {
  const PageMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) => PageMeta(
        page: json['page'] as int,
        limit: json['limit'] as int,
        total: json['total'] as int,
        totalPages: json['totalPages'] as int,
        hasNextPage: json['hasNextPage'] as bool,
      );

  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
}

/// Enveloppe générique `{ data: [...], meta: {...} }` renvoyée par les
/// endpoints paginés de l'API.
class Paginated<T> {
  const Paginated({required this.data, required this.meta});

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    final rawData = json['data'] as List<dynamic>;
    return Paginated(
      data: rawData.map((e) => itemFromJson(e as Map<String, dynamic>)).toList(growable: false),
      meta: PageMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  final List<T> data;
  final PageMeta meta;
}
