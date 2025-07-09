import 'package:bloc/bloc.dart';
import 'package:tms/src/common/router/router.dart';
import 'package:tms/src/common/router/routing_constant.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'auth_state_out.dart';

class AuthCubitOut extends Cubit<AuthStateOut> {
  AuthCubitOut() : super(AuthInitial());

  void logOut() async {
    await Hive.box('tokens').clear();
    emit(UnAuthentificated());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentContext != null) {
        Navigator.of(
          navigatorKey.currentContext!,
          rootNavigator: true,
        ).pushNamedAndRemoveUntil(RoutingConst.auth, (_) => false);
      }
    });
  }
}
