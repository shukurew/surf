import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee.g.dart';
part 'employee.freezed.dart';

@freezed
class Employee with _$Employee {
  const factory Employee({
    @JsonKey(name: 'ext_id') required int extId,
    @JsonKey(name: 'full_name') required String fullName,
  }) = _Employee;

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);
}
