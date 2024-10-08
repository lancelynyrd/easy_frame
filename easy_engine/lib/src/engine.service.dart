import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';

class EngineService {
  static EngineService? _instance;
  static EngineService get instance => _instance ??= EngineService._();

  EngineService._();

  /// [defaultRegion] is the region of the Firebase Cloud Functions.
  ///
  /// If it is null, it will use the default region.
  ///
  /// Each function call may have its own region parameter.
  String? defaultRegion;

  void init({
    String? region,
  }) {
    // init code
    defaultRegion = region;
  }

  /// Claim a user as an admin.
  ///
  /// Calls the OnCall Firebase Cloud Function to claim a user as an admin.
  ///
  /// [region] is the region of the Firebase Cloud Functions.
  Future<String> claimAdmin({
    String? region,
  }) async {
    FirebaseFunctions functions = FirebaseFunctions.instance;

    functions = FirebaseFunctions.instanceFor(
      region: region ?? defaultRegion,
    );

    final HttpsCallable callable = functions.httpsCallable('claimAdmin');
    try {
      final result = await callable.call();
      return result.data;
    } on FirebaseFunctionsException catch (e) {
      log("e.code: ${e.code}, e.message: ${e.message}, e.details: ${e.details}");
      rethrow;
    }
  }

  /// Delete the login user's account
  ///
  /// Calls the OnCall Firebase Cloud Function to delete the login user's account.
  ///
  /// [region] is the region of the Firebase Cloud Functions.
  Future<dynamic> deleteAccount({
    String? region,
  }) async {
    FirebaseFunctions functions = FirebaseFunctions.instance;

    functions = FirebaseFunctions.instanceFor(
      region: region ?? defaultRegion,
    );

    final HttpsCallable callable = functions.httpsCallable('deleteAccount');
    try {
      final result = await callable.call();
      return result.data;
    } on FirebaseFunctionsException catch (e) {
      log("e.code: ${e.code}, e.message: ${e.message}, e.details: ${e.details}");
      rethrow;
    }
  }

  /// Send a message to the users
  Future<List<String>> sendMessage({
    required List<String> tokens,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    String? imageUrl,
  }) async {
    return [];
  }

  /// Send a message to the users
  Future<List<String>> sendMessageToUid({
    required List<String> uids,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    String? imageUrl,
  }) async {
    return [];
  }

  /// Send a message to the users
  Future<List<String>> sendMessageToSubscription({
    required String subscription,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    String? imageUrl,
  }) async {
    return [];
  }
}
