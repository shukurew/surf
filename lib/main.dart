import 'package:intl/date_symbol_data_local.dart';
import 'package:tms/src/common/constants/color_constant.dart';
import 'package:tms/src/common/router/router.dart';
import 'package:tms/src/common/router/routing_constant.dart';
import 'package:tms/src/common/cubit/auth_cubit_out.dart';
import 'package:tms/src/screens/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:tms/src/common/dependencies/injection_container.dart';
import 'package:tms/src/common/dependencies/nv_hive.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await initGetIt();
  await initHive();
  initializeDateFormatting('ru');

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubitOut>.value(value: getIt<AuthCubitOut>()),
        BlocProvider(
          create:
              (context) =>
                  AuthCubit(authService: getIt(), localStorageService: getIt()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        locale: Locale('ru'),
        supportedLocales: [Locale('ru')],
        localizationsDelegates: [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.white),
          useMaterial3: true,
        ),
        home: const InitialScreen(),
        onGenerateRoute: MetaRouter.onGenerateRoute,
      ),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkForPinCode();
  }

  void authListener(BuildContext context, AuthState state) {
    switch (state) {
      case AuthLoaded():
        Navigator.pushReplacementNamed(context, RoutingConst.pincode);
        break;
      case AuthFailed():
        Navigator.pushReplacementNamed(context, RoutingConst.auth);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: authListener,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
