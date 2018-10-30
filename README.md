# flutter_json_demo

A new Flutter application.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).


[json处理](https://flutterchina.club/json/)

[json处理，适合大项目](https://github.com/dart-lang/json_serializable/tree/master/example)

定义模板
```
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
}

@JsonSerializable(includeIfNull: false)
class Item {
  String title;
  List<UserDetail> data;
  Item()

}

@JsonSerializable()
class UserDetail {
  int id;
  String name;

  UserDetail()
}

@JsonLiteral('user.json')
Map get glossaryData => _$glossaryDataJsonLiteral;




```



flutter packages pub run build_runner build 生成模板
