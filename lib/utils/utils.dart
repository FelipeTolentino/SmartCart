class Utils {
  static String doubleToCurrency(double value) {
    String formattedString = value.toStringAsFixed(2);
    formattedString = formattedString.replaceAll(',', ".");
    formattedString = '${formattedString.substring(0, formattedString.length - 3)},${formattedString.substring(formattedString.length - 2)}';
    return 'R\$ $formattedString';
  }

  static double currencyToDouble(String stringValue) {
    stringValue = stringValue.replaceAll('R\$', "").replaceAll(".", "").trim();
    stringValue = '${stringValue.substring(0, stringValue.length - 3)}.${stringValue.substring(stringValue.length - 2)}';
    return double.parse(stringValue);
  }
}