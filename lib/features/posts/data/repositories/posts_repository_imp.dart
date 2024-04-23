import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/features/posts/data/models/post_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/posts_repository.dart';
import '../data_sources/posts_local_data_source.dart';
import '../data_sources/posts_remote_data_source.dart';

typedef DeleteOrUpdateOrAddPost = Future<Unit> Function();

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;
  final PostsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Unit>> addPost({required Post post}) async {
    final PostModel postModel = PostModel.fromEntity(postEntity: post);

    return await _cachExceptionAndReturnFailure(() {
      return remoteDataSource.addPost(postModel: postModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> deletePost({required int id}) async {
    return await _cachExceptionAndReturnFailure(() {
      return remoteDataSource.deletePost(id: id);
    });
  }

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getAllPosts();
        localDataSource.cachePosts(posts: remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await localDataSource.getCachedPosts();
        return Right(localPosts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePost({required Post post}) async {
    final PostModel postModel = PostModel.fromEntity(postEntity: post);

    return await _cachExceptionAndReturnFailure(() {
      return remoteDataSource.updatePost(postModel: postModel);
    });
  }

  Future<Either<Failure, Unit>> _cachExceptionAndReturnFailure(
    DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
