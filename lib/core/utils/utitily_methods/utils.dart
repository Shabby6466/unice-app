import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:toastification/toastification.dart';
import 'package:unice_app/core/di/di.dart';
import 'package:unice_app/core/services/permissions/permission_engine.dart';
import 'package:unice_app/core/utils/resource/r.dart';

class Utility {
  static CustomTransitionPage fadeTransitionPage(Widget child) {
    return CustomTransitionPage(
      child: child,
      maintainState: true,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static void showError(BuildContext context, String text) {
    toastification.show(
      context: context,
      showProgressBar: false,
      borderRadius: BorderRadius.circular(10.r),
      alignment: Alignment.bottomCenter,
      title: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 12.sp,
              color: R.palette.white,
            ),
        maxLines: 3,
      ),
      icon: const Icon(Icons.error, color: Colors.white),
      foregroundColor: R.palette.white,
      backgroundColor: R.palette.red,
      closeOnClick: true,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  static String formatTime(dynamic time, {String locale = 'en'}) {
    try {
      late DateTime parsed;
      if (time is DateTime) {
        parsed = time;
      } else if (time is String) {
        parsed = DateTime.parse(time);
      } else {
        throw ArgumentError('Unsupported time type');
      }

      return DateFormat('hh:mm a', locale).format(parsed.toLocal());
    } catch (e) {
      sl<Logger>().e('Time formatting failed: $e');
      return '';
    }
  }

  static String formatDateToString(dynamic date, {String format = 'yyyy-MM-dd', String? locale}) {
    try {
      late DateTime parsedDate;

      if (date is String) {
        parsedDate = DateTime.parse(date);
      } else if (date is DateTime) {
        parsedDate = date;
      } else {
        throw ArgumentError('Unsupported date type: $date');
      }

      return DateFormat(format, locale).format(parsedDate);
    } catch (e) {
      sl<Logger>().e('Date formatting failed: $e');
      return '';
    }
  }

  static void showSuccess(BuildContext context, String text) {
    toastification.show(
      context: context,
      showProgressBar: false,
      borderRadius: BorderRadius.circular(10.r),
      alignment: Alignment.bottomCenter,
      title: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 12.sp,
              color: R.palette.white,
            ),
        maxLines: 3,
      ),
      icon: const Icon(Icons.error, color: Colors.white),
      foregroundColor: R.palette.white,
      backgroundColor: R.palette.success,
      closeOnClick: true,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  /// This method removes focus from the currently focused view, which typically
  /// causes the soft keyboard to hide. It's a convenient way to dismiss the
  /// keyboard when it's no longer needed, such as after the user has submitted
  /// a form or tapped outside of an editable text field.
  ///
  static void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// this method is use to handle password validity
  static bool isValidPassword(String password, int passwordLength) {
    var hasUppercase = password.contains(RegExp(r'[A-Z]'));
    var hasDigits = password.contains(RegExp(r'[0-9]'));
    var hasLowercase = password.contains(RegExp(r'[a-z]'));
    var hasSpecialChar = password.contains(RegExp(r'[#$%^&*()_+]'));
    var hasMinLength = password.length >= passwordLength;
    return hasDigits && hasUppercase && hasLowercase && hasMinLength && hasSpecialChar;
  }

  /// this method is use to handle email validity
  static bool isEmailValid(String email) {
    const emailRegex =
        r'^(([^<>()[\]\\.,;:%*+{}#!~`=\-\_\s@\"]+([\.\-\_][^<>()[\]\\.,;:%*+{}#!~`=\-\_\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return RegExp(emailRegex).hasMatch(email.trim());
  }
  /// this method is use to handle name validity
  static bool isNameValid(String email) {
    const emailRegex = r'^([a-zA-Z0-9]{3,150})$';
    return RegExp(emailRegex).hasMatch(email.trim());
  }

  static String extractBase64String(String input) {
    final base64Index = input.indexOf(',');
    return input.substring(base64Index + 1);
  }

  static String extractUnValue({required String url, required String value}) {
    final uri = Uri.parse(url);
    return uri.queryParameters[value] ?? '';
  }

  static Future<bool> getPermission(CustomPermission customPermission, PermissionEngine permissionEngine) async {
    var doHavePermission = await permissionEngine.hasPermission(customPermission);
    if (!doHavePermission) {
      doHavePermission = await permissionEngine.resolvePermission(customPermission);
    }
    return doHavePermission;
  }

  /// Checks if two dates represent the same day of the same month and year.
  ///
  /// * [date1]: The first date.
  /// * [date2]: The second date.
  /// * Returns: `true` if thedates are the same day of the same month and year, `false` otherwise.
  static bool isSameMonthAndYear(DateTime date1, DateTime date2) {
    return date1.month == date2.month && date1.year == date2.year && date1.day == date2.day;
  }

  /// Checks if a given date is the previous day.
  ///
  /// * [date]: The date to check.
  /// * Returns: `true` if the given date is the previous day, `false` otherwise.
  static bool isPreviousDay(DateTime date) {
    // Get the current date
    var today = DateTime.now();

    // Remove the time component from the current date
    var currentDate = DateTime(today.year, today.month, today.day);

    // Calculate the previous day
    var previousDay = currentDate.subtract(const Duration(days: 1));

    // Compare the given date to the previous day (only the date part)
    return DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(previousDay);
  }

  /// Copies the given text to the system clipboard.
  ///
  /// * [text]: The text to copy to the clipboard.
  static void clipboardText(String text) {
    try {
      Clipboard.setData(ClipboardData(text: text));
    } catch (e) {
      sl<Logger>().d(e.toString());
    }
  }

  /// this method used get file size
  static Future<int> getFileSize(String path) async {
    final fileBytes = await File(path).readAsBytes();

    return fileBytes.lengthInBytes;
  }

  /// Formats a duration given in seconds into a string representation.
  ///
  /// The output format is either "MM:SS" or "HH:MM:SS", depending on whether
  /// the duration is less than one hour.
  ///
  /// * [seconds] The duration in seconds.
  ///
  /// Returns a string representation of the duration in the format "MM:SS" or "HH:MM:SS".
  ///
  /// Example:///
  /// dart /// formatHHMMSS(3600); // Returns "01:00:00" /// formatHHMMSS(60); // Returns "01:00" /// formatHHMMSS(59); // Returns "00:59" ///
  String formatHHMMSS(int seconds) {
    var hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    var minutes = (seconds / 60).truncate();

    var hoursStr = (hours).toString().padLeft(2, '0');
    var minutesStr = (minutes).toString().padLeft(2, '0');
    var secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return '$minutesStr:$secondsStr';
    }
    return '$hoursStr:$minutesStr:$secondsStr';
  }

  static String capitalize(String s) {
    if (s.isNotEmpty) {
      return s[0].toUpperCase() + s.substring(1);
    } else {
      return s;
    }
  }

  static String onTextChanged1(String value) {
    var returnValue = TextEditingController();
    var input = value.replaceAll('.', '').replaceAll(',', '').replaceAll(' ', '').replaceAll('-', '');

    input = input.replaceFirst(RegExp(r'^0+(?=.)'), '');

    if (input.isEmpty) {
      returnValue.text = '0.00';
    } else if (input.length == 1) {
      returnValue.text = '0.0$input';
    } else if (input.length == 2) {
      returnValue.text = '0.$input';
    } else {
      returnValue.text = '${input.substring(0, input.length - 2)}.${input.substring(input.length - 2)}';
    }
    returnValue.selection = TextSelection.collapsed(offset: returnValue.text.length);
    return returnValue.text;
  }

  static String getDateWithFormat(String format, DateTime dateTime) {
    return DateFormat(format).format(dateTime);
  }

  static String getTransactionType(String type) {
    switch (type) {
      case 'Deposits':
        return 'deposit';
      case 'Withdrawals':
        return 'withdraw';
      case 'Sent':
        return 'send';
      case 'Received':
        return 'receive';
      case 'Pending':
        return '';
      case 'Exchange':
        return 'exchangeMaker';
    }
    return '';
  }

  /// Opens a URL, typically from a push notification.
  ///
  /// Attempts to open the provided [link] using the `url_launcher` package.
  /// If the link cannot be opened, the error is silently ignored.
  ///
  /// * [link]: The URL to open.
  /// * [launchMode]: (Optional) Specifies how the URL should be opened.
  ///   Defaults to `LaunchMode.externalApplication`.
  // static Future<void> openPushLink(
  //   String link, {
  //   LaunchMode? launchMode,
  // }) async {
  //   try {
  //     if (!await launchUrl(
  //       Uri.parse(
  //         link,
  //       ),
  //       mode: launchMode ?? LaunchMode.externalApplication,
  //     )) {}
  //   } catch (_) {}
  // }

  //This method is for converting and getting multipart for the image

  dynamic createImageData(String path) async {
    var fileExtensions = path.split('.');
    var fileExtension = fileExtensions[fileExtensions.length - 1];
    var fileName = '${DateTime.now().millisecondsSinceEpoch.toString()}.$fileExtension';

    var data = FormData.fromMap({
      'file': [
        await MultipartFile.fromFile(
          path,
          filename: fileName,
          contentType: MediaType('image', fileExtension),
        )
      ],
    });
    return data;
  }
}

// /// this class is used for debounce
// class Debouncer {
//   final int milliseconds;
//   Timer? _timer;
//
//   Debouncer({required this.milliseconds});
//
//   void run(VoidCallback action) {
//     _timer?.cancel();
//     _timer = Timer(Duration(milliseconds: milliseconds), action);
//   }
// }
