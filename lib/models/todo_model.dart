// To parse this JSON data, do
//
//     final todoModel = todoModelFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

TodoModel todoModelFromJson(String str) => TodoModel.fromJson(json.decode(str));

String todoModelToJson(TodoModel data) => json.encode(data.toJson());

class TodoModel extends Equatable {
  final String id;
  final String title;
  final String? details;
  final DateTime date;
  final bool isCompleted;

  const TodoModel(
      {required this.id,
      required this.title,
      required this.details,
      required this.date,
      required this.isCompleted});

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
      id: json["id"],
      title: json["title"],
      details: json["details"],
      date: DateTime.fromMillisecondsSinceEpoch(json["date"]),
      isCompleted: json["isCompleted"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "details": details,
        "date": date.millisecondsSinceEpoch,
        "isCompleted": isCompleted
      };

  TodoModel copyWith(
      {required String title,
      required details,
      required date,
      required isCompleted}) {
    return TodoModel(
        id: id,
        title: title,
        details: details,
        date: date,
        isCompleted: isCompleted);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, title, details, date, isCompleted];
}
