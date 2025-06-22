// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotesModel {
  final int? id;
  final String? title;
  final String? discription;
  final String? color;
  final String? dateTime;
  NotesModel({
    this.id,
    this.title,
    this.discription,
    this.color,
    this.dateTime,
  });

  NotesModel copyWith({
    int? id,
    String? title,
    String? discription,
    String? color,
    String? dateTime,
  }) {
    return NotesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      discription: discription ?? this.discription,
      color: color ?? this.color,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'discription': discription,
      'color': color,
      'dateTime': dateTime,
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      discription:
          map['discription'] != null ? map['discription'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      dateTime: map['dateTime'] != null ? map['dateTime'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotesModel.fromJson(String source) =>
      NotesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotesModel(id: $id, title: $title, discription: $discription, color: $color, dateTime: $dateTime)';
  }

  @override
  bool operator ==(covariant NotesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.discription == discription &&
        other.color == color &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        discription.hashCode ^
        color.hashCode ^
        dateTime.hashCode;
  }
}
