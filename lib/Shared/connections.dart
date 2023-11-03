import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:my_catalog/Model/AppState.dart';
import 'package:my_catalog/Redux/Action.dart';

import 'network_error.dart';

class Connections extends StatefulWidget {
  Widget? widgetScreen;
  Function(String status)? onChange;
  Connections({Key? key, this.widgetScreen, this.onChange}) : super(key: key);

  @override
  _ConnectionsState createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  late final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Key connectionsWidgetKey = GlobalKey(debugLabel: 'connectionsWidgetKey_');

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (error) {
      throw Exception(error);
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    final store = StoreProvider.of<AppState>(context, listen: false);
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      clearSnackBar();
      store.dispatch(LoadConnectivityAction(true));
      if(widget.onChange != null) widget.onChange!('connect');
      print('internet');
    }else{
      print('no');
      if(widget.onChange != null) widget.onChange!('no');

      alertShowErrorNetwork(context: context);
      store.dispatch(LoadConnectivityAction(false));
    }
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
