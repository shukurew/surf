import 'package:tms/src/common/services/attendance_service.dart';
import 'package:tms/src/common/services/auth_service.dart';
import 'package:tms/src/common/services/local_storage_service.dart';
import 'package:tms/src/common/services/main_service.dart';
import 'package:tms/src/common/cubit/auth_cubit_out.dart';
import 'package:tms/src/common/dependencies/nv_dio.dart';
import 'package:tms/src/screens/attendance/cubit/select_period_cubit.dart';
import 'package:tms/src/screens/auth/cubit/reset_password_cubit.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.I;

initGetIt() async {
  getIt.registerLazySingleton<NvDio>(() => NvDio());

  getIt.registerLazySingleton<LocalStorageService>(
    () => SecureLocalStorageService(),
  );

  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImplement(nvDio: getIt<NvDio>()),
  );

  getIt.registerLazySingleton<AuthCubitOut>(() => AuthCubitOut());

  getIt.registerLazySingleton<RequestResetCubit>(
    () => RequestResetCubit(authService: getIt<AuthService>()),
  );

  getIt.registerLazySingleton<VerifyCodeCubit>(
    () => VerifyCodeCubit(authService: getIt<AuthService>()),
  );

  getIt.registerLazySingleton<ResetPasswordCubit>(
    () => ResetPasswordCubit(authService: getIt<AuthService>()),
  );

  getIt.registerLazySingleton<MainService>(
    () => MainServiceImplement(nvDio: getIt<NvDio>()),
  );

  getIt.registerLazySingleton<SelectPeriodCubit>(
    () => SelectPeriodCubit(getIt()),
  );

  getIt.registerLazySingleton<AttendanceService>(
    () => AttendanceServiceImplement(getIt()),
  );
}
