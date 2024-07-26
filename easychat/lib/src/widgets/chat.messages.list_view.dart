import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';

class ChatMessagesListView extends StatelessWidget {
  const ChatMessagesListView({
    super.key,
    required this.room,
    this.user,
    this.itemBuilder,
  });

  final ChatRoom? room;
  final User? user;
  final Widget Function(BuildContext context, ChatMessage message)? itemBuilder;

  @override
  Widget build(BuildContext context) {
    dog("chat.messages.list_view room.messageRef: ${room?.messageRef}");
    return FirebaseDatabaseListView(
      query: room!.messageRef.orderByChild("order"),
      reverse: true,
      // loadingBuilder: (context) => const Center(
      //   child: Text("Loading..."),
      // ),
      itemBuilder: (context, doc) {
        final message = ChatMessage.fromSnapshot(doc);
        return itemBuilder?.call(context, message) ??
            ListTile(
              title: Align(
                alignment: message.uid == my.uid
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(message.id),
              ),
              subtitle: Align(
                alignment: message.uid == my.uid
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(message.text!),
              ),
            );
      },
    );
  }
}
