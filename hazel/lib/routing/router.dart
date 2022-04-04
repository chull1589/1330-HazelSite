// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './route_names.dart';
import '../home.dart';
import '../login_valid.dart';
import '../create_user.dart';
import '../project_search.dart';
import '../me_page.dart';
import '../shopping.dart';
import '../project_page.dart';
import '../cart_page.dart';
import '../user_account_settings.dart';
import '../user_settings.dart';
import '../string_extensions.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var routingData = settings.name?.getRoutingData;
  switch (settings.name) {
    case HomeRoute:
      return _getPageRoute(HomePage(), settings);
    case LoginRoute:
      return _getPageRoute(LoginPage(), settings);
    case SignUpRoute:
      return _getPageRoute(CreateUserPage(), settings);
    case ProjectSearchRoute:
      return _getPageRoute(ProjectSearch(), settings);
    // TODO: find out why this doesnt route correctly and defaults
    case ProjectDetailRoute:
      var id = int.tryParse(routingData?['id']);
      return _getPageRoute(
          ProjectPage(
            projNum: id as int,
          ),
          settings);
    case MeRoute:
      return _getPageRoute(MePage(), settings);
    // case CommunityRoute:
    //   return _getPageRoute(CommunityPage(), settings);
    case ImpactRoute:
      return _getPageRoute(Shopping(), settings);
    case CartRoute:
      return _getPageRoute(CartPage(), settings);
    case AccountRoute:
      return _getPageRoute(UserSettings(), settings);
    case AccountSettingsRoute:
      return _getPageRoute(UserAccountSettingsPage(), settings);
    default:
      return _getPageRoute(HomePage(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String? routeName;
  _FadeRoute({required this.child, this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}