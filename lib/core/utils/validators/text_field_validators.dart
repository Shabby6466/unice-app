

class TextFieldValidator {
  static String? validateFirstName(String? value) {
    var regExp = RegExp(r"^[A-Za-z\u00c0-\u017e\s'\-]+$");
    var errorMsg = 'Name is required';
    var invalidMsg = 'Invalid Name';
    var minLenErrorMsg = 'Short Name';
    var maxLenErrorMsg = 'Long Name';

    if (value == null || value.trim().isEmpty) {
      return errorMsg;
    }

    value = value.trim(); // Clean up extra spaces

    return !regExp.hasMatch(value)
        ? invalidMsg
        : (value.length < 2)
        ? minLenErrorMsg
        : (value.length > 26)
        ? maxLenErrorMsg
        : null;
  }
  static String? validateDateOfBirth(String? value) {
    const emptyMsg = 'Empty Date of Birth';
    const invalidFormatMsg = 'Invalid Date Format(YYYY-MM-DD)';
    const ageTooYoungMsg = 'Too Young';
    const ageTooOldMsg = 'Too Old';

    if (value == null || value.isEmpty) {
      return emptyMsg;
    }

    // Assuming expected format: YYYY-MM-DD
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(value)) {
      return invalidFormatMsg;
    }

    try {
      final parsedDate = DateTime.parse(value);
      final currentDate = DateTime.now();
      final age = currentDate.year - parsedDate.year - ((currentDate.month < parsedDate.month || (currentDate.month == parsedDate.month && currentDate.day < parsedDate.day)) ? 1 : 0);

      if (age < 13) {
        return ageTooYoungMsg;
      } else if (age > 120) {
        return ageTooOldMsg;
      }
    } catch (e) {
      return invalidFormatMsg;
    }

