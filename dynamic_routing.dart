import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyAppRoutePath {
  final bool isFirstScreen;
  MyAppRoutePath.home() : isFirstScreen = true;
  MyAppRoutePath.secondScreen() : isFirstScreen = false;
  bool get getIsFirstScreen {
    return isFirstScreen == true;
  }

  bool get getIsSecondScreen {
    return isFirstScreen == false;
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  MyAppRouteInformationParser _myAppRouteInformationParser =
      MyAppRouteInformationParser();
  MyAppRouteDelegate _myAppRouteDelegate = MyAppRouteDelegate();
  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
        routeInformationParser: _myAppRouteInformationParser,
        routerDelegate: _myAppRouteDelegate);
  }
}

class MyAppRouteInformationParser
    extends RouteInformationParser<MyAppRoutePath> {
  @override
  Future<MyAppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    if (uri.pathSegments.length == 0) {
      return MyAppRoutePath.home();
    }
    return MyAppRoutePath.secondScreen();
  }

  @override
  RouteInformation restoreRouteInformation(MyAppRoutePath configuration) {
    if (configuration.getIsFirstScreen) {
      return RouteInformation(location: '/');
    }
    return RouteInformation(location: '/secondScreen');
  }
}

class MyAppRouteDelegate extends RouterDelegate<MyAppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyAppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  bool _isFirstScreen = true;

  MyAppRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  MyAppRoutePath get currentConfiguration {
    if (_isFirstScreen) {
      return MyAppRoutePath.home();
    }
    return MyAppRoutePath.secondScreen();
  }

  void _handleOnTap() {
    _isFirstScreen = false;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(MyAppRoutePath configuration) async {
    if (configuration.isFirstScreen == false) {
      _isFirstScreen = true;
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        CupertinoPage(
            key: ValueKey('FirstScreen'),
            child: FirstScreen(
              handleOnTap: _handleOnTap,
            )),
        if (!_isFirstScreen) CupertinoPage(child: SecondScreen())
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _isFirstScreen = true;
        notifyListeners();
        return true;
      },
    );
  }
}

class FirstScreen extends StatelessWidget {
  final handleOnTap;
  FirstScreen({@required this.handleOnTap});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('first screen'),
        ),
        child: Center(
          child: CupertinoButton(
            child: Text('First Screen'),
            onPressed: handleOnTap,
          ),
        ));
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Second Screen'),
        ),
        child: Center(
          child: Text('SecondScreen'),
        ));
  }
}
