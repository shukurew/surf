import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms/src/common/dependencies/injection_container.dart';
import 'package:tms/src/common/router/routing_constant.dart';
import 'package:tms/src/common/services/auth_service.dart';
import 'package:tms/src/common/services/local_storage_service.dart';
import 'package:tms/src/screens/attendance/attendance_screen.dart';
import 'package:tms/src/screens/attendance/cubit/select_period_cubit.dart';
import 'package:tms/src/screens/auth/cubit/auth_cubit.dart';
import 'package:tms/src/screens/auth/widgets/pin_code_screen.dart';
import 'package:tms/src/screens/main/main_screen.dart';
import 'package:tms/src/screens/auth/auth_screen.dart';
import 'package:tms/src/screens/permission/root_block.dart';
import 'package:flutter/material.dart';

// Global navigator key to access navigator from outside widget tree
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MetaRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutingConst.main:
        return MaterialPageRoute(
          builder: (context) => const MainScreen(),
          settings: routeSettings,
        );
      case RoutingConst.rootBlock:
        return MaterialPageRoute(
          builder: (context) => const RootBlock(),
          settings: routeSettings,
        );
      case RoutingConst.auth:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create:
                    (context) => AuthCubit(
                      authService: getIt<AuthService>(),
                      localStorageService: getIt<LocalStorageService>(),
                    ),
                child: const AuthScreen(),
              ),
          settings: routeSettings,
        );
      case RoutingConst.pincode:
        return MaterialPageRoute(
          builder: (context) => PinCodeScreen(),
          settings: routeSettings,
        );
      case RoutingConst.attendance:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider<SelectPeriodCubit>.value(
                value: getIt(),
                child: const AttendanceScreen(),
              ),
          settings: routeSettings,
        );
    }
    return null;
  }
}
