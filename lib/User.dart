import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User {
  final int code;
  final String status;
  final String msg;
  @JsonKey(nullable: false)
  List<Item> data;

  User(this.code, this.status, this.msg, {List<Item> data})
      : data = data ?? <Item>[];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Item {
  String title;
  List<UserDetail> data;

  Item();

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class UserDetail {
  int id;
  String name;

  UserDetail();

  factory UserDetail.fromJson(Map<String, dynamic> json) =>
      _$UserDetailFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailToJson(this);
}

@JsonLiteral('user.json')
Map get glossaryData => _$glossaryDataJsonLiteral;
