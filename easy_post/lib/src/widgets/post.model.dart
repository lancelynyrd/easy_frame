import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:flutter/material.dart';

/// PostModel
///
/// Gets post data from Realtime Database and keep it in memory cache.
///
/// [id] Post's id.
///
/// There are two different modes.
///
///
///
/// [sync] if [sync] is set to true, then it will display widget with memory
/// data first, then it gets data from server in realtime and updates the
/// widget again. Whenever the data changes in the server, it will update the
/// widget.
///
/// [sync] option helps to reduce the blinking(flickering) on the UI.
///
/// [initialData] is the initial data that is used on very first time. The data
/// may be cached. If the data is not cached, then it will be used as initial
/// data.
class PostModel extends StatelessWidget {
  const PostModel({
    required this.id,
    this.initialData,
    required this.builder,
    this.onLoading,
    this.sync = true,
    super.key,
  });
  final String id;
  final Post? initialData;
  final Widget Function(Post? post) builder;
  final bool sync;
  final Widget? onLoading;

  @override
  Widget build(BuildContext context) {
    return Value(
      ref: postRef(id),
      initialData: initialData?.toJson(),
      builder: (v, _) {
        if (v == null) {
          return builder(null);
        }
        final post = Post.fromJson(Map<String, dynamic>.from(v as Map), id);
        return builder(post);
      },
      onLoading: onLoading,
      sync: sync,
    );
  }
}
