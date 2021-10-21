import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'layouts/HomeDashboard.dart';

final routeObserver = RouteObserver();
void main() {
  runApp(MaterialApp(
    navigatorObservers: [routeObserver],
    home: HomeDashboard(),
  ));
}
