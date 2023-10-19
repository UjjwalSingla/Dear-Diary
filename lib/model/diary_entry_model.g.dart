// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyEntryAdapter extends TypeAdapter<DailyEntry> {
  @override
  final int typeId = 0;

  @override
  DailyEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyEntry(
      date: fields[0] as DateTime,
      description: fields[1] as String,
      rating: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
