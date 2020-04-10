import 'package:flutter/cupertino.dart';

import '../main.dart';

abstract class PageRouteListener with RouteAware {
  void subscribe(BuildContext context) {
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  void unsubscribe() {
    routeObserver.unsubscribe(this);
  }

  // Push to this side
  @override
  void didPush() {
    onOpen();
  }

  // Pops this side
  @override
  void didPop() {
    onClose();
  }

  // Pushes to other side
  @override
  void didPushNext() {
    onClose();
  }

  // Pops to this side
  @override
  void didPopNext() {
    onOpen();
  }

  void onOpen() {}

  void onClose() {}
}