    return null; // Valid
  }
  static String? validateLastName(String? value) {
    var regExp = RegExp(r"^[A-Za-z\u00c0-\u017e\'\-]+$");
    var errorMsg = 'last_name_empty';
    var minLenErrorMsg = 'last_name_short';
    var maxLenErrorMsg = 'last_name_long';
    var invalidMsg = 'last_name_invalid';
    if (value == null || value == '') {
      return errorMsg;
    }
    return !regExp.hasMatch(value)
        ? invalidMsg
        : (value.length <= 2 && regExp.hasMatch(value))
        ? minLenErrorMsg
        : (value.length >= 2 && value.length <= 26 && regExp.hasMatch(value))
        ? null
        : (value.isNotEmpty && value.length > 26 && regExp.hasMatch(value))
        ? maxLenErrorMsg
        : null;
  }

  // This method check whether phone number is valid or not
  static String? validatePhoneNumber(String? value) {
    var errorMsg = 'Invalid Phone Number';
    if (value == null || value.isEmpty) {
      return errorMsg;
    }
    return (value.length > 6 && value.length < 16) ? null : errorMsg;
  }

  // This method check whether company name is valid or not
  static String? validateCompanyName(String? value) {
    var errorMsg = 'company_name_empty';
    var minLenErrorMsg = 'company_name_short';
    if (value == null || value == '') {
      return errorMsg;
    }
    return value.length >= 3 ? null : minLenErrorMsg;
  }

  // This method check whether business name is valid or not
  static String? validateBusinessName(String? value) {
    var errorMsg = 'business_name_empty';
    var minLenErrorMsg = 'business_name_short';

    if (value == null || value.isEmpty) {
      return errorMsg;
    }
    return value.length >= 3 ? null : minLenErrorMsg;
  }

  // This method check whether business name is valid or not
  static String? validateRegisteredCompanyName(String? value) {
    var errorMsg = 'registered_company_name_empty';
    var minLenErrorMsg = 'registered_company_name_short';

    if (value == null || value.isEmpty) {
      return errorMsg;
    }
    return value.length >= 3 ? null : minLenErrorMsg;
  }

  // This method check whether business name is valid or not
  static String? validateRegistrationNumber(String? value) {
    var errorMsg = 'registration_number_empty';
    var minLenErrorMsg = 'registration_number_short';
    var regExp = RegExp(r'^[a-zA-Z0-9-]+$');

    if (value == null || value.isEmpty) {
      return errorMsg;
    }
    if (value.length < 3) {
      return minLenErrorMsg;
    }
    return regExp.hasMatch(value) ? null : 'invalid_input';
  }

  // This method check whether user name is valid or not
  static String? validateUserName(String? value) {
    var invalidCharacterError = 'Invalid Characters';
    var errorMsg = 'Empty Username';
    var minLenErrorMsg = 'Username Short';

    if (value == null || value.isEmpty) {
      return errorMsg;
    }
    if (value.length < 3) {
      return minLenErrorMsg;
    } else {
      if (RegExp(r'^[a-zA-Z0-9@]+$').hasMatch(value) &&
          ('@'.allMatches(value).length <= 1)) {
        if (('@'.allMatches(value).length == 1 && value[0] == '@' ||
            ('@'.allMatches(value).isEmpty))) {
          return null;
        }
      }
      return invalidCharacterError;
    }
  }

  // This method check whether description is valid or not
  static String? validateDescription(String? value) {
    var errorMsg = 'description_empty';
    var minLenErrorMsg = 'description_short';
    var maxLenErrorMsg = 'description_long';

    if (value == null) {
      return errorMsg;
    }

    if (value.length < 20) {
      return minLenErrorMsg;
    }

    if (value.length > 300) {
      return maxLenErrorMsg;
    }

    return null;
  }

  // This method check whether Reason is valid or not
  static String? validateReason(String? value) {
    var errorMsg = 'reason_empty';
    var minLenErrorMsg = 'reason_short';

    if (value == null) {
      return errorMsg;
    }
    return value.length >= 3 ? null : minLenErrorMsg;
  }

  // This method check whether description is valid or not
  static String? validateTagline(String? value) {
    var errorMsg = 'tagline_empty';
    var minLenErrorMsg = 'tagline_short';

    if (value == null) {
      return errorMsg;
    }
    return value.length >= 3 ? null : minLenErrorMsg;
  }

  // This method checks whether email is valid or not

  static String? validateEmail(String? value) {
    var errorMsg = 'Empty Email';
    var errorMsg2 = 'Email is not valid';

    if (value!.isEmpty) {
      return errorMsg;
    } else {
      final emailValidate = RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(value);

      if (!emailValidate) {
        return errorMsg2;
      } else {
        return null;
      }
    }
  }

  // This method check whether amount is entered or not
  static String? validateAmount(String? value) {
    var errorMsg = 'enter_valid_amount';
    if (value == null || value == '') {
      return errorMsg;
    }

    value = value.replaceFormatterValues();

    if (value.isEmpty) {
      return errorMsg;
    }

    return int.parse(value) >= 1 ? null : errorMsg;
  }

  // This method check whether phone number is valid or not
  static String? validateFreelancerPhoneNumber(String? value) {
    var errorMsg = 'phone_number_should_be';
    if (value == null || value.isEmpty) {
      return null;
    }
    return (value.length > 6 && value.length < 16) ? null : errorMsg;
  }

  static String? validateNote(String? value) {
    var errorMsg = 'reason_empty';
    var minLenErrorMsg = 'reason_short';

    if (value == null) {
      return errorMsg;
    }
    return value.length >= 3 ? null : minLenErrorMsg;
  }

}

extension ReplaceFormattedValues on String {
  String replaceFormatterValues() {
    return replaceAll('-', '')
        .replaceAll(RegExp(r'\$'), '')
        .replaceAll(',', '')
        .replaceAll('£', '')
        .replaceAll('€', '')
        .replaceAll('+', '')
        .replaceAll(' ', '')
        .replaceAll('.', '');
  }

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
