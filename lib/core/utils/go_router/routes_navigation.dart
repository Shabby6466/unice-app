import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:unice_app/core/utils/go_router/app_routes.dart';
import 'package:unice_app/core/utils/go_router/routes_constant.dart';

abstract class Navigation {
  // this method is used to move from one route to another without saving prev state of route stack
  bool go(String path);

  // this method is used to move from one route to another with navigation data  without saving prev state of route stack
  // ignore: provide_deprecation_message
  @Deprecated('don\'t use this method')
  bool goNamed(String path, NavigationData navigationData);

  // this method is used to push new routes on screen
  bool push({required String path});

  // this method is used to push new routes on screen with data
  @Deprecated('don\'t use this method')
  bool pushNamed({required String path, required NavigationData navigationData});

  // this method is used to push new routes on screen with data as Extra
  bool pushNamedWithExtra({required String path, required NavigationData navigationData});

  bool pushNamedAndRemoveWithExtra({required String path, required NavigationData navigationData});

  bool pushNamedAndRemove({required String path});

  bool pushNamedWithExtraList({required String path, required List<NavigationData> navigationData});

  // this method is used to move from one route to another with navigation data as routes without saving prev state of route stack
  bool goNamedWithExtra({required String path, required NavigationData navigationData});

  // this is used to pop screen from route stack
  bool popFromRoute();

  /// this method is used to check if router stack has route or not
  bool canPop();

  /// this method is used to pop from route with result i.e [TRUE] / [FALSE]
  bool popWithResult({required bool returnValue});

  /// this method is used to push to route with extra extra results await for result
  Future<bool> pushNamedWithExtraForResult({required String path, required NavigationData navigationData});

  /// this method is used to push new routes on screen with await for result
  Future<bool> pushForResult({required String path});

  bool popUntil({required String path});

  /// Completely resets navigation stack and redirects to login
  bool goToLoginWithFullReset();
}

@Singleton(as: Navigation)
class NavigationImpl implements Navigation {
  @override
  bool go(String path) {
    AppRouter.rootNavigatorKey.currentContext!.go(path);
    return true;
  }

  @override
  bool pushNamed({required path, required navigationData}) {
    AppRouter.rootNavigatorKey.currentContext!.pushNamed(
      path,
      queryParameters: navigationData.toJson(),
    );
    return true;
  }

  @override
  bool push({required String path}) {
    AppRouter.rootNavigatorKey.currentContext!.push(path);
    return true;
  }

  @override
  bool popFromRoute() {
    AppRouter.rootNavigatorKey.currentContext!.pop();
    return true;
  }

  @override
  bool goNamed(String path, NavigationData navigationData) {
    AppRouter.rootNavigatorKey.currentContext!.goNamed(path, queryParameters: navigationData.toJson());
    return true;
  }

  @override
  bool pushNamedWithExtra({required String path, required NavigationData navigationData}) {
    AppRouter.rootNavigatorKey.currentContext!.pushNamed(path, extra: navigationData);
    return true;
  }

  @override
  bool goNamedWithExtra({required String path, required NavigationData navigationData}) {
    AppRouter.rootNavigatorKey.currentContext!.goNamed(path, extra: navigationData);
    return true;
  }

  @override
  bool pushNamedWithExtraList({required String path, required List<NavigationData> navigationData}) {
    AppRouter.rootNavigatorKey.currentContext!.pushNamed(path, extra: navigationData);
    return true;
  }

  @override
  bool canPop() {
    return AppRouter.rootNavigatorKey.currentContext!.canPop();
  }

  @override
  bool popWithResult({required bool returnValue}) {
    AppRouter.rootNavigatorKey.currentContext!.pop(returnValue);
    return returnValue;
  }

  @override
  Future<bool> pushNamedWithExtraForResult({required String path, required NavigationData navigationData}) async {
    return await AppRouter.rootNavigatorKey.currentContext!.pushNamed<bool>(path, extra: navigationData) ?? false;
  }

  @override
  Future<bool> pushForResult({required String path}) async {
    return await AppRouter.rootNavigatorKey.currentContext!.push<bool>(path) ?? false;
  }

  @override
  bool pushNamedAndRemove({required String path}) {
    AppRouter.rootNavigatorKey.currentContext!.pushReplacementNamed(path);
    return true;
  }

  @override
  bool pushNamedAndRemoveWithExtra({required String path, required NavigationData navigationData}) {
    AppRouter.rootNavigatorKey.currentContext!.pushReplacementNamed(path, extra: navigationData);
    return true;
  }

  @override
  bool popUntil({required String path}) {
    while (AppRouter.router.routerDelegate.currentConfiguration.matches.last.matchedLocation != path) {
      if (!AppRouter.rootNavigatorKey.currentContext!.canPop()) {
        break;
      }
      AppRouter.rootNavigatorKey.currentContext!.pop();
    }
    return true;
  }

  @override
  bool goToLoginWithFullReset() {
    // Use a new approach: Add a special parameter to completely override any deep links
    AppRouter.router.go(Routes.loginIndex, extra: {'ignoreDeepLinks': true});
    return true;
  }
}

class NavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('did push route');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('did pop route');
  }
}

abstract class NavigationData extends Object {
  Map<String, dynamic> toJson();
}
