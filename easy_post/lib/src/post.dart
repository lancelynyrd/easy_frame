import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/defines.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:firebase_database/firebase_database.dart';

/// Post mostly contains a `title` and `content` there might be also a image when
/// the user post image
///
/// `id` is the postid and it also the document id of the post
///
/// `title` is the title of the post
///
/// `content` is the content of the post
///
/// `urls` is the list of post image urls
///
/// `createdAt` is the time when the post is created
///
/// `updateAt` is the time when the post is update
///
/// `youtubeUrl` is the youtube url from youtube ex:https://youtube.com/watch=<someID>
///
/// `youtube` is the information of the youtube url such as thumbnail
class Post {
  // collectionReference post's collection

  static const field = (
    id: 'id',
    category: 'category',
    title: 'title',
    subtitle: 'subtitle',
    content: 'content',
    uid: 'uid',
    createdAt: 'createdAt',
    updateAt: 'updateAt',
    urls: 'urls',
    deleted: 'deleted',
    youtubeUrl: 'youtubeUrl',
    youtube: 'youtube',
    order: 'order',
  );

  final String id;
  final String category;
  final String title;
  final String subtitle;
  final String content;
  final String uid;
  final DateTime createdAt;
  final DateTime updateAt;
  final List<String> urls;
  final bool deleted;
  final int order;

  static DatabaseReference col = PostService.instance.postsRef;

  /// The document reference of current post
  DatabaseReference doc(String id) => col.child(id);

  /// The document reference of current post
  DatabaseReference get ref => doc(id);

  /// get the first image url
  String? get imageUrl => urls.isNotEmpty ? urls.first : null;

  /// Youtube URL. Refer README.md for more information
  final String youtubeUrl;
  final Map<String, dynamic> youtube;

  /// Returns true if the current post has youtube.
  bool get hasYoutube => (youtubeUrl.isNotEmpty && youtube.isNotEmpty) || youtube['id'] != null;

  final int likeCount;
  final int commentCount;

  final Map<String, dynamic> data;

  Map<String, dynamic> get extra => data;

  /// Return true if the post is created by the current user
  bool get isMine => currentUser?.uid == uid;

  Post({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.uid,
    required this.createdAt,
    required this.updateAt,
    required this.urls,
    required this.youtubeUrl,
    required this.commentCount,
    required this.data,
    required this.youtube,
    required this.deleted,
    required this.likeCount,
    required this.order,
  });

  factory Post.fromJson(Map<String, dynamic> json, String id) {
    return Post(
      id: id,
      category: json['category'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      content: json['content'] ?? '',
      uid: json['uid'],
      createdAt: json['createdAt'] ?? DateTime.now(),
      updateAt: json['updateAt'] ?? DateTime.now(),

      /// youtubeUrl never be null. But just in case, it put empty string as default.
      youtubeUrl: json['youtubeUrl'] ?? '',
      urls: json['urls'] != null ? List<String>.from(json['urls']) : [],
      commentCount: json['commentCount'] ?? 0,
      data: json,
      youtube: json['youtube'] ?? {},
      deleted: json['deleted'],
      likeCount: json['likeCount'] ?? 0,
      order: json['order'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'title': title,
        'subtitle': subtitle,
        'content': content,
        'uid': uid,
        'createdAt': createdAt,
        'updateAt': updateAt,
        'urls': urls,
        'youtubeUrl': youtubeUrl,
        'commentCount': commentCount,
        'youtube': youtube,
        'deleted': deleted,
        'likeCount': likeCount,
        'order': order,
      };

  @override
  String toString() {
    return 'Post(${toJson()})';
  }

  factory Post.fromSnapshot(DataSnapshot snapshot) {
    if (snapshot.exists == false) {
      throw Exception('Post.fromSnapshot: Post does not exist');
    }

    final docSnapshot = snapshot as Map<String, dynamic>;
    return Post.fromJson(docSnapshot, snapshot.child('id') as String);
  }

// get a post
  static Future<Post> get(String? id) async {
    if (id == null) {
      throw 'post-get/post-id-null Post id is null';
    }
    final documentSnapshot = await postRef(id).get();
    if (documentSnapshot.exists == false) {
      throw 'post-get/post-not-found Post not found';
    }

    return Post.fromSnapshot(documentSnapshot);
  }

  // create a new post
  static Future<DatabaseReference> create({
    required String category,
    String? title,
    String? subtitle,
    String? content,
    List<String> urls = const [],
    String youtubeUrl = '',
    Map<String, dynamic>? extra,
  }) async {
    if (currentUser == null) {
      throw 'post-create/sign-in-required You must login firt to create a post';
    }
    final order = DateTime.now().millisecondsSinceEpoch * -1;
    // if (category.isEmpty) {
    //   throw 'post-create/category-is-required Category is required';
    // }

    final youtube = await getYoutubeSnippet(youtubeUrl);
    DatabaseReference documentReference = PostService.instance.postsRef.push();

    final data = {
      Post.field.category: category,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (content != null) 'content': content,
      'uid': currentUser!.uid,
      'urls': urls,
      'youtubeUrl': youtubeUrl,
      'commentCount': 0,
      'createdAt': ServerValue.timestamp,
      'updateAt': ServerValue.timestamp,
      'deleted': false,
      if (youtube != null) 'youtube': youtube,
      'order': order,
      ...?extra,
    };

    await documentReference.set(data);

    /// Callback after post is created
    PostService.instance.onCreate?.call(Post.fromJson(data, documentReference.path.split('/').last));

    return documentReference;
  }

  /// update a post
  ///
  /// TODO: display loader while updating
  /// TODO: display loader and percentage while image uploading
  Future<void> update({
    String? title,
    String? subtitle,
    String? content,
    List<String>? urls,
    String? youtubeUrl,
    Map<String, dynamic>? extra,
  }) async {
    final data = {
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (content != null) 'content': content,
      if (urls != null) 'urls': urls,
      if (youtubeUrl != null) 'youtubeUrl': youtubeUrl,
    };

    await doc(id).update(
      {
        ...data,
        if (youtubeUrl != null && this.youtubeUrl != youtubeUrl) 'youtube': await getYoutubeSnippet(youtubeUrl),
        'updateAt': ServerValue.timestamp,
        ...?extra,
      },
    );
  }

  /// delete post, this will not delete the document but instead mark the the
  /// document as deleted
  ///
  /// TODO: display loader while deleting
  Future<void> delete() async {
    if (deleted == true) {
      throw 'post-delete/post-already-deleted Post is already deleted';
    }

    for (String url in urls) {
      await StorageService.instance.delete(url);
    }

    await ref.update({
      'deleted': true,
    });
  }
}
