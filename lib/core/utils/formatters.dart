import 'package:intl/intl.dart';

/// Formatage des prix (FCFA, entiers) et des dates/heures.
class Formatters {
  Formatters._();

  static final NumberFormat _fcfaFormat = NumberFormat.decimalPattern('fr_FR');

  /// Formate un montant entier en FCFA, ex: 12500 -> "12 500 FCFA".
  static String priceFcfa(int amount) => '${_fcfaFormat.format(amount)} FCFA';

  static String shortDate(DateTime date, {String locale = 'fr_FR'}) =>
      DateFormat.yMMMd(locale).format(date.toLocal());

  static String time(DateTime date, {String locale = 'fr_FR'}) =>
      DateFormat.Hm(locale).format(date.toLocal());

  static String dateTime(DateTime date, {String locale = 'fr_FR'}) =>
      DateFormat.yMMMd(locale).add_Hm().format(date.toLocal());
}
