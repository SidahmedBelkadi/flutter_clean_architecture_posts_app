import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/post_entity.dart';

abstract class PostsRepository {
  Future<Either<Failure, List<Post>>> getAllPosts();

  Future<Either<Failure, Unit>> deletePost({required int id});

  Future<Either<Failure, Unit>> updatePost({required Post post});

  Future<Either<Failure, Unit>> addPost({required Post post});
}
