import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tms/src/common/services/main_service.dart';

part 'get_main_info_state.dart';

class GetMainInfoCubit extends Cubit<GetMainInfoState> {
  final MainServiceImplement mainService;

  GetMainInfoCubit({required this.mainService}) : super(GetMainInfoInitial());

  void loadMainInfo(String dateFrom, String dateTo) async {
    emit(GetMainInfoLoading());
    try {
      final response = await mainService.getUserStats(dateFrom, dateTo);

      if (response['success'] == true &&
          response['data'] is Map<String, dynamic>) {
        final data = response['data'] as Map<String, dynamic>;

        final int ok = int.tryParse(data['ok'].toString()) ?? 0;
        final int notOk = int.tryParse(data['not_ok'].toString()) ?? 0;

        emit(GetMainInfoLoaded(ok, notOk));
      } else {
        emit(GetMainInfoError('Неверный формат ответа от сервера'));
      }
    } catch (e) {
      emit(GetMainInfoError('Ошибка загрузки данных посещаемости'));
    }
  }
}
