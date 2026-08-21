import 'package:flutter/foundation.dart';

import '../models/menu_item.dart';
import '../models/order.dart';
import '../models/order_item.dart';

/// Ligne de panier : une capture immuable d'un article au prix du moment
/// de l'ajout (indépendante du modèle [MenuItem] pour permettre de
/// reconstruire un panier à partir d'une commande passée, sans re-fetcher
/// le menu).
@immutable
class CartLineItem {
  const CartLineItem({
    required this.menuItemId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    this.imagePath,
  });

  final String menuItemId;
  final String name;
  final int unitPrice;
  final int quantity;
  final String? imagePath;

  int get subtotal => unitPrice * quantity;

  CartLineItem copyWith({int? quantity}) => CartLineItem(
        menuItemId: menuItemId,
        name: name,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
        imagePath: imagePath,
      );
}

/// Résultat d'une tentative d'ajout au panier.
enum CartAddResult { added, restaurantConflict }

/// Panier courant de l'utilisateur.
///
/// Règle métier centrale : une commande = un seul restaurant. Ajouter un
/// article d'un autre restaurant renvoie [CartAddResult.restaurantConflict]
/// plutôt que de muter silencieusement l'état ; c'est à l'UI de proposer le
/// choix "vider le panier / annuler" ([restaurantName] identifie le
/// restaurant en cours).
class CartProvider extends ChangeNotifier {
  final Map<String, CartLineItem> _items = {};

  String? _restaurantId;
  String? _restaurantName;
  int _deliveryFee = 0;

  List<CartLineItem> get items => List.unmodifiable(_items.values);
  String? get restaurantId => _restaurantId;
  String? get restaurantName => _restaurantName;
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  int get itemCount => _items.values.fold(0, (sum, i) => sum + i.quantity);
  int get subtotal => _items.values.fold(0, (sum, i) => sum + i.subtotal);
  int get deliveryFee => _items.isEmpty ? 0 : _deliveryFee;
  int get total => subtotal + deliveryFee;

  int quantityOf(String menuItemId) => _items[menuItemId]?.quantity ?? 0;

  CartAddResult addItem(
    MenuItem item, {
    required String restaurantId,
    required String restaurantName,
    required int deliveryFee,
  }) {
    if (_restaurantId != null && _restaurantId != restaurantId) {
      return CartAddResult.restaurantConflict;
    }
    _restaurantId = restaurantId;
    _restaurantName = restaurantName;
    _deliveryFee = deliveryFee;

    final existing = _items[item.id];
    _items[item.id] = (existing ?? CartLineItem(
      menuItemId: item.id,
      name: item.name,
      unitPrice: item.price,
      quantity: 0,
      imagePath: item.imagePath,
    ))
        .copyWith(quantity: (existing?.quantity ?? 0) + 1);
    notifyListeners();
    return CartAddResult.added;
  }

  /// Vide le panier puis y ajoute [item] (issu de la boîte de dialogue de
  /// conflit de restaurant).
  void clearAndAdd(
    MenuItem item, {
    required String restaurantId,
    required String restaurantName,
    required int deliveryFee,
  }) {
    _items.clear();
    _restaurantId = null;
    addItem(item, restaurantId: restaurantId, restaurantName: restaurantName, deliveryFee: deliveryFee);
  }

  void incrementQuantity(String menuItemId) {
    final existing = _items[menuItemId];
    if (existing == null) return;
    _items[menuItemId] = existing.copyWith(quantity: existing.quantity + 1);
    notifyListeners();
  }

  void decrementQuantity(String menuItemId) {
    final existing = _items[menuItemId];
    if (existing == null) return;
    if (existing.quantity <= 1) {
      removeItem(menuItemId);
      return;
    }
    _items[menuItemId] = existing.copyWith(quantity: existing.quantity - 1);
    notifyListeners();
  }

  void removeItem(String menuItemId) {
    _items.remove(menuItemId);
    if (_items.isEmpty) {
      _restaurantId = null;
      _restaurantName = null;
      _deliveryFee = 0;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _restaurantId = null;
    _restaurantName = null;
    _deliveryFee = 0;
    notifyListeners();
  }

  /// Recharge le panier avec les articles d'une commande passée
  /// ("Recommander en un tap"). [deliveryFee] est celui, à jour, du
  /// restaurant (rafraîchi par l'appelant avant d'invoquer cette méthode).
  void loadFromOrder(Order order, {required int deliveryFee}) {
    _items
      ..clear()
      ..addEntries(order.items.map(
        (i) => MapEntry(
          i.menuItemId,
          CartLineItem(menuItemId: i.menuItemId, name: i.name, unitPrice: i.unitPrice, quantity: i.quantity),
        ),
      ));
    _restaurantId = order.restaurantId;
    _restaurantName = order.restaurantName;
    _deliveryFee = deliveryFee;
    notifyListeners();
  }

  List<OrderItem> toOrderItems() => _items.values
      .map((l) => OrderItem(menuItemId: l.menuItemId, name: l.name, quantity: l.quantity, unitPrice: l.unitPrice))
      .toList(growable: false);
}
