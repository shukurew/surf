import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tms/src/common/services/main_service.dart';

part 'get_main_document_state.dart';

class GetMainDocumentCubit extends Cubit<GetMainDocumentState> {
  final MainServiceImplement mainServiceDocument;

  GetMainDocumentCubit({required this.mainServiceDocument})
    : super(GetMainDocumentInitial());

  void loadMainDocument() async {
    emit(GetMainDocumentLoading());
    try {
      final response = await mainServiceDocument.getMainScreenDocuments();

      if (response['success'] == true &&
          response['data'] is Map<String, dynamic>) {
        final data = response['data'] as Map<String, dynamic>;

        final List<dynamic> documents = data['document'] ?? [];
        emit(GetMainDocumentLoaded(documents));
      } else {
        emit(GetMainDocumentError('Неверный формат ответа от сервера'));
      }
    } catch (e) {
      emit(GetMainDocumentError('Ошибка загрузки документов'));
    }
  }
}
