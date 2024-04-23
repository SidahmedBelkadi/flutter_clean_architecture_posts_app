import 'package:clean_architecture/features/posts/domain/entities/post_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/posts_repository.dart';

class AddPostUseCase {
  final PostsRepository repository;

  AddPostUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({required Post post}) async {
    return await repository.addPost(post: post);
  }
}
