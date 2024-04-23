import 'dart:convert';

import 'package:clean_architecture/core/constants/constants.dart';
import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../models/post_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getAllPosts();

  Future<Unit> deletePost({required int id});

  Future<Unit> updatePost({required PostModel postModel});

  Future<Unit> addPost({required PostModel postModel});
}

class RemoteDataSourceImpl implements PostsRemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<Unit> addPost({required PostModel postModel}) async {
    final Map body = postModel.toMap();

    final response = await client.post(
      Uri.parse("$BASE_URL/posts"),
      body: body,
      headers: HEADERS,
    );

    if (response.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deletePost({required int id}) async {
    final response = await client.delete(Uri.parse("$BASE_URL/posts/$id"), headers: HEADERS);

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<PostModel>> getAllPosts() async {
    final response = await client.get(
      Uri.parse("$BASE_URL/posts"),
      headers: HEADERS,
    );

    if (response.statusCode == 200) {
      final List rawData = json.decode(response.body) as List;
      final List<PostModel> posts =
          rawData.map<PostModel>((post) => PostModel.fromJson(post)).toList();
      return posts;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updatePost({required PostModel postModel}) async {
    final id = postModel.id;
    final Map body = postModel.toMapWithoutId();

    final response = await client.patch(
      Uri.parse("$BASE_URL/posts/$id"),
      body: body,
      headers: HEADERS,
    );

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }
}
