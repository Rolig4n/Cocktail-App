import 'package:fluttercocktail/notification/chat_notification.dart';
import 'package:flutter/material.dart';

class ChatNotificationService with ChangeNotifier {
  List<ChatNotification> _items = [];

  int get itemsCount {
    return _items.length;
  }

  List<ChatNotification> get items {
    return [..._items];
  }

  void add(ChatNotification notification) {
    _items.add(notification);
    notifyListeners();
  }

  void remove(int i) {
    _items.removeAt(i);
    notifyListeners();
  }
}
