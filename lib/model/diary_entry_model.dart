import 'package:hive/hive.dart';

part 'diary_entry_model.g.dart';

@HiveType(typeId: 0)
class DailyEntry extends HiveObject {
  @HiveField(0)
  late DateTime date;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late int rating;

  DailyEntry({
    required this.date,
    required this.description,
    required this.rating,
  });
}
