import 'package:flutter/material.dart';

class Appoint {
  DateTime? startTime;
  DateTime endTime;
  bool isAllDay =false;
   String subject;
   Color color;
   String? startTimeZone;
   String? endTimeZone;
     String? recurrenceRule;
  List<DateTime>? recurrenceExceptionDates;
String? notes;
 String? location;
List<Object>? resourceIds;
Object? recurrenceId;
Object? id;
  Appoint(
     this.startTime,
    this.endTime,
    this.isAllDay,
    this.subject,
    this.color,
    this.startTimeZone,
    this.endTimeZone,
    this.recurrenceRule,
    this.recurrenceExceptionDates,
    this.notes,
    this.location,
    this.resourceIds,
    this.recurrenceId,
    this.id,
  );
  }
