import 'dart:async';
import 'package:SailWithMe/models/messege_module.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SailWithMe/models/FriendStatus.dart';
import 'package:SailWithMe/models/friends_module.dart';
import 'package:firebase_database/firebase_database.dart';

class Utils {
  static StreamTransformer transformerForFriends<T>() =>
      StreamTransformer<Event, List<Friends>>.fromHandlers(
        handleData: (dynamic data, EventSink<List<Friends>> sink) {
          print(data.snapshot);
          final s = data.snapshot.value;
          final List<Friends> users = [];
          for (var key in s.keys) {
            String fullName = s[key]['Name'].toString();
            String imagePath = s[key]['ImageUrl'].toString();
            int isFriend = int.parse(s[key]['IsFriend']);
            if (isFriend == FriendStatus.friends) {
              users.add(new Friends(
                  name: fullName,
                  imageUrl: imagePath,
                  id: key.toString(),
                  isFriend: FriendStatus.friends));
            }
          }

          sink.add(users);
        },
      );

  static StreamTransformer transformerForMessages<T>() =>
      StreamTransformer<Event, List<Message>>.fromHandlers(
        handleData: (dynamic data, EventSink<List<Message>> sink) {
          final s = data.snapshot.value;
          final List<Message> messages = [];

          for (var key in s.keys) {
            String idUser = s[key]['idUser'];
            String urlAvatar = s[key]['urlAvatar'];
            String username = s[key]['username'];
            String message = s[key]['message'];
            DateTime createdAt = DateTime.parse((s[key]['createdAt']));
            Message newMessage = Message(
              idUser: idUser,
              urlAvatar: urlAvatar,
              username: username,
              message: message,
              createdAt: createdAt,
            );
            messages.add(newMessage);
          }
          messages.sort((a, b) {
            return b.createdAt.compareTo(a.createdAt);
          });
          sink.add(messages);
        },
      );

  static DateTime toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }
}
