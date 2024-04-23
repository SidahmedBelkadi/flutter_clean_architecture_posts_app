// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/constants.dart';
import '../models/post_model.dart';

abstract class PostsLocalDataSource {
  Future<List<PostModel>> getCachedPosts();

  Future<Unit> cachePosts({required List<PostModel> posts});
}

class PostsLocalDataSourceImpl implements PostsLocalDataSource {
  SharedPreferences sharedPreferences;

  PostsLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<Unit> cachePosts({required List<PostModel> posts}) async {
    final List<Map<String, dynamic>> jsonPosts =
        posts.map<Map<String, dynamic>>((post) => post.toJson()).toList();

    sharedPreferences.setString(CACHED_POSTS, json.encode(jsonPosts));

    return unit;
  }

  @override
  Future<List<PostModel>> getCachedPosts() async {
    final jsonString = sharedPreferences.getString(CACHED_POSTS);
    if (jsonString != null) {
      final decodedJsonData = json.decode(jsonString);
      final List<PostModel> posts =
          decodedJsonData.map<PostModel>((post) => post.fromJson(post)).toList();

      return Future.value(posts);
    } else {
      throw CacheException();
    }
  }
}
