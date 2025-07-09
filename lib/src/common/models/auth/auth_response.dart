import 'package:json_annotation/json_annotation.dart';
import '../user/user.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final bool success;
  @JsonKey(fromJson: User.fromJson, toJson: _userToJson)
  final User user;
  @JsonKey(name: 'access_token')
  final String accessToken;
  final String message;

  AuthResponse({
    required this.success,
    required this.user,
    required this.accessToken,
    required this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

Map<String, dynamic> _userToJson(User user) => user.toJson();
