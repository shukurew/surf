part of 'get_main_document_cubit.dart';

@immutable
sealed class GetMainDocumentState {}

final class GetMainDocumentInitial extends GetMainDocumentState {}

final class GetMainDocumentLoading extends GetMainDocumentState {}

final class GetMainDocumentLoaded extends GetMainDocumentState {
  final List<dynamic> documents;

  GetMainDocumentLoaded(this.documents);
}

final class GetMainDocumentError extends GetMainDocumentState {
  final String message;

  GetMainDocumentError(this.message);
}
