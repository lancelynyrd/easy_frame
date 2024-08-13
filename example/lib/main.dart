import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_comment/easy_comment.dart';
import 'package:easy_helpers/easy_helpers.dart';

import 'package:easy_locale/easy_locale.dart';
import 'package:easy_messaging/easy_messaging.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easychat/easychat.dart';
// import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easyuser/easyuser.dart';
import 'package:example/etc/zone_error_handler.dart';
// import 'package:example/firebase_options.dart';
// import 'package:example/firebase_options.dart';
import 'package:example/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  /// Uncaught Exception 핸들링
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      lo.init();
      await Firebase.initializeApp(
          // options: DefaultFirebaseOptions.currentPlatform,
          );

      UserService.instance.init();
      runApp(const MyApp());

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.dumpErrorToConsole(details);
      };
    },
    zoneErrorHandler,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    UserService.instance.init();

    StorageService.instance.init(
      uploadBottomSheetPadding: const EdgeInsets.all(16),
      uploadBottomSheetSpacing: 16,
    );

    messagingInit();
    commentInit();
    chatInit();

    // PostService.instance.init(
    //   categories: {
    //     'qna': '질문답변',
    //     'discussion': 'Discussion',
    //     'news': 'News',
    //     'job': '구인구직',
    //     'buyandsell': '사고팔기',
    //     'travel': '여행',
    //     'food': '음식',
    //     'study': '공부',
    //     'hobby': '취미',
    //     'etc': '기타',
    //     'youtube': 'youtube',
    //   },
    // );

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      /// open messaging screen
      // showGeneralDialog(
      //     context: globalContext,
      //     pageBuilder: (_, __, ___) {
      //       return const MessagingScreen();
      //     });

      // ChatService.instance.showChatRoomEditScreen(globalContext);
      // final room = await ChatRoom.get("t5zClWySjgryFf2tK0M8");
      // if (!mounted) return;
      // ChatService.instance.showChatRoomScreen(context, room: room);
      // PostService.instance.showPostCreateScreen(context: globalContext);
      // PostService.instance.showPostEditScreen(context: globalContext);
      // PostService.instance.showPostListScreen(context: globalContext);
      // PostService.instance
      //     .showYoutubeListScreen(context: globalContext, category: 'youtube');

      // showGeneralDialog(
      //   context: globalContext,
      //   pageBuilder: (_, __, ___) => const CommentTestScreen(),
      // );

      // Open post list screen
      // PostService.instance.showPostListScreen(
      //   context: globalContext,
      //   categories: [
      //     Category(id: 'qna', name: 'QnA'),
      //     Category(id: 'discussion', name: 'Discussion'),
      //     Category(id: 'youtube', name: 'Youtube'),
      //     Category(id: 'buyandsell', name: 'Buy and Sell'),
      //     Category(id: 'job', name: 'Jobs'),
      //     Category(id: 'news', name: 'News'),
      //   ],
      // );

      // FirebaseFirestore.instance
      //     .collection('chat-rooms')
      //     .orderBy('users.uidA.nMC', descending: true)
      //     .snapshots()
      //     .listen((event) {
      //   print('chat-room: ${event.docs.length}');
      //   event.docs.map((e) {
      //     print('chat-room: ${e.id}:');
      //   }).toList();
      // });

      /// Open a post detail screen after creating a post.
      // (() async {
      //   final ref = await Post.create(
      //       category: 'yo',
      //       title: 'title-${DateTime.now().jm}',
      //       content: 'content');
      //   final post = await Post.get(ref.id);
      //   PostService.instance
      //       .showPostDetailScreen(context: globalContext, post: post);
      // })();
      // LikeTestService.instance.runTests();

      // MessagingService.instance.getTokens([
      //   'vysiFTQS1ZXSnvS3UnxfeJEpCWN2',
      //   'Jkihj9GMRoNeZ1WXQ5FHMOr3E4c2',
      // ]);

      // MessagingService.instance.send(
      //     uids: [
      //       'vysiFTQS1ZXSnvS3UnxfeJEpCWN2',
      //       'Jkihj9GMRoNeZ1WXQ5FHMOr3E4c2',
      //     ],
      //     title: 'Test from MyApp',
      //     body: 'Test body',
      //     data: {
      //       'key': 'value',
      //     });

      // MessagingService.instance.send(
      //   uids: ['vysiFTQS1ZXSnvS3UnxfeJEpCWN2'],

      // final youtube =
      //     Youtube(url: 'https://www.youtube.com/watch?v=YBmFxBb9U6g');

      // print('youtube id: ${youtube.getVideoId()}');
      //  // ERROR Youtube not found.
      // final snippet = await youtube.getSnippet(
      //   apiKey: 'AIzaSyDguL0DVfgQQ8YJHfSAJm1t8gCetR0-TdY',
      // );

      // print('snippet: $snippet');
    });
  }

  messagingInit() async {
    MessagingService.instance.init(
      sendMessageApi: 'sendmessage-mkxv2itpca-uc.a.run.app',
      sendMessageToUidsApi: 'sendmessagetouids-mkxv2itpca-uc.a.run.app',
      sendMessageToSubscriptionsApi:
          'sendmessagetosubscription-mkxv2itpca-uc.a.run.app',
      onMessageOpenedFromBackground: (message) {
        WidgetsBinding.instance.addPostFrameCallback((duration) async {
          dog('onMessageOpenedFromBackground: $message');
          alert(
            context: globalContext,
            title: Text(message.notification?.title ?? ''),
            message: Text(message.notification?.body ?? ''),
          );
        });
      },
      onMessageOpenedFromTerminated: (RemoteMessage message) {
        WidgetsBinding.instance.addPostFrameCallback((duration) async {
          dog('onMessageOpenedFromTerminated: ${message.notification?.title ?? ''} ${message.notification?.body ?? ''}');
          alert(
            context: globalContext,
            title: Text(message.notification?.title ?? ''),
            message: Text(message.notification?.body ?? ''),
          );
        });
      },
      onForegroundMessage: (message) {
        dog('onForegroundMessage: $message');
      },
    );

    /// Android Head-up Notification
    if (isAndroid) {
      /// Set a channel for high importance notifications.
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', //
        importance: Importance.max, // max 로 해야 Head-up display 가 잘 된다.
        showBadge: true,
        enableVibration: true,
        playSound: true,
      );

      // final youtube =
      //     Youtube(url: 'https://www.youtube.com/watch?v=YBmFxBb9U6g');

      /// Register the channel with the system.
      /// If there is already a registed channel (with same id), then it will be re-registered.
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    // print('youtube id: ${youtube.getVideoId()}');

    // // youtube.getVideoId();
    // final snippet = await youtube.getSnippet(
    //   apiKey: 'AIzaSyDguL0DVfgQQ8YJHfSAJm1t8gCetR0-TdY',
    // );
    // print(' default url :${snippet.thumbnails['default']}');
    // print('snippet: ${snippet.statistics}');
    // });
  }

  commentInit() {
    CommentService.instance.init(
      onCommentCreate: (DocumentReference ref) async {
        /// get ancestor uid
        List<String> ancestorUids =
            await CommentService.instance.getAncestorsUid(ref.id);

        /// you can also attached the uid of the post author before sending the notification
        Comment? comment = await Comment.get(ref.id);
        if (comment == null) return;

        Post post = await Post.get(comment.documentReference.id);
        if (myUid != null && post.uid != myUid) {
          ancestorUids.add(post.uid);
        }

        if (ancestorUids.isEmpty) return;

        /// set push notification to remaining uids
        /// can get comment or post to send more informative push notification
        MessagingService.instance.sendMessageToUid(
          uids: ancestorUids,
          title: 'title ${DateTime.now()}',
          body: 'ancestorComment test',
          data: {
            "action": 'comment',
            'commentId': ref.id,
            'postId': comment.documentReference.id,
          },
        );
      },
    );
  }

  chatInit() {
    ChatService.instance.init(
        chatRoomActionButton: (room) =>
            PushNotificationToggelIcon(subscriptionName: room.id),
        onSendMessage: (
            {required ChatMessage message, required ChatRoom room}) async {
          final uids = room.userUids.where((uid) => uid != myUid).toList();
          if (uids.isEmpty) return;
          MessagingService.instance.sendMessageToUid(
            uids: uids,
            title: 'ChatService ${DateTime.now()}',
            body: '${room.id} ${message.id} ${message.text}',
            data: {"action": 'chat', 'roomId': room.id},
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
