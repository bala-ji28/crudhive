import 'package:hive/hive.dart';
part 'dbmodel.g.dart';

@HiveType(typeId: 1)
class Customer {
  @HiveField(0)
  String name;
  @HiveField(1)
  int phone;
  Customer({required this.name, required this.phone});
}
