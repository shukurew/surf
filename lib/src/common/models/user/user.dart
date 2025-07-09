import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  @JsonKey(name: 'erp_id')
  final dynamic erpId;
  @JsonKey(name: 'ad_id')
  final String adId;
  @JsonKey(name: 'ext_id')
  final dynamic extId;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'first_name')
  final String firstName;
  final String patronymic;
  final String iin;
  @JsonKey(name: 'company_id')
  final int companyId;
  @JsonKey(name: 'department_id')
  final int departmentId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'deleted_at')
  final dynamic deletedAt;
  @JsonKey(name: 'work_schedule_id')
  final int workScheduleId;
  final dynamic search;
  @JsonKey(name: 'birth_date')
  final String? birthDate;
  @JsonKey(name: 'family_status_id')
  final dynamic familyStatusId;
  final dynamic address;
  @JsonKey(name: 'working_position_id')
  final int workingPositionId;
  @JsonKey(name: 'is_admin')
  final dynamic isAdmin;
  final dynamic email;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'parsed_birth_date')
  final String parsedBirthDate;

  User({
    required this.id,
    this.erpId,
    required this.adId,
    this.extId,
    required this.lastName,
    required this.firstName,
    required this.patronymic,
    required this.iin,
    required this.companyId,
    required this.departmentId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.workScheduleId,
    this.search,
    required this.birthDate,
    this.familyStatusId,
    this.address,
    required this.workingPositionId,
    this.isAdmin,
    this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.parsedBirthDate,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
