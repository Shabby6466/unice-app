extension CapitalizeWords on String {
  String capitalizeEachWord() {
    return split(' ').map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : word).join(' ');
  }
}

extension StringExtensions on String {
  String removeSpaces() {
    return replaceAll(' ', '');
  }
}

extension FormatCurrency on String {
  String formatCurrency() {
    var sb = StringBuffer();
    var strBuffer = <String>[];

    var count = 0;
    for (var i = length - 1; i >= 0; i--) {
      count++;

      strBuffer.add(this[i]);
      if (count / 3 == 1 && i > 0) {
        strBuffer.add(',');
        count = 0;
      }
    }
    sb.writeAll(strBuffer.reversed);
    return sb.toString();
  }
}

extension FormatCurrencyValue on String {
  // this method is used to format amount
  String formatAmount({int decimalDigits = 6}) {
    var splitAmount = split('.');
    final amount = splitAmount[0];
    String fraction;
    if (splitAmount.length > 1) {
      fraction = splitAmount[1];
      final len = fraction.length;
      if (len > decimalDigits) {
        fraction = fraction.substring(0, decimalDigits);
      } else {
        final zeros = '0' * (decimalDigits - len);
        fraction = '$fraction$zeros';
      }
    } else {
      fraction = '';
    }

    var sb = StringBuffer();
    var strBuffer = <String>[];

    var count = 0;
    for (var i = amount.length - 1; i >= 0; i--) {
      count++;

      strBuffer.add(amount[i]);
      if (count / 3 == 1 && i > 0) {
        strBuffer.add(',');
        count = 0;
      }
    }

    sb.writeAll(strBuffer.reversed);
    if (fraction.isNotEmpty) {
      sb.writeAll(['.', fraction]);
    }
    return sb.toString();
  }
}

extension StringExtension on String {
  // this method is used to capitalize first word of string
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

extension FirstCharacter on String {
  String firstCharacter() {
    if (isNotEmpty && this[0].isNotEmpty) {
      return this[0];
    } else {
      return '';
    }
  }
}

extension LanguageShortNameExtension on String {
  /// Converts a short language name (like 'eng', 'kor') to ISO 639-1 code (like 'en', 'ko').
  String? toIsoCode() {
    const shortNameToIsoMap = {
      'en': 'eng',
      'ko': 'kor',
      'vi': 'vie',
      'th': 'thai',
      'zh': 'chi',
    };
    if (isEmpty) {
      return '';
    }
    return shortNameToIsoMap[toLowerCase()];
  }
}
